import 'package:flutter_test/flutter_test.dart';
import 'package:dineos/data/models/inventory.dart';

void main() {
  group('inventory models', () {
    test('StockValuationRow parses the valuation endpoint shape', () {
      final row = StockValuationRow.fromJson({
        'item_id': 'abc',
        'name': 'Flour',
        'unit': 'kg',
        'balance': 9.5,
        'threshold': 12,
        'cost_per_unit': 40,
        'value': 380,
        'needs_review': false,
        'low': true,
      });
      expect(row.itemId, 'abc');
      expect(row.balance, 9.5);
      expect(row.value, 380);
      expect(row.low, isTrue);
      expect(row.needsReview, isFalse);
    });

    test('StockValuationRow tolerates missing keys', () {
      final row = StockValuationRow.fromJson({});
      expect(row.itemId, '');
      expect(row.balance, 0);
      expect(row.low, isFalse);
    });

    test('StockAlert parses the alerts endpoint shape', () {
      final alert = StockAlert.fromJson({
        'item_id': 'abc',
        'name': 'Flour',
        'unit': 'kg',
        'balance': 2,
        'threshold': 5,
        'needs_review': true,
        'last_restock': '2026-10-14 10:00:00.000Z',
      });
      expect(alert.name, 'Flour');
      expect(alert.needsReview, isTrue);
      expect(alert.lastRestock, contains('2026-10-14'));
    });

    test('RecipeLine.withIngredient resolves names', () {
      const line = RecipeLine(
        id: 'l1',
        menuItemId: 'm1',
        inventoryItemId: 'i1',
        qtyPerServing: 0.5,
      );
      final resolved = line.withIngredient('Flour', 'kg');
      expect(resolved.inventoryItemName, 'Flour');
      expect(resolved.unit, 'kg');
      expect(resolved.qtyPerServing, 0.5);
    });
  });
}
