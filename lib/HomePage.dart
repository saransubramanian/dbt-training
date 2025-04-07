import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;

    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: HomePage(onThemeChanged: _toggleTheme),
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(bool) onThemeChanged;

  HomePage({required this.onThemeChanged});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [
    Center(child: Text("Dashboard", style: TextStyle(fontSize: 22))),
    Center(child: Text("Tickets", style: TextStyle(fontSize: 22))),
    Center(child: Text("Clients", style: TextStyle(fontSize: 22))),
    Center(child: Text("Calendar Reminder", style: TextStyle(fontSize: 22))),
    Center(child: Text("Account", style: TextStyle(fontSize: 22))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PROTEKFM",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SettingsPage(onThemeChanged: widget.onThemeChanged)));
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.white,
        color: Colors.black,
        height: 75,
        animationDuration: Duration(milliseconds: 300),
        index: _selectedIndex,
        items: const [
          Icon(Icons.dashboard, size: 35, color: Colors.white),
          Icon(Icons.confirmation_number, size: 35, color: Colors.white),
          Icon(Icons.people, size: 35, color: Colors.white),
          Icon(Icons.calendar_today, size: 35, color: Colors.white),
          Icon(Icons.account_circle, size: 35, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// --------------------- SETTINGS PAGE ---------------------
class SettingsPage extends StatelessWidget {
  final Function(bool) onThemeChanged;

  SettingsPage({required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"), backgroundColor: Colors.black),
      body: ListView(
        children: [
          settingsCategory("Account Settings"),
          settingsItem(
              context, "Profile Information", ProfileInformationPage()),
          settingsItem(context, "Change Password", ChangePasswordPage()),
          settingsItem(
              context, "Two-Factor Authentication", TwoFactorAuthPage()),
          settingsItem(context, "Manage Devices", ManageDevicesPage()),
          settingsItem(context, "Delete Account", DeleteAccountPage()),
          settingsCategory("App Preferences"),
          settingsItem(context, "Theme Mode",
              ThemeModePage(onThemeChanged: onThemeChanged)),
          settingsItem(context, "Language Selection", LanguageSelectionPage()),
          settingsItem(
              context, "Notification Settings", NotificationSettingsPage()),
          settingsItem(
              context, "Sounds & Vibration", SoundVibrationSettingsPage()),
          settingsItem(
              context, "Default Dashboard View", DefaultDashboardViewPage()),
          settingsCategory("Security & Privacy"),
          settingsItem(context, "APP Lock", AppLockPage()),
          settingsItem(context, "Clear Cache", ClearCachePage()),
          settingsItem(
              context, "Privacy Policy & Terms", PrivacyPolicyTermsPage()),
          settingsCategory("Ticket & Client Management"),
          settingsItem(context, "Auto Assign Tickets", AutoAssignTicketsPage()),
          settingsItem(context, "Priority Notification Settings",
              PriorityNotificationSettingsPage()),
          settingsItem(
              context, "Default Ticket Status", DefaultTicketStatusPage()),
          settingsCategory("Backup & Sync"),
          settingsItem(context, "Cloud Backup", CloudBackupPage()),
          settingsItem(context, "Sync with Other Devices", SyncDevicesPage()),
          settingsCategory("About & Help"),
          settingsItem(context, "App Version", AppVersionPage()),
          settingsItem(context, "Check for Updates", CheckForUpdatesPage()),
          settingsItem(context, "FAQs & Tutorials", FAQsTutorialsPage()),
        ],
      ),
    );
  }

  Widget settingsCategory(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget settingsItem(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => page)),
    );
  }
}

// --------------------- Profile Information Page ---------------------
class ProfileInformationPage extends StatefulWidget {
  @override
  _ProfileInformationPageState createState() => _ProfileInformationPageState();
}

class _ProfileInformationPageState extends State<ProfileInformationPage> {
  final TextEditingController _nameController =
      TextEditingController(text: "Sankar");
  final TextEditingController _phoneController =
      TextEditingController(text: "123-456-7890");
  final TextEditingController _emailController =
      TextEditingController(text: "sankar@example.com");

  void _saveProfile() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Profile updated successfully!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Profile Information"),
          backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name")),
            TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: "Phone")),
            TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveProfile, child: Text("Save")),
          ],
        ),
      ),
    );
  }
}

