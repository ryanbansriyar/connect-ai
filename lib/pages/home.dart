import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project1/pages/profile.dart';
import 'package:project1/pages/talk.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';
import 'optioncard.dart';
import 'optioncard_cards.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

List<OptionCard> options = [
  OptionCard(title: 'Option 1', text: 'Description 1', extended: 'An extremely long description 1'),
  OptionCard(title: 'Option 2', text: 'Description 2', extended: 'An extremely long description 2'),
  OptionCard(title: 'Option 3', text: 'Description 3', extended: 'An extremely long description 3')
];

Future<Response> getData() async {
  Response response = await get(Uri.parse('http://127.0.0.1:5000/taskapi/1'));
  return response;
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      Response response = await getData();
      String data = response.body;
      print(data);
      setState(() {
        options = [
          OptionCard(title: data, text: 'Description 1', extended: 'An extremely long description 1'),
          OptionCard(title: 'Option 2', text: 'Description 2', extended: 'An extremely long description 2'),
          OptionCard(title: 'Option 3', text: 'Description 3', extended: 'An extremely long description 3')
        ];
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error, e.g., show a snackbar
    }
  }

  int _selectedIndex = 0;

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 1) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Talk(),
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

  Widget optionTemplate(quote) {
    return new OptionCardCreator(optionChoose: quote);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Application'),
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Information',
              onPressed: () {},
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
        body: Center(
          child: Column(
            children: options.map((quote) => optionTemplate(quote)).toList(),
          ),
        ),
        bottomNavigationBar: ResponsiveNavigationBar(
          selectedIndex: _selectedIndex,
          onTabChange: changeTab,
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