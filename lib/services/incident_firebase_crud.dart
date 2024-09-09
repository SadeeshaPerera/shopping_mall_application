import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/incidentresponse.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('Incident');

class FirebaseCrud {
//CRUD method here

//Create incident record

  static Future<IncidentResponse> addIncident({
    required String name,
    required String position,
    required String contactno,
  }) async {
    IncidentResponse incidentresponse = IncidentResponse();
    DocumentReference documentReferencer = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "incident_name": name,
      "position": position,
      "contact_no": contactno
    };

    var result = await documentReferencer.set(data).whenComplete(() {
      incidentresponse.code = 200;
      incidentresponse.message = "Sucessfully added to the database";
    }).catchError((e) {
      incidentresponse.code = 500;
      incidentresponse.message = e;
    });

    return incidentresponse;
  }

  //Read incident records
  static Stream<QuerySnapshot> readIncident() {
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.snapshots();
  }

  //Update incident record
  static Future<IncidentResponse> updateIncident({
    required String name,
    required String position,
    required String contactno,
    required String docId,
  }) async {
    IncidentResponse incidentresponse = IncidentResponse();
    DocumentReference documentReferencer = _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "incident_name": name,
      "position": position,
      "contact_no": contactno
    };

    await documentReferencer.update(data).whenComplete(() {
      incidentresponse.code = 200;
      incidentresponse.message = "Sucessfully updated Incident";
    }).catchError((e) {
      incidentresponse.code = 500;
      incidentresponse.message = e;
    });

    return incidentresponse;
  }

  //Delete Incident record

  static Future<IncidentResponse> deleteIncident({
    required String docId,
  }) async {
    IncidentResponse incidentresponse = IncidentResponse();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      incidentresponse.code = 200;
      incidentresponse.message = "Sucessfully Deleted Incident";
    }).catchError((e) {
      incidentresponse.code = 500;
      incidentresponse.message = e;
    });

    return incidentresponse;
  }
}
