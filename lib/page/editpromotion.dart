import '/page/promotionlistpage.dart';
import 'package:flutter/material.dart';
import '../models/promotion.dart';
import '../services/promotion_firebase_crud.dart';

class PromotionEditPage extends StatefulWidget {
  final Promotion? promotion;
  const PromotionEditPage({super.key, this.promotion});

  @override
  State<StatefulWidget> createState() {
    return _EditPage();
  }
}

class _EditPage extends State<PromotionEditPage> {
  final _shopNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _pictureUrlController = TextEditingController();
  final _docIdController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _docIdController.value = TextEditingValue(text: widget.promotion!.uid.toString());
    _shopNameController.value = TextEditingValue(text: widget.promotion!.shopName.toString());
    _dateController.value = TextEditingValue(text: widget.promotion!.date.toString());
    _pictureUrlController.value = TextEditingValue(text: widget.promotion!.pictureUrl.toString());
  }

  Widget shadowedField(Widget child) {
    return Container(
      width: MediaQuery.of(context).size.width > 600 ? 400 : MediaQuery.of(context).size.width * 0.9,
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

  void _showUpdateDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Update Status",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 16.0),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => PromotionListPage(),
                  ),
                  (route) => false, // Remove all previous routes
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final docIdField = shadowedField(
      TextField(
        controller: _docIdController,
        readOnly: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Document ID",
          border: InputBorder.none,
        ),
      ),
    );

    final shopNameField = shadowedField(
      TextFormField(
        controller: _shopNameController,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Shop Name is required';
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Shop Name",
          border: InputBorder.none,
        ),
      ),
    );

    final dateField = shadowedField(
      TextFormField(
        controller: _dateController,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Date is required';
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Date",
          border: InputBorder.none,
        ),
      ),
    );

    final pictureUrlField = shadowedField(
      TextFormField(
        controller: _pictureUrlController,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Picture URL is required';
          }
          return null;
        },
        decoration: InputDecoration(

            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Contact Number",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final viewListbutton = TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const PromotionListPage(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        },
        child: const Text('View List of Promotion'));


    final saveButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: 200,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var promotionresponse = await FirebaseCrud.updatePromotion(
              shopName: _shopNameController.text,
              date: _dateController.text,
              pictureUrl: _pictureUrlController.text,
              docId: _docIdController.text,
            );

            _showUpdateDialog(promotionresponse.message.toString());
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
        title: const Text('Edit Promotion'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => PromotionListPage(),
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      docIdField,
                      const SizedBox(height: 25.0),
                      shopNameField,
                      const SizedBox(height: 25.0),
                      dateField,
                      const SizedBox(height: 35.0),
                      pictureUrlField,
                      const SizedBox(height: 30.0),
                      saveButton,
                      const SizedBox(height: 15.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
