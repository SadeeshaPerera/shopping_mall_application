import 'package:flutter/material.dart';
import 'package:shopping_mall_application/page/itemlistpage.dart';
import 'package:shopping_mall_application/page/addpromotion.dart';

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
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ItemListPage()));
              },
              child: const Text('Add a Inventory Item'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddPromotion()));
              },
              child: const Text('Create a Promotion'),
            ),
          ],
        ),
      ),
    );
  }
}
