import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_mall_application/page/additem.dart';
import 'package:shopping_mall_application/page/addcontract.dart';
import 'package:shopping_mall_application/page/addpromotion.dart';
import 'package:shopping_mall_application/page/addrental_application.dart';
import 'package:shopping_mall_application/page/admin/admin_main_screen.dart';
import 'package:shopping_mall_application/page/home/incidentsection.dart';
import 'package:shopping_mall_application/page/home/loyalty_section.dart'; // Import the LoyaltySection widget
import 'package:shopping_mall_application/page/home/rental_application_card.dart'; // Import the RentalApplicationCard
import 'package:shopping_mall_application/page/home/occupency_dashboard_section.dart'; // Import the DashboardCard widget
import 'package:shopping_mall_application/auth_gate.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShoppingMate Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                    children: [],
                  ),
                ),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/ShoppingMateLogo.png'),
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 30), // Keep the spacing

            // Incident Section
            IncidentCard(), // Custom widget

            // Loyalty Section
            LoyaltySection(), // Custom widget

            // Rental Application Section
            RentalApplicationCard(), // Custom widget

            // Dashboard Section
            DashboardCard(), // Custom widget

            // Sign-Out Button
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut(); // Sign out using FirebaseAuth
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthGate()), // Navigate to AuthGate
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
