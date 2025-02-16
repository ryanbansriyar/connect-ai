import 'package:flutter/material.dart';

class ObjectiveDetailPage extends StatelessWidget {
  final String title;
  final String text;
  final Function(int, int) onTaskCompleted; // Callback function
  final int taskId;
  final int index;

  ObjectiveDetailPage({
    required this.title,
    required this.text,
    required this.onTaskCompleted, // Receive the callback
    required this.taskId,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Center(
            child: OutlinedButton(
              onPressed: () {
                _showOptionsDialog(context);
              },
              child: Text("Start"),
            ),
          )
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Did completing the task make you feel better?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _handleOption1(context);
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _handleOption2(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _handleOption1(BuildContext context) {
    print('Option 1 selected');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Option 1 Selected')));
    onTaskCompleted(taskId, index); // Execute the callback
  }

  void _handleOption2(BuildContext context) {
    print('Option 2 selected');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Option 2 Selected')));
    onTaskCompleted(taskId, index); // Execute the callback
  }
}