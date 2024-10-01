import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'auth_gate.dart'; // Make sure to import your authentication gate or main screen
import 'home.dart'; // Import your app's main home widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with options for the current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rental Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthGate(), // Change to your app's initial screen
    );
  }
}

// You can remove MyHomePage if it's not being used elsewhere
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Shopping Mate')),
      ),
      body: const Center(
        child: Text('Hello, World!'),
      ),
    );
  }
}
