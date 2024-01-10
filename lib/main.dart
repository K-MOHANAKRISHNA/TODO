import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/home_page.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';
void main() async {
  // init the hive
  await Hive.initFlutter();

  // open a box
  var db=await Hive.openBox('mybox');
  // runApp(const MyApp());
  runApp(DevicePreview(builder:(BuildContext context)=> MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
