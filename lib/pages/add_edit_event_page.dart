import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../services/event_storage.dart';

class AddEditEventPage extends StatefulWidget {
  final DateTime selectedDate;
  final Event? event;

  const AddEditEventPage({super.key, required this.selectedDate, this.event});

  @override
  State<AddEditEventPage> createState() => _AddEditEventPageState();
}

class _AddEditEventPageState extends State<AddEditEventPage> {
  final _formKey = GlobalKey<FormState>();
  final EventStorage _storage = EventStorage();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  bool get isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.event?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final date = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    );

    if (isEditing) {
      final updated = widget.event!.copyWith(
        title: title,
        description: description.isEmpty ? null : description,
        date: date,
      );
      await _storage.updateEvent(updated);
    } else {
      final newEvent = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description.isEmpty ? null : description,
        date: date,
      );
      await _storage.saveEvent(newEvent);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Event' : 'Add Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(isEditing ? 'Save Changes' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
