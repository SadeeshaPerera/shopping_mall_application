import 'itemlistpage.dart';
import 'package:flutter/material.dart';
import '../services/inventory_firebase_crud.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddItem();
  }
}

class _AddItem extends State<AddItem> {
  final _storeitem_name = TextEditingController();

  final _storeitem_description = TextEditingController();
  final _storeitem_price = TextEditingController();
  final _storeitem_quantity_s = TextEditingController();
  final _storeitem_quantity_m = TextEditingController();
  final _storeitem_quantity_l = TextEditingController();
  final _storeitem_quantity_xl = TextEditingController();
  final _storeitem_quantity_xxl = TextEditingController();
  final _storeitem_image_url = TextEditingController();


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {

    final nameField = _buildTextFormField(_storeitem_name, "Item Name");
    final descriptionField =
        _buildTextFormField(_storeitem_description, "Description");
        
    final priceField = _buildTextFormField(_storeitem_price, "Unit Price", isNumber: true);


    // Dropdown for Category
    final categoryField = DropdownButtonFormField<String>(
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
        _buildTextFormField(_storeitem_quantity_s, "Quantity (S)",
            isNumber: true),
        _buildTextFormField(_storeitem_quantity_m, "Quantity (M)",
            isNumber: true),
        _buildTextFormField(_storeitem_quantity_l, "Quantity (L)",
            isNumber: true),
        _buildTextFormField(_storeitem_quantity_xl, "Quantity (XL)",
            isNumber: true),
        _buildTextFormField(_storeitem_quantity_xxl, "Quantity (XXL)",
            isNumber: true),
      ],
    );

    final imageUrlField =
        _buildTextFormField(_storeitem_image_url, "Image URL");

    final viewListButton = _buildViewListButton(context);
    final saveButton = _buildSaveButton(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
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
          return 'Price must be greater than 0';
        }
      }
      return null;
    },
  );
}


  //Button to view inventory
  TextButton _buildViewListButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const ItemListPage())),
      child: const Text('View Inventory'),
    );
  }

  Material _buildSaveButton(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),

      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {

            // Save the item with all new fields including dropdown values
            var response = await FirebaseCrud.addStoreItem(
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
            _showResponseDialog(context, response.message ?? "Default message");

          }
        },
        child: const Text("Save", style: TextStyle(color: Colors.white)),
      ),
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
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const ItemListPage()));
            },

          ),
        ],
      ),
    );
  }
}
