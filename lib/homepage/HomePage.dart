// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:polytech/Widgets/CustomDrawer.dart';
import 'package:polytech/sqlhelper/SqlHelper.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import '../updatescontact/UpdateContact.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> _contacts = [];
  List<Contact> _searchResults = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _getContactList();
  }

  Future<void> _getContactList() async {
    final newContacts = await SqlHelper.getAllContacts();
    setState(() {
      _contacts = newContacts;
    });
  }

  Future<void> _searchContacts(String query) async {
    final searchResults = await SqlHelper.searchContacts(query);
    setState(() {
      _searchResults = searchResults;
    });
  }


  Future<void> _showCallDialog(String phoneNumber) async {
    if (await Permission.phone.request().isGranted) {
      // Permission is granted. You can now initiate the call.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Appeler le contact'),
          content: Text('Voulez-vous appeler ce numéro : $phoneNumber ?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(), // Cancel
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Dismiss dialog
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: phoneNumber,
                );
                if (await canLaunch(launchUri.toString())) {
                  await launch(launchUri.toString());
                } else {
                  throw 'Could not launch $phoneNumber';
                }
              },
              child: const Text('Appeler', style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
      );
    } else {
      // Permission is not granted. You can handle this case.
      // For example, you can show a snackbar or dialog to inform the user.
    }
  }

  // Method to delete a contact
  Future<void> _deleteContact(Contact contact) async {
    await SqlHelper.deleteContact(contact.id!);
    _getContactList();
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
          'Accueil',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher par nom ou téléphone',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    _searchContacts(value);
                  },
                ),
              ),
            ),
          ),

          SizedBox(height: 10),

          Expanded(
            child: SingleChildScrollView(
              child: _searchResults.isNotEmpty || _searchQuery.isNotEmpty
                  ? DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Nom')),
                  DataColumn(label: Text('Téléphone')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _searchResults.isNotEmpty
                    ? _searchResults.map((contact) => _buildDataRow(contact)).toList()
                    : [
                  DataRow(cells: [
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 150), // Adjust padding as needed
                          child: Text(
                            'Aucun contact trouvé',
                            style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text('')),
                  ])
                ],
              )
                  : DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Nom')),
                  DataColumn(label: Text('Téléphone')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _contacts.map((contact) => _buildDataRow(contact)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(Contact contact) {
    return DataRow(
      cells: [
        DataCell(Text(contact.id.toString())),
        DataCell(Text(contact.name)),
        DataCell(
          GestureDetector(
            onTap: () => _showCallDialog(contact.phone),
            child: Text(
              contact.phone,
              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.greenAccent),
                onPressed: () async {
                  final updatedContact = await Get.to(() => UpdateContact(contact: contact, onUpdate: _getContactList));
                  if (updatedContact != null) {
                    _getContactList(); // Refresh list after updating
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirmation = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Supprimer le contact'),
                      content: const Text('Êtes-vous sûr de vouloir supprimer ce contact ?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false), // Cancel
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context, true); // Confirm
                            _deleteContact(contact); // Delete contact
                          },
                          child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (confirmation == true) {
                    await SqlHelper.deleteContact(contact.id!);
                    _getContactList(); // Refresh list after deletion
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
