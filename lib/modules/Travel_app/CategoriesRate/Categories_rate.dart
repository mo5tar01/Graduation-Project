import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Main/Home_Screen.dart';

class CategorySlidersPage extends StatefulWidget {
  const CategorySlidersPage({Key? key}) : super(key: key);


  @override
  _CategorySlidersPageState createState() => _CategorySlidersPageState();

}

class _CategorySlidersPageState extends State<CategorySlidersPage> {

  // Define the variables to hold the slider values
  double natureParksValue = 0.0;
  double sightsLandmarksValue = 0.0;
  double museumsValue = 0.0;
  double waterAmusementParksValue = 0.0;
  double shoppingValue = 0.0;
  double zoosAquariumsValue = 0.0;
  double travelerResourcesValue = 0.0;
  double toursValue = 0.0;
  double concertsShowsValue = 0.0;
  double nightlifeValue = 0.0;
  double funGamesValue = 0.0;
  double foodDrinkValue = 0.0;
  double transportationValue = 0.0;
  double otherValue = 0.0;
  double spasWellnessValue = 0.0;
  double outdoorActivitiesValue = 0.0;
  double eventsValue = 0.0;
  double classesWorkshopsValue = 0.0;
  double casinosGamblingValue = 0.0;

  // Define a variable to hold the user's ID
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Great job! \n Now let's add ratings to get your preferences !",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Highlighted category name color
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Nature & Parks', natureParksValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Sights & Landmarks', sightsLandmarksValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Museums', museumsValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Water & Amusement Parks', waterAmusementParksValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Shopping', shoppingValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Zoos & Aquariums', zoosAquariumsValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Traveler Resources', travelerResourcesValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Tours', toursValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Concerts & Shows', concertsShowsValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Nightlife', nightlifeValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Fun & Games', funGamesValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Food & Drink', foodDrinkValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Transportation', transportationValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Other', otherValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Spas & Wellness', spasWellnessValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Outdoor Activities', outdoorActivitiesValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Events', eventsValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Classes & Workshops', classesWorkshopsValue),
              Divider(
                color: Colors.blue,
              ),
              _buildSlider('Casinos & Gambling', casinosGamblingValue),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  // Call the function to save the user's preferences to Cloud Firestore
                  _savePreferences();
                  // Navigate to the HomeScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen(),
                    ),
                  );
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Define a function to build each slider
  Widget _buildSlider(String name, double value) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Highlighted category name color
          ),
        ),
        Slider(
          value: value,
          onChanged: (double newValue) {
            setState(() {
              switch (name) {
                case 'Nature & Parks':
                  natureParksValue = newValue;
                  break;
                case 'Sights & Landmarks':
                  sightsLandmarksValue = newValue;
                  break;
                case 'Museums':
                  museumsValue = newValue;
                  break;
                case 'Water & Amusement Parks':
                  waterAmusementParksValue = newValue;
                  break;
                case 'Shopping':
                  shoppingValue = newValue;
                  break;
                case 'Zoos & Aquariums':
                  zoosAquariumsValue = newValue;
                  break;
                case 'Traveler Resources':
                  travelerResourcesValue = newValue;
                  break;
                case 'Tours':
                  toursValue = newValue;
                  break;
                case 'Concerts & Shows':
                  concertsShowsValue = newValue;
                  break;
                case 'Nightlife':
                  nightlifeValue = newValue;
                  break;
                case 'Fun & Games':
                  funGamesValue = newValue;
                  break;
                case 'Food & Drink':
                  foodDrinkValue = newValue;
                  break;
                case 'Transportation':
                  transportationValue = newValue;
                  break;
                case 'Other':
                  otherValue = newValue;
                  break;
                case 'Spas & Wellness':
                  spasWellnessValue = newValue;
                  break;
                case 'Outdoor Activities':
                  outdoorActivitiesValue = newValue;
                  break;
                case 'Events':
                  eventsValue = newValue;
                  break;
                case 'Classes & Workshops':
                  classesWorkshopsValue = newValue;
                  break;
                case 'Casinos & Gambling':
                  casinosGamblingValue = newValue;
                  break;
              }
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

  // Define a function to save the user's preferences to Cloud Firestore
  void _savePreferences() async {
    try {
      // Create a map of the user's preferences
      Map<String, double> preferences = {
        'Nature & Parks': natureParksValue,
        'Sights & Landmarks': sightsLandmarksValue,
        'Museums': museumsValue,
        'Water & Amusement Parks': waterAmusementParksValue,
        'Shopping': shoppingValue,
        'Zoos & Aquariums': zoosAquariumsValue,
        'Traveler Resources': travelerResourcesValue,
        'Tours': toursValue,
        'Concerts & Shows': concertsShowsValue,
        'Nightlife': nightlifeValue,
        'Fun & Games': funGamesValue,
        'Food & Drink': foodDrinkValue,
        'Transportation': transportationValue,
        'Other': otherValue,
        'Spas & Wellness': spasWellnessValue,
        'Outdoor Activities': outdoorActivitiesValue,
        'Events': eventsValue,
        'Classes & Workshops': classesWorkshopsValue,
        'Casinos & Gambling': casinosGamblingValue,
      };

      // Save the user's preferences to Cloud Firestore
      await FirebaseFirestore.instance.collection("Categories_rate")
          .doc(userId)
          .set(preferences);

      // Navigate to the HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(),
        ),
      );
    } catch (e) {
      print('Error saving preferences: $e');
      // Show an error message to the user
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again glater.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}