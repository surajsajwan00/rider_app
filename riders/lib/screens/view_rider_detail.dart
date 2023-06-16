import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewRiderScreen extends StatefulWidget {
  final String riderName;
  final String phoneNumber;
  final String address;
  final List<String> localities;
  final File images1;
  final File images2;
  final File images3;
  final File images4;
  final File images5;

  ViewRiderScreen({
    required this.riderName,
    required this.phoneNumber,
    required this.address,
    required this.localities,
    required this.images1,
    required this.images2,
    required this.images3,
    required this.images4,
    required this.images5,
  });

  @override
  _ViewRiderScreenState createState() => _ViewRiderScreenState();
}

class _ViewRiderScreenState extends State<ViewRiderScreen> {
  final List<String> documentTypes = [
    "Aadhar Card",
    "PAN Card",
    "DL",
    "Photo",
    "Other Documents",
  ];

  List<Widget> uploadedPhotos = [];

  int currentPageIndex = 0;
  late PageController _pageController;

  List<String> riders = [];
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sharedPrefs) {
      setState(() {
        prefs = sharedPrefs;
        riders = prefs.getStringList('riders') ?? [];
      });
    });
    _pageController = PageController();
    updateUploadedPhotos();
  }

  void updateUploadedPhotos() {
    uploadedPhotos = [];
    for (int i = 0; i < documentTypes.length; i++) {
      File? imageFile;
      if (i == 0) {
        imageFile = widget.images1;
      } else if (i == 1) {
        imageFile = widget.images2;
      } else if (i == 2) {
        imageFile = widget.images3;
      } else if (i == 3) {
        imageFile = widget.images4;
      } else if (i == 4) {
        imageFile = widget.images4;
      }

      Widget imageWidget = imageFile != null
          ? Image.file(imageFile, width: 150, height: 150, fit: BoxFit.cover)
          : Placeholder(
              color: Colors.white, fallbackWidth: 100, fallbackHeight: 100);

      uploadedPhotos.add(imageWidget);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void saveRidersList() {
    riders.remove(widget.riderName); // Remove the rider's name from the list
    prefs.setStringList('riders', riders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Rider"),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Container(
                  height: 200.0,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_left),
                        onPressed: () {
                          setState(() {
                            if (currentPageIndex > 0) {
                              currentPageIndex--;
                              _pageController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            }
                          });
                        },
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: documentTypes.length,
                          onPageChanged: (index) {
                            setState(() {
                              currentPageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final documentType = documentTypes[index];
                            return Container(
                              width: 150.0,
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              color: Colors.grey[300],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    documentType,
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  SizedBox(height: 8.0),
                                  uploadedPhotos[index],
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: () {
                          setState(() {
                            if (currentPageIndex < documentTypes.length - 1) {
                              currentPageIndex++;
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: documentTypes.length,
                    itemBuilder: (context, index) {
                      final documentType = documentTypes[index];
                      return Visibility(
                        visible: index == currentPageIndex,
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            title: Text(''), // Empty Text widget
                            subtitle: Text(
                              documentType,
                              style: TextStyle(fontSize: 24.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 3.0,
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${widget.riderName}',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Phone Number:  ${widget.phoneNumber}',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Address:  ${widget.address}',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Localities:  ${widget.localities}',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                '''Rider Dissaproved. To Confirm your Dissaproved Swipe Left on Rider's name''')),
                      );
                      saveRidersList(); // Remove the rider's name from the list and save the updated list
                    });
                    Navigator.of(context).pop('rejected');
                  },
                  child: Text('Reject'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                '''Rider approved. To Confirm your approval Swipe Right on Rider's name''')),
                      );
                      saveRidersList();
                    });
                    Navigator.of(context).pop('approved');
                  },
                  child: Text('Approve'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
