import 'package:flutter/material.dart';

class MaintenanceRequestPortal extends StatefulWidget {
  @override
  _MaintenanceRequestPortalState createState() => _MaintenanceRequestPortalState();
}

class _MaintenanceRequestPortalState extends State<MaintenanceRequestPortal> {
  final TextEditingController _requestController = TextEditingController();
  String _status = '';

  void _submitRequest() {
    // Handle the request submission logic here
    setState(() {
      _status = 'Request submitted: ${_requestController.text}';
      _requestController.clear(); // Clear the input field after submission
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance Request Portal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _requestController,
              decoration: InputDecoration(
                labelText: 'Describe your maintenance request',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitRequest,
              child: Text('Submit Request'),
            ),
            SizedBox(height: 20),
            Text(
              _status,
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
