import 'package:flutter/material.dart';
import 'package:tflite_image_classifier/screens/my_image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter tflite',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blueGrey[300],
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Colors.transparent,
      ),
      home: MyImagePicker(),
    );
  }
}
