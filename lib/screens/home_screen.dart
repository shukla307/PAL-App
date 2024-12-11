import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'blog_screen.dart';
import 'medical_chart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userName = 'User'; // Default value

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() {
    final User? user = _auth.currentUser;
    if (user != null && user.displayName != null) {
      setState(() {
        userName = user.displayName!;
      });
    }
  }

  void _signOut() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Hello, $userName",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/medicalHistory'),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Medical History"),
              ),
            ),

            // precription
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CbcGraphScreen()),
                );


                // Add prescription functionality later
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Prescriptions coming soon!')),
                // );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Check Sugar Chart"),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BlogScreen()),
              );
              },
              child: const Text('Blog'),
            ),
          ],
        ),
      ),
    );
  }
}