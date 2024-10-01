import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shopping_mall_application/page/addincident.dart';

class IncidentCard extends StatelessWidget {
  const IncidentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align title to the start
            children: [
              const Center(
                child: Text(
                  'Your Safty is Our Priority', // Title for the card
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10), // Add some space below the title
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
                items: [
                  'assets/images/fireemergency.jpg',
                  'assets/images/theft.jpeg',
                  'assets/images/valdalism.jpeg',
                ].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.asset(i, fit: BoxFit.cover, width: 1000);
                    },
                  );
                }).toList(),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'If you see something, say something. Report any incidents you see to help keep our shopping mall safe.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddIncident()),
                    );
                  },
                  child: const Text('Report an Incident'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
