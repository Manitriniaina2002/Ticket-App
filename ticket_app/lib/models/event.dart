import 'package:hive/hive.dart';

part 'event.g.dart';

@HiveType(typeId: 0)
class Event {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String location;

  @HiveField(4)
  final List<dynamic> ticketTypes;

  @HiveField(5)
  double totalRevenue;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.ticketTypes,
    this.totalRevenue = 0.0,
  });

  double get totalAvailableTickets =>
      ticketTypes.fold(0, (sum, type) => sum + type.availableQuantity);

  double get totalSoldTickets =>
      ticketTypes.fold(0, (sum, type) => sum + type.soldQuantity);
}
