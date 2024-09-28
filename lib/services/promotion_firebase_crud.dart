import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/promotionresponse.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('Promotion');

class FirebaseCrud {
//CRUD method here

//insert promotion
  static Future<PromotionResponse> addPromotion({
    required String name,
    required String position,
    required String contactno,
  }) async {
    PromotionResponse promotionresponse = PromotionResponse();
    DocumentReference documentReferencer = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "promotion_name": name,
      "position": position,
      "contact_no": contactno
    };

    var result = await documentReferencer.set(data).whenComplete(() {
      promotionresponse.code = 200;
      promotionresponse.message = "Sucessfully added to the database";
    }).catchError((e) {
      promotionresponse.code = 500;
      promotionresponse.message = e;
    });

    return promotionresponse;
  }

  //Read promotion records

  static Stream<QuerySnapshot> readPromotion() {
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.snapshots();
  }

  //Update promotion record

  static Future<PromotionResponse> updatePromotion({
    required String name,
    required String position,
    required String contactno,
    required String docId,
  }) async {
    PromotionResponse promotionresponse = PromotionResponse();
    DocumentReference documentReferencer = _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "promotion_name": name,
      "position": position,
      "contact_no": contactno
    };

    await documentReferencer.update(data).whenComplete(() {
      promotionresponse.code = 200;
      promotionresponse.message = "Sucessfully updated Promotion";
    }).catchError((e) {
      promotionresponse.code = 500;
      promotionresponse.message = e;
    });

    return promotionresponse;
  }

  //Delete promotion record

  static Future<PromotionResponse> deletePromotion({
    required String docId,
  }) async {
    PromotionResponse promotionresponse = PromotionResponse();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      promotionresponse.code = 200;
      promotionresponse.message = "Sucessfully Deleted Promotion";
    }).catchError((e) {
      promotionresponse.code = 500;
      promotionresponse.message = e;
    });

    return promotionresponse;
  }
}