// --------------------- Change Password Page ---------------------
class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.currentUser!.updatePassword(_newPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Password changed successfully!")));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Change Password"), backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "New Password")),
              TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Confirm Password"),
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  }),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _changePassword, child: Text("Change Password")),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------- Two-Factor Auth Page ---------------------
class TwoFactorAuthPage extends StatefulWidget {
  @override
  _TwoFactorAuthPageState createState() => _TwoFactorAuthPageState();
}

class _TwoFactorAuthPageState extends State<TwoFactorAuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();

  void _sendOTP() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: (credential) async =>
          await _auth.signInWithCredential(credential),
      verificationFailed: (e) => print("Error: ${e.message}"),
      codeSent: (String verificationId, int? resendToken) => print("Code Sent"),
      codeAutoRetrievalTimeout: (String verificationId) => print("Timeout"),
      timeout: Duration(seconds: 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Two-Factor Authentication"),
          backgroundColor: Colors.blueAccent),
      body: Column(children: [
        TextField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: "Phone Number")),
        ElevatedButton(onPressed: _sendOTP, child: Text("Send OTP"))
      ]),
    );
  }
}

// --------------------- Manage Devices Page ---------------------
class ManageDevicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Manage Devices"), backgroundColor: Colors.blueAccent),
      body: Center(child: Text("Device management feature coming soon!")),
    );
  }
}

// --------------------- Delete Account Page ---------------------
class DeleteAccountPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account deleted successfully!")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Delete Account"), backgroundColor: Colors.redAccent),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => _deleteAccount(context),
          child: Text("Delete Account Permanently"),
        ),
      ),
    );
  }
}

// Placeholder for App Version Page
class AppVersionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("App Version")),
      body: Center(
        child: Text("App Version: 1.0.0"),
      ),
    );
  }
}

// Placeholder for Check For Updates Page
class CheckForUpdatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Check for Updates")),
      body: Center(
        child: Text("Checking for updates..."),
      ),
    );
  }
}

//--------------------- Theme Mode Page ---------------------
class ThemeModePage extends StatefulWidget {
  final Function(bool) onThemeChanged;

  ThemeModePage({required this.onThemeChanged});

  @override
  _ThemeModePageState createState() => _ThemeModePageState();
}

class _ThemeModePageState extends State<ThemeModePage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false; // Default to false
    });
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
      widget.onThemeChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Theme Mode"), backgroundColor: Colors.blueAccent),
      body: SwitchListTile(
        title: Text("Dark Mode"),
        value: _isDarkMode,
        onChanged: _toggleTheme,
      ),
    );
  }
}

// --------------------- Language Selection Page ---------------------
class LanguageSelectionPage extends StatefulWidget {
  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String _selectedLanguage = "English";

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage =
          prefs.getString('language') ?? "English"; // Default to English
    });
  }

  void _saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    setState(() {
      _selectedLanguage = language;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Language set to $language")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Language Selection"),
          backgroundColor: Colors.blueAccent),
      body: Column(
        children: [
          ListTile(
            title: Text("English"),
            leading: Radio(
                value: "English",
                groupValue: _selectedLanguage,
                onChanged: (value) => _saveLanguage(value as String)),
          ),
          ListTile(
            title: Text("Spanish"),
            leading: Radio(
                value: "Spanish",
                groupValue: _selectedLanguage,
                onChanged: (value) => _saveLanguage(value as String)),
          ),
        ],
      ),
    );
  }
}

