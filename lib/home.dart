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
            const SignOutButton(),
            SizedBox(height: 30), // Keep the spacing

            // Incident Section
            IncidentCard(), // Use the custom IncidentCard widget here

            // Loyalty Section
            LoyaltySection(), // Add the Loyalty Section here

            // Rental Application Section
            RentalApplicationCard(), // Add the Rental Application Card

            // Dashboard Section
            DashboardCard(), // Add the new DashboardCard widget here
          ],
        ),
      ),
    );
  }
}
