import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../shared/components/components.dart';
import '../recommendations/recommendations_screen.dart';

class BucketListScreen extends StatefulWidget {
  const BucketListScreen({Key? key}) : super(key: key);

  @override
  State<BucketListScreen> createState() => _BucketListScreenState();
}

class _BucketListScreenState extends State<BucketListScreen> {
  late User _user;
  late CollectionReference _usersCollection;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _usersCollection = FirebaseFirestore.instance.collection('users');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            CustomPaint(
              painter: AppBarPainter(),
              size: const Size(100, 100),
              child: _appBarContent(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _usersCollection
                    .doc(_user.uid)
                    .collection('bucket_list')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  List<QueryDocumentSnapshot> bucketListItems =
                      snapshot.data!.docs;

                  return Column(
                    children: bucketListItems.map((item) {
                      String imageUrl = item.get('ImageURL');
                      String name = item.get('name');
                      String location = item.get('country');

                      return GestureDetector(
                        onTap: () {
                          navigateTo(context, recommendationScreen());
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  child: Image.network(imageUrl),
                                ),
                                SizedBox(width: 60.0,),
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        location,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15.0,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.blue,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBarContent() {
    return Container(
      height: 180,
      width: 400,
      margin: const EdgeInsets.symmetric(vertical: 40,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Container(
              child: Column(
                children: [
                  _userInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _userPersonalInfo(),
                const SizedBox(height: 10),
                _bucketListCounter(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _userPersonalInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            image: const DecorationImage(
              image: NetworkImage(
                  'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _user.displayName ?? 'Guest',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _user.email!,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bucketListCounter() {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersCollection.doc(_user.uid).collection('bucket_list').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        int count = snapshot.data!.docs.length;

        return Column(
          children: [
            Text(
              'Bucket List',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '$count Items',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
