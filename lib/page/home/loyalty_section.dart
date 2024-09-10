import 'package:flutter/material.dart';

class LoyaltySection extends StatelessWidget {
  const LoyaltySection({super.key});

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
            Text(
              'Loyalty Program',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Join our loyalty program and earn rewards for every purchase!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your loyalty program action here
              },
              child: const Text('Join Now'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your view rewards action here
              },
              child: const Text('View Rewards'),
            ),
          ],
        ),
      ),
    );
  }
}
