import 'package:flutter/material.dart';
import 'package:shopping_mall_application/page/loyaltymemberdetails.dart';

class LoyaltySection extends StatelessWidget {
  const LoyaltySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: const Text(
                  'Join Our Loyalty Program',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Join our loyalty program now and earn rewards for every purchase!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoyaltyMemberForm(),
                    ),
                  );
                },
                child: const Text('Join Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
