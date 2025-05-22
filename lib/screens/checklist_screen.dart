import 'package:flutter/material.dart';

class ChecklistScreen extends StatefulWidget {
  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final List<Map<String, dynamic>> checklistItems = [
    {'task': 'Pack Emergency Kit', 'completed': false},
    {'task': 'Check Batteries', 'completed': false},
    {'task': 'Store Water and Food', 'completed': false},
    {'task': 'Prepare First Aid Kit', 'completed': false},
    {'task': 'Plan Evacuation Route', 'completed': false},
  ];

  final TextEditingController _taskController = TextEditingController();

  // Calculate the percentage of completed tasks
  double getCompletionRate() {
    if (checklistItems.isEmpty) return 0.0;
    final completedCount =
        checklistItems.where((item) => item['completed']).length;
    return completedCount / checklistItems.length;
  }

  void _addTask(String task) {
    if (task.isNotEmpty) {
      setState(() {
        checklistItems.add({'task': task, 'completed': false});
      });
      _taskController.clear();
    }
  }

  void _removeTask(int index) {
    setState(() {
      checklistItems.removeAt(index);
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      checklistItems[index]['completed'] = !checklistItems[index]['completed'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disaster Checklist'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Indicator
            Text(
              'Checklist Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: getCompletionRate(),
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            SizedBox(height: 20),

            // Add Task Section
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'Add a new task...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.add_task),
              ),
              onSubmitted: _addTask,
            ),
            SizedBox(height: 20),

            // Checklist Items
            Expanded(
              child: ListView.builder(
                itemCount: checklistItems.length,
                itemBuilder: (context, index) {
                  final item = checklistItems[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        item['completed']
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: item['completed'] ? Colors.green : Colors.red,
                      ),
                      title: Text(
                        item['task'],
                        style: TextStyle(
                          fontSize: 16,
                          decoration: item['completed']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _removeTask(index),
                      ),
                      onTap: () => _toggleTaskCompletion(index),
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
          if (_taskController.text.isNotEmpty) {
            _addTask(_taskController.text);
          }
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
