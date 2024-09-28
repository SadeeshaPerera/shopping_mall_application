import 'package:flutter/material.dart';
import 'package:shopping_mall_application/page/additem.dart';
import 'package:shopping_mall_application/page/addpromotion.dart';
import 'package:shopping_mall_application/page/check_rental_applications.dart'; // Import the new page

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
            Text(
              'Welcome to the Admin Page!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20), // Add some spacing between the text and the buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddItem()),
                );
              },
              child: const Text('Add an Inventory Item'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPromotion()),
                );
              },
              child: const Text('Create a Promotion'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckRentalApplications()), // Navigate to the rental applications page
                );
              },
              child: const Text('Check Rental Applications'),
            ),
          ],
        ),
      ),
    );
  }
}
