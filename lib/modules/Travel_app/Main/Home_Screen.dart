import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/components/components.dart';
import '../Details/Details_Screen.dart';
import '../recommendations/recommendations_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User user;
  late DocumentSnapshot userData;
  late List<List<dynamic>> csvData;

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
    rootBundle.loadString('assets/most_rated_attractions.csv').then((csvString) {
      csvData = CsvToListConverter().convert(csvString);
      setState(() {});
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
          'Welcome back !',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    if (!userData.exists) {
      return Center(child: CircularProgressIndicator());
    }
    String userName = userData['name'];
    String profilePictureUrl = userData['profilePictureUrl'];
    String imageUrl1 = csvData[2][1];
    String imageUrl2 = csvData[3][1];
    String imageUrl3 = csvData[4][1];
    String imageUrl4 = csvData[5][1];
    String imageUrl5 = csvData[6][1];
    String imageUrl6 = csvData[7][1];
    String imageUrl7 = csvData[8][1];
    String imageUrl8 = csvData[9][1];

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
      Padding(
        padding: const EdgeInsets.only(
          left: 40.0,
          right: 40.0,
        ),
        child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            )),
      ),
      SizedBox(
        height: 30,
      ),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            Container(
              height: 150,
              width: 150,
              child: InkWell(
                onTap: () { navigateTo(context, detailsScreen()); },
                child: Image.network(imageUrl1),
              ),
            ),
            SizedBox(width: 10),
            Container(
              height: 150,
              width: 150,
              child: InkWell(
                onTap: () { navigateTo(context, detailsScreen()); },
                child: Image.network(imageUrl2),
              ),
            ),
            SizedBox(width: 10),
            Container(
              height: 150,
              width: 150,
              child: InkWell(
                onTap: () { navigateTo(context, detailsScreen()); },
                child: Image.network(imageUrl3),
              ),
            ),
            SizedBox(width: 10),
            Container(
              height: 150,
              width: 150,
              child: InkWell(
                onTap: () { navigateTo(context, detailsScreen()); },
                child: Image.network(imageUrl4),
              ),
            ),
            SizedBox(width: 10),
            Container(
              height: 150,
              width: 150,
              child: InkWell(
                onTap: () { navigateTo(context, detailsScreen()); },
                child: Image.network(imageUrl5),
              ),
            ),
            SizedBox(width: 10),
            Container(
              height: 150,
              width: 150,
              child: InkWell(
                onTap: () { navigateTo(context, detailsScreen()); },
                child: Image.network(imageUrl6),
              ),
            ),
            SizedBox(width: 10),
            Container(
              height: 150,
              width: 150,
              child: InkWell(
                onTap: () { navigateTo(context, detailsScreen()); },
                child: Image.network(imageUrl7),
              ),
            ),
            SizedBox(width: 10),
            Container(
              height: 150,
              width: 150,
              child: InkWell(
                onTap: () { navigateTo(context, detailsScreen()); },
                child: Image.network(imageUrl8),
              ),
            ),
          ]),
        ),
      ),
    ])));
  }
}

_appBarContent(String userName, String profilePictureUrl) {
  return Row(
    children: [
      Text('Welcome, $userName'),
      Image.network(profilePictureUrl),
    ],
  );
}