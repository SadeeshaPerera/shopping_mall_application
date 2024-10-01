import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_mall_application/utils.dart';

class CheckRentalApplications extends StatelessWidget {
  const CheckRentalApplications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final isAdmin = AppUtils.isAdminUser(FirebaseAuth.instance.currentUser?.email ?? '');
    print("User ID: $userId");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Applications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: isAdmin
          ? FirebaseFirestore.instance.collection('rentalApplications').snapshots()
          : FirebaseFirestore.instance
            .collection('rentalApplications')
            .where('userId', isEqualTo: userId) // Adjust this line if you want to filter by user ID
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No rental applications found."));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['shopType'] ?? 'Unnamed Shop',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text("Category: ${data['category'] ?? 'N/A'}"),
                      Text("Drive Link: ${data['driveLink'] ?? 'N/A'}"),
                      Text("Status: ${data['status'] ?? 'Pending'}"),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: data['status'] == "Pending"
                                ? () {
                              FirebaseFirestore.instance
                                  .collection('rentalApplications')
                                  .doc(doc.id)
                                  .update({'status': 'Approved'});
                            }
                                : null, // Disable button if already approved or rejected
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                                    if (states.contains(WidgetState.disabled)) {
                                      return Colors.grey;
                                    }
                                    return Colors.green;
                                  }),
                                ),
                            child: const Text("Approve", style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: data['status'] == "Pending"
                                ? () {
                              FirebaseFirestore.instance
                                  .collection('rentalApplications')
                                  .doc(doc.id)
                                  .update({'status': 'Rejected'});
                            }
                                : null, // Disable button if already approved or rejected
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                                    if (states.contains(WidgetState.disabled)) {
                                      return Colors.grey;
                                    }
                                    return Colors.red;
                                  }),
                                ),
                            child: const Text("Reject", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
