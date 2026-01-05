import 'package:flutter/material.dart';

class DayCell extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final bool hasEvents;
  final VoidCallback onTap;

  const DayCell({
    super.key,
    required this.date,
    required this.isToday,
    required this.hasEvents,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isToday ? Colors.white : Colors.black87;
    final bgColor = isToday ? Colors.indigo : Colors.transparent;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
            ),
            const SizedBox(height: 4),
            if (hasEvents)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isToday ? Colors.white : Colors.indigo,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
