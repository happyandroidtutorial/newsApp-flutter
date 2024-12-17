import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/Screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (cotext) => HomeScreen()));
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/splash_pic.jpg',
            fit: BoxFit.cover,
            height: height * .5,
          ),
          SizedBox(
            height: 0.04,
          ),
          Text(
            'TOP HEADLINES ',
            style:
                GoogleFonts.anton(letterSpacing: 0.6, color: Colors.grey[700]),
          ),
          SizedBox(
            height: 0.04,
          ),
          SpinKitChasingDots(
            color: Colors.green,
            size: 40,
          )
        ],
      ),
    );
  }
}
