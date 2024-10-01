import '/page/promotionlistpage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../services/promotion_firebase_crud.dart';

class AddPromotion extends StatefulWidget {
  const AddPromotion({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddPage();
  }
}

class _AddPage extends State<AddPromotion> {
  final _shop_name = TextEditingController();
  final _promotion_date = TextEditingController();
  final _picture_url = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _shop_name.dispose();
    _promotion_date.dispose();
    _picture_url.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double fieldWidth = MediaQuery.of(context).size.width > 600
        ? 400
        : MediaQuery.of(context).size.width * 0.9;

    Widget shadowedField(Widget child) {
      return Container(
        width: fieldWidth,
        decoration: BoxDecoration(
          color: Colors.white, // Background color for the shadow effect
          borderRadius: BorderRadius.circular(32.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3), // Changes position of shadow
            ),
          ],
        ),
        child: child,
      );
    }

    final shopNameField = shadowedField(
      TextFormField(
        controller: _shop_name,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Shop Name",
          border: InputBorder.none, // No outline border
        ),
      ),
    );

    final dateField = shadowedField(
      TextFormField(
        controller: _promotion_date,
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
            setState(() {
              _promotion_date.text =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
            });
          }
        },
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Date",
          border: InputBorder.none, // No outline border
          suffixIcon: Icon(
            Icons.calendar_today,
            color: const Color.fromARGB(
                255, 129, 136, 135), // Set calendar icon color to purple
          ),
        ),
      ),
    );

    final pictureField = shadowedField(
      TextFormField(
        controller: _picture_url,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Picture URL",
          border: InputBorder.none, // No outline border
        ),
      ),
    );

    final viewListbutton = TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const PromotionListPage(),
            ),
            (route) => false, //To disable back feature set to false
          );
        },
        child: const Text('View List of Promotions'));

    final saveButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: 150, // Adjusted width for the Save button
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var promotionresponse = await FirebaseCrud.addPromotion(
              shopName: _shop_name.text,
              date: _promotion_date.text,
              pictureUrl: _picture_url.text,
            );
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Promotion Added Successfully'),
                  content: Text(promotionresponse.message.toString()),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('OK'),
                    ),
                  ],
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
        title: const Text('Add Promotion'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 20.0), // Adds space between the AppBar and the form
              Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // Changes position of shadow
                    ),
                  ],
                ),
                child: Column(
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
                            shopNameField,
                            const SizedBox(height: 25.0),
                            dateField,
                            const SizedBox(height: 35.0),
                            pictureField,
                            const SizedBox(height: 25.0),
                            // viewListButton,
                            // const SizedBox(height: 45.0),
                            saveButton,
                            const SizedBox(height: 15.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
