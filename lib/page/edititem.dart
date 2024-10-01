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
  final _storeitem_description = TextEditingController();
  final _storeitem_price = TextEditingController();
  final _storeitem_quantity_s = TextEditingController();
  final _storeitem_quantity_m = TextEditingController();
  final _storeitem_quantity_l = TextEditingController();
  final _storeitem_quantity_xl = TextEditingController();
  final _storeitem_quantity_xxl = TextEditingController();
  final _storeitem_image_url = TextEditingController();
  final _docid = TextEditingController();

  // Dropdown values
  String? _selectedCategory;
  String? _selectedItemType;

  final List<String> _categories = ['Women', 'Men', 'Kids'];
  final List<String> _itemTypes = ['Dress', 'Pant', 'Trouser', 'T-shirt', 'Shirt', 'Blouse', 'Skirt', 'Denim'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
 @override
void initState() {
  super.initState();
  _docid.value = TextEditingValue(text: widget.storeitem!.uid.toString());
  _storeitem_name.value = TextEditingValue(text: widget.storeitem!.itemname.toString());
  _storeitem_description.value = TextEditingValue(text: widget.storeitem!.description.toString());
  _storeitem_price.value = TextEditingValue(text: widget.storeitem!.price.toString());
  
  // Parse quantities to avoid dynamic type issues
  _storeitem_quantity_s.value = TextEditingValue(text: (widget.storeitem!.quantities!['S'] ?? 0).toString());
  _storeitem_quantity_m.value = TextEditingValue(text: (widget.storeitem!.quantities!['M'] ?? 0).toString());
  _storeitem_quantity_l.value = TextEditingValue(text: (widget.storeitem!.quantities!['L'] ?? 0).toString());
  _storeitem_quantity_xl.value = TextEditingValue(text: (widget.storeitem!.quantities!['XL'] ?? 0).toString());
  _storeitem_quantity_xxl.value = TextEditingValue(text: (widget.storeitem!.quantities!['XXL'] ?? 0).toString());
  
  _storeitem_image_url.value = TextEditingValue(text: widget.storeitem!.imageUrl.toString());
  _selectedCategory = widget.storeitem!.category.toString();
  _selectedItemType = widget.storeitem!.itemtype.toString();
}

  @override
  Widget build(BuildContext context) {
    final docIDField = TextFormField(
      controller: _docid,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Document ID",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final nameField = _buildTextFormField(_storeitem_name, "Item Name");
    final descriptionField = _buildTextFormField(_storeitem_description, "Description");
    final priceField = _buildTextFormField(_storeitem_price, "Price", isNumber: true);

    // Dropdown for Category
    final categoryField = DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        hintText: "Select Category",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onChanged: (newValue) => setState(() => _selectedCategory = newValue),
      validator: (value) => value == null ? 'Please select a category' : null,
      items: _categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category),
        );
      }).toList(),
    );

    // Dropdown for Item Type
    final itemTypeField = DropdownButtonFormField<String>(
      value: _selectedItemType,
      decoration: InputDecoration(
        hintText: "Select Item Type",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onChanged: (newValue) => setState(() => _selectedItemType = newValue),
      validator: (value) => value == null ? 'Please select an item type' : null,
      items: _itemTypes.map((itemType) {
        return DropdownMenuItem(
          value: itemType,
          child: Text(itemType),
        );
      }).toList(),
    );

    // Quantity fields for sizes
    final sizeFields = Column(
      children: [
        _buildTextFormField(_storeitem_quantity_s, "Quantity (S)", isNumber: true),
        _buildTextFormField(_storeitem_quantity_m, "Quantity (M)", isNumber: true),
        _buildTextFormField(_storeitem_quantity_l, "Quantity (L)", isNumber: true),
        _buildTextFormField(_storeitem_quantity_xl, "Quantity (XL)", isNumber: true),
        _buildTextFormField(_storeitem_quantity_xxl, "Quantity (XXL)", isNumber: true),
      ],
    );

    final imageUrlField = _buildTextFormField(_storeitem_image_url, "Image URL");

    final viewListButton = TextButton(
      onPressed: () => Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(builder: (BuildContext context) => ItemListPage()),
        (route) => false,
      ),
      child: const Text('View List of Store Items'),
    );

    final saveButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // Ensure quantities are correctly parsed as integers
            var response = await FirebaseCrud.updateStoreItem(
              docId: _docid.text,
              name: _storeitem_name.text,
              category: _selectedCategory!,
              itemtype: _selectedItemType!,
              description: _storeitem_description.text,
              price: double.parse(_storeitem_price.text),
              quantities: {
                  "S": int.tryParse(_storeitem_quantity_s.text) ?? 0,
                  "M": int.tryParse(_storeitem_quantity_m.text) ?? 0,
                  "L": int.tryParse(_storeitem_quantity_l.text) ?? 0,
                  "XL": int.tryParse(_storeitem_quantity_xl.text) ?? 0,
                  "XXL": int.tryParse(_storeitem_quantity_xxl.text) ?? 0,
              }.map((key, value) => MapEntry(key, value as int)),

              imageUrl: _storeitem_image_url.text,
            );
            _showResponseDialog(context, response.message ?? "Default message");
          }
        },
        child: const Text("Update", style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Store Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              docIDField,
              const SizedBox(height: 15),
              nameField,
              const SizedBox(height: 15),
              categoryField,
              const SizedBox(height: 15),
              itemTypeField,
              const SizedBox(height: 15),
              descriptionField,
              const SizedBox(height: 15),
              priceField,
              const SizedBox(height: 15),
              sizeFields,
              const SizedBox(height: 15),
              imageUrlField,
              const SizedBox(height: 25),
              viewListButton,
              const SizedBox(height: 25),
              saveButton,
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextFormField(TextEditingController controller, String hint, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) => value == null || value.trim().isEmpty ? 'This field is required' : null,
    );
  }

    void _showResponseDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

