import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttractionsSearchScreen extends StatefulWidget {
  const AttractionsSearchScreen({Key? key}) : super(key: key);

  @override
  _AttractionsSearchScreenState createState() => _AttractionsSearchScreenState();
}

class _AttractionsSearchScreenState extends State<AttractionsSearchScreen> {
  late TextEditingController _searchController;
  late Stream<QuerySnapshot> _searchResultsStream = Stream<QuerySnapshot>.empty();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
          .asStream();
    });
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
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    searchInFirestore(_searchController.text);
                  },
                ),
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
                        attractions[index].data() as Map<String, dynamic>;
                        // Build your UI for each attraction item
                        // Example: Text(attractionData['Name'])
                        return ListTile(
                          title: Text(attractionData['Name']),
                          subtitle: Text(attractionData['cityAddress']),
                          // Customize the displayed fields according to your needs
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
