import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.download, color: Colors.blue),
                      onPressed: () async {
                        await _generateAndDownloadAllIncidentsPDF();
                      },
                    ),
                    Text('Download', style: TextStyle(color: Colors.blue)),
                  ],
                ),
                SizedBox(width: 16), // Add some space between the buttons
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.app_registration, color: Colors.blue),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => AddIncident(),
                          ),
                          (route) => false, // Disable back feature
                        );
                      },
                    ),
                    Text('Add Incident', style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
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
          ),
        ],
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
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  textStyle: const TextStyle(fontSize: 16),
                  side: const BorderSide(color: Colors.green), // Border color
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndDownloadPDF(
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
                pw.Text(name, style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Text("Description: $description",
                    style: pw.TextStyle(fontSize: 18)),
                pw.Text("Date: $date", style: pw.TextStyle(fontSize: 18)),
                pw.Text("Location: $location",
                    style: pw.TextStyle(fontSize: 18)),
                pw.Text("Contact Number: $contactNumber",
                    style: pw.TextStyle(fontSize: 18)),
                pw.Text("Status: $status", style: pw.TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();
    await Printing.sharePdf(bytes: pdfBytes, filename: '$name.pdf');
  }

  Future<void> _generateAndDownloadAllIncidentsPDF() async {
    final pdf = pw.Document();
    final incidents = await FirebaseCrud.readIncident().first;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: incidents.docs.map((e) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(e["name"] ?? 'No Name',
                        style: pw.TextStyle(fontSize: 24)),
                    pw.SizedBox(height: 10),
                    pw.Text(
                        "Description: ${e['description'] ?? 'No Description'}",
                        style: pw.TextStyle(fontSize: 18)),
                    pw.Text("Date: ${e['date'] ?? 'No Date'}",
                        style: pw.TextStyle(fontSize: 18)),
                    pw.Text("Location: ${e['location'] ?? 'No Location'}",
                        style: pw.TextStyle(fontSize: 18)),
                    pw.Text(
                        "Contact Number: ${e['contactNumber'] ?? 'No Contact Number'}",
                        style: pw.TextStyle(fontSize: 18)),
                    pw.Text("Status: ${e['status'] ?? 'No Status'}",
                        style: pw.TextStyle(fontSize: 18)),
                    pw.Divider(),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();
    await Printing.sharePdf(bytes: pdfBytes, filename: 'All_Incidents.pdf');
  }
}
