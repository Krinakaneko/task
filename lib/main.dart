import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1－5　カレンダー',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {};
  Map<String, bool> _tasks = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('1－5　カレンダー'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  bool allCompleted =
                      events.every((task) => _tasks[task] == true);
                  return Icon(
                    Icons.edit,
                    color: allCompleted ? Colors.grey : Colors.blue,
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: _selectedDay != null && _events[_selectedDay] != null
                ? ListView.builder(
                    itemCount: _events[_selectedDay]!.length,
                    itemBuilder: (context, index) {
                      String task = _events[_selectedDay]![index];
                      return CheckboxListTile(
                        title: Text(task),
                        value: _tasks[task],
                        onChanged: (bool? value) {
                          setState(() {
                            _tasks[task] = value ?? false;
                          });
                        },
                      );
                    },
                  )
                : Center(child: Text('Select a day to see tasks')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Add Task',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty && _selectedDay != null) {
                  setState(() {
                    if (_events[_selectedDay] == null) {
                      _events[_selectedDay!] = [];
                    }
                    _events[_selectedDay]!.add(value);
                    _tasks[value] = false;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
