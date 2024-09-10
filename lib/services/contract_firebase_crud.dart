import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contractresponse.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('Contract');

class FirebaseCrud {
//CRUD method here
//inserting an contract
  static Future<ContractResponse> addcontract({
    required String name,
    required String position,
    required String contactno,
  }) async {
    ContractResponse contractresponse = ContractResponse();
    DocumentReference documentReferencer = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "contract_name": name,
      "position": position,
      "contact_no": contactno
    };

    var result = await documentReferencer.set(data).whenComplete(() {
      contractresponse.code = 200;
      contractresponse.message = "Sucessfully added to the database";
    }).catchError((e) {
      contractresponse.code = 500;
      contractresponse.message = e;
    });

    return contractresponse;
  }

  //fetching all contracts
  static Stream<QuerySnapshot> readcontract() {
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.snapshots();
  }

  //updating an contract

  static Future<ContractResponse> updatecontract({
    required String name,
    required String position,
    required String contactno,
    required String docId,
  }) async {
    ContractResponse contractresponse = ContractResponse();
    DocumentReference documentReferencer = _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "contract_name": name,
      "position": position,
      "contact_no": contactno
    };

    await documentReferencer.update(data).whenComplete(() {
      contractresponse.code = 200;
      contractresponse.message = "Sucessfully updated Contract";
    }).catchError((e) {
      contractresponse.code = 500;
      contractresponse.message = e;
    });

    return contractresponse;
  }

  //deleting an contract

  static Future<ContractResponse> deletecontract({
    required String docId,
  }) async {
    ContractResponse contractresponse = ContractResponse();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      contractresponse.code = 200;
      contractresponse.message = "Sucessfully Deleted Contract";
    }).catchError((e) {
      contractresponse.code = 500;
      contractresponse.message = e;
    });

    return contractresponse;
  }
}
