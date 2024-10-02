import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/promotionresponse.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('Promotion');

class FirebaseCrud {
  //Insert promotion
  static Future<PromotionResponse> addPromotion({
    required String shopName,
    required String date,
    required String pictureUrl,
  }) async {
    PromotionResponse promotionresponse = PromotionResponse();
    DocumentReference documentReferencer = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "shop_name": shopName,
      "date": date,
      "picture_url": pictureUrl,
    };

    await documentReferencer.set(data).whenComplete(() {
      promotionresponse.code = 200;
      promotionresponse.message = "Successfully added to the database";
    }).catchError((e) {
      promotionresponse.code = 500;
      promotionresponse.message = e.toString();
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
    required String shopName,
    required String date,
    required String pictureUrl,
    required String docId,
  }) async {
    PromotionResponse promotionresponse = PromotionResponse();
    DocumentReference documentReferencer = _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "shop_name": shopName,
      "date": date,
      "picture_url": pictureUrl,
    };

    await documentReferencer.update(data).whenComplete(() {
      promotionresponse.code = 200;
      promotionresponse.message = "Successfully updated Promotion";
    }).catchError((e) {
      promotionresponse.code = 500;
      promotionresponse.message = e.toString();
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
      promotionresponse.message = "Successfully Deleted Promotion";
    }).catchError((e) {
      promotionresponse.code = 500;
      promotionresponse.message = e.toString();
    });

    return promotionresponse;
  }
}
