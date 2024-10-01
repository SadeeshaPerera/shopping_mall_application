import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_mall_application/page/additem.dart';
import 'package:shopping_mall_application/page/addpromotion.dart';
import 'package:shopping_mall_application/page/addloyaltypoints.dart';

import 'package:shopping_mall_application/page/admin/admin_incident_list_page.dart';

import 'package:shopping_mall_application/page/check_rental_applications.dart'; // Import the CheckRentalApplications page
import 'package:shopping_mall_application/page/maintenance_request_list_page.dart'; // Import the MaintenanceRequestList page
import 'package:shopping_mall_application/auth_gate.dart'; // Import your authentication gate


class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Admin Page!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
                height:
                    20), // Add some spacing between the text and the buttons

            // Button to add an inventory item
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddItem()), // Navigate to AddItem page
                );
              },
              child: const Text('Add an Inventory Item'),
            ),

            // Button to create a promotion
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddPromotion()), // Navigate to AddPromotion page
                );
              },
              child: const Text('Create a Promotion'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddLoyaltyPoints()));
              },
              child: const Text('Add Loyalty Points'),


            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminIncidentListPage()));
              },
              child: const Text('View Reported Incidents'),


            // Button to check rental applications
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CheckRentalApplications()), // Navigate to CheckRentalApplications page
                );
              },
              child: const Text('Check Rental Applications'),
            ),

            // Button to view maintenance requests
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MaintenanceRequestListPage()), // Navigate to MaintenanceRequestListPage
                );
              },
              child: const Text('View Maintenance Requests'),
            ),

            const SizedBox(
                height: 20), // Add some spacing before the sign-out button

            // Sign-Out Button
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut(); // Sign out from Firebase
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AuthGate()), // Navigate back to the sign-in page
                );
              },
              child: const Text('Sign Out'),


            ),
          ],
        ),
      ),
    );
  }
}
