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
  final _formKey = GlobalKey<FormState>();
  final _etudiant = _Etudiant();

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
                decoration: InputDecoration(
                  labelText: 'Nom',
                  contentPadding: const EdgeInsets.all(12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey, // Border color
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
                onSaved: (value) => _etudiant.name = value!,
              ),

              SizedBox(height: 20),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Age',
                  contentPadding: const EdgeInsets.all(12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un age';
                  }
                  return null;
                },
                onSaved: (value) => _etudiant.age = int.parse(value!),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save(); // Save form data

                    // Create an Etudiant object from _etudiant data
                    final newEtudiant = Etudiant(
                      id: 0, // Auto-incrementing ID
                      name: _etudiant.name,
                      age: _etudiant.age,
                    );
                    await SqlHelper.insertEtudiant([newEtudiant]);

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
                child: const Text('Ajouter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}