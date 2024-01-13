import 'dart:async';

import 'package:flutter/material.dart';
import '../DashBoard/Dashboard.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Use Timer to navigate after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashBoard(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: Image.asset(
            'assets/Rusume_logo.png',
            fit: BoxFit.cover,
            width: 70,
            height: 70,
          ),
        ),
      ),
    );
  }
}
