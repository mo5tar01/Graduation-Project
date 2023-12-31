import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_recommendation/Recommendation.dart';
import 'package:travel_recommendation/modules/Travel_app/AttractionsSearchScreen/Attraction_Search_Screen.dart';
import 'package:travel_recommendation/modules/Travel_app/ForYou/ForYou_Screen.dart';
import '../../../shared/components/components.dart';
import '../Details/Details_Screen.dart';
import '../Firebase/firebase_auth.dart';
import '../recommendations/recommendations_screen.dart';
import 'package:csv/csv.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User user;
  late DocumentSnapshot userData;
  List<Recommendation> myrecommedation = [];
  bool isLoading = true;
  // Future<void> getData() async {
  //   List<Recommendation> tmp = await Auth.getDocs();
  //
  //
  //   setState(() {
  //     myrecommedation.addAll(tmp);
  //   });
  // }

  Future<void> getData() async {
    try {
      List<Recommendation> tmp = await Auth.getDocs();

      setState(() {
        myrecommedation.addAll(tmp);
      });

      // Print the retrieved recommendations for debugging
      myrecommedation.forEach((element) {
        print(element.name);
      });
    } catch (error) {
      print('Error retrieving data: $error');
    }
  }
  // void Exportdata()async{
  //   final CollectionReference AllPlaces=FirebaseFirestore.instance.collection("attractions");
  //   final attData=await rootBundle.loadString("assets/filtered_attractions.csv");
  //   List<List<dynamic>> csvTable=CsvToListConverter().convert(attData);
  //   List<List<dynamic>> data=[];
  //   data=csvTable;
  //   for(var i=0; i< data.length;i++){
  //     var record = {
  //       "cityAddress": data[i][0],
  //       "CountryAddress": data[i][1],
  //       "Image": data[i][2],
  //       "Name": data[i][3],
  //       "numReview": data[i][4],
  //       "rankingDenomirator": data[i][5],
  //       "rankingPosition": data[i][6],
  //       "RATING": data[i][7],
  //       "rawRanking": data[i][8],
  //       "subCategory": data[i][9],
  //       "subType": data[i][10],
  //     };
  //     AllPlaces.add(record);
  //   }
  // }
  void exportData() async {
    final CollectionReference allPlaces = FirebaseFirestore.instance.collection("attractions");
    final attData = await rootBundle.loadString("assets/filtered_attractions.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(attData);
    // List<List<dynamic>> data = csvTable;
    // for (var i = 0; i < data.length; i++) {
    //   var record = {
    //     "cityAddress": data[i][0],
    //     "CountryAddress": data[i][1],
    //     "Image": data[i][2],
    //     "Name": data[i][3],
    //     "numReview": data[i][4],
    //     "rankingDenominator": data[i][5],
    //     "rankingPosition": data[i][6],
    //     "RATING": data[i][7],
    //     "rawRanking": data[i][8],
    //     "subCategory": data[i][9],
    //     "subType": data[i][10],
    //   };
    //   await allPlaces.add(record);
    // }
  }



  @override
  void initState() {
    super.initState();
    getData();

    user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((document) {
      if (document.exists) {
        setState(() {
          userData = document;
          isLoading = false;

        });
      }
    }).onError((error, stackTrace) {
      print('Error retrieving document: $error');
      print('Stack trace: $stackTrace');
      setState(() {
        isLoading = false; // Mark loading as complete if an error occurs
      });
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
          'Welcome back!',
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
    if (isLoading) {
      // Show loading indicator if data is still loading
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
            Padding(
              padding: const EdgeInsets.only(
                left: 40.0,
                right: 40.0,
              ),
              child:ElevatedButton(
                onPressed: () {
                  navigateTo(context, AttractionsSearchScreen());
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 10),
                      Text('Search'),
                    ],
                  ),
                ),
              ),

            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    myrecommedation.length,
                        (index) => Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            navigateTo(
                              context,
                               detailsScreen(myrecommedation[index]),
                            );
                          },
                          child: Image.network(
                            myrecommedation[index].ImageURL,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  border: Border.all(
                    color: Colors.lightBlueAccent, // Set border color
                    width: 3.0,
                  ), // Set border width
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ), // Set rounded corner radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                  child: MaterialButton(
                    onPressed: () {
                      navigateTo(context, recommendationScreen());

                  },
                  child: Text("Recommendations"),
                ),
              ),
            ),
            // SizedBox(height: 20),
            // Padding(
            //   padding: const EdgeInsets.only(left: 50.0, right: 50.0),
            //   child: Container(
            //     margin: EdgeInsets.all(5),
            //     padding: EdgeInsets.all(4),
            //     alignment: Alignment.center,
            //     decoration: BoxDecoration(
            //       color: Colors.lightBlueAccent,
            //       border: Border.all(
            //         color: Colors.lightBlueAccent, // Set border color
            //         width: 3.0,
            //       ), // Set border width
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(30.0),
            //       ), // Set rounded corner radius
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black.withOpacity(0.2),
            //           blurRadius: 10.0,
            //           spreadRadius: 1.0,
            //         ),
            //       ],
            //     ),
            //     child: MaterialButton(
            //       onPressed: () {
            //         navigateTo(context, forYouScreen());
            //
            //       },
            //       child: Text("For You"),
            //     ),
            //   ),
            // ),
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
}
