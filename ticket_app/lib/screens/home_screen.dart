import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/theme_switch.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Manager'),
        actions: const [
          ThemeSwitch(),
        ],
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          final events = eventProvider.events;
          return events.isEmpty
              ? const Center(
                  child: Text('No events yet. Add your first event!'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EventCard(event: event);
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-event');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