// --------------------- Notification Settings Page ---------------------
class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool smsNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Notification Settings"),
          backgroundColor: Colors.blueAccent),
      body: Column(
        children: [
          SwitchListTile(
            title: Text("Push Notifications"),
            value: pushNotifications,
            onChanged: (val) => setState(() => pushNotifications = val),
          ),
          SwitchListTile(
            title: Text("Email Notifications"),
            value: emailNotifications,
            onChanged: (val) => setState(() => emailNotifications = val),
          ),
          SwitchListTile(
            title: Text("SMS Notifications"),
            value: smsNotifications,
            onChanged: (val) => setState(() => smsNotifications = val),
          ),
        ],
      ),
    );
  }
}

// --------------------- Sound & Vibration Settings Page ---------------------
class SoundVibrationSettingsPage extends StatefulWidget {
  @override
  _SoundVibrationSettingsPageState createState() =>
      _SoundVibrationSettingsPageState();
}

class _SoundVibrationSettingsPageState
    extends State<SoundVibrationSettingsPage> {
  bool _soundEnabled = true; // Default to true
  bool _vibrationEnabled = true; // Default to true

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundEnabled = prefs.getBool('soundEnabled') ?? true; // Default to true
      _vibrationEnabled =
          prefs.getBool('vibrationEnabled') ?? true; // Default to true
    });
  }

  Future<void> _savePreference(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void _playSound() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("🔊 Sound played (Simulation)")));
  }

  void _vibratePhone() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator != null && hasVibrator) {
      Vibration.vibrate(duration: 500);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("📳 Vibration triggered (Simulation)")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Vibration not supported on this device")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Sounds & Vibration"),
          backgroundColor: Colors.blueAccent),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text("Enable Sound"),
            value: _soundEnabled,
            onChanged: (value) {
              setState(() {
                _soundEnabled = value;
                _savePreference('soundEnabled', value);
                if (value) _playSound();
              });
            },
          ),
          SwitchListTile(
            title: Text("Enable Vibration"),
            value: _vibrationEnabled,
            onChanged: (value) {
              setState(() {
                _vibrationEnabled = value;
                _savePreference('vibrationEnabled', value);
                if (value) _vibratePhone();
              });
            },
          ),
        ],
      ),
    );
  }
}

// --------------------- Default Dashboard View Page ---------------------
class DefaultDashboardViewPage extends StatefulWidget {
  @override
  _DefaultDashboardViewPageState createState() =>
      _DefaultDashboardViewPageState();
}

class _DefaultDashboardViewPageState extends State<DefaultDashboardViewPage> {
  String _selectedView = "Dashboard"; // Default selection

  final List<String> _dashboardViews = [
    "Dashboard",
    "Tickets",
    "Clients",
    "Calendar Reminder",
    "Account"
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedDashboardView();
  }

  Future<void> _loadSavedDashboardView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedView = prefs.getString('defaultDashboardView');
    if (savedView != null) {
      setState(() {
        _selectedView = savedView;
      });
    }
  }

  Future<void> _saveDashboardView(String view) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultDashboardView', view);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Default dashboard set to $view"),
          duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Default Dashboard View"),
          backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choose your Default Dashboard View:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedView,
              isExpanded: true,
              items: _dashboardViews.map((String view) {
                return DropdownMenuItem<String>(
                  value: view,
                  child: Text(view),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null && newValue != _selectedView) {
                  setState(() => _selectedView = newValue);
                  _saveDashboardView(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------- App Lock Page ---------------------
class AppLockPage extends StatefulWidget {
  @override
  _AppLockPageState createState() => _AppLockPageState();
}

class _AppLockPageState extends State<AppLockPage> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final storage = FlutterSecureStorage();

  Future<void> _savePin() async {
    await storage.write(key: 'app_pin', value: _newPinController.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("PIN Set Successfully!"),
      backgroundColor: Colors.green,
    ));
  }

  Future<void> _validatePin() async {
    String? savedPin = await storage.read(key: 'app_pin');
    if (savedPin == _pinController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Access Granted!"),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Incorrect PIN!"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Lock", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _newPinController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Set New PIN",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _savePin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Save PIN", style: TextStyle(color: Colors.white)),
            ),
            Divider(),
            TextField(
              controller: _pinController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Enter PIN",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _validatePin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child:
                  Text("Validate PIN", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------- Clear Cache Page ---------------------
class ClearCachePage extends StatefulWidget {
  @override
  _ClearCachePageState createState() => _ClearCachePageState();
}

class _ClearCachePageState extends State<ClearCachePage> {
  Future<void> _clearCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Cache cleared successfully!")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error clearing cache: $e")));
    }
  }

  Future<void> _clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("App data cleared successfully!")));
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text("Clear Cache & Data", style: TextStyle(color: Colors.blue)),
          content: Text("Are you sure? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearCache();
                _clearData();
              },
              child: Text("Clear", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clear Cache & Data")),
      body: Center(
        child: ElevatedButton(
          onPressed: _showConfirmationDialog,
          child: Text("Clear Cache & Data"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ),
    );
  }
}

