// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:polytech/Widgets/CustomDrawer.dart';
import 'package:polytech/sqlhelper/SqlHelper.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import '../updatescontact/UpdateContact.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Appeler le contact'),
          content: Text('Voulez-vous appeler ce numéro : $phoneNumber ?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
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
    }
  }

  Future<void> _deleteContact(Contact contact) async {
    await SqlHelper.deleteContact(contact.id!);
    _getContactList();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), minTextAdapt: true );

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        elevation: 2,
        title: const Text(
          'Liste Des Contacts',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
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
          SizedBox(height: 10.h),
          Expanded(
            child: _buildContactList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactList() {
    final contacts = _searchResults.isNotEmpty || _searchQuery.isNotEmpty
        ? _searchResults
        : _contacts;

    if (contacts.isEmpty) {
      return Center(
        child: Text(
          'Aucun contact trouvé',
          style: TextStyle(color: Colors.red, fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(8.0.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0.w,
        mainAxisSpacing: 8.0.h,
        childAspectRatio: 0.9,
      ),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return _buildContactCard(contact);
      },
    );
  }

  Widget _buildContactCard(Contact contact) {
    return Card(
     shadowColor: Colors.grey,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 12.0.w, left: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${contact.id}',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10.h),
            Text(
              'Nom: ${contact.name}',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: () => _showCallDialog(contact.phone),
              child: Text(
                'Téléphone: ${contact.phone}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.blue,
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.greenAccent, size: 30.w),
                  onPressed: () async {
                    final updatedContact = await Get.to(() => UpdateContact(contact: contact, onUpdate: _getContactList));
                    if (updatedContact != null) {
                      _getContactList();
                    }
                  },
                ),
                SizedBox(width: 12.w),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 30.w),
                  onPressed: () async {
                    final confirmation = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Supprimer le contact'),
                        content: const Text('Êtes-vous sûr de vouloir supprimer ce contact ?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context, true);
                              _deleteContact(contact);
                            },
                            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (confirmation == true) {
                      await SqlHelper.deleteContact(contact.id!);
                      _getContactList();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}