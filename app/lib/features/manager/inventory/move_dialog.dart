import 'package:dineos/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../data/repositories/inventory_repository.dart';

enum MoveKind { purchase, wastage, adjust }

Future<void> showMoveDialog(
    BuildContext context, MoveKind kind, String itemId, String itemName) {
  return showDialog<void>(
    context: context,
    builder: (_) => _MoveDialog(kind: kind, itemId: itemId, itemName: itemName),
  );
}

class _MoveDialog extends ConsumerStatefulWidget {
  const _MoveDialog(
      {required this.kind, required this.itemId, required this.itemName});

  final MoveKind kind;
  final String itemId;
  final String itemName;

  @override
  ConsumerState<_MoveDialog> createState() => _MoveDialogState();
}

class _MoveDialogState extends ConsumerState<_MoveDialog> {
  late final _qty = TextEditingController();
  late final _note = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _qty.dispose();
    _note.dispose();
    super.dispose();
  }

  String _title(AppStrings s) => switch (widget.kind) {
        MoveKind.purchase => s.invPurchaseTitle,
        MoveKind.wastage => s.invWastageTitle,
        MoveKind.adjust => s.invAdjustTitle,
      };

  Future<void> _save() async {
    final qty = double.tryParse(_qty.text.trim()) ?? 0;
    final note = _note.text.trim();

    if (qty <= 0) {
      setState(() => _error = AppStrings.of(context)!.invQuantity);
      return;
    }
    if (widget.kind == MoveKind.adjust && note.isEmpty) {
      setState(() => _error = AppStrings.of(context)!.invNote);
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final repo = ref.read(inventoryRepositoryProvider);
      switch (widget.kind) {
        case MoveKind.purchase:
          await repo.purchase(itemId: widget.itemId, qty: qty, note: note);
        case MoveKind.wastage:
          await repo.logWastage(itemId: widget.itemId, qty: qty, note: note);
        case MoveKind.adjust:
          await repo.adjust(itemId: widget.itemId, delta: qty, note: note);
      }
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

    return FormDialog(
      title: '${_title(s)} — ${widget.itemName}',
      busy: _busy,
      error: _error,
      onSave: _save,
      saveLabel: s.commonSave,
      children: [
        AppField(
          label: s.invQuantity,
          controller: _qty,
          hint: '0',
          autofocus: true,
          enabled: !_busy,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
        ),
        const SizedBox(height: Space.md),
        AppField(
          label: s.invNote,
          controller: _note,
          hint: widget.kind == MoveKind.adjust ? s.invAdjustHint : '',
          enabled: !_busy,
        ),
      ],
    );
  }
}
