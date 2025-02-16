import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project1/model/user.dart';
import 'package:project1/model/usertest.dart';
import 'package:project1/widgets/widgets1.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text field with the current name (if available)
    _nameController.text = "Current Name"; // Replace with actual current name
    // Add a listener to the controller
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _nameController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    // Get the new name from the controller
    final newName = _nameController.text;
    // Call the function to make the PATCH request
    _updateName(newName);
  }

  Future<void> _updateName(String newName) async {
    final url = Uri.parse('http://127.0.0.1:5000/'); // Replace with your API endpoint
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'name': newName});

    try {
      final response = await http.patch(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Request successful
        print('Name updated successfully');
        // Optionally, show a success message to the user
      } else {
        // Request failed
        print('Failed to update name. Status code: ${response.statusCode}');
        // Optionally, show an error message to the user
      }
    } catch (e) {
      // Error during the request
      print('Error updating name: $e');
      // Optionally, show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            // ... other widgets
          ],
        ),
      ),
    );
  }
}