import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/MaintenanceFirebaseCrud.dart'; // Assuming you have a service for Firestore CRUD operations

class MaintenanceRequestListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MaintenanceRequestListPage();
  }
}

class _MaintenanceRequestListPage extends State<MaintenanceRequestListPage> {
  final Stream<QuerySnapshot> _maintenanceRequestsStream =
      MaintenanceFirebaseCrud.readMaintenanceRequests();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("List of Maintenance Requests"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder(
        stream: _maintenanceRequestsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView(
                children: snapshot.data!.docs.map((e) {
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("Request: ${e["request_description"]}"),
                          subtitle: Text("Status: ${e["status"]}"),
                        ),
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
                                // Navigate to a details page if needed
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(5.0),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              child: const Text('Delete'),
                              onPressed: () async {
                                var response = await MaintenanceFirebaseCrud
                                    .deleteMaintenanceRequest(docId: e.id);
                                if (response.code != 200) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content:
                                            Text(response.message.toString()),
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
