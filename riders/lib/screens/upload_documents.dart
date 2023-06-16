import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:riders/screens/add_new_rider.dart';
import 'package:riders/screens/riderlist.dart';
import 'package:riders/widgets/riderdata.dart';
import 'package:riders/widgets/viewdoc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class Document {
  String docname;
  File image;

  Document({required this.docname, required this.image});
}

class UploadDocumentsScreen extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final List<String> localities;
  final String address;
  final String pincode;
  final String bankAccountNumber;
  final String ifscNumber;

  UploadDocumentsScreen({
    required this.name,
    required this.phoneNumber,
    required this.localities,
    required this.address,
    required this.pincode,
    required this.bankAccountNumber,
    required this.ifscNumber,
  });

  @override
  _UploadDocumentsScreenState createState() => _UploadDocumentsScreenState();
}

class _UploadDocumentsScreenState extends State<UploadDocumentsScreen> {
  List<Document> documents = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      documents.add(Document(docname: docs[i], image: File('')));
    }
  }

  //sample set of documnets
  final List<String> docs = [
    "Aadhar Card",
    "Pan Card",
    "DL",
    "Photo",
    "Other Documents"
  ];

  List<bool> addedDocuments = List<bool>.generate(5, (index) => false);
  bool areAllSelected = true;

  Future<void> _pickImage(BuildContext context, String document) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '$document.jpg';
      final file = File('${appDir.path}/$fileName');
      await pickedFile.saveTo(file.path);

      int i = 0;
      for (i; i < documents.length; i++) {
        if (documents[i].docname == document) {
          documents[i].image = file;
          break;
        }
      }

      if (i == documents.length) {
        documents.add(Document(docname: document, image: file));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved as $fileName')),
      );

      setState(() {
        final index = docs.indexOf(document);
        addedDocuments[index] = true;
        updateSelectedStatus(); //This will mark the document as selected
      });

      // Store the image file in RiderData
      final riderData = Provider.of<RiderData>(context, listen: false);
      riderData.addDocumentImage(document, file);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
  }

  void updateSelectedStatus() {
    areAllSelected = addedDocuments.every((isSelected) => isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Documents"),
      ),
      body: ChangeNotifierProvider(
        create: (_) => RiderData(),
        child: ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final document = docs[index];
            final isSelected = addedDocuments[index];
            final isAdded = addedDocuments[index];

            return Container(
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                leading: Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      addedDocuments[index] = value ?? false;
                      updateSelectedStatus();
                    });
                  },
                ),
                title: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    document,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: "viewButton$index",
                      child: OutlinedButton(
                        onPressed: isAdded
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewDocumentScreen(document: document),
                                  ),
                                );
                              }
                            : null,
                        child: Text(
                          "View",
                          style: TextStyle(
                            color: isAdded ? Colors.blue : Colors.grey,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isAdded ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Hero(
                      tag: "addButton$index",
                      child: OutlinedButton(
                        onPressed: () {
                          _pickImage(context, document);
                        },
                        child: Text(
                          "Add",
                          style: TextStyle(color: Colors.blue),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 40.0, bottom: 16.0),
            child: SizedBox(
              width: 100.0,
              height: 50.0,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNewRiderScreen(),
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text("Back"),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 8.0, bottom: 16.0),
            child: SizedBox(
              width: 100.0,
              height: 50.0,
              child: ElevatedButton(
                onPressed: areAllSelected
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RidersList(
                              name: widget.name,
                              phoneNumber: widget.phoneNumber,
                              localities: widget.localities,
                              address: widget.address,
                              pincode: widget.pincode,
                              bankAccountNumber: widget.bankAccountNumber,
                              ifscNumber: widget.ifscNumber,
                              images1: documents[0].image,
                              images2: documents[1].image,
                              images3: documents[2].image,
                              images4: documents[3].image,
                              images5: documents[4].image,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: areAllSelected ? Colors.blue : Colors.grey,
                ),
                child: Text("Save"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
