import 'package:flutter/material.dart';

class FullImageView extends StatelessWidget {
  final String imageUrl;

  const FullImageView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 40.0, // Adjust this value based on the padding required
            right: 20.0, // Adjust this value based on the padding required
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context); // Close the image view and go back
              },
            ),
          ),
        ],
      ),
    );
  }
}

