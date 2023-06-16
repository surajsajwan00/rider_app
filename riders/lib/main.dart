import 'package:flutter/material.dart';
import 'package:riders/screens/splash.dart';
import 'package:riders/widgets/riderdata.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                RiderData()), // this is reqired to acces(application state) data using provider
      ],
      child: RidersApp(),
    ),
  );
}

class RidersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: splash(),
    );
  }
}
