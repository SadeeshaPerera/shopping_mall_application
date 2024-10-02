import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_mall_application/page/loyaltymemberdetails.dart';

class MyPoints extends StatefulWidget {
  const MyPoints({super.key});

  @override
  _MyPointsState createState() => _MyPointsState();
}

class _MyPointsState extends State<MyPoints> {
  final TextEditingController _mobileController = TextEditingController();
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _redeemHistory = []; // List for redeem history
  double _totalPoints = 0.0;
  double _totalRedeemedPoints = 0.0; // Variable to store total redeemed points
  bool _hasTransactions = false; // New flag to track transactions
  bool _hasChecked = false; // New flag to track if the user has checked

  Future<void> _checkIfRegistered() async {
    String mobileNumber = _mobileController.text.trim();

    if (mobileNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your mobile number')),
      );
      return;
    }

    // Set hasChecked to true when user attempts to check
    setState(() {
      _hasChecked = true; // User has checked
    });

    try {
      // Check if the mobile number is registered
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('loyaltyMembers') // Change to your collection name
          .where('phone', isEqualTo: mobileNumber) // Ensure this matches the field name
          .get();

      if (snapshot.docs.isNotEmpty) {
        // If registered, proceed to check points
        _checkPoints();
        _fetchRedeemHistory(); // Fetch redeem history
      } else {
        // Show dialog if not registered
        _showNotRegisteredDialog();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking registration: $e')),
      );
    }
  }

  Future<void> _checkPoints() async {
    String mobileNumber = _mobileController.text.trim();

    // Reset previous transactions, total points, and the hasTransactions flag
    setState(() {
      _transactions.clear();
      _totalPoints = 0.0;
      _hasTransactions = false; // Reset the flag
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

        _hasTransactions = true; // Set the flag to true if transactions are found

        // Trigger a rebuild to show the updated transactions
        setState(() {});
      } else {
        // No records found, keep the flag as false
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  Future<void> _fetchRedeemHistory() async {
  String mobileNumber = _mobileController.text.trim();

  // Reset previous redeem history
  setState(() {
    _redeemHistory.clear(); // Clear previous redeem history
    _totalRedeemedPoints = 0.0; // Reset total redeemed points
  });

  try {
    // Fetch redeem history from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('redeemed_points') // Use the redeemed_points collection
        .where('phone_number', isEqualTo: mobileNumber) // Ensure this matches the field name
        .get();

    for (var doc in snapshot.docs) {
      String shopName = doc['shop_name'];

      // Ensure points_redeemed is casted to double, even if it's stored as an int
      double pointsRedeemed = (doc['points_redeemed'] is int)
          ? (doc['points_redeemed'] as int).toDouble()
          : doc['points_redeemed'] as double;

      // Add redeem history to the list
      _redeemHistory.add({
        'shop_name': shopName,
        'points': pointsRedeemed, // Store points_redeemed
      });

      // Sum total redeemed points
      _totalRedeemedPoints += pointsRedeemed;
    }

    // Deduct total redeemed points from total points
    _totalPoints -= _totalRedeemedPoints;

    // Trigger a rebuild to show the updated redeem history and total points
    setState(() {});
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching redeem history: $e')),
    );
  }
}


  void _showNotRegisteredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Not Registered'),
          content: const Text('This mobile number is not registered.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Join Now'),
              onPressed: () {
                // Navigate directly to the LoyaltyMemberDetails page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoyaltyMemberForm()),
                );
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
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
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
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

              // Display transaction history or message if no transactions found
              Expanded(
                child: _hasChecked // Only show message after checking
                    ? (_hasTransactions
                        ? ListView.builder(
                            itemCount: _transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = _transactions[index];
                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(transaction['shop_name']),
                                  subtitle: Text(
                                    'Points: ${transaction['points'].toStringAsFixed(0)}',
                                     style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(child: Text('No transactions found.')))
                    : const SizedBox(), // Empty space if not checked
              ),

              const SizedBox(height: 20),

              // Section for Redeem History
              const Text(
                'Redeem History:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Display redeem history or message if no history found
              Expanded(
                child: _hasChecked // Only show message after checking
                    ? (_redeemHistory.isNotEmpty
                        ? ListView.builder(
                            itemCount: _redeemHistory.length,
                            itemBuilder: (context, index) {
                              final redeem = _redeemHistory[index];
                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(redeem['shop_name']),
                                  subtitle: Text(
                                    'Points: ${redeem['points'].toStringAsFixed(0)}', // Show points redeemed only
                                     style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(child: Text('No redeem history found.')))
                    : const SizedBox(), // Empty space if not checked
              ),
            ],
          ),
        ),
      ),
    );
  }
}
