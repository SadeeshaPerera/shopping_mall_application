import 'itemlistpage.dart';
import 'package:flutter/material.dart';

import '../services/inventory_firebase_crud.dart';

class AddItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddItem();
  }
}

class _AddItem extends State<AddItem> {
  // Controllers for form fields
  final _storeitem_name = TextEditingController();
  final _storeitem_category = TextEditingController();
  final _storeitem_quantity = TextEditingController();
  final _storeitem_price = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Name field
    final nameField = TextFormField(
        controller: _storeitem_name,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Item Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    // Category field
    final categoryField = TextFormField(
        controller: _storeitem_category,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Category",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    // Quantity field
    final quantityField = TextFormField(
        controller: _storeitem_quantity,
        keyboardType: TextInputType.number,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          if (int.tryParse(value) == null) {
            return 'Enter a valid number';
          }
          return null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

            hintText: "Quantity",

            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    // Price field
    final priceField = TextFormField(
        controller: _storeitem_price,
        keyboardType: TextInputType.number,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          if (int.tryParse(value) == null) {
            return 'Enter a valid number';
          }
          return null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

            hintText: "Price",

            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    // Button to view item list
    final viewListButton = TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ItemListPage(),
            ),
            (route) => false,
          );
        },
        child: const Text('View List of Store Items'));

    // Save Button
    final saveButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var storeItemResponse = await FirebaseCrud.addStoreItem(
              name: _storeitem_name.text,
              category: _storeitem_category.text,
              quantity: int.parse(_storeitem_quantity.text),
              price: int.parse(_storeitem_price.text),
            );

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(storeItemResponse.message.toString()),
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

    // Build UI
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add New Store Item'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                  categoryField,
                  const SizedBox(height: 25.0),
                  quantityField,
                  const SizedBox(height: 25.0),
                  priceField,
                  const SizedBox(height: 35.0),
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
    );
  }
}
