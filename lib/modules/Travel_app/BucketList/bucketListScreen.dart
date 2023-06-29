import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../shared/components/components.dart';
import '../BucketListDetails/DetailsBucketListScreen.dart';
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
              child: FutureBuilder<DocumentSnapshot>(
                future: _usersCollection.doc(_user.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  Map<String, dynamic>? userData = snapshot.data?.data() as Map<String, dynamic>?;
                  List<dynamic> bucketList = userData?['bucketList'] ?? [];

                  return Column(
                    children: bucketList.map((item) {
                      String imageUrl = item['imageURL'];
                      String name = item['name'];
                      String country = item['country'];

                      return GestureDetector(
                        onTap: () {
                          navigateTo(context, BucketListDetailsScreen(bucketItem: item));
                        },
                        child: Column(
                          children: [
                          SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    child: Image.network(imageUrl),
                                  ),
                                  SizedBox(
                                    width: 60.0,
                                  ),
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
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          country,
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
      margin: const EdgeInsets.symmetric(
        vertical: 40,
      ),
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
  Widget _userPersonalInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius:20, color: Colors.lightBlue, spreadRadius: 1)],
                ),
                child: const Text(
                  'BUCKETLIST',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset (-0.3,-0.3),
                        color: Colors.black,),
                      Shadow( // bottomRight
                          offset: Offset(0.3, -0.3),
                          color: Colors.black
                      ),
                      Shadow( // topRight
                          offset: Offset(0.3, 0.3),
                          color: Colors.black
                      ),
                      Shadow( // topLeft
                          offset: Offset(-0.3, 0.3),
                          color: Colors.black
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 10, ),
              // Row(
              //   children: const [
              //     Icon(
              //       Icons.location_on_outlined,
              //       color: Colors.white,
              //       size: 15,
              //     ),
              //     // SizedBox(width: 5, ),
              //     // Text(
              //     //   'Cairo, Egypt',
              //     //   style: TextStyle(
              //     //     fontSize: 10,
              //     //     letterSpacing: 2,
              //     //     color: Colors.white,
              //     //     shadows: [
              //     //       Shadow(
              //     //         offset: Offset (-0.1,-0.1),
              //     //         color: Colors.black,),
              //     //       Shadow( // bottomRight
              //     //           offset: Offset(0.1, -0.1),
              //     //           color: Colors.black
              //     //       ),
              //     //       Shadow( // topRight
              //     //           offset: Offset(0.1, 0.1),
              //     //           color: Colors.black
              //     //       ),
              //     //       Shadow( // topLeft
              //     //           offset: Offset(-0.1, 0.1),
              //     //           color: Colors.black
              //     //       ),
              //     //     ],
              //     //
              //     //
              //     //   ),
              //     // ),
              //   ],
              // )
            ],
          ),
        ),
        // Expanded(
        //   flex: 1,
        //   child: Container(
        //     height: 30,
        //     child: const Center(
        //       child: Text(
        //         'Follow',
        //         style: TextStyle(
        //             color: Color.fromARGB(255, 177, 22, 234),
        //             fontWeight: FontWeight.w500
        //         ),
        //       ),
        //     ),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //   ),
        // )
      ],
    );
  }
  Widget _userInfo(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
            flex:1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _userPersonalInfo(),
                  const SizedBox(height: 25,),

                ],
              ),
            )),

        // Padding(
        //   padding: const EdgeInsets.fromLTRB(8, 20, 20, 0),
        //   child: _userAvatar(),
        // ),
      ],
    );
  }

}
