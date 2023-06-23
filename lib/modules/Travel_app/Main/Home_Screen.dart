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
  } );}

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
      // Return a loading indicator until the data is loaded
      return Center(child: CircularProgressIndicator());
    }
    String userName = userData['name'];
    String profilePictureUrl = userData['profilePictureUrl'];
    String imageUrl = csvData[2][1];

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
                      onTap: () {
                        navigateTo(
                          context,
                          detailsScreen(),
                        );
                      },
                      child: Image.network(imageUrl),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    child: InkWell(
                      onTap: () {
                        navigateTo(
                          context,
                          detailsScreen(),
                        );
                      },
                      child: Image.network(imageUrl),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //       width: 0.5,),
                    // borderRadius: BorderRadius.circular(10),),
                    child: InkWell(
                      onTap: () {
                        navigateTo(
                          context,
                          detailsScreen(),
                        );
                      },
                      child: Image.network(imageUrl),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //       width: 0.5,),
                    // borderRadius: BorderRadius.circular(10),),
                    child: InkWell(
                      onTap: () {
                        navigateTo(
                          context,
                          detailsScreen(),
                        );
                      },
                      child: Image.network(imageUrl),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //       width: 0.5,),
                    // borderRadius: BorderRadius.circular(10),),
                    child: InkWell(
                      onTap: () {
                        navigateTo(
                          context,
                          detailsScreen(),
                        );
                      },
                      child: Image.network(imageUrl),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //       width: 0.5,),
                    // borderRadius: BorderRadius.circular(10),),
                    child: InkWell(
                      onTap: () {
                        navigateTo(
                          context,
                          detailsScreen(),
                        );
                      },
                      child: Image.network(imageUrl),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //       width: 0.5,),
                    // borderRadius: BorderRadius.circular(10),),
                    child: InkWell(
                      onTap: () {
                        navigateTo(
                          context,
                          detailsScreen(),
                        );
                      },
                      child: Image.network(imageUrl),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //       width: 0.5,),
                    // borderRadius: BorderRadius.circular(10),),
                    child: InkWell(
                      onTap: () {
                        navigateTo(
                          context,
                          detailsScreen(),
                        );
                      },
                      child: Image.network(imageUrl),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //       width: 0.5,),
                    // borderRadius: BorderRadius.circular(10),),
                    child: InkWell(
                      onTap: () {
                        navigateTo(
                          context,
                          detailsScreen(),
                        );
                      },
                      child: Image.network(imageUrl),
                    ),
                  ),
                ]),
              ),
            ),


            SizedBox(
              height: 30,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 50.0,right: 50.0,),
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  border: Border.all(
                      color: Colors.lightBlueAccent, // Set border color
                      width: 3.0), // Set border width
                  borderRadius: BorderRadius.all(
                      Radius.circular(30.0)), // Set rounded corner radius
                  // Make rounded corner of border
                ),
                child: MaterialButton(
                  onPressed: (){
                    navigateTo(context, recommendationScreen(),);
                  }, child:Text( "Recommendations"),


                ),
              ),
            ),

          ]),
      ));
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
            )),
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
          BoxShadow(blurRadius: 10, color: Colors.blueGrey, spreadRadius: 3)
        ],
      ),
      child: CircleAvatar(
        radius: 45,
        backgroundImage: NetworkImage(profilePictureUrl),
      ),
    );
  }
}
