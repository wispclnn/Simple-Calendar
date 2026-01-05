import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../services/event_storage.dart';
import '../utils/date_utils.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final EventStorage _storage = EventStorage();
  final TextEditingController _searchController = TextEditingController();

  List<Event> _results = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onSearchChanged(String query) async {
    setState(() {
      _isSearching = true;
    });

    final results = await _storage.searchEvents(query);

    if (!mounted) return;
    setState(() {
      _results = results;
      _isSearching = false;
    });
  }

  Map<String, List<Event>> _groupByDate(List<Event> events) {
    final Map<String, List<Event>> grouped = {};
    for (final e in events) {
      final key = dateKey(e.date);
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(e);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDate(_results);
    final dateKeys = grouped.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Search Events')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by title or description...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          if (_isSearching) const LinearProgressIndicator(),
          Expanded(
            child: _results.isEmpty && !_isSearching
                ? const Center(child: Text('No results'))
                : ListView.builder(
                    itemCount: dateKeys.length,
                    itemBuilder: (context, index) {
                      final key = dateKeys[index];
                      final events = grouped[key]!;
                      return _DateGroup(dateLabel: key, events: events);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DateGroup extends StatelessWidget {
  final String dateLabel;
  final List<Event> events;

  const _DateGroup({required this.dateLabel, required this.events});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(dateLabel),
      children: events
          .map(
            (e) => ListTile(
              title: Text(e.title),
              subtitle: e.description != null && e.description!.isNotEmpty
                  ? Text(e.description!)
                  : null,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/events',
                  arguments: {'date': e.date},
                );
              },
            ),
          )
          .toList(),
    );
  }
}
