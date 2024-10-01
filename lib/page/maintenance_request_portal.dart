import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_mall_application/models/rental_application.dart';

class MaintenanceRequestPortal extends StatefulWidget {
  @override
  _MaintenanceRequestPortalState createState() => _MaintenanceRequestPortalState();
}

class _MaintenanceRequestPortalState extends State<MaintenanceRequestPortal> {
  final TextEditingController _requestController = TextEditingController();
  String _status = '';

  void _submitRequest(QueryDocumentSnapshot<Object?> rentalApplication) {
    // Save the maintenance request to the database
    FirebaseFirestore.instance.collection('maintenanceRequests').add({
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'shopId': rentalApplication.id,
      'shopType': rentalApplication['shopType'],
      'userName': rentalApplication['userName'],
      'request': _requestController.text,
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    // Handle the request submission logic here
    setState(() {
      _status = 'Request submitted: ${_requestController.text}';
      _requestController.clear(); // Clear the input field after submission
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance Request Portal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
            .collection('rentalApplications')
            .where('userId', isEqualTo: userId) // Adjust this line if you want to filter by user ID
            .where('status', isEqualTo: 'Approved') // Adjust this line if you want to filter by status
            .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No rental applications found."));
            }
            final rentalApplication = snapshot.data!.docs[0];
            return Column(
              children: [
                TextField(
                  controller: _requestController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Describe your maintenance request',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _submitRequest(rentalApplication),
                  child: Text('Submit Request'),
                ),
                SizedBox(height: 20),
                Text(
                  _status,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
