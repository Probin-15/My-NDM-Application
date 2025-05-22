import 'package:flutter/material.dart';

class FirstAidScreen extends StatefulWidget {
  @override
  _FirstAidScreenState createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen> {
  // Sample data for first aid instructions
  final List<Map<String, dynamic>> firstAidData = [
    {
      'category': 'Burns',
      'instructions': [
        'Cool the burn with running water for at least 10 minutes.',
        'Cover the burn with a sterile, non-stick bandage.',
        'Avoid using ice, butter, or any greasy substances.',
        'Seek medical help if the burn is severe.'
      ],
      'icon': Icons.local_fire_department,
      'image': 'assets/burns.png',
    },
    {
      'category': 'Cuts',
      'instructions': [
        'Apply pressure with a clean cloth to stop bleeding.',
        'Clean the cut with water and mild soap.',
        'Apply an antibiotic ointment and bandage.',
        'Seek medical attention for deep or infected cuts.'
      ],
      'icon': Icons.cut,
      'image': 'assets/cuts.png',
    },
    {
      'category': 'Fractures',
      'instructions': [
        'Immobilize the injured area.',
        'Apply ice packs to reduce swelling.',
        'Avoid moving the person if a neck or back injury is suspected.',
        'Seek emergency medical help immediately.'
      ],
      'icon': Icons.healing,
      'image': 'assets/fractures.png',
    },
    {
      'category': 'Choking',
      'instructions': [
        'Encourage the person to cough if they can.',
        'Perform abdominal thrusts (Heimlich maneuver) if necessary.',
        'Seek immediate medical help if the person is unconscious.',
      ],
      'icon': Icons.masks,
      'image': 'assets/choking.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Aid Guide'),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar for first aid topics
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search First Aid Tips...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    // Add search functionality if needed
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: firstAidData.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ExpansionTile(
                      leading: Icon(
                        firstAidData[index]['icon'],
                        color: Colors.redAccent,
                        size: 40,
                      ),
                      title: Text(
                        firstAidData[index]['category'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      subtitle: Text(
                        'Tap to view instructions',
                        style: TextStyle(color: Colors.grey),
                      ),
                      children: firstAidData[index]['instructions']
                          .map<Widget>((instruction) => ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text(instruction),
                      ))
                          .toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add emergency contact functionality
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Emergency Contacts'),
              content: Text('Call 911 or your local emergency number immediately.'),
              actions: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.call),
                  label: Text('Call Now'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.phone),
      ),
    );
  }
}
