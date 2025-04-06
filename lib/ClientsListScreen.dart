import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    title: 'Clients Management',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const ClientsListScreen(),
  ));
}

// Global list to store saved tickets
List<Ticket> savedTickets = [];

// 🎫 Ticket Class
class Ticket {
  final String name;
  final int value;
  String title;
  String expectedEndDate;
  String category;
  String jobDescription;
  String location;
  List<File?> beforeAttachments;
  List<File?> afterAttachments;
  DateTime dateTime; // Date of ticket creation

  Ticket({
    required this.name,
    required this.value,
    this.title = "",
    this.expectedEndDate = "",
    this.category = "",
    this.jobDescription = "",
    this.location = "",
    List<File?>? beforeAttachments,
    List<File?>? afterAttachments,
    DateTime? dateTime,
  })  : beforeAttachments = beforeAttachments ?? [],
        afterAttachments = afterAttachments ?? [],
        dateTime = dateTime ?? DateTime.now();

  String get summary {
    return '$title - Expected End Date: $expectedEndDate';
  }
}

// 🎫 Clients List Screen
class ClientsListScreen extends StatefulWidget {
  const ClientsListScreen({Key? key}) : super(key: key);

  @override
  _ClientsListScreenState createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends State<ClientsListScreen> {
  final List<Ticket> tickets = [
    Ticket(name: 'STORE 1', value: 0),
    Ticket(name: 'STORE 2', value: 0),
    Ticket(name: 'STORE 3', value: 0),
    Ticket(name: 'STORE 4', value: 0),
    Ticket(name: 'STORE 5', value: 0),
  ];

  final List<Color> nameColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
  ];

  final Color valueBgColor = Colors.yellow;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients List'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Clients...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.trim().toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];

          if (!ticket.name.toLowerCase().contains(searchText)) {
            return const SizedBox.shrink();
          }

