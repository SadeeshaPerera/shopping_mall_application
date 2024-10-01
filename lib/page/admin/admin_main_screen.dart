import 'package:flutter/material.dart';

import 'package:shopping_mall_application/page/itemlistpage.dart';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shopping_mall_application/page/additem.dart';

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
        title: const Text('Admin Dashboard'),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Web layout
            return buildWebLayout(context);
          } else {
            // Mobile layout
            return buildMobileLayout(context);
          }
        },
      ),
    );
  }

  Widget buildWebLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: buildDashboardItems(context),
      ),
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: buildDashboardItems(context),
      ),
    );
  }


  List<Widget> buildDashboardItems(BuildContext context) {
    return [
      buildDashboardItem(
        context,
        icon: Icons.inventory,
        label: 'Add an Inventory Item',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItem()),
          );
        },
      ),
      buildDashboardItem(
        context,
        icon: Icons.inventory,
        label: 'Add Loyalty Points',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddLoyaltyPoints()),
          );
        },
      ),
      buildDashboardItem(
        context,
        icon: Icons.local_offer,
        label: 'Create a Promotion',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPromotion()),
          );
        },
      ),
      buildDashboardItem(
        context,
        icon: Icons.report,
        label: 'View Reported Incidents',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminIncidentListPage()),
          );
        },
      ),
      buildDashboardItem(
        context,
        icon: Icons.assignment,
        label: 'Check Rental Applications',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CheckRentalApplications()),
          );
        },
      ),
      buildDashboardItem(
        context,
        icon: Icons.build,
        label: 'View Maintenance Requests',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MaintenanceRequestListPage()),
          );
        },
      ),
      buildDashboardItem(
        context,
        icon: Icons.logout,
        label: 'Sign Out',
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AuthGate()),
          );
        },
      ),
    ];
  }

  Widget buildDashboardItem(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 48.0, color: Theme.of(context).primaryColor),
                const SizedBox(height: 16.0),
                Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16.0)),
              ],

            ),
          ),
        ),
      ),
    );
  }
}
