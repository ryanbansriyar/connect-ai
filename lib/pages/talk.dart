import 'package:flutter/material.dart';
import 'package:project1/pages/home.dart';
import 'package:project1/pages/profile.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';

class Talk extends StatefulWidget {
  @override
  _TalkState createState() => _TalkState();
}

class _TalkState extends State<Talk> {
  int _selectedIndex = 1;

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Home(),
            transitionsBuilder: (context, animation, secondaryAnimation,
                child) {
              return child;
            },
            transitionDuration: Duration.zero,
          ),
        );
      });
    }
    if (_selectedIndex == 2) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => MainProfilePage(),
            transitionsBuilder: (context, animation, secondaryAnimation,
                child) {
              return child;
            },
            transitionDuration: Duration.zero,
          ),
        );
      });
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Talk'),
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Information',
              onPressed: () {
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              tooltip: 'Notifications',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Notifications'),
                      ),
                      body: const Center(
                        child: Text(
                          'Insert list of notifications',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                ));
              },
            ),
          ],
        ),
        // extendBody: true,
        bottomNavigationBar: ResponsiveNavigationBar(
          selectedIndex: _selectedIndex,
          onTabChange: changeTab,
          // showActiveButtonText: false,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          navigationBarButtons: const <NavigationBarButton>[
            NavigationBarButton(
                text: 'Home',
                icon: Icons.home,
                backgroundColor: Colors.green
            ),
            NavigationBarButton(
                text: 'Talk',
                icon: Icons.message,
                backgroundColor: Colors.green

            ),
            NavigationBarButton(
              text: 'Profile',
              icon: Icons.person,
              backgroundColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

