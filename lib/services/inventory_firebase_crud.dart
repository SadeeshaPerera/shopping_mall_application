import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/storeitemresponse.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('StoreItem');

class FirebaseCrud {
//CRUD method here

// Add store item
static Future<StoreItemResponse> addStoreItem({
  required String name,
  required String category,
  required int quantity,
  required int price,
}) async {
  StoreItemResponse storeItemResponse = StoreItemResponse();
  DocumentReference documentReferencer = _Collection.doc(); // Make sure _Collection refers to your "StoreItem" Firestore collection.

  // Correct the data map
  Map<String, dynamic> data = <String, dynamic>{
    "itemname": name,
    "category": category,
    "quantity": quantity, // Added quantity field
    "price": price        // Added price field
  };

  // Try saving to Firestore
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
  // Reference to the StoreItem collection in Firestore
  CollectionReference storeItemCollection = FirebaseFirestore.instance.collection('StoreItem');

  // Return a stream of snapshots for real-time updates
  return storeItemCollection.snapshots();
}

  // Update store item record
static Future<StoreItemResponse> updateStoreItem({
  required String name,
  required String category,
  required int quantity,
  required int price,
  required String docId,
}) async {
  StoreItemResponse storeItemResponse = StoreItemResponse();
  DocumentReference documentReferencer = _Collection.doc(docId);

  Map<String, dynamic> data = <String, dynamic>{
    "itemname": name,
    "category": category,
    "quantity": quantity,
    "price": price,
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


  //Delete storeitem record

  static Future<StoreItemResponse> deleteStoreItem({
    required String docId,
  }) async {
    StoreItemResponse storeitemresponse = StoreItemResponse();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      storeitemresponse.code = 200;
      storeitemresponse.message = "Sucessfully Deleted StoreItem";
    }).catchError((e) {
      storeitemresponse.code = 500;
      storeitemresponse.message = e;
    });

    return storeitemresponse;
  }

  
}
