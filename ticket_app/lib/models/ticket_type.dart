import 'package:hive/hive.dart';

part 'ticket_type.g.dart';

@HiveType(typeId: 1)
class TicketType {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(3)
  int availableQuantity;

  @HiveField(4)
  int soldQuantity;

  TicketType({
    required this.id,
    required this.name,
    required this.price,
    required this.availableQuantity,
    this.soldQuantity = 0,
  });

  double get totalRevenue => price * soldQuantity;

  bool get isSoldOut => availableQuantity <= 0;

  void sell(int quantity) {
    if (quantity > availableQuantity) {
      throw Exception('Not enough tickets available');
    }
    availableQuantity -= quantity;
    soldQuantity += quantity;
  }
}
