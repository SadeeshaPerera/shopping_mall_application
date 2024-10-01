import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_mall_application/utils.dart';
import '../services/MaintenanceFirebaseCrud.dart'; // Assuming you have a service for Firestore CRUD operations

class MaintenanceRequestListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MaintenanceRequestListPage();
  }
}

class _MaintenanceRequestListPage extends State<MaintenanceRequestListPage> {

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final isAdmin = AppUtils.isAdminUser(FirebaseAuth.instance.currentUser?.email ?? '');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("List of Maintenance Requests"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder(
        stream: isAdmin
          ? FirebaseFirestore.instance.collection('maintenanceRequests').snapshots()
          : FirebaseFirestore.instance
            .collection('maintenanceRequests')
            .where('userId', isEqualTo: userId) // Adjust this line if you want to filter by user ID
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView(
                children: snapshot.data!.docs.map((e) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Request:", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(e['request'], style: const TextStyle(fontSize: 18)),
                          Text("Status: ${e['status']}"),
                          const SizedBox(height: 10),
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(5.0),
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                child: const Text('View Details'),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Request Details'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Shop ID: ${e['shopId']}"),
                                            Text("Shop Type: ${e['shopType']}"),
                                            Text("User Name: ${e['userName']}"),
                                            Text("Request: ${e['request']}"),
                                            Text("Status: ${e['status']}"),
                                            Text("Created At: ${DateTime.fromMillisecondsSinceEpoch(e['createdAt'].millisecondsSinceEpoch)}"),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              if (isAdmin) TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(5.0),
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                onPressed: e['status'] == 'Completed' ? null : () async {
                                  try {
                                    await FirebaseFirestore.instance.collection('maintenanceRequests').doc(e.id).update({'status': 'Completed'});
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: const Text('Mark as Completed'),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(5.0),
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                child: const Text('Delete'),
                                onPressed: () async {
                                  var response =
                                  await MaintenanceFirebaseCrud.deleteMaintenanceRequest(docId: e.id);
                                  if (response.code != 200) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(response.message.toString()),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
