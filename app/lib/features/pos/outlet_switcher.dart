import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/outlet.dart';
import '../../data/outlets.dart';
import '../../l10n/generated/app_localizations.dart';

/// Which branch this device is working at. Sits in the header of the floor
/// and the kitchen screen; hidden entirely when there is only one outlet.
class OutletSwitcher extends ConsumerWidget {
  const OutletSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlets = ref.watch(outletsProvider).value ?? const <Outlet>[];
    final active = outlets.where((o) => o.active).toList();
    if (active.length < 2) return const SizedBox.shrink();

    final currentId = ref.watch(effectiveOutletIdProvider);
    final current = active.where((o) => o.id == currentId).firstOrNull;
    final p = context.palette;
    final strings = AppStrings.of(context)!;

    return PopupMenuButton<String>(
      tooltip: strings.outletSwitch,
      onSelected: (id) => ref.read(currentOutletIdProvider.notifier).select(id),
      itemBuilder: (_) => [
        for (final o in active)
          PopupMenuItem(
            value: o.id,
            child: Row(
              children: [
                Expanded(child: Text(o.name)),
                if (o.id == currentId)
                  Icon(Icons.check, size: 18, color: p.brand),
              ],
            ),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Space.sm, vertical: Space.xs),
        decoration: BoxDecoration(
          border: Border.all(color: p.borderStrong),
          borderRadius: Radii.pill,
          color: p.surface,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.storefront_outlined, size: 16, color: p.textSecondary),
            const SizedBox(width: Space.xxs),
            Text(
              current?.name ?? strings.outletTitle,
              style: AppType.label.copyWith(color: p.textPrimary),
            ),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down, size: 18, color: p.textSecondary),
          ],
        ),
      ),
    );
  }
}
