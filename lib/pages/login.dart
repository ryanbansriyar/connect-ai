import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project1/pages/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart' as crypto;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
Future<void> clearSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  print('SharedPreferences cleared.');
}
class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn? _googleSignIn;

  @override
  void initState() {
    super.initState();
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signInSilently();
      if (googleUser != null) {
        _googleSignIn = GoogleSignIn();
        // Check if it's a first-time login
        final isFirstTime = await _isFirstTimeLogin();
        if (isFirstTime) {
          // Create a new profile
          await _createProfile(googleUser);
        }
        // Proceed to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        _googleSignIn = GoogleSignIn(
          clientId: '419213438482-uvbr062sciidsjaqabhdvcdpgknul8vf.apps.googleusercontent.com',
          scopes: ['email'],
        );
      }
    } catch (error) {
      print('Error initializing Google Sign-In: $error');
    }
  }

  Future<bool> _isFirstTimeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('first_time') ?? true;
    if (isFirstTime) {
      // Set first_time to false for subsequent logins
      await prefs.setBool('first_time', false);
    }
    return isFirstTime;
  }
  String generateMd5(String data) {
    var content = const Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return digest.toString();
  }
  Future<void> _createProfile(GoogleSignInAccount googleUser) async {
    final id = generateMd5(googleUser.email.toString());
    final url = Uri.parse('http://frogleader.pythonanywhere.com:5080/profile/$id');
    String username = 'epicwelnessbackend';
    String password = 'epicwelnessbackendhelp';
    String credentials = '$username:$password';
    String encodedCredentials = base64.encode(utf8.encode(credentials));

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $encodedCredentials', // Add the Authorization header
    };
    final body = jsonEncode({
      "name": googleUser.displayName ?? "test",
      "age": 0, // Default age
      "gender": "unknown", // Default gender
      "email": googleUser.email,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        print('Profile created successfully');
      } else {
        print('Failed to create profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating profile: $e');
    }
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn?.signIn();
      if (googleUser != null) {
        // Check if it's a first-time login
        final isFirstTime = await _isFirstTimeLogin();
        if (isFirstTime) {
          // Create a new profile
          await _createProfile(googleUser);
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    } catch (error) {
      print('Sign-in error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _handleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 10),
                  Text('Sign in with Google'),
                ],
              ),
            ),
            if (kDebugMode) // Only show in debug mode
              ElevatedButton(
                onPressed: () {
                  clearSharedPreferences();
                },
                child: Text('Clear SharedPreferences'),
              ),
          ],
        ),
      ),
    );
  }
}