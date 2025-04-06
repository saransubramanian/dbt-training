import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  File? _image;
  File? _tempImage;
  final picker = ImagePicker();
  bool _isPickingImage = false;
  String selectedMonth = "January";
  String selectedYear = "2025";

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    _isPickingImage = true;

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _tempImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }

    _isPickingImage = false;
  }

  Future<void> _saveImage() async {
    if (_tempImage == null) return;
    final directory = await getApplicationDocumentsDirectory();
    final newImage = File('${directory.path}/profile_image.png');
    await _tempImage!.copy(newImage.path);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', newImage.path);
    setState(() {
      _image = newImage;
      _tempImage = null;
    });
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? const Icon(Icons.person,
                            size: 50, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: const Text("Sankar",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            if (_tempImage != null) ...[
              const SizedBox(height: 10),
              Image.file(_tempImage!, height: 100),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveImage,
                child: const Text("Done"),
              ),
            ],
            const SizedBox(height: 20),
            _buildInfoBox("Total Tickets", "0"),
            const SizedBox(height: 10),
            _buildInfoBox("Yearly Ticket Cost", "\$0"),
            const SizedBox(height: 20),
            const Text("Tickets",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text("Recorder Monthly",
                style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: _buildDropdown([
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
                  "December"
                ], selectedMonth, (String? newValue) {
                  setState(() {
                    selectedMonth = newValue!;
                  });
                })),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildDropdown([
                  for (int year = 1800; year <= 2030; year++) year.toString()
                ], selectedYear, (String? newValue) {
                  setState(() {
                    selectedYear = newValue!;
                  });
                })),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 5),
          Text(value,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String selectedValue,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      value: selectedValue,
      onChanged: onChanged,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
            show: true, drawHorizontalLine: true, horizontalInterval: 1),
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true))),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(spots: const [
            FlSpot(0, 1),
            FlSpot(1, 3),
            FlSpot(2, 2),
            FlSpot(3, 1.5),
            FlSpot(4, 3.5)
          ], isCurved: true, color: Colors.blue, barWidth: 3),
        ],
      ),
    );
  }
}
