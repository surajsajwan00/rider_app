import 'package:flutter/material.dart';

class UnverifiedRidersScreen extends StatelessWidget {
  final List<String> unverifiedRiders;

  UnverifiedRidersScreen({required this.unverifiedRiders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unverified Riders"),
      ),
      body: ListView.builder(
        itemCount: unverifiedRiders.length,
        itemBuilder: (context, index) {
          final riderName = unverifiedRiders[index];
          return ListTile(
            title: Text(riderName),
          );
        },
      ),
    );
  }
}
