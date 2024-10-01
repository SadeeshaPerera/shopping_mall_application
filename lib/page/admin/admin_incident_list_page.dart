import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/incident.dart';
import '../../page/addincident.dart';
import '../../page/editincident.dart';
import '../../services/incident_firebase_crud.dart';

class AdminIncidentListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AdminIncidentListPage();
  }
}

class _AdminIncidentListPage extends State<AdminIncidentListPage> {
  final Stream<QuerySnapshot> collectionReference = FirebaseCrud.readIncident();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Admin - Reported Incidents",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.app_registration,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => AddIncident(),
                ),
                (route) => false, // Disable back feature
              );
            },
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Web layout
            return buildWebLayout();
          } else {
            // Mobile layout
            return buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget buildWebLayout() {
    return StreamBuilder(
      stream: collectionReference,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var e = snapshot.data!.docs[index];
                return buildIncidentCard(e);
              },
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildMobileLayout() {
    return StreamBuilder(
      stream: collectionReference,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var e = snapshot.data!.docs[index];
                return buildIncidentCard(e);
              },
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildIncidentCard(QueryDocumentSnapshot e) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Center(child: Text(e["name"] ?? 'No Name')),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Description: " + (e['description'] ?? 'No Description'),
                    style: const TextStyle(fontSize: 14)),
                Text("Date: " + (e['date'] ?? 'No Date'),
                    style: const TextStyle(fontSize: 14)),
                Text("Location: " + (e['location'] ?? 'No Location'),
                    style: const TextStyle(fontSize: 14)),
                Text(
                    "Contact Number: " +
                        (e['contactNumber'] ?? 'No Contact Number'),
                    style: const TextStyle(fontSize: 12)),
                Text("Status: " + (e['status'] ?? 'No Status'),
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: const Text('Update'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => EditIncident(
                        incident: Incident(
                          id: e.id,
                          name: e["name"] ?? 'No Name',
                          description: e["description"] ?? 'No Description',
                          date: DateTime.parse(
                              e["date"] ?? DateTime.now().toIso8601String()),
                          location: e["location"] ?? 'No Location',
                          contactNumber:
                              e["contactNumber"] ?? 'No Contact Number',
                          status: e["status"] ?? 'No Status',
                        ),
                      ),
                    ),
                    (route) => false, // Disable back feature
                  );
                },
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  textStyle: TextStyle(fontSize: 16),
                  side: BorderSide(color: Colors.red), // Border color
                ),
                child: const Text('Remove'),
                onPressed: () async {
                  var incidentResponse =
                      await FirebaseCrud.deleteIncident(docId: e.id);
                  if (incidentResponse.code != 200) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(incidentResponse.message.toString()),
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
  }
}
