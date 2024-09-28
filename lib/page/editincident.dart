import 'incidentlistpage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:flutter/services.dart'; // For input validation

import '../services/incident_firebase_crud.dart';
import '../models/incident.dart';

class EditIncident extends StatefulWidget {
  final Incident incident;

  EditIncident({required this.incident});

  @override
  _EditIncidentState createState() => _EditIncidentState();
}

class _EditIncidentState extends State<EditIncident> {
  final _incident_name = TextEditingController();
  final _incident_description = TextEditingController();
  final _incident_date = TextEditingController();
  final _incident_location = TextEditingController();
  final _incident_contact = TextEditingController();
  final _incident_status = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // List of status options
  final List<String> _statusOptions = ['Urgent', 'Critical', 'Normal'];
  final List<String> _incidentNames = [
    'Fire',
    'Flood',
    'Accident',
    'Robbery',
    'Theft',
    'Vandal',
    'Other'
  ];
  String? _selectedIncidentName; // To store the selected incident name

  @override
  void initState() {
    super.initState();
    _incident_name.text = widget.incident.name!;
    _incident_description.text = widget.incident.description!;
    _incident_date.text = widget.incident.date?.toIso8601String() ?? '';
    _incident_location.text = widget.incident.location!;
    _incident_contact.text = widget.incident.contactNumber!;
    _incident_status.text = widget.incident.status!;
    _selectedIncidentName = widget.incident.name;
  }

  @override
  Widget build(BuildContext context) {
    final nameField = DropdownButtonFormField<String>(
      value: _selectedIncidentName,
      items: _incidentNames.map((String name) {
        return DropdownMenuItem<String>(
          value: name,
          child: Text(name),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedIncidentName = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Incident Type",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0)),
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
        contentPadding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0),
        hintText: "Description",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0)),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0)),
        suffixIcon: Icon(Icons.calendar_today),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0)),
      ),
    );

    final contactField = TextFormField(
      controller: _incident_contact,
      autofocus: false,
      keyboardType: TextInputType.number, // Set the keyboard type to number
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly, // Allow only digits
      ],
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
          return 'Please enter a valid contact number';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Your Contact Number",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0)),
      ),
    );

    final statusField = DropdownButtonFormField<String>(
      value: _incident_status.text.isNotEmpty
          ? _incident_status.text
          : _statusOptions.first,
      items: _statusOptions.map((String status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(status),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _incident_status.text = newValue!;
        });
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Status",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
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
      child: const Text('My Informed Incidents'),
    );

    final updateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var incidentResponse = await FirebaseCrud.updateIncident(
              id: widget.incident.id!,
              name: _selectedIncidentName!, // Pass the selected incident name
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
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                        Navigator.pushReplacementNamed(
                            context, '/listPage'); // Navigate to the list page
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
          "Update",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:
            const Text('Edit Incident', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                    updateButton,
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
