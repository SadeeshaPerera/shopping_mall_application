import 'package:flutter/material.dart';
import '../services/rental_application_crud.dart';
import '../models/rental_application.dart';
import 'rental_application_list_page.dart';

class EditRentalApplication extends StatefulWidget {
  final RentalApplication rentalApplication;

  EditRentalApplication({required this.rentalApplication});

  @override
  _EditRentalApplicationState createState() => _EditRentalApplicationState();
}

class _EditRentalApplicationState extends State<EditRentalApplication> {
  final _userNameController = TextEditingController();
  final _shopTypeController = TextEditingController();
  final _driveLinkController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _userNameController.text = widget.rentalApplication.userName!;
    _shopTypeController.text = widget.rentalApplication.shopType!;
    _driveLinkController.text = widget.rentalApplication.driveLink!;
  }

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

    // Update Button
    final updateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var response = await RentalApplicationCrud.updateRentalApplication(
              id: widget.rentalApplication.id!,
              userName: _userNameController.text,
              shopType: _shopTypeController.text,
              driveLink: _driveLinkController.text,
            );
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(response['message']),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Text(
          "Update Application",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    // View Applications Button
    final viewApplicationsButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
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

    // Delete Button
    final deleteButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.red,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          var response = await RentalApplicationCrud.deleteRentalApplication(
              widget.rentalApplication.id!);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(response['message']),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => RentalApplicationListPage()),
                      );
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        child: Text(
          "Delete Application",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Rental Application',
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
                const SizedBox(height: 10.0),
                shopTypeField,
                const SizedBox(height: 10.0),
                driveLinkField,
                const SizedBox(height: 15.0),
                updateButton,
                const SizedBox(height: 10.0),
                deleteButton, // Add delete button here
                const SizedBox(height: 10.0),
                viewApplicationsButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
