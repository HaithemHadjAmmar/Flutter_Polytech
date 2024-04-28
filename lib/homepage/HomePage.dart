// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:polytech/Widgets/CustomDrawer.dart';
import 'package:polytech/sqlhelper/SqlHelper.dart';
import 'package:polytech/updatesetudiant/UpdateEtudiants.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Etudiant> _etudiants = [];

  @override
  void initState() {
    super.initState();
    _getListeEtudiants();
  }

  Future<void> _getListeEtudiants() async {
    final newEtudiants = await SqlHelper.getAllEtudiants();
    setState(() {
      _etudiants = newEtudiants;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        elevation: 2,
        title: const Text(
          'Acceuil',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Nom')),
            DataColumn(label: Text('Age')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _etudiants.map((etudiant) => _buildDataRow(etudiant)).toList(),
        ),
      ),
    );
  }

  DataRow _buildDataRow(Etudiant etudiant) {
    return DataRow(
      cells: [
        DataCell(Text(etudiant.id.toString())),
        DataCell(Text(etudiant.name)),
        DataCell(Text(etudiant.age.toString() + ' ans')),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.greenAccent),
                onPressed: () {
                  Get.to(UpdateEtudiant(etudiant: etudiant),
                      transition: Transition.fadeIn,
                     duration: Duration(milliseconds: 500));
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirmation = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Supprimer l\'étudiant'),
                      content: const Text('Êtes-vous sûr de vouloir supprimer cet étudiant ?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false), // Cancel
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true), // Confirm
                          child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (confirmation == true) {
                    await SqlHelper.deleteEtudiant(etudiant.id);
                    _getListeEtudiants(); // Refresh list after deletion
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}