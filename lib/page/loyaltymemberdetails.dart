import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_mall_application/page/mypoints.dart';

class LoyaltyMemberForm extends StatefulWidget {
  const LoyaltyMemberForm({super.key});

  @override
  _LoyaltyMemberFormState createState() => _LoyaltyMemberFormState();
}

class _LoyaltyMemberFormState extends State<LoyaltyMemberForm> {
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers to retrieve user input
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  // To store the selected birthday date
  DateTime? _selectedDate;
  final TextEditingController _birthdayController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Method to show a date picker and select the birthday
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _birthdayController.text = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Show dialog and navigate to MyPoints page after clicking OK
  Future<void> _showSubmissionDialog(String name) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submission Successful'),
          content: Text('Welcome, $name! Your loyalty membership has been submitted.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MyPoints()),
                ); // Navigate to MyPoints page
              },
            ),
          ],
        );
      },
    );
  }

  // Check if email or phone number already exists
  Future<bool> _isDuplicate(String email, String phone) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('loyaltyMembers')
        .where('email', isEqualTo: email)
        .where('phone', isEqualTo: phone)
        .get();

    return result.docs.isNotEmpty;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String email = _emailController.text;
      String phone = _phoneController.text;
      String birthday = _birthdayController.text;
      String address = _addressController.text;

      // Check for duplicates
      bool isDuplicate = await _isDuplicate(email, phone);
      if (isDuplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This email and phone number combination already exists.')),
        );
        return; // Exit the function if duplicates are found
      }

      FirebaseFirestore.instance.collection('loyaltyMembers').add({
        'name': name,
        'email': email,
        'phone': phone,
        'birthday': birthday,
        'address': address,
        'createdAt': Timestamp.now(),
      }).then((value) {
        _showSubmissionDialog(name); // Show dialog on success

        // Clear the form fields
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _birthdayController.clear();
        _addressController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loyalty Membership Form'),
        backgroundColor: Colors.purple, // Purple app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone number field
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Birthday field with date picker
              TextFormField(
                controller: _birthdayController,
                decoration: InputDecoration(
                  labelText: 'Birthday',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your birthday';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address field
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
