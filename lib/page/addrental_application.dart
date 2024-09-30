import 'package:flutter/material.dart';
import '../services/rental_application_crud.dart';
import 'rental_application_list_page.dart'; // Import the RentalApplicationListPage

class RentalApplication extends StatefulWidget {
  @override
  _RentalApplicationState createState() => _RentalApplicationState();
}

class _RentalApplicationState extends State<RentalApplication> {
  final _userNameController = TextEditingController();
  final _shopTypeController = TextEditingController();
  final _driveLinkController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userNameField = TextFormField(
      controller: _userNameController,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "User Name",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final shopTypeField = TextFormField(
      controller: _shopTypeController,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Shop Type",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final driveLinkField = TextFormField(
      controller: _driveLinkController,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Drive Link (Documents)",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final saveButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var response = await RentalApplicationCrud.addRentalApplication(
              userName: _userNameController.text,
              shopType: _shopTypeController.text,
              driveLink: _driveLinkController.text,
            );

            // Update to access the message correctly from the map
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(response['message']
                      .toString()), // Access the message correctly
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Text(
          "Submit Application",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    final viewApplicationsButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blueGrey, // Change color as needed
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => RentalApplicationListPage()),
          );
        },
        child: Text(
          "View Applications",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Application',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                userNameField,
                const SizedBox(height: 25.0),
                shopTypeField,
                const SizedBox(height: 25.0),
                driveLinkField,
                const SizedBox(height: 45.0),
                saveButton,
                const SizedBox(height: 15.0),
                viewApplicationsButton, // Add the view applications button here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