// --------------------- Privacy Policy & Terms Page ---------------------
class PrivacyPolicyTermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Privacy Policy & Terms",
              style: TextStyle(color: Colors.white))),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Privacy Policy",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700)),
              SizedBox(height: 8),
              Text(
                  "We value your privacy and ensure that your data is protected. Our app collects minimal user information and follows strict security protocols.",
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Text("Terms & Conditions",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700)),
              SizedBox(height: 8),
              Text(
                  "By using our app, you agree to the terms and conditions outlined. Unauthorized use, data breach attempts, or policy violations may lead to service restrictions.",
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Text("User Agreement",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700)),
              SizedBox(height: 8),
              Text(
                  "Users must ensure their activities align with legal guidelines. We hold the right to modify the policies as necessary.",
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Back",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------- Auto Assign Tickets Page ---------------------
class AutoAssignTicketsPage extends StatefulWidget {
  @override
  _AutoAssignTicketsPageState createState() => _AutoAssignTicketsPageState();
}

class _AutoAssignTicketsPageState extends State<AutoAssignTicketsPage> {
  List<String> agents = ["Agent A", "Agent B", "Agent C", "Agent D"];
  List<Map<String, String>> tickets = [];
  int currentAgentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTickets = prefs.getString('tickets');
    if (savedTickets != null) {
      setState(() {
        tickets = List<Map<String, String>>.from(json.decode(savedTickets));
      });
    }
  }

  Future<void> _saveTickets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('tickets', json.encode(tickets));
  }

  void _assignTicket() {
    String assignedAgent = agents[currentAgentIndex];

    setState(() {
      tickets.add({
        "Ticket ID": "TICKET-${tickets.length + 1}",
        "Assigned To": assignedAgent,
      });
      currentAgentIndex =
          (currentAgentIndex + 1) % agents.length; // Round-robin assignment
      _saveTickets();
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Ticket assigned to $assignedAgent"),
        duration: Duration(seconds: 2)));
  }

  void _clearTickets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('tickets');

    setState(() {
      tickets.clear();
      currentAgentIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("All tickets cleared"), duration: Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Auto-Assign Tickets")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _assignTicket,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Assign New Ticket"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(tickets[index]["Ticket ID"] ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700)),
                      subtitle: Text(
                          "Assigned To: ${tickets[index]["Assigned To"] ?? ""}"),
                      leading: Icon(Icons.assignment, color: Colors.blue),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _clearTickets,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Clear All Tickets"),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------- Priority Notification Settings Page ---------------------
class PriorityNotificationSettingsPage extends StatefulWidget {
  @override
  _PriorityNotificationSettingsPageState createState() =>
      _PriorityNotificationSettingsPageState();
}

class _PriorityNotificationSettingsPageState
    extends State<PriorityNotificationSettingsPage> {
  String _selectedPriority = "High"; // Default priority

  @override
  void initState() {
    super.initState();
    _loadSavedPriority();
  }

  Future<void> _loadSavedPriority() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedPriority = prefs.getString('notificationPriority') ??
          "High"; // Default to "High"
    });
  }

  Future<void> _savePriority(String priority) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notificationPriority', priority);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Notification priority set to $priority")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Priority Notification Settings",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Notification Priority:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            RadioListTile(
              title: Text("High (Instant notifications with sound)"),
              value: "High",
              groupValue: _selectedPriority,
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value as String;
                  _savePriority(value); // Save new value
                });
              },
              activeColor: Colors.blue,
            ),
            RadioListTile(
              title: Text("Medium (Delayed notifications)"),
              value: "Medium",
              groupValue: _selectedPriority,
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value as String;
                  _savePriority(value); // Save new value
                });
              },
              activeColor: Colors.blue,
            ),
            RadioListTile(
              title: Text("Low (Silent notifications)"),
              value: "Low",
              groupValue: _selectedPriority,
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value as String;
                  _savePriority(value); // Save new value
                });
              },
              activeColor: Colors.blue,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  _savePriority(_selectedPriority);
                },
                child: Text("Save",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------- Default Ticket Status Page ---------------------
class DefaultTicketStatusPage extends StatefulWidget {
  @override
  _DefaultTicketStatusPageState createState() =>
      _DefaultTicketStatusPageState();
}

class _DefaultTicketStatusPageState extends State<DefaultTicketStatusPage> {
  String _selectedStatus = "Open"; // Default status

  final List<String> _statuses = [
    "Open",
    "In Progress",
    "On Hold",
    "Closed",
    "Resolved"
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedStatus();
  }

  Future<void> _loadSavedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedStatus =
          prefs.getString('defaultTicketStatus') ?? "Open"; // Default to "Open"
    });
  }

  Future<void> _saveStatus(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultTicketStatus', status);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Default Ticket Status changed to $status")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Default Ticket Status",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue.shade700),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choose Default Ticket Status:",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade700),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedStatus,
                  isExpanded: true,
                  icon:
                      Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                  items: _statuses.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status, style: TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedStatus = newValue;
                      });
                      _saveStatus(newValue);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------- Cloud Backup Page ---------------------