          Color nameBgColor = nameColors[index % nameColors.length];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Card(
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: nameBgColor,
                  child: Text(
                    ticket.name[0],
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(ticket.name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: valueBgColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${ticket.value}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                onTap: () {
                  // Navigate to the Ticket Summary Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CountrySelectionScreen()),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// 🌍 Country Selection Screen
class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({Key? key}) : super(key: key);

  @override
  _CountrySelectionScreenState createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  final List<Color> nameColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
  ];

  final Color valueBgColor = Colors.yellow;
  String searchText = '';

  final List<Map<String, dynamic>> countries = [
    {
      'name': 'Australia',
      'flag': '🇦🇺',
      'code': 'AU',
      'tickets': [
        {'name': 'A', 'value': 0},
        {'name': 'B', 'value': 0},
        {'name': 'C', 'value': 0},
        {'name': 'D', 'value': 0},
        {'name': 'E', 'value': 0},
      ],
    },
    {
      'name': 'New Zealand',
      'flag': '🇳🇿',
      'code': 'NZ',
      'tickets': [
        {'name': 'F', 'value': 0},
        {'name': 'G', 'value': 0},
        {'name': 'H', 'value': 0},
        {'name': 'I', 'value': 0},
        {'name': 'J', 'value': 0},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Country'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search countries...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.trim().toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: countries.length,
        itemBuilder: (context, index) {
          final country = countries[index];

          if (!country['name'].toLowerCase().contains(searchText)) {
            return const SizedBox.shrink();
          }

          return ListTile(
            title: Row(
              children: [
                Text(country['flag'], style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(country['name']),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketSummaryScreen(
                    countryName: country['name'],
                    countryCode: country['code'],
                    tickets: (country['tickets'] as List<dynamic>)
                        .map((ticket) => Ticket(
                            name: ticket['name'], value: ticket['value']))
                        .toList(),
                    nameColors: nameColors,
                    valueBgColor: valueBgColor,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// 📊 Ticket Summary Screen
class TicketSummaryScreen extends StatelessWidget {
  final String countryName;
  final String countryCode;
  final List<Ticket> tickets;
  final List<Color> nameColors;
  final Color valueBgColor;

  const TicketSummaryScreen({
    required this.countryName,
    required this.countryCode,
    required this.tickets,
    required this.nameColors,
    required this.valueBgColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$countryName - Ticket Summary')),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          Color nameBgColor = nameColors[index % nameColors.length];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.grey[200],
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: nameBgColor,
                  child: Text(
                    tickets[index].name[0],
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(tickets[index].name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: valueBgColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${tickets[index].value}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                onTap: () {
                  // Navigate to the Ticket Detail Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketDetailPage(
                        countryCode: countryCode,
                        ticket: tickets[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// 🎫 Ticket Detail Page
class TicketDetailPage extends StatelessWidget {
  final String countryCode;
  final Ticket ticket;

  const TicketDetailPage({
    required this.countryCode,
    required this.ticket,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ticket.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Ticket Creation Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TicketCreationPage(countryCodes: [countryCode]),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// 🎟️ Ticket Creation Page
class TicketCreationPage extends StatefulWidget {
  final List<String> countryCodes;

  const TicketCreationPage({required this.countryCodes, Key? key})
      : super(key: key);

  @override
  _TicketCreationPageState createState() => _TicketCreationPageState();
}

class _TicketCreationPageState extends State<TicketCreationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _expectedEndDateController =
      TextEditingController();

  String _ticketId = "";
  String _dateTime = "";
  List<XFile?> _beforeAttachments = [];
  List<XFile?> _afterAttachments = [];

  final List<String> _categories = [
    "Interior & General",
    "Electrical",
    "HVAC System",
    "Plumbing & Pest",
    "Fire Protection",
    "AV System",
    "IT & Security",
    "Carpentry Work",
    "Furniture & Rugs",
    "Additional Works",
    "Cleaning Service",
    "Preventive Repair",
    "Corrective Maintenance",
    "Finance Services",
  ];

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _generateTicketId();
    _setCurrentDateTime();
  }

  void _generateTicketId() {
    final idNumber = Random().nextInt(9000) + 1000;
    setState(() {
      _ticketId = "PT-$idNumber-${widget.countryCodes.join('-')}";
    });
  }

  void _setCurrentDateTime() {
    setState(() {
      _dateTime = DateTime.now().toString();
    });
  }

  Future<void> _pickFiles(bool isBefore) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile?> pickedFiles = await picker.pickMultiImage();
    List<XFile?> validFiles = [];

    if (pickedFiles.isNotEmpty) {
      for (var file in pickedFiles) {
        if (file != null) {
          final fileExtension = file.path.toLowerCase().split('.').last;
          // Allow only images, mp4 videos, and PDFs
          if (['jpg', 'jpeg', 'png', 'mp4', 'pdf'].contains(fileExtension)) {
            validFiles.add(file);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Only .jpg, .jpeg, .png, .mp4, and .pdf files are allowed.')),
            );
          }
        }
      }

      setState(() {
        if (isBefore) {
          _beforeAttachments = validFiles;
        } else {
          _afterAttachments = validFiles;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _expectedEndDateController.text =
            "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveTicket() async {
    if (_titleController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _jobDescriptionController.text.isEmpty ||
        _selectedCategory == null ||
        _expectedEndDateController.text.isEmpty) {
      _showErrorDialog("Please fill all required fields.");
      return;
    }

    List<File?> beforeFiles = _beforeAttachments
        .map((xFile) => xFile != null ? File(xFile.path) : null)
        .toList();
    List<File?> afterFiles = _afterAttachments
        .map((xFile) => xFile != null ? File(xFile.path) : null)
        .toList();

    Ticket newTicket = Ticket(
      name: _ticketId,
      value: 0,
      title: _titleController.text,
      expectedEndDate: _expectedEndDateController.text,
      category: _selectedCategory!,
      jobDescription: _jobDescriptionController.text,
      location: _locationController.text,
      beforeAttachments: beforeFiles,
      afterAttachments: afterFiles,
      dateTime: DateTime.parse(_dateTime),
    );

    savedTickets.add(newTicket); // Save new ticket
    Navigator.pop(context); // Close the current page after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Ticket"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoContainer("Ticket ID: $_ticketId"),
            const SizedBox(height: 8),
            _buildInfoContainer("Current Date & Time: $_dateTime"),
            const SizedBox(height: 16),
            _buildTitleInput(),
            const SizedBox(height: 8),
            _buildExpectedEndDateInput(),
            const SizedBox(height: 8),
            _buildCategoryDropdown(),
            const SizedBox(height: 8),
            _buildJobDescriptionInput(),
            const SizedBox(height: 8),
            _buildLocationInput(),
            const SizedBox(height: 8),
            _buildFilePickerButton(true, "Attach Before: Image, Video, PDF"),
            const SizedBox(height: 16),
            _buildSelectedFilesDisplay(
                _beforeAttachments, "Before Attachments"),
            const SizedBox(height: 8),
            _buildFilePickerButton(false, "Attach After: Image, Video, PDF"),
            const SizedBox(height: 16),
            _buildSelectedFilesDisplay(_afterAttachments, "After Attachments"),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: _saveTicket,
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String text) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildExpectedEndDateInput() {
    return _buildInputContainer(
      GestureDetector(
        onTap: () => _selectEndDate(context),
        child: AbsorbPointer(
          child: TextField(
            controller: _expectedEndDateController,
            decoration: InputDecoration(
              labelText: "Expected End Date (YYYY-MM-DD)",
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.blue), // Color when enabled
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red), // Color when focused
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleInput() {
    return _buildInputContainer(
      TextField(
        controller: _titleController,
        decoration: InputDecoration(
          labelText: "Title",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue), // Color when enabled
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Color when focused
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return _buildInputContainer(
      DropdownButtonFormField<String>(
        value: _selectedCategory,
        hint: const Text("Select Category"),
        onChanged: (newValue) => setState(() => _selectedCategory = newValue),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue), // Color when enabled
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Color when focused
          ),
        ),
        items: _categories
            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
            .toList(),
      ),
    );
  }

  Widget _buildJobDescriptionInput() {
    return _buildInputContainer(
      TextField(
        controller: _jobDescriptionController,
        decoration: InputDecoration(
          labelText: "Job Description",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue), // Color when enabled
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Color when focused
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInput() {
    return _buildInputContainer(
      TextField(
        controller: _locationController,
        decoration: InputDecoration(
          labelText: "Location",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue), // Color when enabled
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Color when focused
          ),
        ),
      ),
    );
  }

  Widget _buildFilePickerButton(bool isBefore, String label) {
    return _buildInputContainer(
      Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ElevatedButton(
          onPressed: () => _pickFiles(isBefore),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }

  Widget _buildSelectedFilesDisplay(List<XFile?> attachments, String title) {
    return _buildInputContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (attachments.isNotEmpty)
            ...attachments.map((file) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  file?.name ?? 'No file selected',
                  style: TextStyle(
                      color: file == null ? Colors.red : Colors.black),
                ),
              );
            })
          else
            const Text('No files selected'),
        ],
      ),
    );
  }

  Widget _buildInputContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey),
      ),
      child: child,
    );
  }
}
