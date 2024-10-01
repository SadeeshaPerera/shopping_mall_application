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
  final _redeemFormKey = GlobalKey<FormState>();

  // Controllers for adding loyalty points
  final _billAmountController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  DateTime? _selectedDate;
  final List<String> _shopNames = ['ODEL', 'Cool Planet', 'Hameedia', 'Nolimit'];
  String? _selectedShop;

  // Controllers for redeeming points
  final _pointsController = TextEditingController();
  final _redeemPhoneNumberController = TextEditingController();
  String? _redeemSelectedShop;
  DateTime? _redeemSelectedDate;

  @override
  void dispose() {
    _billAmountController.dispose();
    _phoneNumberController.dispose();
    _pointsController.dispose();
    _redeemPhoneNumberController.dispose();
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

  Future<void> _selectRedeemDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _redeemSelectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _redeemSelectedDate) {
      setState(() {
        _redeemSelectedDate = pickedDate;
      });
    }
  }

  Future<void> _submitAddPointsForm() async {
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

  Future<void> _submitRedeemForm() async {
    if (_redeemFormKey.currentState!.validate()) {
      String shopName = _redeemSelectedShop ?? 'No shop selected';
      String points = _pointsController.text;
      String redeemPhoneNumber = _redeemPhoneNumberController.text;
      String formattedDate = _redeemSelectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_redeemSelectedDate!)
          : 'No date selected';

      // Add redeem data to Firestore
      try {
        await FirebaseFirestore.instance.collection('redeemed_points').add({
          'shop_name': shopName,
          'points_redeemed': int.parse(points),
          'date': formattedDate,
          'phone_number': redeemPhoneNumber,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Points redeemed at shop: $shopName')),
        );

        // Clear redeem form fields
        setState(() {
          _redeemSelectedShop = null;
          _pointsController.clear();
          _redeemPhoneNumberController.clear();
          _redeemSelectedDate = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error redeeming points: $e')),
        );
      }
    }
  }

  Widget shadowedField(Widget child) {
    final double fieldWidth = MediaQuery.of(context).size.width > 600 ? 400 : MediaQuery.of(context).size.width * 0.9;
    return Container(
      width: fieldWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fields for adding loyalty points
    final shopDropdownField = shadowedField(
      DropdownButtonFormField<String>(
        value: _selectedShop,
        decoration: const InputDecoration(
          hintText: 'Select Shop',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
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
    );

    final billAmountField = shadowedField(
      TextFormField(
        controller: _billAmountController,
        decoration: const InputDecoration(
          hintText: 'Bill Amount',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
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
    );

    final phoneNumberField = shadowedField(
      TextFormField(
        controller: _phoneNumberController,
        decoration: const InputDecoration(
          hintText: 'Phone Number',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
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
    );

    final dateField = shadowedField(
      TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Select Date',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ),
        controller: TextEditingController(
          text: _selectedDate != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
              : '',
        ),
        validator: (value) {
          if (_selectedDate == null) {
            return 'Please select a date';
          }
          return null;
        },
      ),
    );

    final saveButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: 150,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _submitAddPointsForm,
        child: const Text(
          "Save",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );

    // Fields for redeeming points
    final redeemShopDropdownField = shadowedField(
      DropdownButtonFormField<String>(
        value: _redeemSelectedShop,
        decoration: const InputDecoration(
          hintText: 'Select Shop to Redeem',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
        items: _shopNames.map((String shopName) {
          return DropdownMenuItem<String>(
            value: shopName,
            child: Text(shopName),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _redeemSelectedShop = newValue;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Please select a shop';
          }
          return null;
        },
      ),
    );

    final pointsField = shadowedField(
      TextFormField(
        controller: _pointsController,
        decoration: const InputDecoration(
          hintText: 'Points to Redeem',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the points to redeem';
          } else if (int.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );

    final redeemPhoneNumberField = shadowedField(
      TextFormField(
        controller: _redeemPhoneNumberController,
        decoration: const InputDecoration(
          hintText: 'Phone Number',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
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
    );

    final redeemDateField = shadowedField(
      TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Select Redeem Date',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectRedeemDate(context),
          ),
        ),
        controller: TextEditingController(
          text: _redeemSelectedDate != null
              ? DateFormat('yyyy-MM-dd').format(_redeemSelectedDate!)
              : '',
        ),
        validator: (value) {
          if (_redeemSelectedDate == null) {
            return 'Please select a redeem date';
          }
          return null;
        },
      ),
    );

    final redeemButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: 150,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _submitRedeemForm,
        child: const Text(
          "Redeem",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add and Redeem Loyalty Points'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              shadowedField(Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      shopDropdownField,
                      const SizedBox(height: 25.0),
                      billAmountField,
                      const SizedBox(height: 25.0),
                      phoneNumberField,
                      const SizedBox(height: 25.0),
                      dateField,
                      const SizedBox(height: 45.0),
                      saveButton,
                    ],
                  ),
                ),
              )),
              const SizedBox(height: 40.0),
              shadowedField(Form(
                key: _redeemFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      redeemShopDropdownField,
                      const SizedBox(height: 25.0),
                      pointsField,
                      const SizedBox(height: 25.0),
                      redeemPhoneNumberField,
                      const SizedBox(height: 25.0),
                      redeemDateField,
                      const SizedBox(height: 45.0),
                      redeemButton,
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
