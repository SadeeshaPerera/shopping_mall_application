import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckRentalApplications extends StatelessWidget {
  const CheckRentalApplications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Applications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rental_applications')
            .where('userId',
                isEqualTo:
                    userId) // Adjust this line if you want to filter by user ID
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
                        data['shopName'] ?? 'Unnamed Shop',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                                        .collection('rental_applications')
                                        .doc(doc.id)
                                        .update({'status': 'Approved'});
                                  }
                                : null, // Disable button if already approved or rejected
                            child: const Text("Approve"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: data['status'] == "Pending"
                                ? () {
                                    FirebaseFirestore.instance
                                        .collection('rental_applications')
                                        .doc(doc.id)
                                        .update({'status': 'Rejected'});
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
            }).toList(),
          );
        },
      ),
    );
  }
}
