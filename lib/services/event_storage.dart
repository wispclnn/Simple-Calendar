import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/event_model.dart';
import '../utils/date_utils.dart';

class EventStorage {
  EventStorage._internal();

  static final EventStorage _instance = EventStorage._internal();

  factory EventStorage() => _instance;

  static const String _storageKey = 'events';

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  /// Load all events from SharedPreferences
  Future<List<Event>> getAllEvents() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If decoding fails, clear invalid data.
      await prefs.remove(_storageKey);
      return [];
    }
  }

  Future<void> _saveAllEvents(List<Event> events) async {
    final prefs = await _prefs;
    final List<Map<String, dynamic>> jsonList = events
        .map((e) => e.toJson())
        .toList();
    await prefs.setString(_storageKey, json.encode(jsonList));
  }

  /// Save a new event
  Future<void> saveEvent(Event event) async {
    final events = await getAllEvents();
    events.add(event);
    await _saveAllEvents(events);
  }

  /// Update an existing event
  Future<void> updateEvent(Event updated) async {
    final events = await getAllEvents();
    final index = events.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      events[index] = updated;
      await _saveAllEvents(events);
    }
  }

  /// Delete an event by id
  Future<void> deleteEvent(String id) async {
    final events = await getAllEvents();
    events.removeWhere((e) => e.id == id);
    await _saveAllEvents(events);
  }

  /// Search events by title or description (case-insensitive)
  Future<List<Event>> searchEvents(String query) async {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase();
    final events = await getAllEvents();
    return events.where((event) {
      final title = event.title.toLowerCase();
      final desc = (event.description ?? '').toLowerCase();
      return title.contains(q) || desc.contains(q);
    }).toList();
  }

  /// Helper to get events for a specific date
  Future<List<Event>> getEventsForDate(DateTime date) async {
    final events = await getAllEvents();
    return events.where((e) => isSameDate(e.date, date)).toList();
  }

  /// Helper to group events by date key (yyyy-MM-dd)
  Future<Map<String, List<Event>>> getEventsGroupedByDate() async {
    final events = await getAllEvents();
    final Map<String, List<Event>> map = {};
    for (final event in events) {
      final key = dateKey(event.date);
      map.putIfAbsent(key, () => []);
      map[key]!.add(event);
    }
    return map;
  }
}
