import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'emergency_contacts_screen.dart';

class DetailsScreen extends StatelessWidget {
  final String disasterName;

  // Sample data for demonstration
  final Map<String, dynamic> disasterData = {
    'Flood': {
      'description':
      'Floods are natural disasters that occur when there is excessive water in a region, often caused by heavy rainfall, river overflow, or dam breaks.',
      'safetyMeasures': [
        'Move to higher ground immediately.',
        'Avoid walking or driving through floodwaters.',
        'Stay informed via radio or emergency alerts.'
      ],
      'preparationTips': [
        'Keep an emergency kit ready.',
        'Store important documents in waterproof containers.',
        'Have a family evacuation plan in place.'
      ],
      'usefulLinks': [
        {'title': 'Flood Safety Tips', 'url': 'https://ndma.gov.in/Natural-Hazards/Floods/Do-Donts'},
        {'title': 'Disaster Preparedness', 'url': 'https://www.redcross.org'}
      ],
      'image': 'assets/flood.png',
    },
    'Earthquake': {
      'description':
      'Earthquakes are sudden, violent shaking of the ground caused by movements of tectonic plates. They can cause significant damage to buildings and infrastructure.',
      'safetyMeasures': [
        'Drop, Cover, and Hold On.',
        'Stay indoors until the shaking stops.',
        'Stay away from windows and heavy furniture.'
      ],
      'preparationTips': [
        'Secure heavy furniture to walls.',
        'Know safe spots in each room (under sturdy tables).',
        'Have an emergency kit with essentials.'
      ],
      'usefulLinks': [
        {'title': 'Earthquake Preparedness', 'url': 'https://www.ready.gov/earthquakes'},
        {'title': 'Safety Measures', 'url': 'https://www.redcross.org'}
      ],
      'image': 'assets/earthquake.png',
    },
  };

  DetailsScreen(this.disasterName);

  // Method to launch a URL
  Future<void> _launchURL(String url) async {
    final Uri uri=Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final disasterInfo = disasterData[disasterName] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(disasterName),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disaster Image
              if (disasterInfo['image'] != null)
                Center(
                  child: Image.asset(
                    disasterInfo['image'],
                    height: 150,
                  ),
                ),
              SizedBox(height: 20),

              // Description Section
              Text(
                'Description',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                disasterInfo['description'] ?? 'No description available.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Safety Measures Section
              ExpansionTile(
                title: Text(
                  'Safety Measures',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.shield, color: Colors.green),
                children: (disasterInfo['safetyMeasures'] as List<String>?)
                    ?.map(
                      (measure) => ListTile(
                    leading: Icon(Icons.check_circle_outline, color: Colors.green),
                    title: Text(measure),
                  ),
                )
                    .toList() ??
                    [Text('No safety measures available.')],
              ),
              SizedBox(height: 20),

              // Preparation Tips Section
              ExpansionTile(
                title: Text(
                  'Preparation Tips',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.tips_and_updates, color: Colors.orange),
                children: (disasterInfo['preparationTips'] as List<String>?)
                    ?.map(
                      (tip) => ListTile(
                    leading: Icon(Icons.lightbulb, color: Colors.orange),
                    title: Text(tip),
                  ),
                )
                    .toList() ??
                    [Text('No preparation tips available.')],
              ),
              SizedBox(height: 20),

              // Useful Links Section
              Text(
                'Useful Links',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Column(
                children: (disasterInfo['usefulLinks'] as List<Map<String, String>>?)
                    ?.map(
                      (link) => ListTile(
                    leading: Icon(Icons.link, color: Colors.blue),
                    title: Text(link['title'] ?? ''),
                        onTap: () async {
                          final url = link['url'];
                          if (url != null) {
                            final Uri uri = Uri.parse(url); // Convert the string URL to a Uri object

                            // Check if the URL can be launched
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri); // Launch the URL
                            } else {
                              // Handle error when the URL can't be opened
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Could not open the link.')),
                              );
                            }
                          }
                        },

                      ),
                )
                    .toList() ??
                    [Text('No useful links available.')],
              ),
              SizedBox(height: 20),

              // Emergency Contacts Button
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.contact_phone),
                  label: Text('Emergency Contacts'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmergencyContactsScreen()),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),

              // Share Button
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.share),
                  label: Text('Share Info'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    // Placeholder for share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Share functionality coming soon!')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
