import 'itemlistpage.dart';
import 'package:flutter/material.dart';
import '../models/storeitem.dart';
import '../services/inventory_firebase_crud.dart';

class EditItem extends StatefulWidget {
  final StoreItem? storeitem;
  const EditItem({super.key, this.storeitem});

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
  final List<String> _itemTypes = [
    'Dress',
    'Pant',
    'Trouser',
    'T-shirt',
    'Shirt',
    'Blouse',
    'Skirt',
    'Denim'
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _docid.value = TextEditingValue(text: widget.storeitem!.uid.toString());
    _storeitem_name.value =
        TextEditingValue(text: widget.storeitem!.itemname.toString());
    _storeitem_description.value =
        TextEditingValue(text: widget.storeitem!.description.toString());
    _storeitem_price.value =
        TextEditingValue(text: widget.storeitem!.price.toString());

    _storeitem_quantity_s.value = TextEditingValue(
        text: (widget.storeitem!.quantities!['S'] ?? 0).toString());
    _storeitem_quantity_m.value = TextEditingValue(
        text: (widget.storeitem!.quantities!['M'] ?? 0).toString());
    _storeitem_quantity_l.value = TextEditingValue(
        text: (widget.storeitem!.quantities!['L'] ?? 0).toString());
    _storeitem_quantity_xl.value = TextEditingValue(
        text: (widget.storeitem!.quantities!['XL'] ?? 0).toString());
    _storeitem_quantity_xxl.value = TextEditingValue(
        text: (widget.storeitem!.quantities!['XXL'] ?? 0).toString());

    _storeitem_image_url.value =
        TextEditingValue(text: widget.storeitem!.imageUrl.toString());
    _selectedCategory = widget.storeitem!.category.toString();
    _selectedItemType = widget.storeitem!.itemtype.toString();
  }

  @override
  Widget build(BuildContext context) {
    final docIDField = _buildFieldContainer(
      TextFormField(
        controller: _docid,
        readOnly: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Document ID",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );

    final nameField =
        _buildFieldContainer(_buildTextFormField(_storeitem_name, "Item Name"));
    final descriptionField = _buildFieldContainer(
        _buildTextFormField(_storeitem_description, "Description"));
    final priceField = _buildFieldContainer(
        _buildTextFormField(_storeitem_price, "Unit Price", isNumber: true));

    final categoryField = _buildFieldContainer(
      DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: InputDecoration(
          hintText: "Select Item Category",
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
      ),
    );

    final itemTypeField = _buildFieldContainer(
      DropdownButtonFormField<String>(
        value: _selectedItemType,
        decoration: InputDecoration(
          hintText: "Select Item Type",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (newValue) => setState(() => _selectedItemType = newValue),
        validator: (value) =>
            value == null ? 'Please select an item type' : null,
        items: _itemTypes.map((itemType) {
          return DropdownMenuItem(
            value: itemType,
            child: Text(itemType),
          );
        }).toList(),
      ),
    );

    final sizeFields = Column(
      children: [
        _buildFieldContainer(_buildTextFormField(
            _storeitem_quantity_s, "Quantity (S)",
            isNumber: true)),
        _buildFieldContainer(_buildTextFormField(
            _storeitem_quantity_m, "Quantity (M)",
            isNumber: true)),
        _buildFieldContainer(_buildTextFormField(
            _storeitem_quantity_l, "Quantity (L)",
            isNumber: true)),
        _buildFieldContainer(_buildTextFormField(
            _storeitem_quantity_xl, "Quantity (XL)",
            isNumber: true)),
        _buildFieldContainer(_buildTextFormField(
            _storeitem_quantity_xxl, "Quantity (XXL)",
            isNumber: true)),
      ],
    );

    final imageUrlField = _buildFieldContainer(
        _buildTextFormField(_storeitem_image_url, "Image URL"));

    final viewListButton = _buildFieldContainer(
      TextButton(
        onPressed: () => Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const ItemListPage()),
          (route) => false,
        ),
        child: const Text('View Inventory'),
      ),
    );

    final saveButton = _buildFieldContainer(
      Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColor,
        child: MaterialButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
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
                },
                imageUrl: _storeitem_image_url.text,
              );
              _showResponseDialog(
                  context, response.message ?? "Default message");
            }
          },
          child: const Text("Update", style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Update Item')),
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

  // Container with shadow outline for fields and buttons
  Widget _buildFieldContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 450),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  TextFormField _buildTextFormField(
      TextEditingController controller, String hint,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        if (isNumber) {
          final parsedValue = double.tryParse(value);
          if (parsedValue == null) {
            return 'Please enter a valid number';
          }
          if (parsedValue <= 0) {
            return 'Price and Quantity must be greater than 0';
          }
        }
        return null;
      },
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const ItemListPage()));
            },
          ),
        ],
      ),
    );
  }
}