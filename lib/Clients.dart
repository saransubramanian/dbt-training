import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CountryPickerScreen(),
    );
  }
}

class CountryPickerScreen extends StatefulWidget {
  @override
  _CountryPickerScreenState createState() => _CountryPickerScreenState();
}

class _CountryPickerScreenState extends State<CountryPickerScreen> {
  Country? selectedCountry; // Nullable to avoid errors

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCountryPicker();
    });
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      countryListTheme: CountryListThemeData(
        backgroundColor: Colors.white, // White background
        searchTextStyle: TextStyle(color: Colors.black),
        textStyle: TextStyle(color: Colors.black), // Country name color
        inputDecoration: InputDecoration(
          hintText: 'Search...',
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          prefixIcon: Icon(Icons.search, color: Colors.black),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country;
        });

        // ✅ Print selected country
        print("Selected Country: ${country.name} (${country.countryCode})");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Full white background
      body: Center(
        child: Text(
          selectedCountry != null
              ? "Selected Country: ${selectedCountry!.name} (${selectedCountry!.countryCode})"
              : "Select a Country",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
