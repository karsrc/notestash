import 'package:flutter/material.dart';

class Plus extends StatefulWidget {
  const Plus({super.key});

  @override
  State<Plus> createState() => _PlusState();
}

class _PlusState extends State<Plus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plus Page"),
      ),
      body: const Center(
        child: Text("Hello, Plus!"),
      ),
    );
  }
}