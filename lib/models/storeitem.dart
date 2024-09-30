import 'package:cloud_firestore/cloud_firestore.dart';

class StoreItem {
  String? uid;
  String? itemname;
  String? category; // Dropdown: Women, Men, Kids
  String? itemtype; // Dropdown: dress, pant, trouser, t-shirt, shirt, blouse, skirt, denim
  String? description;
  Map<String, int>? quantities; // For sizes S, M, L, XL, XXL
  double? price; // Currency in Rupees (double)
  String? imageUrl; // Link to the image
  Timestamp? createdAt; // Created date & time
  Timestamp? updatedAt; // Updated date & time

  StoreItem({
    this.uid,
    this.itemname,
    this.category,
    this.itemtype,
    this.description,
    this.quantities,
    this.price,
    this.imageUrl,
    this.createdAt,
    this.updatedAt, required name,
  });
}
