import 'package:flutter/material.dart';
import 'package:travel_recommendation/modules/Travel_app/RecommendationDetails/Recommendation_Details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../shared/components/components.dart';

class recommendationScreen extends StatefulWidget {
  const recommendationScreen({Key? key}) : super(key: key);

  @override
  State<recommendationScreen> createState() => _recommendationScreenState();
}

class _recommendationScreenState extends State<recommendationScreen> {
  List<dynamic>? recommendationList;

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userEmail = user.email!;
        const baseUrl = 'https://4974-35-201-252-166.ngrok-free.app/';
        const api = 'api/recommendations?user=';
        final url = baseUrl + api + userEmail;

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final responseBody = response.body;
          setState(() {
            recommendationList = jsonDecode(responseBody);
          });
        } else {
          // Request failed
          print('Request failed with status: ${response.statusCode}');
        }
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      // Error occurred during the request
      print('Error: $e');
    }
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
              child: recommendationList != null && recommendationList!.isNotEmpty
                  ? Column(
                children: recommendationList!.map((item) {
                  String imageUrl = item['Image'];
                  String name = item['Name'];
                  String country = item['countryAddress'];

                  return GestureDetector(
                    onTap: () {
                      navigateTo(
                        context,
                        RecommendationDetailsScreen(recommendationItem: item),
                      );
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
              )
                  : CircularProgressIndicator(),
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
                  boxShadow: [
                    BoxShadow(blurRadius: 20, color: Colors.lightBlue, spreadRadius: 1),
                  ],
                ),
                child: const Text(
                  'Recommendations',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    color: Colors.white,
                    shadows: [
                      Shadow(offset: Offset(-0.3, -0.3), color: Colors.black),
                      Shadow(offset: Offset(0.3, -0.3), color: Colors.black),
                      Shadow(offset: Offset(0.3, 0.3), color: Colors.black),
                      Shadow(offset: Offset(-0.3, 0.3), color: Colors.black),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AppBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    Paint paint = Paint();
    Path path = Path();
    paint.shader = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.lightBlueAccent,
        Colors.blue,
      ],
    ).createShader(rect);
    path.lineTo(0, size.height - size.height / 5);
    path.conicTo(size.width / 2.2, size.height / 2, size.width, size.height - size.height / 5, 1);
    path.lineTo(size.width, 0);
    canvas.drawShadow(path, Colors.blue, 4, false);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
