import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rental_application.dart';

class RentalApplicationCrud {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collectionName = "rentalApplications";

  // Add a new rental application
  static Future<Map<String, dynamic>> addRentalApplication({
    required String userName,
    required String shopType,
    required String driveLink,
  }) async {
    try {
      DocumentReference docRef = await _firestore.collection(collectionName).add({
        'userName': userName,
        'shopType': shopType,
        'driveLink': driveLink,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {
        'status': true,
        'message': 'Application successfully submitted',
        'id': docRef.id,
      };
    } catch (e) {
      return {
        'status': false,
        'message': 'Error adding application: $e',
      };
    }
  }

  // Update an existing rental application
  static Future<Map<String, dynamic>> updateRentalApplication({
    required String id,
    required String userName,
    required String shopType,
    required String driveLink,
  }) async {
    try {
      await _firestore.collection(collectionName).doc(id).update({
        'userName': userName,
        'shopType': shopType,
        'driveLink': driveLink,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return {
        'status': true,
        'message': 'Application successfully updated',
      };
    } catch (e) {
      return {
        'status': false,
        'message': 'Error updating application: $e',
      };
    }
  }

  // Delete a rental application
  static Future<Map<String, dynamic>> deleteRentalApplication(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
      return {
        'status': true,
        'message': 'Application successfully deleted',
      };
    } catch (e) {
      return {
        'status': false,
        'message': 'Error deleting application: $e',
      };
    }
  }

  // Fetch all rental applications
  static Future<Map<String, dynamic>> getAllRentalApplications() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .orderBy('createdAt', descending: true) // Ordering by creation time
          .get();

      List<RentalApplication> applications = querySnapshot.docs.map((doc) {
        return RentalApplication(
          id: doc.id,
          userName: doc['userName'],
          shopType: doc['shopType'],
          driveLink: doc['driveLink'],
        );
      }).toList();

      return {
        'status': true,
        'data': applications,
      };
    } catch (e) {
      return {
        'status': false,
        'message': 'Error fetching applications: $e',
      };
    }
  }
}
