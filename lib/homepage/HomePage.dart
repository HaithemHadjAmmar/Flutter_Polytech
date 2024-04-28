// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:polytech/Widgets/CustomDrawer.dart';
import 'package:polytech/sqlhelper/SqlHelper.dart';

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
    final newEtudiants = await SQLHelper.getAllEtudiants();
    setState(() {
      _etudiants.addAll(newEtudiants);
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
              fontWeight: FontWeight.w700
          ),
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
                  // Handle edit action for this etudiant
                  // You can navigate to an edit form and pre-populate data
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await SQLHelper.deleteEtudiant(etudiant.id);
                  _getListeEtudiants(); // Refresh list after deletion
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}