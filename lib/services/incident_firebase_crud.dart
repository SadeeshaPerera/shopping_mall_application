import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('Incident');

class FirebaseCrud {
//CRUD method here

//Create incident record

  static Future<Response> addIncident({
    required String name,
    required String position,
    required String contactno,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "incident_name": name,
      "position": position,
      "contact_no": contactno
    };

    var result = await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  //Read incident records
  static Stream<QuerySnapshot> readIncident() {
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.snapshots();
  }

  //Update incident record
  static Future<Response> updateIncident({
    required String name,
    required String position,
    required String contactno,
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "incident_name": name,
      "position": position,
      "contact_no": contactno
    };

    await documentReferencer.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully updated Incident";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  //Delete Incident record

  static Future<Response> deleteIncident({
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully Deleted Incident";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
}
