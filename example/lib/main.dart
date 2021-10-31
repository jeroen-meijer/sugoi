import 'package:flutter/material.dart';
import 'package:sugoi_gallery/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sugoi Gallery',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
      builder: (context, child) {
        return Scaffold(
          body: child,
        );
      },
    );
  }
}
