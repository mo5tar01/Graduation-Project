import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference().child('users');

  // Sign up the user with their email and password
  Future<User?> signUp(String email, String password, String firstName, String lastName, String phoneNumber, File? profilePicture) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Get the user's uid
      String uid = userCredential.user!.uid;

      // Upload profile picture to Firebase Storage
      String? profilePictureUrl;
      if (profilePicture != null) {
        firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('users/$uid/profilePicture');
        firebase_storage.UploadTask uploadTask = storageRef.putFile(profilePicture);
        await uploadTask.whenComplete(() => null);
        profilePictureUrl = await storageRef.getDownloadURL();
      }

      // Save the user's data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
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
  Future<void> updateFeatureRating(String uid, String featureName, double rating) async {
    try {
      // Update the user's rating for the given feature in the database
      await _databaseReference.child(uid).child('featureRatings').update({featureName: rating});
    } catch (e) {
      print('Error updating feature rating: $e');
    }
  }
}