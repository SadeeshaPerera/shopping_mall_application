import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shopping_mall_application/page/addincident.dart';

class IncidentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Description of the incident goes here. This is a sample description.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddIncident()),
                );
              },
              child: const Text('Report an Incident'),
            ),
          ],
        ),
      ),
    );
  }
}
