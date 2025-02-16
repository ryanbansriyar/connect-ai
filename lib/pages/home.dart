import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project1/pages/profile.dart';
import 'package:project1/pages/talk.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';
import 'optioncard.dart';
import 'optioncard_cards.dart';
import 'objectivepage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<OptionCard> options = [];
  List<int> completedTasks = []; // Keep track of completed task IDs
  bool isLoading = true;
  String? errorMessage;
  int nextTaskId = 1; // Track the next task ID to fetch
  final int maxVisibleTasks = 3;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }
  Future<void> _fetchInitialData() async {
    if (!mounted) return; // Check if the widget is still in the tree

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      List<OptionCard> fetchedOptions = [];
      // Fetch only one task at a time
      for (int i = 0; i < maxVisibleTasks; i++) {
        if (!completedTasks.contains(nextTaskId + i)) {
          Response response = await getData((nextTaskId + i).toString());
          final jsonData = jsonDecode(response.body);
          String name = jsonData['name'] as String;
          String extended = jsonData['extended'] as String;
          String short = jsonData['short'] as String;
          fetchedOptions.add(OptionCard(title: name, text: short, extended: extended));
        }
      }

      if (!mounted) return; // Check again before updating state
      setState(() {
        options = fetchedOptions;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      if (!mounted) return; // Check again before updating state
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching data: $e';
      });
    }
  }
  Future<Response> getData(number) async {
    Response response = await get(Uri.parse('http://frogleader.pythonanywhere.com/taskapi/' + number));
    print(response);
    return response;
  }

  Future<void> _fetchData(int index) async {
    if (!mounted) return; // Check if the widget is still in the tree

    try {
      Response response = await getData(nextTaskId.toString());
      final jsonData = jsonDecode(response.body);
      String name = jsonData['name'] as String;
      String extended = jsonData['extended'] as String;
      String short = jsonData['short'] as String;
      OptionCard newOption = OptionCard(title: name, text: short, extended: extended);

      if (!mounted) return; // Check again before updating state
      setState(() {
        options[index] = newOption;
      });
    } catch (e) {
      print('Error fetching data: $e');
      if (!mounted) return; // Check again before updating state
      setState(() {
        errorMessage = 'Error fetching data: $e';
      });
    }
  }

  Future<void> _completeTask(int taskId) async {
    print("Completing task with ID: $taskId"); // Added print statement
    // Show dialog to confirm completion
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Complete Task?'),
          content: Text('Are you sure you want to complete this task?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Complete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (!mounted) return; // Check if the widget is still in the tree
      setState(() {
        completedTasks.add(taskId);
      });
    }
  }
  void _navigateToObjectivePage(OptionCard option, int taskId, int index, Function(int, int) onTaskCompleted) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObjectiveDetailPage(
          title: option.title,
          text: option.extended,
          onTaskCompleted: onTaskCompleted, // Pass the callback here
          taskId: taskId,
          index: index,
        ),
      ),
    );
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
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return child;
            },
            transitionDuration: Duration.zero,
          ),
        );
      });
    }
  }
  void _onTaskCompleted(int taskId, int index) {
    setState(() {
      completedTasks.add(taskId);
      nextTaskId++;
    });
    _fetchData(index);
  }
  Widget optionTemplate(OptionCard quote, int taskId, int index) {
    return GestureDetector(
      onTap: () => _navigateToObjectivePage(quote, taskId, index, _onTaskCompleted),
      child: OptionCardCreator(optionChoose: quote),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
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
          child: isLoading
              ? CircularProgressIndicator()
              : errorMessage != null
              ? Text(errorMessage!)
              : Column(
            children: [
              for (int i = 0; i < options.length; i++)
                optionTemplate(options[i], nextTaskId + i, i), // Use nextTaskId here
            ],
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