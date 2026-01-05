import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/event_storage.dart';
import '../models/event_model.dart';
import '../utils/date_utils.dart';
import '../widgets/calendar_grid.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final EventStorage _storage = EventStorage();

  late DateTime _currentMonth;
  Map<String, List<Event>> _eventsByDate = {};

  final List<String> _monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final grouped = await _storage.getEventsGroupedByDate();
    if (!mounted) return;
    setState(() {
      _eventsByDate = grouped;
    });
  }

  void _goToPrevMonth() {
    setState(() {
      _currentMonth = prevMonth(_currentMonth);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentMonth = nextMonth(_currentMonth);
    });
  }

  void _onDaySelected(DateTime date) async {
    await Navigator.pushNamed(context, '/events', arguments: {'date': date});
    _loadEvents();
  }

  String _monthLabel(DateTime date) {
    return '${_monthNames[date.month - 1]} ${date.year}';
  }

  // -------------------------------------------
  // iOS-STYLE MONTH & YEAR PICKER (CUPERTINO)
  // -------------------------------------------
  Future<DateTime?> _showMonthYearPickerIOS() async {
    int tempYear = _currentMonth.year;
    int tempMonth = _currentMonth.month;

    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (_) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              // iOS-style toolbar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoButton(
                      child: const Text("Done"),
                      onPressed: () =>
                          Navigator.pop(context, DateTime(tempYear, tempMonth)),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Row(
                  children: [
                    // YEAR PICKER
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 36,
                        scrollController: FixedExtentScrollController(
                          initialItem: tempYear - 1970,
                        ),
                        onSelectedItemChanged: (index) {
                          tempYear = 1970 + index;
                        },
                        children: List.generate(
                          200, // 1970-2170
                          (index) => Center(
                            child: Text(
                              "${1970 + index}",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // MONTH PICKER
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 36,
                        scrollController: FixedExtentScrollController(
                          initialItem: tempMonth - 1,
                        ),
                        onSelectedItemChanged: (index) {
                          tempMonth = index + 1;
                        },
                        children: List.generate(
                          12,
                          (index) => Center(
                            child: Text(
                              _monthNames[index],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // -------------------------------------------
  // BUILD UI
  // -------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Month navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _goToPrevMonth,
                ),

                // Tappable month title (opens iOS picker)
                GestureDetector(
                  onTap: () async {
                    final selected = await _showMonthYearPickerIOS();
                    if (selected != null) {
                      setState(() {
                        _currentMonth = DateTime(
                          selected.year,
                          selected.month,
                          1,
                        );
                      });
                      _loadEvents();
                    }
                  },
                  child: Text(
                    _monthLabel(_currentMonth),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _goToNextMonth,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Expanded(
              child: CalendarGrid(
                year: _currentMonth.year,
                month: _currentMonth.month,
                eventsByDate: _eventsByDate,
                onDaySelected: _onDaySelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
