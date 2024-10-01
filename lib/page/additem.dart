import 'itemlistpage.dart';
import 'package:flutter/material.dart';
import '../services/inventory_firebase_crud.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddItem();
  }
}

class _AddItem extends State<AddItem> {
  final _storeitemNameController = TextEditingController();
  final _storeitemDescriptionController = TextEditingController();
  final _storeitemPriceController = TextEditingController();
  final _storeitemQuantitySController = TextEditingController();
  final _storeitemQuantityMController = TextEditingController();
  final _storeitemQuantityLController = TextEditingController();
  final _storeitemQuantityXLController = TextEditingController();
  final _storeitemQuantityXXLController = TextEditingController();
  final _storeitemImageUrlController = TextEditingController();

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
  void dispose() {
    // Dispose controllers to free up resources
    _storeitemNameController.dispose();
    _storeitemDescriptionController.dispose();
    _storeitemPriceController.dispose();
    _storeitemQuantitySController.dispose();
    _storeitemQuantityMController.dispose();
    _storeitemQuantityLController.dispose();
    _storeitemQuantityXLController.dispose();
    _storeitemQuantityXXLController.dispose();
    _storeitemImageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nameField = _buildFieldContainer(
        _buildTextFormField(_storeitemNameController, "Item Name"));
    final descriptionField = _buildFieldContainer(
        _buildTextFormField(_storeitemDescriptionController, "Description"));
    final priceField = _buildFieldContainer(_buildTextFormField(
      _storeitemPriceController,
      "Unit Price",
      isNumber: true,
      minValue: 0.01, // Price must be greater than 0
    ));

    // Dropdown for Category
    final categoryField = _buildFieldContainer(
      DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: InputDecoration(
          hintText: "Select Item Category",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (newValue) => setState(() => _selectedCategory = newValue),
        validator: (value) =>
            value == null || value.isEmpty ? 'Please select a category' : null,
        items: _categories.map((category) {
          return DropdownMenuItem(
            value: category,
            child: Text(category),
          );
        }).toList(),
      ),
    );

    // Dropdown for Item Type
    final itemTypeField = _buildFieldContainer(
      DropdownButtonFormField<String>(
        value: _selectedItemType,
        decoration: InputDecoration(
          hintText: "Select Item Type",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (newValue) => setState(() => _selectedItemType = newValue),
        validator: (value) => value == null || value.isEmpty
            ? 'Please select an item type'
            : null,
        items: _itemTypes.map((itemType) {
          return DropdownMenuItem(
            value: itemType,
            child: Text(itemType),
          );
        }).toList(),
      ),
    );

    // Quantity fields for sizes
    final sizeFields = Column(
      children: [
        _buildFieldContainer(_buildTextFormField(
          _storeitemQuantitySController,
          "Quantity (S)",
          isNumber: true,
          minValue: 0, // Quantity can be zero or positive
        )),
        _buildFieldContainer(_buildTextFormField(
          _storeitemQuantityMController,
          "Quantity (M)",
          isNumber: true,
          minValue: 0,
        )),
        _buildFieldContainer(_buildTextFormField(
          _storeitemQuantityLController,
          "Quantity (L)",
          isNumber: true,
          minValue: 0,
        )),
        _buildFieldContainer(_buildTextFormField(
          _storeitemQuantityXLController,
          "Quantity (XL)",
          isNumber: true,
          minValue: 0,
        )),
        _buildFieldContainer(_buildTextFormField(
          _storeitemQuantityXXLController,
          "Quantity (XXL)",
          isNumber: true,
          minValue: 0,
        )),
      ],
    );

    final imageUrlField = _buildFieldContainer(
        _buildTextFormField(_storeitemImageUrlController, "Image URL"));

    final viewListButton = _buildFieldContainer(_buildViewListButton(context));
    final saveButton = _buildFieldContainer(_buildSaveButton(context));

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Item')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
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

  // Container with shadow outline for fields and buttons
  Widget _buildFieldContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(
          horizontal: 450), // Adjusted for responsiveness
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

  /// Builds a [TextFormField] with customizable validation.
  ///
  /// [controller]: Controls the text being edited.
  /// [hint]: Placeholder text for the field.
  /// [isNumber]: If true, the keyboard is set to number input.
  /// [minValue]: The minimum acceptable value (inclusive). Defaults to 0.
  TextFormField _buildTextFormField(
      TextEditingController controller, String hint,
      {bool isNumber = false, double minValue = 0}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        if (isNumber) {
          final parsedValue = minValue == 0
              ? int.tryParse(value) ?? double.tryParse(value)
              : double.tryParse(value);
          if (parsedValue == null) {
            return 'Please enter a valid number';
          }
          if (parsedValue < minValue) {
            return minValue > 0
                ? 'Value must be greater than $minValue'
                : 'Value cannot be negative';
          }
        }
        return null;
      },
    );
  }

  // Button to view inventory
  TextButton _buildViewListButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const ItemListPage())),
      child: const Text('View Inventory'),
    );
  }

  // Save button to add a new item
  Material _buildSaveButton(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              // Save the item with all new fields including dropdown values
              var response = await FirebaseCrud.addStoreItem(
                name: _storeitemNameController.text.trim(),
                category: _selectedCategory!,
                itemtype: _selectedItemType!,
                description: _storeitemDescriptionController.text.trim(),
                price: double.parse(_storeitemPriceController.text.trim()),
                quantities: {
                  "S":
                      int.tryParse(_storeitemQuantitySController.text.trim()) ??
                          0,
                  "M":
                      int.tryParse(_storeitemQuantityMController.text.trim()) ??
                          0,
                  "L":
                      int.tryParse(_storeitemQuantityLController.text.trim()) ??
                          0,
                  "XL": int.tryParse(
                          _storeitemQuantityXLController.text.trim()) ??
                      0,
                  "XXL": int.tryParse(
                          _storeitemQuantityXXLController.text.trim()) ??
                      0,
                },
                imageUrl: _storeitemImageUrlController.text.trim(),
              );
              _showResponseDialog(
                  context, response.message ?? "Item added successfully!");
            } catch (e) {
              _showResponseDialog(context, "An error occurred: $e");
            }
          }
        },
        child: const Text("SAVE", style: TextStyle(color: Colors.white)),
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const ItemListPage()));
            },
          ),
        ],
      ),
    );
  }
}
