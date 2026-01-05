import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../utils/date_utils.dart';
import 'day_cell.dart';

typedef DaySelectedCallback = void Function(DateTime date);

class CalendarGrid extends StatelessWidget {
  final int year;
  final int month;
  final Map<String, List<Event>> eventsByDate;
  final DaySelectedCallback onDaySelected;

  const CalendarGrid({
    super.key,
    required this.year,
    required this.month,
    required this.eventsByDate,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final monthDate = DateTime(year, month, 1);
    final firstWeekday = firstWeekdayOfMonth(monthDate); // 1-7
    final daysCount = daysInMonth(monthDate);

    // Number of leading empty cells (assuming week starts Monday)
    final leading = firstWeekday - 1;

    final totalCells = leading + daysCount;
    final trailing = (totalCells % 7 == 0) ? 0 : (7 - (totalCells % 7));
    final itemCount = totalCells + trailing;

    final today = DateTime.now();

    return Column(
      children: [
        // Weekday header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _WeekdayLabel('Mon'),
            _WeekdayLabel('Tue'),
            _WeekdayLabel('Wed'),
            _WeekdayLabel('Thu'),
            _WeekdayLabel('Fri'),
            _WeekdayLabel('Sat'),
            _WeekdayLabel('Sun'),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index < leading || index >= leading + daysCount) {
                // Empty cell (before first day or after last day)
                return const SizedBox.shrink();
              }

              final dayNumber = index - leading + 1;
              final date = DateTime(year, month, dayNumber);
              final key = dateKey(date);
              final hasEvents = eventsByDate.containsKey(key);
              final isTodayFlag = isSameDate(date, today);

              return DayCell(
                date: date,
                isToday: isTodayFlag,
                hasEvents: hasEvents,
                onTap: () => onDaySelected(date),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String label;

  const _WeekdayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
