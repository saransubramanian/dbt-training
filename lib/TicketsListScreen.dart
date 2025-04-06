import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

void main() {
  runApp(MaterialApp(
    title: 'Tickets Management',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const TicketsListScreen(),
  ));
}

// Global list to store saved tickets
List<Ticket> savedTickets = [];

// Ticket Status Enum
enum TicketStatus { pending, completed }

// 🎫 Tickets List Screen
class TicketsListScreen extends StatefulWidget {
  const TicketsListScreen({Key? key}) : super(key: key);

  @override
  _TicketsListScreenState createState() => _TicketsListScreenState();
}

class _TicketsListScreenState extends State<TicketsListScreen> {
  final List<Ticket> tickets = [
    Ticket(name: 'STORE 1', value: 0, list: []),
    Ticket(name: 'STORE 2', value: 0, list: []),
    Ticket(name: 'STORE 3', value: 0, list: []),
    Ticket(name: 'STORE 4', value: 0, list: []),
    Ticket(name: 'STORE 5', value: 0, list: []),
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
        title: const Text('Tickets List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TicketHistoryScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tickets...',
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

// 🎟️ Ticket Model
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
  DateTime dateTime;
  TicketStatus status; // New status property
  List<String> list; // List of items related to the ticket

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
    this.status = TicketStatus.pending,
    List<String>? list, // New list parameter
  })  : beforeAttachments = beforeAttachments ?? [],
        afterAttachments = afterAttachments ?? [],
        dateTime = dateTime ?? DateTime.now(),
        list = list ?? []; // Initialize the list to an empty list if null

  String get summary {
    return '$title - Expected End Date: $expectedEndDate';
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
                            name: ticket['name'],
                            value: ticket['value'],
                            list: []))
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TicketCreationPage(countryCode: countryCode)),
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

// 🎟️ Ticket Creation Page
class TicketCreationPage extends StatefulWidget {
  final String countryCode;

  const TicketCreationPage({required this.countryCode, Key? key})
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
      _ticketId = "PT-$idNumber-${widget.countryCode}";
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

  Future<void> _saveTicketAndGeneratePDF() async {
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
      list: [], // Initialize the list if needed
    );

    savedTickets.add(newTicket);
    Navigator.pop(context);
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
                onPressed: _saveTicketAndGeneratePDF,
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

// 🎟️ Ticket History Screen
class TicketHistoryScreen extends StatefulWidget {
  const TicketHistoryScreen({Key? key}) : super(key: key);

  @override
  _TicketHistoryScreenState createState() => _TicketHistoryScreenState();
}

class _TicketHistoryScreenState extends State<TicketHistoryScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredTickets = savedTickets.where((ticket) {
      // Check if the search text matches the ID, summary or items in the list
      bool matchesId =
          ticket.name.toLowerCase().contains(searchText.toLowerCase());
      bool matchesSummary =
          ticket.summary.toLowerCase().contains(searchText.toLowerCase());
      bool matchesList = ticket.list
          .any((item) => item.toLowerCase().contains(searchText.toLowerCase()));

      return matchesId || matchesSummary || matchesList;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket History'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search History...',
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
        itemCount: filteredTickets.length,
        itemBuilder: (context, index) {
          final ticket = filteredTickets[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Card(
              color: Colors.lightBlue[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  '${ticket.title} (${ticket.name}) - ${ticket.summary}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: Text(
                  ticket.status.toString().split('.').last,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TicketDetailsPage(ticket: ticket)),
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

// 🎟️ Ticket Details Page
class TicketDetailsPage extends StatelessWidget {
  final Ticket ticket;

  const TicketDetailsPage({required this.ticket, Key? key}) : super(key: key);

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Ticket ID: ${ticket.name}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Current Date & Time: ${ticket.dateTime}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Title: ${ticket.title}'),
              pw.SizedBox(height: 10),
              pw.Text('Expected End Date: ${ticket.expectedEndDate}'),
              pw.SizedBox(height: 10),
              pw.Text('Category: ${ticket.category}'),
              pw.SizedBox(height: 10),
              pw.Text('Job Description: ${ticket.jobDescription}'),
              pw.SizedBox(height: 10),
              pw.Text('Location: ${ticket.location}'),
              pw.SizedBox(height: 20),
              pw.Text(
                  'Ticket List: ${ticket.list.join(", ")}'), // Correctly joins the list
              pw.SizedBox(height: 20),
              pw.Text('Before Attachments:'),
              pw.SizedBox(height: 5),
              ...ticket.beforeAttachments.map((file) =>
                  pw.Text(file?.path.split('/').last ?? 'No file attached')),
              pw.SizedBox(height: 20),
              pw.Text('After Attachments:'),
              pw.SizedBox(height: 5),
              ...ticket.afterAttachments.map((file) =>
                  pw.Text(file?.path.split('/').last ?? 'No file attached')),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final filepath =
        '${directory.path}/${ticket.name}.pdf'; // Using name as ticket ID
    final file = File(filepath);
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(filepath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _generatePdf(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow('Ticket ID', ticket.name),
            _buildDetailRow('Current Date & Time', ticket.dateTime.toString()),
            _buildDetailRow('Title', ticket.title),
            _buildDetailRow('Expected End Date', ticket.expectedEndDate),
            _buildDetailRow('Category', ticket.category),
            _buildDetailRow('Job Description', ticket.jobDescription),
            _buildDetailRow('Location', ticket.location),
            _buildDetailRow('Ticket List',
                ticket.list.join(", ")), // Correctly display Ticket List
            _buildDetailRow(
                'Ticket Summary', ticket.summary), // Display Ticket Summary
            _buildAttachmentList(
                'Before Attachments', ticket.beforeAttachments),
            _buildAttachmentList('After Attachments', ticket.afterAttachments),
            ticket.status == TicketStatus.pending
                ? _completeTicketButton(context, ticket)
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _completeTicketButton(BuildContext context, Ticket ticket) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          _completeTicket(context, ticket);
        },
        child: const Text("Complete Ticket"),
      ),
    );
  }

  Future<void> _completeTicket(BuildContext context, Ticket ticket) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Complete Ticket"),
          content: const Text("Are you sure you want to complete this ticket?"),
          actions: [
            TextButton(
              onPressed: () {
                ticket.status =
                    TicketStatus.completed; // Change the status to completed
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the ticket details page
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text('$label:',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentList(String label, List<File?> files) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          ...files
              .map((file) =>
                  Text(file?.path.split('/').last ?? 'No file attached'))
              .toList(),
        ],
      ),
    );
  }
}
