import 'package:flutter/material.dart';
import 'maintenance_request_portal.dart'; // Import the new maintenance request portal screen

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Under Construction',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MaintenanceRequestPortal(), // Navigate to Maintenance Request Portal
                  ),
                );
              },
              child: Text('Maintenance Request Portal'),
            ),
          ],
        ),
      ),
    );
  }
}
