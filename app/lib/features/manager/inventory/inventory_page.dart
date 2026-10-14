import 'package:dineos/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/page_scaffold.dart';
import '../../../data/models/inventory.dart';
import '../../../data/repositories/inventory_repository.dart';
import 'item_dialog.dart';
import 'move_dialog.dart';

/// Stock on hand: valuation, low-stock alerts, and the item list with
/// purchase / wastage / adjust actions. All arithmetic happens server-side —
/// the app only ever sends intent.
class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context)!;
    final valuation = ref.watch(inventoryValuationProvider);
    final alerts = ref.watch(stockAlertsProvider);

    return Column(
      children: [
        PageHeader(
          title: s.invTitle,
          subtitle: s.invSubtitle,
          action: FilledButton.icon(
            onPressed: () => showInventoryItemDialog(context, null),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(s.invNewItem),
          ),
        ),
        Expanded(
          child: AsyncView<({List<StockValuationRow> rows, double total})>(
            value: valuation,
            onRetry: () => ref.invalidate(inventoryValuationProvider),
            data: (val) => _Body(
              valuation: val,
              alerts: alerts.value ?? const <StockAlert>[],
            ),
          ),
        ),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.valuation, required this.alerts});

  final ({List<StockValuationRow> rows, double total}) valuation;
  final List<StockAlert> alerts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context)!;

    if (valuation.rows.isEmpty) {
      return EmptyState(
        icon: Icons.inventory_2_outlined,
        title: s.invEmpty,
        message: s.invEmptyHint,
        action: FilledButton(
          onPressed: () => showInventoryItemDialog(context, null),
          child: Text(s.invNewItem),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.xl),
      children: [
        _ValuationCard(total: valuation.total, count: valuation.rows.length),
        if (alerts.isNotEmpty) ...[
          const SizedBox(height: Space.lg),
          _AlertsCard(alerts: alerts),
        ],
        const SizedBox(height: Space.lg),
        for (final row in valuation.rows) ...[
          _ItemTile(
            row: row,
            onTap: () => showInventoryItemDialog(context, row.itemId),
          ),
          const SizedBox(height: Space.xs),
        ],
      ],
    );
  }
}

class _ValuationCard extends StatelessWidget {
  const _ValuationCard({required this.total, required this.count});

  final double total;
  final int count;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context)!;
    final p = context.palette;

    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: p.brandSubtle,
        borderRadius: Radii.large,
        border: Border.all(color: p.brand.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: p.brand,
              borderRadius: Radii.medium,
            ),
            child: const Icon(Icons.inventory_2_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.invStockValue,
                    style: AppType.small.copyWith(color: p.textSecondary)),
                Text(
                  total.toStringAsFixed(2),
                  style: AppType.headline.copyWith(color: p.textPrimary),
                ),
              ],
            ),
          ),
          Text('$count',
              style: AppType.headline.copyWith(color: p.textTertiary)),
        ],
      ),
    );
  }
}

class _AlertsCard extends StatelessWidget {
  const _AlertsCard({required this.alerts});

  final List<StockAlert> alerts;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context)!;
    final p = context.palette;

    return Container(
      padding: const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(
        color: p.warningSubtle,
        borderRadius: Radii.large,
        border: Border.all(color: p.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 18, color: p.warning),
              const SizedBox(width: Space.xs),
              Text(s.invLowStock,
                  style:
                      AppType.bodyStrong.copyWith(color: p.textPrimary)),
            ],
          ),
          const SizedBox(height: Space.sm),
          for (final a in alerts)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(a.name,
                        style: AppType.body.copyWith(color: p.textPrimary)),
                  ),
                  if (a.needsReview)
                    _Badge(label: s.invNeedsReview, danger: true),
                  const SizedBox(width: Space.xs),
                  Text(
                    '${a.balance.toStringAsFixed(2)} ${a.unit}',
                    style: AppType.bodyStrong
                        .copyWith(color: p.textPrimary),
                  ),
                  if (a.lastRestock.isNotEmpty) ...[
                    const SizedBox(width: Space.xs),
                    Text(s.invLastRestock(a.lastRestock.substring(0, 10)),
                        style: AppType.small
                            .copyWith(color: p.textTertiary)),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, this.danger = false});

  final String label;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final bg = danger ? p.dangerSubtle : p.warningSubtle;
    final fg = danger ? p.danger : p.warning;

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: Space.xs, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: Radii.pill,
      ),
      child: Text(label,
          style: AppType.small.copyWith(
              color: fg, fontWeight: FontWeight.w600)),
    );
  }
}

class _ItemTile extends ConsumerWidget {
  const _ItemTile({required this.row, required this.onTap});

  final StockValuationRow row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context)!;
    final p = context.palette;

    return Material(
      color: p.surface,
      borderRadius: Radii.medium,
      child: InkWell(
        borderRadius: Radii.medium,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Space.md, vertical: Space.sm),
          decoration: BoxDecoration(
            borderRadius: Radii.medium,
            border: Border.all(color: p.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(row.name,
                              style: AppType.bodyStrong
                                  .copyWith(color: p.textPrimary)),
                        ),
                        if (row.low) ...[
                          const SizedBox(width: Space.xs),
                          _Badge(label: s.invLow),
                        ],
                        if (row.needsReview) ...[
                          const SizedBox(width: Space.xs),
                          _Badge(label: s.invNeedsReview, danger: true),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${s.invBalance}: ${row.balance.toStringAsFixed(2)} ${row.unit}'
                      ' · ${s.invThreshold}: ${row.threshold.toStringAsFixed(2)}',
                      style:
                          AppType.small.copyWith(color: p.textTertiary),
                    ),
                  ],
                ),
              ),
              Text(row.value.toStringAsFixed(2),
                  style:
                      AppType.bodyStrong.copyWith(color: p.textPrimary)),
              const SizedBox(width: Space.sm),
              _ActionMenu(row: row),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionMenu extends ConsumerWidget {
  const _ActionMenu({required this.row});

  final StockValuationRow row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context)!;
    final items = ref.watch(inventoryItemsProvider).value ?? const [];

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, size: 20),
      onSelected: (v) {
        final item = items.where((i) => i.id == row.itemId).firstOrNull;
        switch (v) {
          case 'purchase':
            showMoveDialog(context, MoveKind.purchase, row.itemId, row.name);
          case 'wastage':
            showMoveDialog(context, MoveKind.wastage, row.itemId, row.name);
          case 'adjust':
            showMoveDialog(context, MoveKind.adjust, row.itemId, row.name);
          case 'edit':
            if (item != null) showInventoryItemDialog(context, item.id);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: 'purchase', child: Text(s.invPurchase)),
        PopupMenuItem(value: 'wastage', child: Text(s.invWastage)),
        PopupMenuItem(value: 'adjust', child: Text(s.invAdjust)),
        const PopupMenuDivider(),
        PopupMenuItem(value: 'edit', child: Text(s.invEdit)),
      ],
    );
  }
}
