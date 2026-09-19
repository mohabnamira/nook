// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'new_entry_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('nook')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NewEntryScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}