import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riders/screens/add_new_rider.dart';
import 'package:riders/screens/unverified.dart';
import 'package:riders/screens/view_rider_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RidersList extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final List<String> localities;
  final String address;
  final String pincode;
  final String bankAccountNumber;
  final String ifscNumber;
  final File images1;
  final File images2;
  final File images3;
  final File images4;
  final File images5;

  RidersList({
    required this.name,
    required this.phoneNumber,
    required this.localities,
    required this.address,
    required this.pincode,
    required this.bankAccountNumber,
    required this.ifscNumber,
    required this.images1,
    required this.images2,
    required this.images3,
    required this.images4,
    required this.images5,
  });

  @override
  _RidersListState createState() => _RidersListState();
}

class _RidersListState extends State<RidersList> {
  String name = "";
  String phoneNumber = "";
  List<String> localities = [];
  String address = "";
  String pincode = "";
  String bankAccountNumber = "";
  String ifscNumber = "";
  File img1 = File("");
  File img2 = File("");
  File img3 = File("");
  File img4 = File("");
  File img5 = File("");

  List<String> riders = [];
  List<String> un = [];

  void addName(String name, List<String> riders) {
    setState(() {
      riders.insert(0, name);
    });

    // Save the updated riders list to shared preferences
    saveRidersList(riders);
  }

  void showMessage(String message, String riderName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Message"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (message == "Rider is rejected") {
                  setState(() {
                    riders.remove(name);
                  });

                  // Save the updated riders list to shared preferences
                  saveRidersList(riders);
                } else if (message == "Rider is approved") {
                  setState(() {
                    riders.remove(name);
                  });
                  // Save the updated riders list to shared preferences
                  saveRidersList(riders);
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    name = widget.name;
    phoneNumber = widget.phoneNumber;
    localities = widget.localities;
    address = widget.address;
    pincode = widget.pincode;
    bankAccountNumber = widget.bankAccountNumber;
    ifscNumber = widget.ifscNumber;
    img1 = widget.images1;
    img2 = widget.images2;
    img3 = widget.images3;
    img4 = widget.images4;

    // Retrieve the stored riders list from shared preferences
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        riders = prefs.getStringList('riders') ?? [];
        addName(name, riders);
      });
    });

    // Print the values
    print("PRINT FROM LIST");
    print("Name: $name");
    print("Phone Number: $phoneNumber");
    print("Localities: $localities");
    print("Address: $address");
    print("Pincode: $pincode");
    print("Bank Account Number: $bankAccountNumber");
    print("IFSC Number: $ifscNumber");

    print("printing the list");
    print(riders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Riders"),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: riders.length,
            itemBuilder: (context, index) {
              final riderName = riders[index];
              return Dismissible(
                key: Key(riderName),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) {
                  setState(() {
                    if (direction == DismissDirection.endToStart) {
                      // Disapprove rider
                      riders.removeAt(index);
                      showMessage('Rider "$riderName" disapproved.', riderName);
                      un.add(riderName);
                      // Save the updated riders list to shared preferences
                      saveRidersList(riders);
                    } else if (direction == DismissDirection.startToEnd) {
                      // Approve rider
                      riders.removeAt(index);
                      showMessage('Rider "$riderName" approved.', riderName);
                    }
                  });
                },
                background: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewRiderScreen(
                          riderName: riderName,
                          phoneNumber: phoneNumber,
                          address: address,
                          localities: localities,
                          images1: img1,
                          images2: img2,
                          images3: img3,
                          images4: img4,
                          images5: img5,
                        ),
                      ),
                    );
                  },
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
                ),
              );
            },
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Container(
              width: 100.0,
              height: 50.0,
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
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: Container(
              width: 100.0,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UnverifiedRidersScreen(unverifiedRiders: un)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text("Unverified Riders"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveRidersList(List<String> riders) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('riders', riders);
  }
}

void saveUnverifiedRidersList(List<String> unverifiedRiders) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('unverifiedRiders', unverifiedRiders);
}
