import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_mall_application/page/home/incidentsection.dart';
import 'package:shopping_mall_application/page/home/loyalty_section.dart'; // Import the LoyaltySection widget

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
              const IncidentCard(), // Use the custom IncidentCard widget here
              const LoyaltySection(), // Add the LoyaltySection widget here
            ],
          ),

        ),
      ),
    );
  }
}
