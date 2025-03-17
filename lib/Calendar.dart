import 'package:flutter/material.dart';
import 'package:reminders/reminders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReminderScreen(),
    );
  }
}

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final Reminders reminders = Reminders();
  RemList? currentList;
  List<RemList> allLists = [];

  @override
  void initState() {
    super.initState();
    _initializeReminders();
  }

  Future<void> _initializeReminders() async {
    bool isGranted = await reminders.requestPermission();
    if (!mounted) return;

    if (isGranted) {
      await _loadLists();
    }
  }

  Future<void> _loadLists() async {
    final lists = await reminders.getAllLists();
    if (!mounted) return;

    setState(() {
      allLists = lists;
      if (allLists.isNotEmpty) {
        currentList = allLists.first;
      }
    });
  }

  Future<List<Reminder>> _getReminders() async {
    if (currentList == null) return [];
    return await reminders.getReminders() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Reminders"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<RemList>(
              hint: const Text("Select a list"),
              value: currentList,
              items: allLists.map((list) {
                return DropdownMenuItem(
                  value: list,
                  child: Text(list.title),
                );
              }).toList(),
              onChanged: (selectedList) {
                if (!mounted) return;
                setState(() {
                  currentList = selectedList;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Reminder>>(
              future: _getReminders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No reminders found"));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final reminder = snapshot.data![index];
                    return ListTile(
                      title: Text(reminder.title),
                      subtitle: Text(reminder.dueDate?.toLocal().toString() ??
                          "No due date"),
                    );
                  },
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
            MaterialPageRoute(builder: (context) => const CreateEventScreen()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          startTime = pickedTime;
        } else {
          endTime = pickedTime;
        }
      });
    }
  }

  void _saveEvent() {
    if (_titleController.text.isEmpty ||
        selectedDate == null ||
        startTime == null ||
        endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Event")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title")),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _pickDate,
                child: Text(selectedDate == null
                    ? "Select Date"
                    : selectedDate.toString())),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () => _pickTime(true),
                child: Text(startTime == null
                    ? "Select Start Time"
                    : startTime.toString())),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () => _pickTime(false),
                child: Text(
                    endTime == null ? "Select End Time" : endTime.toString())),
            const SizedBox(height: 10),
            TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description")),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _saveEvent, child: const Text("Save Event")),
          ],
        ),
      ),
    );
  }
}
