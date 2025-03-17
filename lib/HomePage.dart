import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
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
    Center(child: Text("Calendar", style: TextStyle(fontSize: 22))),
    Center(child: Text("Account", style: TextStyle(fontSize: 22))),
  ];

  void goToPage(int index) {
    final CurvedNavigationBarState? navBarState =
        _bottomNavigationKey.currentState;
    navBarState?.setPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "PROTEKFM",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.white,
        color: Colors.black,
        height: 75, // ✅ Fixed height (should be ≤ 75)
        animationDuration: Duration(milliseconds: 300),
        index: _selectedIndex,
        items: const [
          Icon(Icons.dashboard, size: 30, color: Colors.white), // Dashboard
          Icon(Icons.confirmation_number,
              size: 30, color: Colors.white), // Tickets
          Icon(Icons.people, size: 30, color: Colors.white), // Clients
          Icon(Icons.calendar_today, size: 30, color: Colors.white), // Calendar
          Icon(Icons.account_circle, size: 30, color: Colors.white), // Account
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
