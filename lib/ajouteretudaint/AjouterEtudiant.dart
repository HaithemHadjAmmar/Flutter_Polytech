// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:polytech/homepage/HomePage.dart';
import 'package:polytech/sqlhelper/SqlHelper.dart';
import 'package:get/get.dart';

class AjouterContact extends StatefulWidget {
  const AjouterContact({Key? key}) : super(key: key);

  @override
  State<AjouterContact> createState() => _AjouterContactState();
}

class _Contact {
  String name = '';
  String phone = '';
}

class _AjouterContactState extends State<AjouterContact> {
  final _formKey = GlobalKey<FormState>();
  final _contact = _Contact();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        title: Text('Ajouter Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nom',
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
                onSaved: (value) => _contact.name = value!,
              ),

              SizedBox(height: 20),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Téléphone',
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
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone';
                  }
                  return null;
                },
                onSaved: (value) => _contact.phone = value!,
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Create a Contact object from _contact data
                    final newContact = Contact(
                      id: 0, // Auto-incrementing ID
                      name: _contact.name,
                      phone: _contact.phone,
                    );
                    await SqlHelper.insertContact([newContact]);

                    // Show a success message (optional)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contact ajouté avec succès!')),
                    );

                    // Clear the form (optional)
                    _formKey.currentState!.reset();
                    _contact.name = '';
                    _contact.phone = '';

                    // Navigate to HomePage and potentially refresh data
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
