import 'package:flutter/material.dart';

class SafetyTipsScreen extends StatelessWidget {
  final String disaster;
  final String tip;

  SafetyTipsScreen(this.disaster, this.tip);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$disaster Safety Tips'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Safety Tip for $disaster',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              tip,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
