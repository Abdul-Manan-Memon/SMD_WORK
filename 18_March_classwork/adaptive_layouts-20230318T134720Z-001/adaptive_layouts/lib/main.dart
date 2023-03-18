// Create By -> {
//Sanjay kumar (19k-1052), 
//Gul Muneer (19k-1384),
// Abdul Manan (19k-1071)
//}

import 'package:flutter/material.dart';
import 'package:flutter_adaptive_layouts/MasterDetailPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MasterDetailPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

