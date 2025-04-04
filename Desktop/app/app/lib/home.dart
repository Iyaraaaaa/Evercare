import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'doctor_home.dart';
import 'doctor.dart';
import 'schedule.dart';
import 'edit_profile.dart';
import 'notifications.dart';
import 'privacy.dart';
import 'permission.dart';
import 'about_us.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _userName = "User Name";
  String _userEmail = "user@example.com";
  String _userImage = '';

  final List<Widget> _pages = [
    DoctorHomePage(),
    DoctorPage(),
    SchedulePage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? "User Name";
      _userEmail = prefs.getString('userEmail') ?? "user@example.com";
      _userImage = prefs.getString('userImage') ?? 'assets/images/empty.jpg';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Channeling App'),
        backgroundColor: const Color.fromARGB(255, 238, 222, 222),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 238, 222, 222), Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.local_hospital), label: 'Doctors'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(_userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                accountEmail: Text(_userEmail),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: _userImage.isEmpty
                      ? AssetImage('assets/images/empty.jpg')
                      : (_userImage.startsWith('http')
                          ? NetworkImage(_userImage)
                          : AssetImage(_userImage)) as ImageProvider,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color.fromARGB(255, 180, 228, 200), Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16, // Change left to right
                child: IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () async {
                    Navigator.pop(context);
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          userName: _userName,
                          userEmail: _userEmail,
                          userImage: _userImage,
                        ),
                      ),
                    );
                    if (result == true) {
                      _loadUserData();
                    }
                  },
                ),
              ),
            ],
          ),
          _buildDrawerItem(Icons.notifications, 'Notifications', Colors.purple, NotificationsPage()),
          _buildDrawerItem(Icons.privacy_tip, 'Privacy', Colors.green, PrivacyPage()),
          _buildDrawerItem(Icons.settings, 'Permission', Colors.orange, PermissionPage()),
          _buildDrawerItem(Icons.info, 'About Us', Colors.teal, AboutUsPage()),
          _buildDrawerItem(Icons.logout, 'Log Out', Colors.red, LoginPage(), isLogout: true),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, Color iconColor, Widget page, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      tileColor: isLogout ? Colors.red.shade50 : null,
      onTap: () async {
        if (isLogout) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }
      },
    );
  }
}