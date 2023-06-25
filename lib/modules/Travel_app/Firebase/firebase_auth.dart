import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:travel_recommendation/Recommendation.dart';
import 'package:travel_recommendation/models/shop_app/login_model.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('users');

  // Sign up the user with their email and password
  Future<User?> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
    String phoneNumber,
    File? profilePicture,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the user's uid
      String uid = userCredential.user!.uid;

      // Upload profile picture to Firebase Storage
      String? profilePictureUrl;
      if (profilePicture != null) {
        firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('users/$uid/profilePicture');
        firebase_storage.UploadTask uploadTask =
            storageRef.putFile(profilePicture);
        await uploadTask.whenComplete(() => null);
        profilePictureUrl = await storageRef.getDownloadURL();
      }

      // Save the user's data to the Realtime Database
      await _databaseReference.child(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'profilePictureUrl': profilePictureUrl,
      });

      // Return the user object
      return userCredential.user;
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }


  static Future<List<Recommendation>> getDocs() async {
    List<Recommendation> myRecom = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Recommendations").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {

      var a = querySnapshot.docs[i];
      Recommendation tmp = new Recommendation(
          a.get('city'),
          a.get('country'),
          a.get('ImageURL'),
          a.get('name'),
          a.get('rating'),
          a.get('description'));
      myRecom.add(tmp);
    }
    return myRecom;
  }

  // Retrieve image URLs from CSV
  Future<List<String>> getImageUrlsFromCSV() async {
    try {
      // Load CSV file from assets
      String csvString =
          await rootBundle.loadString('assets/most_rated_attractions.csv');

      // Parse the CSV string
      List<List<dynamic>> csvTable = CsvToListConverter().convert(csvString);

      // Extract image URLs from the CSV
      List<String> imageUrls = [];
      for (var row in csvTable) {
        // Assuming the image URL column is at index 0
        imageUrls.add(row[0]);
      }

      return imageUrls;
    } catch (e) {
      print('Error reading CSV file: $e');
      rethrow;
    }
  }

  // Upload image URLs to Firebase Storage
  Future<String> uploadImageUrlsToStorage(
      String uid, List<String> imageUrls) async {
    try {
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('users/$uid/csvFile');
      String csvFilePath = 'user_${uid}_image_urls.csv';

      // Create CSV content with image URLs
      List<List<dynamic>> csvList = imageUrls.map((url) => [url]).toList();
      String csvString = const ListToCsvConverter().convert(csvList);

      // Create temporary CSV file
      File tempCsvFile = await File(csvFilePath).writeAsString(csvString);

      // Upload CSV file to Firebase Storage
      firebase_storage.UploadTask uploadTask = storageRef.putFile(tempCsvFile);
      await uploadTask.whenComplete(() => null);
      String downloadUrl = await storageRef.getDownloadURL();

      // Delete temporary CSV file
      await tempCsvFile.delete();

      return downloadUrl;
    } catch (e) {
      print('Error uploading CSV file: $e');
      rethrow;
    }
  }
  Future<List?> fetchBucketList() async {
    try {
      // Get the current user ID (you can replace this with your own logic to get the user ID)

        User? user = FirebaseAuth.instance.currentUser;
        String userId = user?.uid ?? ''; // Get the user ID or an empty string if the user is not authenticated


      // Create a reference to the user's document in Firestore
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Get the user's document snapshot
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await userRef.get() as DocumentSnapshot<Map<String, dynamic>>;

      // Get the bucketList array from the user's document
      List<dynamic>? bucketList =
          userSnapshot.data()?['bucketList']?.cast<dynamic>() ?? [];

      // Return the bucketList array
      return bucketList;
    } catch (error) {
      // Handle the error here (e.g., show an error message)
      print('Failed to fetch bucket list: $error');
      return [];
    }
  }


  // Log in the user with their email and password
  Future<User?> logIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Return the user object
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }

  // Update the user's feature ratings in the database
  Future<void> updateFeatureRating(
      String uid, String featureName, double rating) async {
    try {
      // Update the user's rating for the given feature in the database
      await _databaseReference
          .child(uid)
          .child('featureRatings')
          .update({featureName: rating});
    } catch (e) {
      print('Error updating feature rating: $e');
    }
  }
}
