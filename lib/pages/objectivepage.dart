import 'package:flutter/material.dart';

class ObjectiveDetailPage extends StatelessWidget {
  final String title;
  final String text;

  ObjectiveDetailPage({required this.title, required this.text});

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
                }, child: Text("Start")

            ),
          )
        ],
      ),
    );
  }
}
void _showOptionsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Choose an Option'),
        actions: <Widget>[
          TextButton(
            child: Text('Option 1'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _handleOption1(context); // Handle option 1
            },
          ),
          TextButton(
            child: Text('Option 2'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _handleOption2(context); // Handle option 2
            },
          ),
        ],
      );
    },
  );
}

void _handleOption1(BuildContext context) {
  // Handle the action for Option 1
  print('Option 1 selected');
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Option 1 Selected')));
}

void _handleOption2(BuildContext context) {
  // Handle the action for Option 2
  print('Option 2 selected');
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Option 2 Selected')));
}
