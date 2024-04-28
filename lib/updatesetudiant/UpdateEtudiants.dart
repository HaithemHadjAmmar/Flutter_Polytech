import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Assuming you're using GetX for navigation
import 'package:polytech/homepage/HomePage.dart';
import 'package:polytech/sqlhelper/SqlHelper.dart';

class UpdateEtudiant extends StatefulWidget {
  const UpdateEtudiant({Key? key, required this.etudiant}) : super(key: key);
  final Etudiant etudiant;
  @override
  State<UpdateEtudiant> createState() => _UpdateEtudiantState();
}

class _UpdateEtudiantState extends State<UpdateEtudiant> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-populate controllers with existing data from 'widget.etudiant'
    _nameController.text = widget.etudiant.name;
    _ageController.text = widget.etudiant.age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        elevation: 2,
        title: const Text(
          'Update Etudiant',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Form fields for name, age, and CNE (if applicable)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer un nom' : null, // Basic validation
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer un age' : null, // Basic validation
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final updatedEtudiant = Etudiant(
                      id: widget.etudiant.id, // Maintain existing ID
                      name: _nameController.text,
                      age: int.parse(_ageController.text),
                   // Handle optional CNE
                    );
                    await SqlHelper.updateEtudiant(updatedEtudiant);
                    Get.to(HomePage(),
                        transition: Transition.fadeIn,
                        duration: Duration(milliseconds: 500));
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}