import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../services/inventory_firebase_crud.dart';
import '../models/storeitem.dart';
import '/page/additem.dart';
import '/page/edititem.dart';
import 'package:printing/printing.dart'; // For displaying/printing PDFs in web

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ListPage();
  }
}

class _ListPage extends State<ItemListPage> {
  final Stream<QuerySnapshot> collectionReference =
      FirebaseCrud.readStoreItem();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("INVENTORY DETAILS",style: TextStyle(color: Colors.white,)),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => const AddItem(),
                ),
                (route) => false,
              );
            },
          ),
          IconButton(
              icon: const Icon(
                Icons.picture_as_pdf,
                color: Colors.white,
              ),
              onPressed: () {
                generatePdfReport(
                    context); // Call the PDF generation function inside a function
              })
        ],
      ),
      body: StreamBuilder(
        stream: collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // 5 items per row
                  childAspectRatio:
                      0.5, // Adjusts the height/width ratio of the cards
                  mainAxisSpacing: 10, // Spacing between rows
                  crossAxisSpacing: 10, // Spacing between columns
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var e = snapshot.data!.docs[index];
                  DateTime createdAt = (e['createdAt'] as Timestamp).toDate();
                  DateTime updatedAt = (e['updatedAt'] as Timestamp).toDate();
                  Map<String, int> sizes = Map<String, int>.from(
                      e['quantities'] ??
                          {'S': 0, 'M': 0, 'L': 0, 'XL': 0, 'XXL': 0});

                  return Card(
  child: SingleChildScrollView( // Wrap with SingleChildScrollView to handle overflow
    child: Column(
      children: [
        ListTile(
          title: Text(e["itemname"],style: TextStyle(color: const Color.fromARGB(255, 9, 3, 135),fontSize:18,fontWeight: FontWeight.bold,)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              e['imageUrl'] != null
                  ? Image.network(
                      e['imageUrl'],
                      height: 300,
                      width: 200,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 100,
                      width: 100,
                      color: Colors.grey,
                      child: const Icon(Icons.image, size: 50),
                    ),
              const SizedBox(height: 10),
              Text("Category: " + e['category'], style: const TextStyle(fontSize: 16)),
              Text("Item Type: " + e['itemtype'], style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,)),
              Text("Price: Rs. ${e['price']}", style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,)),
              const Text("Quantities by Size: ", style: TextStyle(fontSize: 14)),
              Text(
                  "S: ${sizes['S']}, M: ${sizes['M']}, L: ${sizes['L']}, XL: ${sizes['XL']}, XXL: ${sizes['XXL']}",
                  style: const TextStyle(fontSize: 14)),
              Text("Description: " + e['description'], style: const TextStyle(fontSize: 14)),
              Text("Created At: $createdAt", style: const TextStyle(fontSize: 12)),
              Text("Updated At: $updatedAt", style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(5.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Edit',style: TextStyle(color: Color.fromARGB(255, 10, 157, 15),fontSize: 16,)),
              onPressed: () {
                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => EditItem(
                      storeitem: StoreItem(
                        uid: e.id,
                        itemname: e["itemname"],
                        category: e["category"],
                        itemtype: e["itemtype"],
                        quantities: sizes,
                        price: e["price"],
                        description: e["description"],
                        imageUrl: e["imageUrl"],
                        name: null,
                      ),
                    ),
                  ),
                  (route) => false,
                );
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(5.0),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Delete',style: TextStyle(color: Colors.red,)),
              onPressed: () {_showDeleteConfirmationDialog(context, e.id);},
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
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> generatePdfReport(BuildContext context) async {
    // Display a loading snackbar to inform the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generating PDF report...')),
    );

    // Create a PDF document
    final pdf = pw.Document();

    try {
      // Fetch data from Firestore and check if it's successfully fetched
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('StoreItem').get();

      if (snapshot.docs.isEmpty) {
        // Display a snackbar to inform there is no data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No items found in inventory!')),
        );
        return; // Stop if there's no data
      }

      // Print for debugging to ensure data fetching works
      print('Data fetched successfully: ${snapshot.docs.length} items found.');

      // Create the PDF content
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Inventory Report',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: [
                    'Item Name',
                    'Category',
                    'Item Type',
                    'Price (Rs.)'
                  ],
                  data: snapshot.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    // Return the row data for the PDF table
                    return [
                      data['itemname'] ?? 'Unknown',
                      data['category'] ?? 'Unknown',
                      data['itemtype'] ?? 'Unknown',
                      data['price']?.toString() ?? '0',
                    ];
                  }).toList(),
                ),
              ],
            );
          },
        ),
      );

      // Display a preview of the generated PDF or allow download/print
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      // Inform the user that the PDF was generated successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF report generated successfully!')),
      );
    } catch (e) {
      // Handle errors and inform the user if something goes wrong
      print('Error generating PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF report')),
      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                var promotionresponse =
                    await FirebaseCrud.deleteStoreItem(docId: docId);
                Navigator.of(context).pop(); // Close the dialog

                // Show success or error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(promotionresponse.message.toString()),
                  ),
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

}
