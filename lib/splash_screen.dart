import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Already imported
import 'dart:async';
import 'pet_list_screen.dart';

class SplashWrapper extends StatefulWidget {
  @override
  _SplashWrapperState createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3)); // 3-second delay
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PetListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ss.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 120),
              SizedBox(height: 20),
              Text(
                'Pet Care Organizer',
                style: GoogleFonts.exo2( // Apply the Google Font here
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
