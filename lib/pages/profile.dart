// import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project1/widgets/widgets1.dart';
import 'package:project1/model/user.dart';
import 'package:project1/pages/home.dart';
import 'package:project1/pages/talk.dart';
import 'package:project1/model/usertest.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';

import 'edit_profile.dart';
class MainProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<MainProfilePage> {
  @override
  int _selectedIndex = 2;

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
  }
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;

    return Builder(
      builder: (context) =>
          Scaffold(
            appBar: buildAppBar(context),
            body: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath: user.imagePath,
                  onClicked: () {
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                    );
                  },
                ),
                const SizedBox(height: 24),
                buildName(user),
                const SizedBox(height: 24),
                const SizedBox(height: 24),
                NumbersWidget(),
                const SizedBox(height: 48),
                buildAbout(user),
              ],


            ),
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

  Widget buildName(User user) => Column(
    children: [
      Text(
        user.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        user.email,
        style: TextStyle(color: Colors.grey),
      )
    ],
  );

  Widget buildUpgradeButton() => ButtonWidget(
    text: 'Upgrade To PRO',
    onClicked: () {},
  );

  Widget buildAbout(User user) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          user.about,
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );
}