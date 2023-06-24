import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdatePreferencesPage extends StatefulWidget {
  final String userId;

  const UpdatePreferencesPage({Key? key, required this.userId}) : super(key: key);

  @override
  _UpdatePreferencesPageState createState() => _UpdatePreferencesPageState();
}

class _UpdatePreferencesPageState extends State<UpdatePreferencesPage> {
  late Map<String, double> currentPreferences;
  late String userId;

  // Initialize Firebase Auth and Cloud Firestore
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Get the current user's ID and assign it to the userId variable
    final currentUser = _auth.currentUser;
    userId = currentUser!.uid;

    // Initialize currentPreferences with an empty map
    currentPreferences = {};

    // Load the current preferences
    loadCurrentPreferences();
  }

  Future<void> loadCurrentPreferences() async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Categories_rate')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        setState(() {
          currentPreferences = Map<String, double>.from(snapshot.data() as Map<dynamic, dynamic>);
        });
      } else {
        // User preferences document doesn't exist, initialize with default values
        setState(() {
          currentPreferences = {
            'Nature & Parks': 0.0,
            'Sights & Landmarks': 0.0,
            'Museums': 0.0,
            'Water & Amusement Parks': 0.0,
            'Shopping': 0.0,
            'Zoos & Aquariums': 0.0,
            'Traveler Resources': 0.0,
            'Tours': 0.0,
            'Concerts & Shows': 0.0,
            'Nightlife': 0.0,
            'Fun & Games': 0.0,
            'Food & Drink': 0.0,
            'Transportation': 0.0,
            'Other': 0.0,
            'Spas & Wellness': 0.0,
            'Outdoor Activities': 0.0,
            'Events': 0.0,
            'Classes & Workshops': 0.0,
            'Casinos & Gambling': 0.0,
          };
        });
      }
    } catch (e) {
      print('Error loading preferences: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> savePreferences() async {
    try {
      await FirebaseFirestore.instance
          .collection('Categories_rate')
          .doc(userId)
          .update(currentPreferences);

      // Show a success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preferences saved successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error saving preferences: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentPreferences.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Update Preferences'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Preferences'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Update your preferences",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.blue),
              for (final entry in currentPreferences.entries)
                _buildSlider(entry.key, entry.value),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: savePreferences,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(String name, double value) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Slider(
          value: value,
          onChanged: (double newValue) {
            setState(() {
              currentPreferences[name] = newValue;
            });
          },
          min: 0,
          max: 5,
          divisions: 5,
          label: '$value',
        ),
      ],
    );
  }
}
