import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:project1/pages/home.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn? _googleSignIn; // Make _googleSignIn nullable

  @override
  void initState() {
    super.initState();
    _initializeGoogleSignIn();
  }


  Future<void> _initializeGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signInSilently();
      if (googleUser != null) {
        _googleSignIn = GoogleSignIn(); // Initialize with default values
        // User is already signed in, proceed to the home screen or other logic
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        // User is not signed in, initialize for sign-in flow
        _googleSignIn = GoogleSignIn(
          clientId: '419213438482-uvbr062sciidsjaqabhdvcdpgknul8vf.apps.googleusercontent.com',
          scopes: ['email'],
        );
      }
    } catch (error) {
      print('Error initializing Google Sign-In: $error');
      // Handle the error, e.g., show a snackbar or dialog
    }
  }

  Future<void> _handleSignIn() async {
    try {
      // Use the initialized _googleSignIn instance
      final GoogleSignInAccount? googleUser = await _googleSignIn?.signIn();
      if (googleUser != null) {
        // Navigate to the home screen after successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    } catch (error) {
      print('Sign-in error: $error');
      // Handle sign-in errors, e.g., show a snackbar or dialog
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
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
      ),
    );
  }
}