import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_mall_application/models/rental_application.dart';
import 'package:shopping_mall_application/page/maintenance_request_list_page.dart';
import 'maintenance_request_portal.dart'; // Import the new maintenance request portal screen

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   'Under Construction',
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.grey,
            //   ),
            // ),
            // SizedBox(height: 20), // Add some spacing
            StreamBuilder<QuerySnapshot>(
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
                return Text(
                  'Your rental shop ID: ${rentalApplication.id}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MaintenanceRequestPortal(), // Navigate to Maintenance Request Portal
                  ),
                );
              },
              child: Text('Maintenance Request Portal'),
            ),
            const SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MaintenanceRequestListPage(), // Navigate to Maintenance Request Portal
                  ),
                );
              },
              child: Text('My Maintenance Requests'),
            ),
          ],
        ),
      ),
    );
  }
}
