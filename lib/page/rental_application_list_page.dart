import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rental_application.dart';
import '../services/rental_application_crud.dart';
import 'edit_rental_application.dart'; // Import the EditRentalApplication page

class RentalApplicationListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RentalApplicationListPage();
  }
}

class _RentalApplicationListPage extends State<RentalApplicationListPage> {
  // Initialize a StreamController to manage the stream of rental applications
  final StreamController<List<RentalApplication>> _streamController =
      StreamController<List<RentalApplication>>();

  @override
  void initState() {
    super.initState();
    _fetchRentalApplications(); // Fetch applications when the page is initialized
  }

  // Fetching rental applications and adding to StreamController
  void _fetchRentalApplications() async {
    final response = await RentalApplicationCrud.getAllRentalApplications();
    if (response['status']) {
      _streamController.add(response['data'] as List<RentalApplication>);
    } else {
      _streamController.addError(response['message']);
    }
  }

  @override
  void dispose() {
    _streamController.close(); // Close the stream when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Rental Applications",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder<List<RentalApplication>>(
        stream: _streamController.stream,
        builder: (BuildContext context,
            AsyncSnapshot<List<RentalApplication>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No rental applications found."));
          }

          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                RentalApplication rentalApplication = snapshot.data![index];

                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Card(
                      child: ListTile(
                        title:
                            Text(rentalApplication.userName ?? 'No User Name'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                "Shop Type: ${rentalApplication.shopType ?? 'N/A'}"),
                            Text(
                                "Drive Link: ${rentalApplication.driveLink ?? 'N/A'}"),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditRentalApplication(
                                    rentalApplication: rentalApplication),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
