import 'package:femme_ex/screens/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'disaster_alerts_screen.dart';
import 'emergency_contacts_screen.dart';
import 'first_aid_screen.dart';
import 'checklist_screen.dart';
import 'details_screen.dart';
import 'about_us_screen.dart'; // Import the AboutUsScreen (if not yet implemented)
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../db_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;  // Index to track the current page selected in the bottom navigation bar
  int _contactIndex = 0;   // Index to track which contact to call next

  final List<Widget> _pages = [
    HomeContent(),   // Home content widget, will contain the rest of your content
    WeatherScreen(), // Weather screen
    OSMMapScreen(), // About Us screen
  ];

  final List<IconData> _icons = [
    Icons.home,        // Home screen icon
    Icons.cloud,       // Weather screen icon
    Icons.map,        // About Us screen icon
  ];

  final List<String> _titles = [
    'Home',   // Home title
    'Weather', // Weather title
    'Map', // About Us title
  ];






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),  // Update app bar title based on selected tab
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: _pages[_currentIndex],  // Display the selected page in the body
      bottomNavigationBar: AnimatedBottomNavigationBar(
        height: 60,
        icons: _icons,                   // Set the icons for the navigation bar
        activeIndex: _currentIndex,      // Set the active index of the bottom navigation
        gapLocation: GapLocation.none,   // No gap between the icons
        onTap: (index) => setState(() {  // On tab change, update the selected index
          _currentIndex = index;
        }),
        splashColor: Colors.blueAccent, // Splash color when an icon is tapped
        backgroundColor: Colors.blueGrey, // Background color of the bottom navigation bar
      ),

    );
  }
}

class HomeContent extends StatelessWidget {
  final List<Map<String, String>> disasterTypes = [
    {'name': 'Flood', 'image': 'assets/flood.png'},
    {'name': 'Earthquake', 'image': 'assets/earthquake.png'},
    {'name': 'Fire', 'image': 'assets/fire.png'},
    {'name': 'Tornado', 'image': 'assets/tornado.png'},
  ];

  final List<Map<String, String>> safetyTips = [
    {'disaster': 'Flood', 'tip': 'Move to higher ground immediately. Avoid flooded roads.'},
    {'disaster': 'Earthquake', 'tip': 'Drop, Cover, and Hold On. Stay away from windows.'},
    {'disaster': 'Fire', 'tip': 'Stop, Drop, and Roll if your clothes catch fire.'},
    {'disaster': 'Tornado', 'tip': 'Seek shelter in a basement or storm cellar.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search disasters or tips...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),

            // Featured Disaster Alert
            Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: ListTile(
                leading: Icon(Icons.warning, color: Colors.white, size: 40),
                title: Text(
                  'Flood Alert in Your Area!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(
                  'High water levels expected. Evacuate immediately!',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DisasterAlertsScreen()),
                  );
                },
              ),
            ),

            // Quick Access Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickAccessButton(
                  context,
                  'Contacts',
                  Icons.contact_phone,
                  Colors.blueAccent,
                  EmergencyContactsScreen(),
                ),
                _buildQuickAccessButton(
                  context,
                  'First Aid',
                  Icons.medical_services,
                  Colors.redAccent,
                  FirstAidScreen(),
                ),
                _buildQuickAccessButton(
                  context,
                  'Checklist',
                  Icons.checklist,
                  Colors.green,
                  ChecklistScreen(),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Safety Tips Carousel
            Text('Safety Tips', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                height: 180,
                autoPlay: true,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
              ),
              items: safetyTips.map((tip) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tip['disaster']!,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        ),
                        SizedBox(height: 10),
                        Text(tip['tip']!, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // Disaster Types Grid
            Text('Disaster Types', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: disasterTypes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(disasterTypes[index]['name']!),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          disasterTypes[index]['image']!,
                          height: 80,
                          width: 80,
                        ),
                        SizedBox(height: 10),
                        Text(
                          disasterTypes[index]['name']!,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper function for quick access buttons
  Widget _buildQuickAccessButton(BuildContext context, String label, IconData icon, Color color, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          SizedBox(height: 10),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
