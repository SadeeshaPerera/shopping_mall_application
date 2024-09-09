import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/incidentresponse.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('Incident');

class FirebaseCrud {
  // Create incident record
  static Future<IncidentResponse> addIncident({
    required String name,
    required String description,
    required String date,
    required String location,
    required String contactNumber,
    required String status,
  }) async {
    IncidentResponse incidentresponse = IncidentResponse();
    DocumentReference documentReferencer = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "description": description,
      "date": date,
      "location": location,
      "contactNumber": contactNumber,
      "status": status,
    };

    await documentReferencer.set(data).whenComplete(() {
      incidentresponse.code = 200;
      incidentresponse.message = "Successfully added to the database";
    }).catchError((e) {
      incidentresponse.code = 500;
      incidentresponse.message = e.toString();
    });

    return incidentresponse;
  }

  // Read incident records
  static Stream<QuerySnapshot> readIncident() {
    CollectionReference notesItemCollection = _Collection;
    return notesItemCollection.snapshots();
  }

  // Update incident record
  static Future<IncidentResponse> updateIncident({
    required String id,
    required String name,
    required String description,
    required String date,
    required String location,
    required String contactNumber,
    required String status,
  }) async {
    IncidentResponse incidentresponse = IncidentResponse();
    DocumentReference documentReferencer = _Collection.doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "description": description,
      "date": date,
      "location": location,
      "contactNumber": contactNumber,
      "status": status,
    };

    await documentReferencer.update(data).whenComplete(() {
      incidentresponse.code = 200;
      incidentresponse.message = "Successfully updated Incident";
    }).catchError((e) {
      incidentresponse.code = 500;
      incidentresponse.message = e.toString();
    });

    return incidentresponse;
  }

  // Delete Incident record
  static Future<IncidentResponse> deleteIncident({
    required String docId,
  }) async {
    IncidentResponse incidentresponse = IncidentResponse();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      incidentresponse.code = 200;
      incidentresponse.message = "Successfully Deleted Incident";
    }).catchError((e) {
      incidentresponse.code = 500;
      incidentresponse.message = e.toString();
    });

    return incidentresponse;
  }

  // Add Store Item
  static Future<IncidentResponse> addStoreItem({
    required String name,
    required String description,
    required double price,
  }) async {
    IncidentResponse storeitemresponse = IncidentResponse();
    DocumentReference documentReferencer =
        _firestore.collection('StoreItem').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "description": description,
      "price": price,
    };

    await documentReferencer.set(data).whenComplete(() {
      storeitemresponse.code = 200;
      storeitemresponse.message = "Successfully added to the database";
    }).catchError((e) {
      storeitemresponse.code = 500;
      storeitemresponse.message = e.toString();
    });

    return storeitemresponse;
  }

  // Read Store Items
  static Stream<QuerySnapshot> readStoreItem() {
    CollectionReference storeItemCollection =
        _firestore.collection('StoreItem');
    return storeItemCollection.snapshots();
  }

  // Delete Store Item
  static Future<IncidentResponse> deleteStoreItem({
    required String docId,
  }) async {
    IncidentResponse storeitemresponse = IncidentResponse();
    DocumentReference documentReferencer =
        _firestore.collection('StoreItem').doc(docId);

    await documentReferencer.delete().whenComplete(() {
      storeitemresponse.code = 200;
      storeitemresponse.message = "Successfully Deleted Store Item";
    }).catchError((e) {
      storeitemresponse.code = 500;
      storeitemresponse.message = e.toString();
    });

    return storeitemresponse;
  }
}
