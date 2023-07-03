import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_recommendation/layout/TravelApp/cubit/cubit.dart';
import 'package:travel_recommendation/modules/Travel_app/AboutScreen/AboutScreen.dart';
import 'package:travel_recommendation/modules/Travel_app/Main/Home_Screen.dart';
import 'package:travel_recommendation/modules/Travel_app/login/travel_login_screen.dart';
import '../../../shared/components/components.dart';
import '../CategoriesRateUpdate/Categories_rate_update.dart';
import '../Details/Details_Screen.dart';
import '../recommendations/recommendations_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late User user;
  late DocumentSnapshot userData;

  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((document) {
      if (document.exists) {
        setState(() {
          userData = document;
        });
      }
    }).onError((error, stackTrace) {
      print('Error retrieving document: $error');
      print('Stack trace: $stackTrace');
    });
  }

  Widget _header() {
    return Text(
      'Start Exploring Now!',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Future<void> updateUserImageUrls(List<String> imageUrls) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'imageUrls': imageUrls});
  }

  Widget _userPersonalInfo(String userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, $userName!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          'Settings Screen',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  void _navigateToEditPreferences() {
    navigateTo(context, UpdatePreferencesPage(userId: '',));
    // TODO: Implement navigation to Edit Preferences page
  }

  void _navigateToThemeSettings() {
    ShopCubit.get(context).changeAppMode();
  }

  void _navigateToAboutPage() {
navigateTo(context, AboutScreen());
  }

  void _signOut() {
    navigateAndFinish(context, TravelLoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    if (!userData.exists) {
      // Return a loading indicator until the data is loaded
      return Center(child: CircularProgressIndicator());
    }
    String userName = userData['name'];
    String profilePictureUrl = userData['profilePictureUrl'];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomPaint(
              painter: AppBarPainter(),
              size: const Size(100, 100),
              child: _appBarContent(userName, profilePictureUrl),
            ),
            const SizedBox(height: 20),
            _buildNavigationItem(
              'Edit Preferences',
              Icons.settings,
              _navigateToEditPreferences,
            ),
            const SizedBox(height: 10),
            _buildNavigationItem(
              'Theme',
              Icons.brightness_4_outlined,
              _navigateToThemeSettings,
            ),
            const SizedBox(height: 10),
            _buildNavigationItem(
              'About',
              Icons.info,
              _navigateToAboutPage,
            ),
            const SizedBox(height: 10),
            _buildSignOutButton(),
          ],
        ),
      ),
    );
  }

  Widget _appBarContent(String userName, String profilePictureUrl) {
    return Container(
      height: 180,
      width: 400,
      margin: const EdgeInsets.symmetric(
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _header(),
          const SizedBox(
            height: 20.0,
          ),
          Container(
            child: Column(
              children: [
                _userInfo(userName, profilePictureUrl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _userInfo(String userName, String profilePictureUrl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _userPersonalInfo(userName),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 20, 20, 0),
          child: profilePictureUrl != null
              ? _userAvatar(profilePictureUrl)
              : const CircleAvatar(radius: 45),
        ),
      ],
    );
  }

  Widget _userAvatar(String profilePictureUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.blueGrey, spreadRadius: 3),
        ],
      ),
      child: CircleAvatar(
        radius: 45,
        backgroundImage: NetworkImage(profilePictureUrl),
      ),
    );
  }

  Widget _buildNavigationItem(
      String title, IconData icon, VoidCallback onPressed) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onPressed,
    );
  }

  Widget _buildSignOutButton() {
    return ElevatedButton(
      onPressed: _signOut,
      child: Text('Sign Out'),
    );
  }
}
