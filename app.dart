import 'package:flutter/material.dart';

import 'pages/calendar_page.dart';
import 'pages/event_list_page.dart';
import 'pages/add_edit_event_page.dart';
import 'pages/search_page.dart';
import 'models/event_model.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CalendarPage(),
        '/calendar': (context) => const CalendarPage(),
        '/events': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          final selectedDate = args['date'] as DateTime;
          return EventListPage(selectedDate: selectedDate);
        },
        '/add_edit': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          final selectedDate = args['date'] as DateTime;
          final event = args['event'] as Event?;
          return AddEditEventPage(selectedDate: selectedDate, event: event);
        },
        '/search': (context) => const SearchPage(),
      },
    );
  }
}
