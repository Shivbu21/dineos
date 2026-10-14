import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'live.dart';
import 'models/outlet.dart';
import 'prefs.dart';

/// Which outlet this device is working at, persisted per device.
///
/// The till, the floor and the kitchen view all scope to this. It starts unset;
/// [effectiveOutletIdProvider] resolves it.
class CurrentOutlet extends Notifier<String?> {
  @override
  String? build() => ref.watch(prefsProvider).outletId;

  /// Switches outlet and remembers the choice on this device.
  Future<void> select(String? id) async {
    state = id;
    await ref.read(prefsProvider).setOutletId(id);
  }
}

final currentOutletIdProvider =
    NotifierProvider<CurrentOutlet, String?>(CurrentOutlet.new);

/// Every outlet on the server, for the switcher.
final outletsProvider = StreamProvider<List<Outlet>>(
  (ref) => liveCollection(ref, 'outlets', Outlet.fromRecord,
      sort: 'sort_order,name'),
);

/// The outlet in effect: the device's explicit choice, or the only outlet when
/// there is exactly one. Null while a multi-outlet device has not chosen yet —
/// screens show a picker instead of mixing outlets together.
final effectiveOutletIdProvider = Provider<String?>((ref) {
  final chosen = ref.watch(currentOutletIdProvider);
  if (chosen != null) return chosen;
  final outlets = ref.watch(outletsProvider).value ?? const <Outlet>[];
  final active = outlets.where((o) => o.active).toList();
  return active.length == 1 ? active.first.id : null;
});

/// The outlet record in effect, if it has loaded.
final effectiveOutletProvider = Provider<Outlet?>((ref) {
  final id = ref.watch(effectiveOutletIdProvider);
  if (id == null) return null;
  final outlets = ref.watch(outletsProvider).value ?? const <Outlet>[];
  for (final o in outlets) {
    if (o.id == id) return o;
  }
  return null;
});

/// Builds an outlet-scoped filter for [liveCollection]: `outlet = {:o}` when
/// an outlet is in effect, unfiltered while the device has not chosen one.
({String filter, Map<String, Object?> params}) outletFilter(Ref ref) {
  final outletId = ref.watch(effectiveOutletIdProvider);
  if (outletId == null) return (filter: '', params: const {});
  return (filter: 'outlet = {:o}', params: {'o': outletId});
}
