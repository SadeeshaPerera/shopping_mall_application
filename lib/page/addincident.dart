import 'incidentlistpage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

import '../services/incident_firebase_crud.dart';

class AddIncident extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddIncident();
  }
}

class _AddIncident extends State<AddIncident> {
  final _incident_name = TextEditingController();
  final _incident_description = TextEditingController();
  final _incident_date = TextEditingController();
  final _incident_location = TextEditingController();
  final _incident_contact = TextEditingController();
  final _incident_status = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      controller: _incident_name,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Name",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final descriptionField = TextFormField(
      controller: _incident_description,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Description",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final dateField = TextFormField(
      controller: _incident_date,
      autofocus: false,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setState(() {
            _incident_date.text = formattedDate;
          });
        }
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Date",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final locationField = TextFormField(
      controller: _incident_location,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Location",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final contactField = TextFormField(
      controller: _incident_contact,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Contact Number",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final statusField = TextFormField(
      controller: _incident_status,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Status",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final viewListButton = TextButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => IncidentListPage(),
          ),
          (route) => false, // To disable back feature set to false
        );
      },
      child: const Text('Informed Incidents'),
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
            var incidentResponse = await FirebaseCrud.addIncident(
              name: _incident_name.text,
              description: _incident_description.text,
              date: _incident_date.text,
              location: _incident_location.text,
              contactNumber: _incident_contact.text,
              status: _incident_status.text,
            );
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(incidentResponse.message.toString()),
                );
              },
            );
          }
        },
        child: Text(
          "Save",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Report an Incident'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/images/incidentImg.jpeg')),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    nameField,
                    const SizedBox(height: 25.0),
                    descriptionField,
                    const SizedBox(height: 25.0),
                    dateField,
                    const SizedBox(height: 25.0),
                    locationField,
                    const SizedBox(height: 25.0),
                    contactField,
                    const SizedBox(height: 25.0),
                    statusField,
                    viewListButton,
                    const SizedBox(height: 45.0),
                    saveButton,
                    const SizedBox(height: 15.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
