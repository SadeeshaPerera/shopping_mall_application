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

import 'package:shopping_mall_application/page/myexpenses.dart';

import 'package:shopping_mall_application/page/home/rental_application_card.dart'; // Import the RentalApplicationCard
import 'package:shopping_mall_application/page/home/occupency_dashboard_section.dart'; // Import the DashboardCard widget
import 'package:shopping_mall_application/auth_gate.dart';

import 'package:shopping_mall_application/page/promotionlistcustomer.dart';
import 'package:shopping_mall_application/page/mypoints.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                    children: const [],
                  ),
                ),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/ShoppingMateLogo.png'),
              Text(
                'Welcome!',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SignOutButton(),
              const SizedBox(height: 30), // Keep the spacing
 // Add the LoyaltySection widget here

              IncidentCard(), // Use the custom IncidentCard widget here
              LoyaltySection(), // Add the LoyaltySection widget here
              const SizedBox(height: 20), // Add spacing between sections

              SeePromotionCard(), // Add the Promotion card widget here
              const SizedBox(height: 20), // Add spacing for the wallet section
              SeeMyWalletCard(), // Add the My Wallet card widget here

              

              RentalApplicationCard(), // Custom widget

              // Dashboard Section
              DashboardCard(), // Add the Promotion card widget here


            ],
          ),
        ),
      ),
    );
  }
}

class SeePromotionCard extends StatelessWidget {
  const SeePromotionCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(10.0),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            leading: const Icon(Icons.local_offer, color: Colors.purple),
            title: const Text(
              'See Promotions',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Check out the latest promotions and offers'),
            trailing: Icon(Icons.arrow_forward,
                color: Theme.of(context).primaryColor),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PromotionListCustomerPage(),
                ),
              );
            }));
  }
}

// Define the updated SeeMyWalletCard widget with My Points and My Expenses
class SeeMyWalletCard extends StatelessWidget {
  const SeeMyWalletCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute space evenly
          children: [
            // My Points Section
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyPoints(), // Navigate to MyPoints page
                    ),
                  );
                },
                child: Column(
                  children: [
                    const Icon(Icons.account_balance_wallet, color: Colors.purple, size: 40),
                    const SizedBox(height: 10),
                    const Text(
                      'My Points',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text('View your points and rewards', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),

            // Divider between sections
            Container(
              width: 1,
              height: 60,
              color: Colors.grey[300],
            ),

            // My Expenses Section
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>const MyExpenses(), // Navigate to MyExpenses page
                    ),
                  );
                },
                child: Column(
                  children: [
                    const Icon(Icons.money, color: Colors.purple, size: 40),
                    const SizedBox(height: 10),
                    const Text(
                      'My Expenses',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text('View your spending history', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