class CloudBackupPage extends StatefulWidget {
  @override
  _CloudBackupPageState createState() => _CloudBackupPageState();
}

class _CloudBackupPageState extends State<CloudBackupPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _backupData = ""; // Initialize with an empty string

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _backupToCloud() async {
    User? user = _auth.currentUser;

    if (user == null) {
      _showSnackbar("Please log in to backup data.");
      return;
    }

    var sampleData = {
      "name": "Sankar",
      "email": "sankar@example.com",
      "phone": "123-456-7890",
      "tickets": 42,
      "annual_ticket_cost": 5000,
    };

    try {
      await _firestore.collection("backups").doc(user.uid).set(sampleData);
      _showSnackbar("Backup successful!");
    } catch (e) {
      _showSnackbar("Error during backup: $e");
    }
  }

  Future<void> _restoreFromCloud() async {
    User? user = _auth.currentUser;

    if (user == null) {
      _showSnackbar("Please log in to restore data.");
      return;
    }

    try {
      DocumentSnapshot snapshot =
          await _firestore.collection("backups").doc(user.uid).get();
      if (snapshot.exists) {
        setState(() {
          _backupData = snapshot.data() != null
              ? snapshot.data().toString()
              : "No data found"; // Use safe fallback
        });
        _showSnackbar("Data restored successfully!");
      } else {
        _showSnackbar("No backup found.");
      }
    } catch (e) {
      _showSnackbar("Error during restore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cloud Backup")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Backup Data:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Text(_backupData.isEmpty ? "No backup data" : _backupData,
                  textAlign: TextAlign.center),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: _backupToCloud,
              icon: Icon(Icons.cloud_upload, color: Colors.white),
              label: Text("Backup to Cloud",
                  style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: _restoreFromCloud,
              icon: Icon(Icons.cloud_download, color: Colors.white),
              label: Text("Restore from Cloud",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------- Sync with Other Devices Page ---------------------
class SyncDevicesPage extends StatefulWidget {
  @override
  _SyncDevicesPageState createState() => _SyncDevicesPageState();
}

class _SyncDevicesPageState extends State<SyncDevicesPage> {
  final TextEditingController _dataController = TextEditingController();
  String? _userId;
  bool _isSyncing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getUserId();
  }

  Future<void> _getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      _loadUserData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not logged in! Please sign in.")));
    }
  }

  Future<void> _loadUserData() async {
    if (_userId == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('syncedData');

    if (savedData != null) {
      setState(() {
        _dataController.text = savedData;
      });
    }

    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(_userId).get();

    if (snapshot.exists) {
      setState(() {
        _dataController.text = snapshot['data'] ?? "";
      });
      prefs.setString('syncedData', snapshot['data'] ?? "");
    }
  }

  Future<void> _syncData() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User ID missing. Please log in.")));
      return;
    }

    setState(() {
      _isSyncing = true;
    });

    String userData = _dataController.text.trim();
    if (userData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter some data to sync.")));
      setState(() {
        _isSyncing = false;
      });
      return;
    }

    await FirebaseFirestore.instance.collection('users').doc(_userId).set({
      'data': userData,
      'timestamp': FieldValue.serverTimestamp(),
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('syncedData', userData);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Data synced successfully!")));

    setState(() {
      _isSyncing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sync with Other Devices")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dataController,
              decoration: InputDecoration(labelText: "Enter Data to Sync"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: _isSyncing ? null : _syncData,
              child: _isSyncing
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Sync Now"),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------- FAQs & Tutorials Page ---------------------
class FAQsTutorialsPage extends StatefulWidget {
  @override
  _FAQsTutorialsPageState createState() => _FAQsTutorialsPageState();
}

class _FAQsTutorialsPageState extends State<FAQsTutorialsPage> {
  final List<Map<String, String>> _faqs = [
    {
      "question": "How do I reset my password?",
      "answer": "Go to Settings > Change Password and follow the instructions."
    },
    {
      "question": "How can I contact support?",
      "answer":
          "You can contact our support team via email at support@example.com."
    },
    {
      "question": "How to enable notifications?",
      "answer":
          "Go to Settings > Notification Settings and enable push notifications."
    },
    {
      "question": "Can I use this app offline?",
      "answer": "Yes, but some features require an internet connection."
    },
    {
      "question": "How to delete my account?",
      "answer":
          "Go to Settings > Account Settings > Delete Account and follow the steps."
    },
  ];

  final List<Map<String, Widget>> _tutorials = [
    {
      "title": Text("Getting Started"),
      "page": TutorialPage(
          title: "Getting Started",
          content: "This tutorial explains how to get started with the app.")
    },
    {
      "title": Text("Managing Tickets"),
      "page": TutorialPage(
          title: "Managing Tickets",
          content:
              "Learn how to create, update, and track tickets efficiently.")
    },
    {
      "title": Text("Setting Up Your Profile"),
      "page": TutorialPage(
          title: "Setting Up Your Profile",
          content:
              "Customize your profile with your name, email, and phone number.")
    },
    {
      "title": Text("Using Calendar & Reminders"),
      "page": TutorialPage(
          title: "Using Calendar & Reminders",
          content: "Schedule important events and set reminders.")
    },
    {
      "title": Text("Security & Privacy Settings"),
      "page": TutorialPage(
          title: "Security & Privacy Settings",
          content:
              "Understand how to secure your account and manage privacy settings.")
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("FAQs & Tutorials"), backgroundColor: Colors.blueAccent),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Frequently Asked Questions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _faqs.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: Text(_faqs[index]["question"]!,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                children: [
                  Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(_faqs[index]["answer"]!))
                ],
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Tutorials",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _tutorials.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: _tutorials[index]["title"],
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => _tutorials[index]["page"]!),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// --------------------- Tutorial Detail Page ---------------------
class TutorialPage extends StatelessWidget {
  final String title;
  final String content;

  TutorialPage({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(content, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
