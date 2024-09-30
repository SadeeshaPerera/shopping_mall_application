import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceFirebaseCrud {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection =
      'MaintenanceRequests'; // Your collection name

  // Method to read maintenance requests
  static Stream<QuerySnapshot> readMaintenanceRequests() {
    return _firestore.collection(_collection).snapshots();
  }

  // Method to add a maintenance request
  static Future<Response> addMaintenanceRequest(
      String requestDescription) async {
    try {
      await _firestore.collection(_collection).add({
        'request_description': requestDescription,
        'status': 'Pending', // Default status
        'created_at': FieldValue.serverTimestamp(), // Optional: timestamp
      });
      return Response(code: 200, message: 'Request added successfully');
    } catch (e) {
      return Response(code: 400, message: e.toString());
    }
  }

  // Method to delete a maintenance request
  static Future<Response> deleteMaintenanceRequest(
      {required String docId}) async {
    try {
      await _firestore.collection(_collection).doc(docId).delete();
      return Response(code: 200, message: 'Request deleted successfully');
    } catch (e) {
      return Response(code: 400, message: e.toString());
    }
  }
}

// Simple response class to handle CRUD responses
class Response {
  final int code;
  final String message;

  Response({required this.code, required this.message});
}
