import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPoints extends StatefulWidget {
  const MyPoints({super.key});

  @override
  _MyPointsState createState() => _MyPointsState();
}

class _MyPointsState extends State<MyPoints> {
  final TextEditingController _mobileController = TextEditingController();
  List<Map<String, dynamic>> _transactions = [];
  double _totalPoints = 0.0;

  Future<void> _checkIfRegistered() async {
    String mobileNumber = _mobileController.text.trim();

    if (mobileNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your mobile number')),
      );
      return;
    }

    try {
      // Check if the mobile number is registered
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('loyaltyMembers') // Change to your collection name
          .where('phone', isEqualTo: mobileNumber) // Ensure this matches the field name
          .get();

      if (snapshot.docs.isNotEmpty) {
        // If registered, proceed to check points
        _checkPoints();
      } else {
        // If not registered
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This mobile number is not registered.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking registration: $e')),
      );
    }
  }

  Future<void> _checkPoints() async {
  String mobileNumber = _mobileController.text.trim();

  // Reset previous transactions and total points
  setState(() {
    _transactions.clear();
    _totalPoints = 0.0; // Reset the total points
  });

  try {
    // Fetching all transactions from Firestore for the given mobile number
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('loyalty_points') // Ensure this matches your collection
        .where('phone_number', isEqualTo: mobileNumber) // Check field name
        .get();

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        String shopName = doc['shop_name'];
        
        // Ensure bill_amount is casted to double, even if it's stored as an int
        double billAmount = (doc['bill_amount'] is int) 
            ? (doc['bill_amount'] as int).toDouble() 
            : doc['bill_amount'] as double;
        
        double points = billAmount * 0.05; // Calculate 5% of the bill amount

        // Add transaction to the list
        _transactions.add({
          'shop_name': shopName,
          'points': points,
        });

        // Sum total points
        _totalPoints += points;
      }

      // Trigger a rebuild to show the updated transactions
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No records found for this mobile number')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching data: $e')),
    );
  }
}


  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Points'),
        backgroundColor: Colors.purple,
      ),
      body: Center( // Center all the items in the body
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: [
              // Input field for mobile number
              TextField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Enter Mobile Number',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              // Button to check points
              ElevatedButton(
                onPressed: _checkIfRegistered, // Call the new method
                child: const Text('Check Points'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              // Stylish Total Points Display
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 232, 230, 233),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Total Points:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center coins and points
                      children: [
                        const Icon(
                          Icons.monetization_on, // Coin-like icon
                          color: Color.fromARGB(255, 150, 136, 8), // Coin color
                          size: 32, // Icon size
                        ),
                        const SizedBox(width: 8), // Spacing between icon and points
                        Text(
                          '${_totalPoints.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 168, 3, 11),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section for Transaction History
              const Text(
                'Transaction History:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Display transaction history in Card format
              Expanded(
                child: ListView.builder(
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = _transactions[index];
                    return Card(
                      elevation: 4, // Shadow effect for the card
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          transaction['shop_name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          '+${transaction['points'].toStringAsFixed(0)} points',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
