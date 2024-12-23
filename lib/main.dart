import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() => runApp(PetCareApp());

class PetCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashWrapper(),
    );
  }
}
