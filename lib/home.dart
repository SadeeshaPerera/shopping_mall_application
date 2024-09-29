import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_mall_application/page/additem.dart';
import 'package:shopping_mall_application/page/addcontract.dart';
import 'package:shopping_mall_application/page/addpromotion.dart';
import 'package:shopping_mall_application/page/admin/admin_main_screen.dart';
import 'package:shopping_mall_application/page/home/incidentsection.dart';
import 'package:shopping_mall_application/page/home/loyalty_section.dart'; // Import the LoyaltySection widget
import 'package:shopping_mall_application/page/promotionlistcustomer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              IncidentCard(), // Use the custom IncidentCard widget here
              LoyaltySection(), // Add the LoyaltySection widget here
              const SizedBox(height: 20), // Add spacing between sections
              SeePromotionCard(), // Add the Promotion card widget here
            ],
          ),
        ),
      ),
    );
  }
}

// Define the custom SeePromotionCard widget
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
        trailing: Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PromotionListCustomerPage(), // Navigate to the PromotionListPage
            ),
          );
        },
      ),
    );
  }
}
