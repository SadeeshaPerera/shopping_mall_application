import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AddLoyaltyPoints extends StatefulWidget {
  const AddLoyaltyPoints({super.key});

  @override
  _AddLoyaltyPointsState createState() => _AddLoyaltyPointsState();
}

class _AddLoyaltyPointsState extends State<AddLoyaltyPoints> {
  final _formKey = GlobalKey<FormState>();

  final _billAmountController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  DateTime? _selectedDate;
  final List<String> _shopNames = ['Shop A', 'Shop B', 'Shop C', 'Shop D'];
  String? _selectedShop;

  @override
  void dispose() {
    _billAmountController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String shopName = _selectedShop ?? 'No shop selected';
      String billAmount = _billAmountController.text;
      String phoneNumber = _phoneNumberController.text;
      String formattedDate = _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : 'No date selected';

      // Add data to Firestore
      try {
        await FirebaseFirestore.instance.collection('loyalty_points').add({
          'shop_name': shopName,
          'bill_amount': double.parse(billAmount),
          'date': formattedDate,
          'phone_number': phoneNumber,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loyalty points added for shop: $shopName')),
        );

        // Clear form fields
        setState(() {
          _selectedShop = null;
          _billAmountController.clear();
          _phoneNumberController.clear();
          _selectedDate = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding loyalty points: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Loyalty Points'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedShop,
                decoration: const InputDecoration(
                  labelText: 'Shop Name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                items: _shopNames.map((String shopName) {
                  return DropdownMenuItem<String>(
                    value: shopName,
                    child: Text(shopName),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedShop = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a shop';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _billAmountController,
                decoration: const InputDecoration(
                  labelText: 'Bill Amount',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the bill amount';
                  } else if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the phone number';
                  } else if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                controller: TextEditingController(
                    text: _selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                        : ''),
                validator: (value) {
                  if (_selectedDate == null) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Points'),
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
