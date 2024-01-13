import 'package:flutter/material.dart';
import 'package:rusume_builder_app/Presentation/DashBoard/Home.dart';

import 'Create_Rusume.dart';
import 'Setting.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    CreateRusume(),
    Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_currentIndex],
      // Set the background color here
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          // Update the selected index when a tab is pressed
          setState(() {
            _currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),backgroundColor: Colors.black,
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Create Rusume',
          ),



          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        selectedItemColor: Colors.amber[800],
      ),

    );
  }
}
