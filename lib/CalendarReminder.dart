import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() => runApp(CalendarReminderApp());

class CalendarReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReminderHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ReminderHomePage extends StatefulWidget {
  @override
  _ReminderHomePageState createState() => _ReminderHomePageState();
}

class _ReminderHomePageState extends State<ReminderHomePage> {
  final List<Map<String, dynamic>> _events = [];
  String? _selectedCategory;
  final List<String> _categories = ['All', 'Work', 'Personal', 'Urgent'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'All';
  }

  List<Map<String, dynamic>> get _filteredEvents {
    if (_selectedCategory == 'All') return _events;
    return _events
        .where((event) => event['category'] == _selectedCategory)
        .toList();
  }

  void _addNewEvent(Map<String, dynamic> newEvent) {
    setState(() {
      _events.add(newEvent);
    });
  }

  void _deleteEvent(int index) {
    setState(() {
      _events.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar Reminder',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedCategory,
              items: _categories
                  .map((category) =>
                      DropdownMenuItem(value: category, child: Text(category)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
          ),
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime(1800),
            lastDay: DateTime(2100),
            calendarFormat: CalendarFormat.month,
            onDaySelected: (selectedDay, focusedDay) {},
            calendarStyle: CalendarStyle(
              todayDecoration:
                  BoxDecoration(color: Colors.black, shape: BoxShape.circle),
              defaultTextStyle: TextStyle(color: Colors.black),
            ),
            headerStyle: HeaderStyle(
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
              formatButtonTextStyle: TextStyle(color: Colors.black),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.black),
              weekendStyle: TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: _filteredEvents.isEmpty
                ? Center(child: Text('No Events'))
                : ListView.builder(
                    itemCount: _filteredEvents.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(_filteredEvents[index]['title']),
                          subtitle: Text(
                              '${_filteredEvents[index]['date']} • ${_filteredEvents[index]['startTime']} - ${_filteredEvents[index]['endTime']}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteEvent(index),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventDetailsPage(
                                  event: _filteredEvents[index],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventPage(onAddEvent: _addNewEvent),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.black,
      ),
    );
  }
}

class AddEventPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddEvent;

  AddEventPage({required this.onAddEvent});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedCategory;
  final List<String> _categories = ['Work', 'Personal', 'Urgent'];

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickTime(bool isStart) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  void _saveEvent() {
    if (_titleController.text.isEmpty ||
        _selectedDate == null ||
        _startTime == null ||
        _endTime == null ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the details')),
      );
      return;
    }
    final newEvent = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
      'startTime': _startTime!.format(context),
      'endTime': _endTime!.format(context),
      'category': _selectedCategory,
    };
    widget.onAddEvent(newEvent);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Add New Event'), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  hintText: "Enter Title", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  hintText: "Enter Description", border: OutlineInputBorder()),
            ),
            ElevatedButton(onPressed: _pickDate, child: Text('Select Date')),
            ElevatedButton(
                onPressed: () => _pickTime(true), child: Text('Start Time')),
            ElevatedButton(
                onPressed: () => _pickTime(false), child: Text('End Time')),
            DropdownButton<String>(
              value: _selectedCategory,
              hint: Text("Select Category"),
              items: _categories
                  .map((category) =>
                      DropdownMenuItem(value: category, child: Text(category)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            ElevatedButton(onPressed: _saveEvent, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}

class EventDetailsPage extends StatelessWidget {
  final Map<String, dynamic> event;

  EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Title: ${event['title']}'),
            Text('Date: ${event['date']}'),
            Text('Time: ${event['startTime']} - ${event['endTime']}'),
            Text('Category: ${event['category']}'),
            Text('Description: ${event['description']}'),
          ],
        ),
      ),
    );
  }
}
