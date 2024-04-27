// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:polytech/Widgets/CustomDrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        elevation: 2,
        title: Text(
          'Acceuil',
          style: TextStyle(
              fontSize: 25,
            fontWeight: FontWeight.w700
          ),
        ),
      ),
      body: Center(
        child: Text('Hello'),
      ),
    );
  }
}
