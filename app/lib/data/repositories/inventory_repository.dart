import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

import '../live.dart';
import '../models/inventory.dart';
import '../outlets.dart';
import 'menu_repository.dart' show pbProvider;

/// Stock master data for the current outlet, live.
final inventoryItemsProvider = StreamProvider<List<InventoryItem>>((ref) {
  final f = outletFilter(ref);
  return liveCollection(ref, 'inventory_items', InventoryItem.fromRecord,
      sort: 'name', filter: f.filter, params: f.params);
});

/// Recipe lines for one menu item, with ingredient names resolved.
final recipeLinesProvider =
    FutureProvider.family<List<RecipeLine>, String>((ref, menuItemId) async {
  final pb = ref.watch(pbProvider);
  final records = await pb.collection('recipe_lines').getFullList(
        filter: pb.filter('menu_item = {:id}', {'id': menuItemId}),
        sort: 'sort_order',
      );
  final lines = records.map(RecipeLine.fromRecord).toList();
  if (lines.isEmpty) return lines;

  final items = await pb.collection('inventory_items').getFullList(
        filter: pb.filter(
            'id = {:ids}', {'ids': lines.map((l) => l.inventoryItemId)}),
      );
  final byId = {for (final r in items) r.id: r};
  return [
    for (final l in lines)
      byId.containsKey(l.inventoryItemId)
          ? l.withIngredient(byId[l.inventoryItemId]!.getStringValue('name'),
              byId[l.inventoryItemId]!.getStringValue('unit'))
          : l,
  ];
});

/// Server-computed valuation for the current outlet.
final inventoryValuationProvider =
    FutureProvider<({List<StockValuationRow> rows, double total})>((ref) async {
  final outletId = ref.watch(effectiveOutletIdProvider);
  final repo = ref.watch(inventoryRepositoryProvider);
  final val = await repo.valuation(outletId);
  return (
    rows: (val['items'] as List)
        .map((j) => StockValuationRow.fromJson(j as Map<String, dynamic>))
        .toList(),
    total: (val['total_value'] as num? ?? 0).toDouble(),
  );
});

/// Server-computed low-stock alerts for the current outlet.
final stockAlertsProvider = FutureProvider<List<StockAlert>>((ref) async {
  final outletId = ref.watch(effectiveOutletIdProvider);
  final repo = ref.watch(inventoryRepositoryProvider);
  final res = await repo.alerts(outletId);
  return (res['alerts'] as List)
      .map((j) => StockAlert.fromJson(j as Map<String, dynamic>))
      .toList();
});

final inventoryRepositoryProvider = Provider<InventoryRepository>(
  (ref) => InventoryRepository(ref.watch(pbProvider)),
);

/// Writes. Reads go through the live providers above.
class InventoryRepository {
  const InventoryRepository(this._pb);

  final PocketBase _pb;

  Future<Map<String, dynamic>> _send(
    String path, {
    String method = 'GET',
    Map<String, dynamic> query = const {},
    Map<String, dynamic> body = const {},
  }) async {
    final res = await _pb.send(path, method: method, query: query, body: body);
    return res as Map<String, dynamic>;
  }

  // ------------------------------------------------------------ stock items

  Future<void> saveInventoryItem({
    String? id,
    required String name,
    required String unit,
    required double costPerUnit,
    required double threshold,
    required String outletId,
    required bool active,
  }) async {
    final body = <String, dynamic>{
      'name': name.trim(),
      'unit': unit.trim(),
      'cost_per_unit': costPerUnit,
      'low_stock_threshold': threshold,
      'outlet': outletId,
      'active': active,
    };
    if (id == null) {
      await _pb.collection('inventory_items').create(body: body);
    } else {
      await _pb.collection('inventory_items').update(id, body: body);
    }
  }

  Future<void> deleteInventoryItem(String id) =>
      _pb.collection('inventory_items').delete(id);

  // ---------------------------------------------------------------- recipes

  Future<void> addRecipeLine({
    required String menuItemId,
    required String inventoryItemId,
    required double qtyPerServing,
  }) =>
      _pb.collection('recipe_lines').create(body: {
        'menu_item': menuItemId,
        'inventory_item': inventoryItemId,
        'qty_per_serving': qtyPerServing,
      });

  Future<void> deleteRecipeLine(String id) =>
      _pb.collection('recipe_lines').delete(id);

  // ------------------------------------------------------- stock movements
  //
  // The server does all the arithmetic; the app only ever sends intent.

  Future<double> purchase({
    required String itemId,
    required double qty,
    double? costPerUnit,
    String note = '',
  }) async {
    final res = await _send('/api/app/inventory/purchase', method: 'POST', body: {
      'inventory_item': itemId,
      'qty': qty,
      'cost_per_unit': ?costPerUnit,
      'note': note,
    });
    return (res['balance_after'] as num? ?? 0).toDouble();
  }

  Future<double> logWastage({
    required String itemId,
    required double qty,
    String note = '',
  }) async {
    final res = await _send('/api/app/inventory/wastage', method: 'POST', body: {
      'inventory_item': itemId,
      'qty': qty,
      'note': note,
    });
    return (res['balance_after'] as num? ?? 0).toDouble();
  }

  Future<double> adjust({
    required String itemId,
    required double delta,
    required String note,
  }) async {
    final res = await _send('/api/app/inventory/adjust', method: 'POST', body: {
      'inventory_item': itemId,
      'qty_delta': delta,
      'note': note,
    });
    return (res['balance_after'] as num? ?? 0).toDouble();
  }

  Future<Map<String, dynamic>> valuation(String? outletId) => _send(
        '/api/app/inventory/valuation',
        query: {if (outletId != null && outletId.isNotEmpty) 'outlet': outletId},
      );

  Future<Map<String, dynamic>> alerts(String? outletId) => _send(
        '/api/app/inventory/alerts',
        query: {if (outletId != null && outletId.isNotEmpty) 'outlet': outletId},
      );
}
