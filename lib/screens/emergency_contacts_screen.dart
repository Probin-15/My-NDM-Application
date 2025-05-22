import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../db_helper.dart';

class EmergencyContactsScreen extends StatefulWidget {
  @override
  _EmergencyContactsScreenState createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  List<Map<String, dynamic>> contacts = [];
  List<Map<String, dynamic>> filteredContacts = [];

  final DBHelper dbHelper = DBHelper();  // Initialize DBHelper

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  // Load contacts from the database
  _loadContacts() async {
    final loadedContacts = await dbHelper.getContacts();
    setState(() {
      contacts = loadedContacts;
      filteredContacts = loadedContacts;
    });
  }

  // Search contacts by name
  void _searchContacts(String query) {
    final results = contacts
        .where((contact) =>
        contact['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredContacts = results;
    });
  }

  // Add a new contact
  void _addContact() async {
    if (_nameController.text.isNotEmpty && _numberController.text.isNotEmpty) {
      // Save the contact to the database
      await dbHelper.insertContact({
        'name': _nameController.text,
        'number': _numberController.text,
      });
      _loadContacts();  // Reload contacts from DB
      Navigator.of(context).pop();
      _nameController.clear();
      _numberController.clear();
    }
  }

  // Show dialog to add a new contact
  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Contact Name'),
              ),
              TextField(
                controller: _numberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: _addContact,
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Make a phone call using flutter_phone_direct_caller
  Future<void> _makePhoneCall(String number) async {
    try {
      bool? res = await FlutterPhoneDirectCaller.callNumber(number);
      if (res == true) {
        print('Call initiated successfully');
      } else {
        print('Call failed');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  // Delete a contact from the database
  void _deleteContact(int id) async {
    await dbHelper.deleteContact(id);
    _loadContacts();  // Reload contacts after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Contacts'),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchContacts,
              decoration: InputDecoration(
                hintText: 'Search Contacts...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  child: ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.blueAccent,
                      size: 30,
                    ),
                    title: Text(
                      filteredContacts[index]['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(filteredContacts[index]['number']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.call, color: Colors.green),
                          onPressed: () =>
                              _makePhoneCall(filteredContacts[index]['number']),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteContact(filteredContacts[index]['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}