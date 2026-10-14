import 'package:pocketbase/pocketbase.dart';

/// One branch of the restaurant. Menus, tables, orders and the kitchen view
/// are all scoped to an outlet; the till only ever sees its own.
class Outlet {
  const Outlet({
    required this.id,
    required this.name,
    this.address = '',
    this.phone = '',
    this.currencySymbol = '',
    this.currencyCode = '',
    this.active = true,
    this.sortOrder = 0,
  });

  final String id;
  final String name;
  final String address;
  final String phone;
  final String currencySymbol;
  final String currencyCode;
  final bool active;
  final int sortOrder;

  factory Outlet.fromRecord(RecordModel r) => Outlet(
        id: r.id,
        name: r.getStringValue('name'),
        address: r.getStringValue('address'),
        phone: r.getStringValue('phone'),
        currencySymbol: r.getStringValue('currency_symbol'),
        currencyCode: r.getStringValue('currency_code'),
        active: r.getBoolValue('active'),
        sortOrder: r.getIntValue('sort_order'),
      );
}
