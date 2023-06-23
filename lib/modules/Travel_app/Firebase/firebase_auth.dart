import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';

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
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Get the user's uid
      String uid = userCredential.user!.uid;

      // Upload profile picture to Firebase Storage
      String? profilePictureUrl;
      if (profilePicture != null) {
        firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('users/$uid/profilePicture');
        firebase_storage.UploadTask uploadTask = storageRef.putFile(profilePicture);
        await uploadTask.whenComplete(() => null);
        profilePictureUrl = await storageRef.getDownloadURL();
      }

      // Retrieve image URLs from CSV and upload to Firebase Storage
      String? csvFileUrl;
      List<String> imageUrls = await getImageUrlsFromCSV();
      csvFileUrl = await uploadImageUrlsToStorage(uid, imageUrls);

      // Save the user's data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'profilePictureUrl': profilePictureUrl,
        'csvFileUrl': csvFileUrl,
      });

      // Return the user object
      return userCredential.user;
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }


  // Retrieve image URLs from CSV
  Future<List<String>> getImageUrlsFromCSV() async {
    try {
      // Load CSV file from assets
      String csvString = await rootBundle.loadString('assets/most_rated_attractions.csv');

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
  Future<String> uploadImageUrlsToStorage(String uid, List<String> imageUrls) async {
    try {
      firebase_storage.Reference storageRef =
      firebase_storage.FirebaseStorage.instance.ref().child('users/$uid/csvFile');
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