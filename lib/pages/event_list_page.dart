import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../services/event_storage.dart';
import '../widgets/event_tile.dart';
import '../utils/date_utils.dart';

class EventListPage extends StatefulWidget {
  final DateTime selectedDate;

  const EventListPage({super.key, required this.selectedDate});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final EventStorage _storage = EventStorage();

  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEventsForDate();
  }

  Future<void> _loadEventsForDate() async {
    final events = await _storage.getEventsForDate(widget.selectedDate);
    if (!mounted) return;
    setState(() {
      _events = events;
    });
  }

  Future<void> _deleteEvent(Event event) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _storage.deleteEvent(event.id);
      _loadEventsForDate();
    }
  }

  Future<void> _goToAddEvent() async {
    await Navigator.pushNamed(
      context,
      '/add_edit',
      arguments: {'date': widget.selectedDate, 'event': null},
    );
    _loadEventsForDate();
  }

  Future<void> _goToEditEvent(Event event) async {
    await Navigator.pushNamed(
      context,
      '/add_edit',
      arguments: {'date': widget.selectedDate, 'event': event},
    );
    _loadEventsForDate();
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = formatDateFriendly(widget.selectedDate);

    return Scaffold(
      appBar: AppBar(title: Text('Events - $dateLabel')),
      body: _events.isEmpty
          ? const Center(child: Text('No events for this date yet.'))
          : ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return EventTile(
                  event: event,
                  onEdit: () => _goToEditEvent(event),
                  onDelete: () => _deleteEvent(event),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddEvent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
