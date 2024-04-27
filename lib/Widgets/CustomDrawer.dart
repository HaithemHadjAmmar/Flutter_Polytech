// ignore_for_file: file_names

import 'package:flutter/material.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
        const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.greenAccent,
            ),
            child: Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/nft.png'),
              ),
            ),
          ),

          ListTile(
            title: Text('Item 1'),
            onTap: () {
              // Handle item tap
            },
          ),

          ListTile(
            title: Text('Item 2'),
            onTap: () {
              // Handle item tap
            },
          ),

        ],
      ),
    );
  }
}
