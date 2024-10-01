import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '/models/incident.dart';
import '/page/addincident.dart';
import '/page/editincident.dart';
import '../services/incident_firebase_crud.dart';

class IncidentListPage extends StatefulWidget {
  const IncidentListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _IncidentListPage();
  }
}

class _IncidentListPage extends State<IncidentListPage> {
  final Stream<QuerySnapshot> collectionReference = FirebaseCrud.readIncident();

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
            icon: const Icon(Icons.app_registration, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => const AddIncident(),
                ),
                (route) => false, // Disable back feature
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
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
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
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        Text(
                                            "Date: " + (e['date'] ?? 'No Date'),
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        Text(
                                            "Location: " +
                                                (e['location'] ??
                                                    'No Location'),
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        Text(
                                            "Contact Number: " +
                                                (e['contactNumber'] ??
                                                    'No Contact Number'),
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        Text(
                                            "Status: " +
                                                (e['status'] ?? 'No Status'),
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            OverflowBar(
                              alignment: MainAxisAlignment.end,
                              children: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    textStyle: const TextStyle(fontSize: 16),
                                  ),
                                  child: const Text('Update'),
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
                                                DateTime.now()
                                                    .toIso8601String()),
                                            location:
                                                e["location"] ?? 'No Location',
                                            contactNumber: e["contactNumber"] ??
                                                'No Contact Number',
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
                                    foregroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    textStyle: const TextStyle(fontSize: 16),
                                    side: const BorderSide(
                                        color: Colors.red), // Border color
                                  ),
                                  child: const Text('Remove'),
                                  onPressed: () async {
                                    var incidentResponse =
                                        await FirebaseCrud.deleteIncident(
                                            docId: e.id);
                                    if (incidentResponse.code != 200) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(incidentResponse
                                                .message
                                                .toString()),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    textStyle: const TextStyle(fontSize: 16),
                                    side: const BorderSide(
                                        color: Colors.green), // Border color
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.download, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text('Report'),
                                    ],
                                  ),
                                  onPressed: () {
                                    _generateAndDownloadPDF(
                                      context,
                                      e["name"] ?? 'No Name',
                                      e["description"] ?? 'No Description',
                                      e["date"] ?? 'No Date',
                                      e["location"] ?? 'No Location',
                                      e["contactNumber"] ?? 'No Contact Number',
                                      e["status"] ?? 'No Status',
                                    );
                                  },
                                )
                              ],
                            )
                          ],
                        ),
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

  void _generateAndDownloadPDF(
      BuildContext context,
      String name,
      String description,
      String date,
      String location,
      String contactNumber,
      String status) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(name, style: const pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Text("Description: $description",
                    style: const pw.TextStyle(fontSize: 18)),
                pw.Text("Date: $date", style: const pw.TextStyle(fontSize: 18)),
                pw.Text("Location: $location",
                    style: const pw.TextStyle(fontSize: 18)),
                pw.Text("Contact Number: $contactNumber",
                    style: const pw.TextStyle(fontSize: 18)),
                pw.Text("Status: $status", style: const pw.TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();
    await Printing.sharePdf(bytes: pdfBytes, filename: '$name.pdf');
  }
}

void main() => runApp(const MaterialApp(home: IncidentListPage()));
