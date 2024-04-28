// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:polytech/ajouteretudaint/AjouterEtudiant.dart';
import 'package:get/get.dart';

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
            title: Text('Liste des etudiants'),
            onTap: () {
              // Handle item tap
            },
          ),

          Divider(color: Colors.grey, thickness: 0.5),

          ListTile(
            title: Text('Ajouter Etudiant'),
            onTap: () {
              Get.to(
                    () => AjouterEtudiant(),
                transition: Transition.fadeIn,
                duration: Duration(milliseconds: 500),
              );
            },
          ),

        ],
      ),
    );
  }
}
