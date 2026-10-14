import 'package:dineos/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../data/outlets.dart';
import '../../../data/repositories/inventory_repository.dart';

Future<void> showInventoryItemDialog(BuildContext context, String? itemId) {
  return showDialog<void>(
    context: context,
    builder: (_) => _ItemDialog(itemId: itemId),
  );
}

class _ItemDialog extends ConsumerStatefulWidget {
  const _ItemDialog({this.itemId});

  final String? itemId;

  @override
  ConsumerState<_ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends ConsumerState<_ItemDialog> {
  late final _name = TextEditingController();
  late final _unit = TextEditingController();
  late final _cost = TextEditingController();
  late final _threshold = TextEditingController();
  late bool _active = true;
  bool _loaded = false;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.itemId;
    if (id == null) {
      setState(() => _loaded = true);
      return;
    }
    final items = ref.read(inventoryItemsProvider).value ?? const [];
    final item = items.where((i) => i.id == id).firstOrNull;
    if (item != null && mounted) {
      _name.text = item.name;
      _unit.text = item.unit;
      _cost.text = item.costPerUnit.toStringAsFixed(2);
      _threshold.text = item.threshold.toStringAsFixed(2);
      _active = item.active;
    }
    if (mounted) setState(() => _loaded = true);
  }

  @override
  void dispose() {
    for (final c in [_name, _unit, _cost, _threshold]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final s = AppStrings.of(context)!;
    final name = _name.text.trim();
    final unit = _unit.text.trim();
    final cost = double.tryParse(_cost.text.trim()) ?? -1;
    final threshold = double.tryParse(_threshold.text.trim()) ?? -1;

    if (name.isEmpty || unit.isEmpty || cost < 0 || threshold < 0) {
      setState(() => _error = s.invQuantity);
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final outletId = ref.read(effectiveOutletIdProvider) ?? '';
      await ref.read(inventoryRepositoryProvider).saveInventoryItem(
            id: widget.itemId,
            name: name,
            unit: unit,
            costPerUnit: cost,
            threshold: threshold,
            outletId: outletId,
            active: _active,
          );
      ref.invalidate(inventoryItemsProvider);
      ref.invalidate(inventoryValuationProvider);
      ref.invalidate(stockAlertsProvider);
      if (mounted) Navigator.of(context).pop();
    } catch (err) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = '$err';
        });
      }
    }
  }

  Future<void> _delete() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(inventoryRepositoryProvider)
          .deleteInventoryItem(widget.itemId!);
      ref.invalidate(inventoryItemsProvider);
      ref.invalidate(inventoryValuationProvider);
      ref.invalidate(stockAlertsProvider);
      if (mounted) Navigator.of(context).pop();
    } catch (err) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = '$err';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context)!;
    final isNew = widget.itemId == null;

    return FormDialog(
      title: isNew ? s.invNewItem : s.invTitle,
      busy: _busy,
      error: _error,
      onSave: _save,
      onDelete: isNew ? null : _delete,
      children: [
        if (!_loaded)
          const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else ...[
          AppField(
            label: s.commonName,
            controller: _name,
            hint: 'Flour',
            autofocus: true,
            enabled: !_busy,
          ),
          const SizedBox(height: Space.md),
          Row(
            children: [
              Expanded(
                child: AppField(
                  label: s.invUnit,
                  controller: _unit,
                  hint: 'kg',
                  enabled: !_busy,
                ),
              ),
              const SizedBox(width: Space.sm),
              Expanded(
                child: AppField(
                  label: s.invCostPerUnit(s.invUnit),
                  controller: _cost,
                  hint: '0.00',
                  enabled: !_busy,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.md),
          AppField(
            label: s.invThreshold,
            controller: _threshold,
            hint: '0',
            enabled: !_busy,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
          ),
          const SizedBox(height: Space.md),
          FormSwitch(
            label: s.invActive,
            description: s.invActive,
            value: _active,
            onChanged: _busy ? null : (v) => setState(() => _active = v),
          ),
        ],
      ],
    );
  }
}
