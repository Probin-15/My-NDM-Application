import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DisasterAlertsScreen extends StatefulWidget {
  @override
  _DisasterAlertsScreenState createState() => _DisasterAlertsScreenState();
}

class _DisasterAlertsScreenState extends State<DisasterAlertsScreen> {
  String selectedCategory = 'All';
  final List<Map<String, String>> disasterAlerts = [
    {
      'title': 'Earthquake in California',
      'type': 'Earthquake',
      'location': 'Los Angeles, CA',
      'time': '2024-11-11 10:30:00',
      'tips': 'Drop, Cover, and Hold On.',
    },
    {
      'title': 'Flood Warning',
      'type': 'Flood',
      'location': 'Miami, FL',
      'time': '2024-11-10 14:45:00',
      'tips': 'Move to higher ground immediately.',
    },
    {
      'title': 'Wildfire Alert',
      'type': 'Fire',
      'location': 'Austin, TX',
      'time': '2024-11-09 16:00:00',
      'tips': 'Evacuate the area if advised.',
    },
    {
      'title': 'Tornado Warning',
      'type': 'Tornado',
      'location': 'Kansas City, MO',
      'time': '2024-11-08 09:15:00',
      'tips': 'Take shelter in a basement or storm cellar.',
    },
  ];

  List<Map<String, String>> filteredAlerts = [];

  @override
  void initState() {
    super.initState();
    filteredAlerts = disasterAlerts;
  }

  void filterAlerts(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        filteredAlerts = disasterAlerts;
      } else {
        filteredAlerts = disasterAlerts
            .where((alert) => alert['type'] == category)
            .toList();
      }
    });
  }

  String formatDate(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }

  void showAlertDetails(Map<String, String> alert) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alert['title']!),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location: ${alert['location']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Date & Time: ${formatDate(alert['time']!)}'),
              SizedBox(height: 20),
              Text(
                'Emergency Tips:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(alert['tips']!),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disaster Alerts'),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          // Dropdown for filtering disaster categories
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              items: ['All', 'Earthquake', 'Flood', 'Fire', 'Tornado']
                  .map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                filterAlerts(value!);
              },
              decoration: InputDecoration(
                labelText: 'Filter by Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),

          // ListView for displaying alerts
          Expanded(
            child: ListView.builder(
              itemCount: filteredAlerts.length,
              itemBuilder: (context, index) {
                final alert = filteredAlerts[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(
                      Icons.warning,
                      color: Colors.red[800],
                      size: 30,
                    ),
                    title: Text(
                      alert['title']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location: ${alert['location']}'),
                        Text('Time: ${formatDate(alert['time']!)}'),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () => showAlertDetails(alert),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Notifications Enabled'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: Icon(Icons.notifications_active),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
