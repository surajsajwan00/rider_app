import 'package:flutter/material.dart';
import 'package:riders/screens/add_new_rider.dart';

class RidersListHome extends StatefulWidget {
  @override
  _RidersListHomeState createState() => _RidersListHomeState();
}

class _RidersListHomeState extends State<RidersListHome> {
  List<String> riders = [
    "Rider's name Here",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to the Rider App"),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: riders.length,
            itemBuilder: (context, index) {
              final riderName = riders[index];
              return Dismissible(
                key: Key(riderName),
                direction: DismissDirection.none,
                child: ListTile(
                  title: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      riderName,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Container(
              width: 100.0,
              height: 50,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewRiderScreen()),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text("Add Rider"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
