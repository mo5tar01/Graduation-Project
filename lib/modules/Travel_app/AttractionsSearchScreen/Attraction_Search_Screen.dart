import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Attractions.dart';
import '../../../shared/components/components.dart';
import '../Details/Details_Screen.dart';
import '../DetailsAtt/DetailsAtt_Screen.dart';
import '../Firebase/firebase_auth.dart';

class AttractionsSearchScreen extends StatefulWidget {
  const AttractionsSearchScreen({Key? key}) : super(key: key);

  @override
  _AttractionsSearchScreenState createState() => _AttractionsSearchScreenState();
}

class _AttractionsSearchScreenState extends State<AttractionsSearchScreen> {
  late TextEditingController _searchController;
  late Stream<QuerySnapshot> _searchResultsStream = Stream<QuerySnapshot>.empty();
  List<Attractions> myattractions = [];
  List<String> categories = ['Tours', 'Museums', 'Shopping',
    'Food & Drink', 'Sights & Landmarks','Traveler Resources',
    'Nature & Parks', 'Events','Fun & Games',
    'Casinos & Gambling', 'Classes & Workshops','Concerts & Shows',
    'Nightlife','Other','Outdoor Activities',
    'Spas & Wellness','Transportation','Water & Amusement Parks',
    'Zoos & Aquariums'];
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  Future<void> getData() async {
    try {
      List<Attractions> tmp = await Auth.getDocs2();

      setState(() {
        myattractions.addAll(tmp);
      });

      // Print the retrieved recommendations for debugging
      myattractions.forEach((element) {
        print(element.Name);
      });
    } catch (error) {
      print('Error retrieving data: $error');
    }
  }

  void goto(
      String cityAddress,
      String CountryAddress,
      String Image,
      String Name,
      String subCategory,
      String subType,
      num? RATING,
      num? numReviews,
      num? rankingDenomirator,
      num? rankingPosition,
      num? rawRanking) {
    Attractions ayy = new Attractions(
        cityAddress,
        CountryAddress,
        Image,
        Name,
        RATING,
        numReviews,
        rankingDenomirator,
        rankingPosition,
        rawRanking,
        subCategory,
        subType);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => detailsAttractionsScreen(ayy)),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // void searchInFirestore(String query) {
  //   setState(() {
  //     _searchResultsStream = FirebaseFirestore.instance
  //         .collection('attractions')
  //         .where('Name', isGreaterThanOrEqualTo: query)
  //         .orderBy('Name')
  //         .get()
  //         .then<QuerySnapshot>((snapshot) {
  //       if (snapshot.docs.isEmpty) {
  //         return FirebaseFirestore.instance
  //             .collection('attractions')
  //             .where('cityAddress', isGreaterThanOrEqualTo: query)
  //             .orderBy('cityAddress')
  //             .get();
  //       } else {
  //         return Future.value(snapshot);
  //       }
  //     })
  //         .then<QuerySnapshot>((snapshot) {
  //       if (snapshot.docs.isEmpty) {
  //         return FirebaseFirestore.instance
  //             .collection('attractions')
  //             .where('subCategory', isEqualTo: selectedCategory)
  //             .get();
  //       } else {
  //         return Future.value(snapshot);
  //       }
  //     })
  //         .asStream();
  //   });
  // }
  void searchInFirestore(String query) {
    setState(() {
      _searchResultsStream = FirebaseFirestore.instance
          .collection('attractions')
          .where('Name', isEqualTo: query)
          .get()
          .then<QuerySnapshot>((snapshot) {
        if (snapshot.docs.isEmpty) {
          return FirebaseFirestore.instance
              .collection('attractions')
              .where('cityAddress', isEqualTo: query)
              .get();
        } else {
          return Future.value(snapshot);
        }
      })
          .then<QuerySnapshot>((snapshot) {
        if (snapshot.docs.isEmpty) {
          return FirebaseFirestore.instance
              .collection('attractions')
              .where('subCategory', isEqualTo: selectedCategory)
              .get();
        } else {
          return Future.value(snapshot);
        }
      })
          .asStream();
    });
  }


  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    searchInFirestore(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attractions Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    searchInFirestore(_searchController.text);
                    int count = await getDocumentCount();
                    print('Document count: $count');

                  },
                ),
              ),
              onChanged: (value) {
                _searchController.value = _searchController.value.copyWith(
                  text: value.capitalizeFirstLetter(),
                  selection: TextSelection.collapsed(offset: value.length),
                );
              },
            ),
            SizedBox(height: 16.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: () {
                        selectCategory(category);
                      },
                      child: Text(category),
                      style: ElevatedButton.styleFrom(
                        primary: selectedCategory == category ? Colors.blueGrey : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _searchResultsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasData && snapshot.data != null) {
                    List<QueryDocumentSnapshot> attractions =
                        snapshot.data!.docs;

                    if (attractions.isEmpty) {
                      return Center(
                        child: Text('No attractions found.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: attractions.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> attractionData =
                        attractions[index].data()
                        as Map<String, dynamic>;

                        return GestureDetector(
                          onTap: () {
                            goto(
                              attractionData['cityAddress'],
                              attractionData['CountryAddress'],
                              attractionData['Image'],
                              attractionData['Name'],
                              attractionData['subCategory'],
                              attractionData['subType'],
                              attractionData['RATING'],
                              attractionData['numReview'],
                              attractionData['rankingDenominator'],
                              attractionData['rankingPosition'],
                              attractionData['rawRanking'],
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
                                      child: Image.network(
                                          attractionData['Image']),
                                    ),
                                    SizedBox(
                                      width: 60.0,
                                    ),
                                    Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            attractionData['Name'],
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
                                            attractionData['CountryAddress'],
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
                      },
                    );
                  }

                  return Center(
                    child: Text('No data found.'),
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}
Future<int> getDocumentCount() async {
  QuerySnapshot snapshot =
  await FirebaseFirestore.instance.collection('attractions').get();
  return snapshot.size;
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}