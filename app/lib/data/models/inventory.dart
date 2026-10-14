import 'package:pocketbase/pocketbase.dart';

/// Something the kitchen stocks: flour, milk, chicken. Balances live in the
/// server-side ledger (stock_moves); this row carries the master data only.
class InventoryItem {
  const InventoryItem({
    required this.id,
    required this.name,
    required this.unit,
    required this.costPerUnit,
    required this.threshold,
    required this.outletId,
    required this.active,
    required this.needsReview,
  });

  final String id;
  final String name;
  final String unit;
  final double costPerUnit;
  final double threshold;
  final String outletId;
  final bool active;
  final bool needsReview;

  factory InventoryItem.fromRecord(RecordModel r) => InventoryItem(
        id: r.id,
        name: r.getStringValue('name'),
        unit: r.getStringValue('unit'),
        costPerUnit: r.getDoubleValue('cost_per_unit'),
        threshold: r.getDoubleValue('low_stock_threshold'),
        outletId: r.getStringValue('outlet'),
        active: r.getBoolValue('active'),
        needsReview: r.getBoolValue('needs_review'),
      );
}

/// One row of the valuation endpoint: balance and value computed server-side.
class StockValuationRow {
  const StockValuationRow({
    required this.itemId,
    required this.name,
    required this.unit,
    required this.balance,
    required this.threshold,
    required this.costPerUnit,
    required this.value,
    required this.needsReview,
    required this.low,
  });

  final String itemId;
  final String name;
  final String unit;
  final double balance;
  final double threshold;
  final double costPerUnit;
  final double value;
  final bool needsReview;
  final bool low;

  factory StockValuationRow.fromJson(Map<String, dynamic> j) =>
      StockValuationRow(
        itemId: j['item_id'] as String? ?? '',
        name: j['name'] as String? ?? '',
        unit: j['unit'] as String? ?? '',
        balance: (j['balance'] as num? ?? 0).toDouble(),
        threshold: (j['threshold'] as num? ?? 0).toDouble(),
        costPerUnit: (j['cost_per_unit'] as num? ?? 0).toDouble(),
        value: (j['value'] as num? ?? 0).toDouble(),
        needsReview: j['needs_review'] as bool? ?? false,
        low: j['low'] as bool? ?? false,
      );
}

/// One row of the low-stock alerts endpoint.
class StockAlert {
  const StockAlert({
    required this.itemId,
    required this.name,
    required this.unit,
    required this.balance,
    required this.threshold,
    required this.needsReview,
    required this.lastRestock,
  });

  final String itemId;
  final String name;
  final String unit;
  final double balance;
  final double threshold;
  final bool needsReview;
  final String lastRestock;

  factory StockAlert.fromJson(Map<String, dynamic> j) => StockAlert(
        itemId: j['item_id'] as String? ?? '',
        name: j['name'] as String? ?? '',
        unit: j['unit'] as String? ?? '',
        balance: (j['balance'] as num? ?? 0).toDouble(),
        threshold: (j['threshold'] as num? ?? 0).toDouble(),
        needsReview: j['needs_review'] as bool? ?? false,
        lastRestock: j['last_restock'] as String? ?? '',
      );
}

/// One bill-of-materials line: this dish consumes this much of that ingredient
/// per serving.
class RecipeLine {
  const RecipeLine({
    required this.id,
    required this.menuItemId,
    required this.inventoryItemId,
    required this.qtyPerServing,
    this.inventoryItemName = '',
    this.unit = '',
  });

  final String id;
  final String menuItemId;
  final String inventoryItemId;
  final double qtyPerServing;
  final String inventoryItemName;
  final String unit;

  factory RecipeLine.fromRecord(RecordModel r) => RecipeLine(
        id: r.id,
        menuItemId: r.getStringValue('menu_item'),
        inventoryItemId: r.getStringValue('inventory_item'),
        qtyPerServing: r.getDoubleValue('qty_per_serving'),
      );

  RecipeLine withIngredient(String name, String unit) => RecipeLine(
        id: id,
        menuItemId: menuItemId,
        inventoryItemId: inventoryItemId,
        qtyPerServing: qtyPerServing,
        inventoryItemName: name,
        unit: unit,
      );
}
