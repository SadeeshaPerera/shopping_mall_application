import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MyExpenses extends StatelessWidget {
  const MyExpenses({super.key});

  Future<void> _generatePDFReport(BuildContext context) async {
    final pdf = pw.Document();

    // Fetch data from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('loyalty_points').get();

    // Create the PDF content
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('My Expenses Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Shop Name', 'Bill Amount (Rs.)', 'Date'],
                data: snapshot.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return [
                    data['shop_name'] ?? 'Unknown',
                    data['bill_amount']?.toString() ?? '0',
                    data['date'] ?? 'Unknown date',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _generatePDFReport(context), // Generate PDF report when clicked
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('loyalty_points').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching expenses.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No expenses found.'));
          }

          final expenses = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'shop_name': data['shop_name'] ?? 'Unknown shop',
              'bill_amount': data['bill_amount'] ?? 0.0,
              'date': data['date'] ?? 'Unknown date',
            };
          }).toList();

          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];

              return Card(
                margin: const EdgeInsets.all(10.0),
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    'Shop: ${expense['shop_name']}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        'Bill Amount: Rs. ${expense['bill_amount'].toString()}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Date: ${expense['date']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
