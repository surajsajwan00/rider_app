import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ViewDocumentScreen extends StatelessWidget {
  final String document;
  ViewDocumentScreen({required this.document});

  Future<File> _loadImage(String document) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '$document.jpg';
    final file = File('${appDir.path}/$fileName');
    if (await file.exists()) {
      return file;
    } else {
      throw Exception('File not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View $document'),
      ),
      body: FutureBuilder(
        future: _loadImage(document),
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Center(
                child: Image.file(snapshot.data!),
              );
            } else {
              return Center(
                child: Text('No image found for $document'),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
