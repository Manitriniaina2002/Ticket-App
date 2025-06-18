import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/event.dart';
import '../models/ticket_type.dart';

class EventProvider with ChangeNotifier {
  final Box<Event> _eventBox = Hive.box<Event>('events');
  final Box<TicketType> _ticketTypeBox = Hive.box<TicketType>('ticket_types');

  List<Event> get events => _eventBox.values.toList();

  Future<void> addEvent(Event event) async {
    await _eventBox.add(event);
    notifyListeners();
  }

  Future<void> addTicketType(String eventId, TicketType ticketType) async {
    final event = _eventBox.get(eventId);
    if (event != null) {
      final updatedEvent = Event(
        id: event.id,
        name: event.name,
        date: event.date,
        location: event.location,
        ticketTypes: [...event.ticketTypes, ticketType],
        totalRevenue: event.totalRevenue,
      );
      await _eventBox.put(eventId, updatedEvent);
      notifyListeners();
    }
  }

  Future<void> sellTicket(String eventId, String ticketTypeId, int quantity) async {
    final event = _eventBox.get(eventId);
    if (event != null) {
      final ticketType = event.ticketTypes.firstWhere(
        (type) => type.id == ticketTypeId,
        orElse: () => throw Exception('Ticket type not found'),
      );

      final updatedTicketType = TicketType(
        id: ticketType.id,
        name: ticketType.name,
        price: ticketType.price,
        availableQuantity: ticketType.availableQuantity,
        soldQuantity: ticketType.soldQuantity,
      );

      updatedTicketType.sell(quantity);

      final updatedEvent = Event(
        id: event.id,
        name: event.name,
        date: event.date,
        location: event.location,
        ticketTypes: event.ticketTypes
            .map((type) => type.id == ticketTypeId ? updatedTicketType : type)
            .toList(),
        totalRevenue: event.totalRevenue + (ticketType.price * quantity),
      );

      await _eventBox.put(eventId, updatedEvent);
      notifyListeners();
    }
  }
}
