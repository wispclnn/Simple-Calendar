import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../utils/date_utils.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EventTile({
    super.key,
    required this.event,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(event.title),
      subtitle: Text(
        (event.description?.isNotEmpty == true
                ? '${event.description}\n'
                : '') +
            'Date: ${formatDateFriendly(event.date)}',
      ),
      isThreeLine: event.description?.isNotEmpty == true,
      trailing: Wrap(
        spacing: 8,
        children: [
          IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
        ],
      ),
    );
  }
}
