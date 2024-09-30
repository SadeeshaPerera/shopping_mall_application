import 'package:flutter/material.dart';
import 'package:shopping_mall_application/page/dashboard.dart'; // Import your dashboard page

class DashboardCard extends StatelessWidget {
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
                'Dashboard', // Title for the card
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
                'Access your personal dashboard for an overview of your activities and applications.',
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
                            Dashboard()), // Navigate to the dashboard page
                  );
                },
                child: const Text('Open My Dashboard'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
