import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/storeitemresponse.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('StoreItem');

class FirebaseCrud {
  // Add store item
  static Future<StoreItemResponse> addStoreItem({
    required String name,
    required String category,
    required String itemtype,
    required String description,
    required Map<String, int> quantities,
    required double price,
    required String imageUrl,
  }) async {
    StoreItemResponse storeItemResponse = StoreItemResponse();
    DocumentReference documentReferencer = _Collection.doc();

    // Create a timestamp for the created date & time
    Timestamp timestamp = Timestamp.now();

    // Data map with createdAt field
    Map<String, dynamic> data = <String, dynamic>{
      "itemname": name,
      "category": category,
      "itemtype": itemtype,
      "description": description,
      "quantities": quantities,
      "price": price,
      "imageUrl": imageUrl,
      "createdAt": timestamp, // Timestamp for creation
      "updatedAt": timestamp, // Initially, updatedAt is the same as createdAt
    };

    try {
      await documentReferencer.set(data);
      storeItemResponse.code = 200;
      storeItemResponse.message = "Successfully added to the database";
    } catch (e) {
      storeItemResponse.code = 500;
      storeItemResponse.message = e.toString();
    }

    return storeItemResponse;
  }

  // Read storeitem records
  static Stream<QuerySnapshot> readStoreItem() {
    CollectionReference storeItemCollection =
        FirebaseFirestore.instance.collection('StoreItem');
    return storeItemCollection.snapshots();
  }

  // Update store item record
  static Future<StoreItemResponse> updateStoreItem({
    required String name,
    required String category,
    required String itemtype,
    required String description,
    required Map<String, dynamic>
        quantities, // Allow dynamic temporarily for casting
    required double price,
    required String imageUrl,
    required String docId,
  }) async {
    StoreItemResponse storeItemResponse = StoreItemResponse();
    DocumentReference documentReferencer = _Collection.doc(docId);

    // Cast quantities to Map<String, int>
    Map<String, int> castQuantities =
        quantities.map((key, value) => MapEntry(key, value as int));

    // Create a timestamp for the updated date & time
    Timestamp timestamp = Timestamp.now();

    Map<String, dynamic> data = <String, dynamic>{
      "itemname": name,
      "category": category,
      "itemtype": itemtype,
      "description": description,
      "quantities": castQuantities, // Use the casted quantities
      "price": price,
      "imageUrl": imageUrl,
      "updatedAt": timestamp, // Update the timestamp for the updated time
    };

    await documentReferencer.update(data).whenComplete(() {
      storeItemResponse.code = 200;
      storeItemResponse.message = "Successfully updated StoreItem";
    }).catchError((e) {
      storeItemResponse.code = 500;
      storeItemResponse.message = e;
    });

    return storeItemResponse;
  }

  // Delete storeitem record
  static Future<StoreItemResponse> deleteStoreItem({
    required String docId,
  }) async {
    StoreItemResponse storeItemResponse = StoreItemResponse();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      storeItemResponse.code = 200;
      storeItemResponse.message = "Successfully Deleted StoreItem";
    }).catchError((e) {
      storeItemResponse.code = 500;
      storeItemResponse.message = e;
    });

    return storeItemResponse;
  }
}
