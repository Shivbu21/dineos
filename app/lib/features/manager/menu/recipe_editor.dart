import 'package:dineos/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_field.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/search_picker.dart';
import '../../../data/models/inventory.dart';
import '../../../data/repositories/inventory_repository.dart';

/// Bill of materials for one menu item: which stock ingredients each serving
/// consumes. Serving a line deducts these automatically (server-side).
class RecipeEditor extends ConsumerWidget {
  const RecipeEditor({super.key, required this.menuItemId});

  final String menuItemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context)!;
    final p = context.palette;
    final lines = ref.watch(recipeLinesProvider(menuItemId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.invRecipe, style: AppType.label.copyWith(color: p.textSecondary)),
        const SizedBox(height: 2),
        Text(s.invRecipeHint,
            style: AppType.small.copyWith(color: p.textTertiary)),
        const SizedBox(height: Space.xs),
        lines.when(
          skipLoadingOnRefresh: true,
          data: (all) => Column(
            children: [
              for (final l in all) _LineRow(line: l, menuItemId: menuItemId),
              const SizedBox(height: Space.xs),
              OutlinedButton.icon(
                onPressed: () => _addLine(context, ref),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(s.invAddIngredient),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding:
                      const EdgeInsets.symmetric(horizontal: Space.sm),
                ),
              ),
            ],
          ),
          loading: () => const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (err, _) => Text('$err',
              style: AppType.small.copyWith(color: p.danger)),
        ),
      ],
    );
  }

  Future<void> _addLine(BuildContext context, WidgetRef ref) async {
    final s = AppStrings.of(context)!;
    final items = ref.read(inventoryItemsProvider).value ?? const <InventoryItem>[];
    final active = items.where((i) => i.active).toList();
    if (active.isEmpty || !context.mounted) return;

    final picked = await showSearchPicker<InventoryItem>(
      context: context,
      title: s.invPickIngredient,
      options: active,
      labelOf: (i) => '${i.name} (${i.unit})',
      searchHint: s.invPickIngredient,
    );
    if (picked == null || !context.mounted) return;

    final qty = await showDialog<double>(
      context: context,
      builder: (_) => _QtyDialog(itemName: picked.name, unit: picked.unit),
    );
    if (qty == null || qty <= 0) return;

    try {
      await ref.read(inventoryRepositoryProvider).addRecipeLine(
            menuItemId: menuItemId,
            inventoryItemId: picked.id,
            qtyPerServing: qty,
          );
      ref.invalidate(recipeLinesProvider(menuItemId));
    } catch (err) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$err')),
        );
      }
    }
  }
}

class _LineRow extends ConsumerWidget {
  const _LineRow({required this.line, required this.menuItemId});

  final RecipeLine line;
  final String menuItemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context)!;
    final p = context.palette;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              line.inventoryItemName.isEmpty
                  ? line.inventoryItemId
                  : '${line.inventoryItemName} (${line.unit})',
              style: AppType.body.copyWith(color: p.textPrimary),
            ),
          ),
          Text(
            '${line.qtyPerServing.toStringAsFixed(2)} ${s.invQtyPerServing}',
            style: AppType.small.copyWith(color: p.textSecondary),
          ),
          const SizedBox(width: Space.xs),
          IconButton(
            icon: Icon(Icons.close_rounded, size: 18, color: p.textTertiary),
            tooltip: s.commonRemove,
            onPressed: () async {
              try {
                await ref
                    .read(inventoryRepositoryProvider)
                    .deleteRecipeLine(line.id);
                ref.invalidate(recipeLinesProvider(menuItemId));
              } catch (err) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$err')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class _QtyDialog extends StatefulWidget {
  const _QtyDialog({required this.itemName, required this.unit});

  final String itemName;
  final String unit;

  @override
  State<_QtyDialog> createState() => _QtyDialogState();
}

class _QtyDialogState extends State<_QtyDialog> {
  final _qty = TextEditingController();

  @override
  void dispose() {
    _qty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context)!;

    return FormDialog(
      title: '${s.invAddIngredient} — ${widget.itemName}',
      width: 380,
      onSave: () {
        final qty = double.tryParse(_qty.text.trim()) ?? 0;
        if (qty > 0) Navigator.of(context).pop(qty);
      },
      saveLabel: s.commonAdd,
      children: [
        AppField(
          label: '${s.invQtyPerServing} (${widget.unit})',
          controller: _qty,
          hint: '0',
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
        ),
      ],
    );
  }
}
