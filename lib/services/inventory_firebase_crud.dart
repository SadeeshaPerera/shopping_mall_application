import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/storeitemresponse.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('StoreItem');

class FirebaseCrud {
//CRUD method here

//Add storeitem
  static Future<StoreItemResponse> addStoreItem({
    required String name,
    required String position,
    required String contactno,
  }) async {
    StoreItemResponse storeitemresponse = StoreItemResponse();
    DocumentReference documentReferencer = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "storeitem_name": name,
      "position": position,
      "contact_no": contactno
    };

    var result = await documentReferencer.set(data).whenComplete(() {
      storeitemresponse.code = 200;
      storeitemresponse.message = "Sucessfully added to the database";
    }).catchError((e) {
      storeitemresponse.code = 500;
      storeitemresponse.message = e;
    });

    return storeitemresponse;
  }

  //Read storeitem records
  static Stream<QuerySnapshot> readStoreItem() {
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.snapshots();
  }

  //Update storeitem record

  static Future<StoreItemResponse> updateStoreItem({
    required String name,
    required String position,
    required String contactno,
    required String docId,
  }) async {
    StoreItemResponse storeitemresponse = StoreItemResponse();
    DocumentReference documentReferencer = _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "storeitem_name": name,
      "position": position,
      "contact_no": contactno
    };

    await documentReferencer.update(data).whenComplete(() {
      storeitemresponse.code = 200;
      storeitemresponse.message = "Sucessfully updated StoreItem";
    }).catchError((e) {
      storeitemresponse.code = 500;
      storeitemresponse.message = e;
    });

    return storeitemresponse;
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
