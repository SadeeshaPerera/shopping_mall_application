import 'package:flutter/material.dart';
import '../services/incident_firebase_crud.dart';
import '../models/incident.dart';

class EditIncident extends StatefulWidget {
  final Incident incident;

  EditIncident({required this.incident});

  @override
  _EditIncidentState createState() => _EditIncidentState();
}

class _EditIncidentState extends State<EditIncident> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _locationController;
  late TextEditingController _contactNumberController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.incident.name);
    _descriptionController =
        TextEditingController(text: widget.incident.description);
    _dateController =
        TextEditingController(text: widget.incident.date?.toIso8601String());
    _locationController = TextEditingController(text: widget.incident.location);
    _contactNumberController =
        TextEditingController(text: widget.incident.contactNumber);
    _statusController = TextEditingController(text: widget.incident.status);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _contactNumberController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Incident'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactNumberController,
                decoration: InputDecoration(labelText: 'Contact Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a status';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // Padding
                  textStyle: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold), // Text style
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var incidentResponse = await FirebaseCrud.updateIncident(
                      id: widget.incident.id!,
                      name: _nameController.text,
                      description: _descriptionController.text,
                      date: _dateController.text,
                      location: _locationController.text,
                      contactNumber: _contactNumberController.text,
                      status: _statusController.text,
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
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
