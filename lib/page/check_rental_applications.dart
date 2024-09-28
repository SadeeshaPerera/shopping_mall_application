import 'package:flutter/material.dart';

// Sample data model for rental applications
class RentalApplication {
  final String shopName;
  final String category;
  final String driveLink;
  String status; // "Pending", "Approved", or "Rejected"

  RentalApplication({
    required this.shopName,
    required this.category,
    required this.driveLink,
    this.status = "Pending",
  });
}

// Mock list of rental applications
List<RentalApplication> applications = [
  RentalApplication(
    shopName: "Shop 1",
    category: "Clothing",
    driveLink: "https://drive.google.com/example1",
  ),
  RentalApplication(
    shopName: "Shop 2",
    category: "Food",
    driveLink: "https://drive.google.com/example2",
  ),
  // Add more sample applications as needed
];

class CheckRentalApplications extends StatelessWidget {
  const CheckRentalApplications({Key? key}) : super(key: key);

  void _approveApplication(int index) {
    // Update the application status
    applications[index].status = "Approved";
  }

  void _rejectApplication(int index) {
    // Update the application status
    applications[index].status = "Rejected";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Applications'),
      ),
      body: ListView.builder(
        itemCount: applications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    applications[index].shopName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text("Category: ${applications[index].category}"),
                  Text("Drive Link: ${applications[index].driveLink}"),
                  Text("Status: ${applications[index].status}"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: applications[index].status == "Pending"
                            ? () {
                          _approveApplication(index);
                          // Refresh the UI
                          (context as Element).markNeedsBuild();
                        }
                            : null, // Disable button if already approved or rejected
                        child: const Text("Approve"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: applications[index].status == "Pending"
                            ? () {
                          _rejectApplication(index);
                          // Refresh the UI
                          (context as Element).markNeedsBuild();
                        }
                            : null, // Disable button if already approved or rejected
                        child: const Text("Reject"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
