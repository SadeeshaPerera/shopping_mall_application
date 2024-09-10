import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/incident.dart';
import '/page/addincident.dart';
import '/page/editincident.dart';
import 'package:flutter/material.dart';

import '../services/incident_firebase_crud.dart';

class IncidentListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IncidentListPage();
  }
}

class _IncidentListPage extends State<IncidentListPage> {
  final Stream<QuerySnapshot> collectionReference = FirebaseCrud.readIncident();
  //FirebaseFirestore.instance.collection('Incident').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Reported Incidents",
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
                (route) =>
                    false, //if you want to disable back feature set to false
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView(
                children: snapshot.data!.docs.map((e) {
                  return Center(
                    child: Card(
                      child: Column(
                        children: [
                          Center(
                            child: ListTile(
                              title:
                                  Center(child: Text(e["name"] ?? 'No Name')),
                              subtitle: Container(
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          "Description: " +
                                              (e['description'] ??
                                                  'No Description'),
                                          style: const TextStyle(fontSize: 14)),
                                      Text("Date: " + (e['date'] ?? 'No Date'),
                                          style: const TextStyle(fontSize: 14)),
                                      Text(
                                          "Location: " +
                                              (e['location'] ?? 'No Location'),
                                          style: const TextStyle(fontSize: 14)),
                                      Text(
                                          "Contact Number: " +
                                              (e['contactNumber'] ??
                                                  'No Contact Number'),
                                          style: const TextStyle(fontSize: 12)),
                                      Text(
                                          "Status: " +
                                              (e['status'] ?? 'No Status'),
                                          style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(5.0),
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                child: const Text('Edit'),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil<dynamic>(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          EditIncident(
                                        incident: Incident(
                                          id: e.id,
                                          name: e["name"] ?? 'No Name',
                                          description: e["description"] ??
                                              'No Description',
                                          date: DateTime.parse(e["date"] ??
                                              DateTime.now().toIso8601String()),
                                          location:
                                              e["location"] ?? 'No Location',
                                          contactNumber: e["contactNumber"] ??
                                              'No Contact Number',
                                          status: e["status"] ?? 'No Status',
                                        ),
                                      ),
                                    ),
                                    (route) =>
                                        false, //if you want to disable back feature set to false
                                  );
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(5.0),
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                child: const Text('Delete'),
                                onPressed: () async {
                                  var incidentResponse =
                                      await FirebaseCrud.deleteIncident(
                                          docId: e.id);
                                  if (incidentResponse.code != 200) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(incidentResponse.message
                                              .toString()),
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

          return Container();
        },
      ),
    );
  }
}
