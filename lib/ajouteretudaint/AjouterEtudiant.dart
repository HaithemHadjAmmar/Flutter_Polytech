// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:polytech/homepage/HomePage.dart';
import 'package:polytech/sqlhelper/SqlHelper.dart';
import 'package:get/get.dart';

class AjouterEtudiant extends StatefulWidget {
  const AjouterEtudiant({Key? key}) : super(key: key);

  @override
  State<AjouterEtudiant> createState() => _AjouterEtudiantState();
}

class _Etudiant {
  String name = '';
  int age = 0;
}

class _AjouterEtudiantState extends State<AjouterEtudiant> {
  final _formKey = GlobalKey<FormState>(); // Create a form key
  final _etudiant = _Etudiant(); // Create an instance of _Etudiant

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        title: Text('Ajouter Etudiant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Set the form key
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nom',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
                onSaved: (value) => _etudiant.name = value!, // Save name
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Age',
                ),
                keyboardType: TextInputType.number, // Allow only numbers
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un age';
                  }
                  return null;
                },
                onSaved: (value) => _etudiant.age = int.parse(value!), // Save age
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save(); // Save form data

                    // Call insertEtudiant to insert data into database
                    await SQLHelper.insertEtudiant(Etudiant(
                      id: 0, // Auto-incrementing ID
                      name: _etudiant.name,
                      age: _etudiant.age,
                    ));

                    // Show a success message (optional)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Etudiant ajouté avec succès!'),),
                    );

                    // Clear the form (optional)
                    _formKey.currentState!.reset();
                    _etudiant.name = '';
                    _etudiant.age = 0;

                    // Navigate to HomeScreen and potentially refresh data
                    Get.to(
                          () => HomePage(),
                      transition: Transition.fadeIn,
                      duration: Duration(milliseconds: 500),
                    );
                  }
                },
                child: const Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}