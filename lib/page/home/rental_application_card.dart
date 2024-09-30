import 'package:flutter/material.dart';
import 'package:shopping_mall_application/page/addrental_application.dart';

class RentalApplicationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Rental Application', // Title for the card
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10), // Add some space below the title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Apply for a rental space at our shopping mall. Fill out the application form and we will get back to you shortly.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RentalApplication()), // Navigate to the rental application page
                  );
                },
                child: const Text('Submit Application'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
