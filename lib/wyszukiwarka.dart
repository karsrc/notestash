import 'package:flutter/material.dart';

class Wyszukiwarka extends StatelessWidget {
  const Wyszukiwarka({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wyszukiwarka"),
        backgroundColor: Colors.black54,
      ),
      body: Center(
        child: Text(
          "Wyszukiwarka Placeholder",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}