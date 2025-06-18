import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/ticket_type.dart';
import '../screens/ticket_sale_screen.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              event.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date: ${_formatDate(event.date)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Location: ${event.location}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ticket Types:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ...event.ticketTypes.map((type) => _buildTicketTypeRow(type)),
                const SizedBox(height: 16),
                Text(
                  'Total Revenue: \$${event.totalRevenue.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketSaleScreen(event: event),
                    ),
                  );
                },
                icon: const Icon(Icons.sell),
                label: const Text('Sell Tickets'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement statistics view
                },
                icon: const Icon(Icons.bar_chart),
                label: const Text('Statistics'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTicketTypeRow(TicketType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${type.name} - \$${type.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            'Available: ${type.availableQuantity}',
            style: TextStyle(
              color: type.isSoldOut ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
