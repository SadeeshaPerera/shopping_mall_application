import 'itemlistpage.dart';
import 'package:flutter/material.dart';

import '../models/storeitem.dart';
import '../services/inventory_firebase_crud.dart';

class EditItem extends StatefulWidget {
  final StoreItem? storeitem;
  EditItem({this.storeitem});

  @override
  State<StatefulWidget> createState() {
    return _EditItem();
  }
}

class _EditItem extends State<EditItem> {
  final _storeitem_name = TextEditingController();
  final _storeitem_category = TextEditingController();
  final _storeitem_quantity = TextEditingController();
  final _storeitem_price = TextEditingController();
  final _docid = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _docid.value = TextEditingValue(text: widget.storeitem!.uid.toString());
    _storeitem_name.value = TextEditingValue(text: widget.storeitem!.itemname.toString());
    _storeitem_category.value = TextEditingValue(text: widget.storeitem!.category.toString());
    _storeitem_quantity.value = TextEditingValue(text: widget.storeitem!.quantity.toString());
    _storeitem_price.value = TextEditingValue(text: widget.storeitem!.price.toString());
  }

  @override
  Widget build(BuildContext context) {
    final DocIDField = TextField(
      controller: _docid,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Document ID",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final nameField = TextFormField(
      controller: _storeitem_name,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Item Name",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final categoryField = TextFormField(
      controller: _storeitem_category,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Category",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final quantityField = TextFormField(
      controller: _storeitem_quantity,
      keyboardType: TextInputType.number,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Quantity",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final priceField = TextFormField(
      controller: _storeitem_price,
      keyboardType: TextInputType.number,
      autofocus: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Price",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

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
      child: const Text('View List of Store Items'),
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
            var storeitemresponse = await FirebaseCrud.updateStoreItem(
              name: _storeitem_name.text,
              category: _storeitem_category.text,
              quantity: int.parse(_storeitem_quantity.text),
              price: int.parse(_storeitem_price.text),
              docId: _docid.text,
            );
            if (storeitemresponse.code != 200) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(storeitemresponse.message.toString()),
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(storeitemresponse.message.toString()),
                  );
                },
              );
            }
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
        title: const Text('Edit Store Item'),
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
                  DocIDField,
                  const SizedBox(height: 25.0),
                  nameField,
                  const SizedBox(height: 25.0),
                  categoryField,
                  const SizedBox(height: 25.0),
                  quantityField,
                  const SizedBox(height: 25.0),
                  priceField,
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
