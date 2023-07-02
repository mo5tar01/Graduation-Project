import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_recommendation/Recommendation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class detailsScreen extends StatefulWidget {
  Recommendation myrecommendation;
  detailsScreen(this.myrecommendation);

  @override
  State<detailsScreen> createState() => _detailsScreenState();
}

class _detailsScreenState extends State<detailsScreen> with TickerProviderStateMixin{
  final double infoHeight = 364.0;
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1=0.0;
  double opacity2=0.0;
  double opacity3=0.0;
  var feedbackController= TextEditingController();
  late User user;
  late DocumentSnapshot userData;
  bool isIconFavorite = false;

  @override
  void initState(){
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

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000),vsync: this
    );
    animation=Tween<double>(begin:0.0,end:1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval(0,0.1,curve: Curves.fastOutSlowIn))
    );
    setData();
    super.initState();
  }
  Future<void> setData() async {
    animationController?.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }
  void toggleIcon() {
    setState(() {
      isIconFavorite = !isIconFavorite;
    });
  }

  Widget build(BuildContext context) {
    final double tempHeight= MediaQuery.of(context).size.height-
        (MediaQuery.of(context).size.width/1.2)+
        24.0;
    return Container(
      color: Color(0xFFFFFFFF),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children:<Widget> [
            Column(
              children: <Widget>[
                AspectRatio(aspectRatio: 1,
                  child: Image.network(
                    widget.myrecommendation.ImageURL,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width/1.2)-24.0,
              bottom: 0,
              left: 0,
              right:0,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: const BorderRadius.only(
                    topLeft:Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0xFF3A5160).withOpacity(0.2),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8,right: 8),
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: infoHeight,
                          maxHeight: tempHeight>infoHeight?tempHeight:infoHeight
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:<Widget> [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 18, right: 16
                            ),
                            child: Text(
                              widget.myrecommendation.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: Color(0xFF17262A),

                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 8, top: 16,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        widget.myrecommendation.city+", " + widget.myrecommendation.country,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 22,
                                          letterSpacing: 0.27,
                                          color: Color(0xFF132342),

                                        ),
                                      ),
                                      SizedBox(width: 3,),
                                      Icon(Icons.pin_drop,
                                        color: Color(0xFF132342),
                                        size: 24.0,),
                                    ],
                                  ),
                                ),

                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text(widget.myrecommendation.rating.toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 22,
                                          letterSpacing: 0.27,
                                          color: Color(0xFF3A5160),
                                        ),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xFF132342),
                                        size: 24.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: opacity1,
                            duration: const Duration(milliseconds: 500,),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: <Widget>[
                                    getTimeBoxUI(widget.myrecommendation.numReviews.toString(),'Reviews'),
                                    getTimeBoxUI(widget.myrecommendation.subCategory,'Category'),
                                    getTimeBoxUI(widget.myrecommendation.rankingPosition.toString(),'Ranking Position'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 8,
                              ),
                              child: Text(
                                widget.myrecommendation.description,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 14,
                                  letterSpacing: 0.27,
                                  color: Color(0xFF3A5160),
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, bottom: 16, right: 16),
                              child: Column(
                                children: [
                                  TextField(
                                    cursorHeight: 20,
                                    autofocus: false,
                                    controller: feedbackController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Enter your Feedback',
                                      // hintText: "Enter your Feedback",
                                      prefixIcon: Icon(Icons.star),
                                      suffixIcon: Icon(Icons.keyboard_arrow_down),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(color: Colors.grey, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(color: Colors.grey, width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        gapPadding: 0.0,
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(color:Color(0xFF132342), width: 1.5),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: saveDetailsToDatabase,
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFFFFF),
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(12.0),
                                              ),
                                              border: Border.all(color: Color(0xFF3A5160).withOpacity(0.2)),
                                            ),
                                            child: Icon(
                                              isIconFavorite ? Icons.favorite : Icons.favorite_border,
                                              color: Color(0xFF132342),
                                              size: 28,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: (){

                                            feedbackController.text.trim();


                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text(
                                                "Your Feedback Saving.........",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            )
                                            );
                                          },
                                          child: Expanded(
                                            child: Container(
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF132342),
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(16.0),
                                                ),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color:Color(0xFF132342).withOpacity(0.5),
                                                      offset: const Offset(1.1, 1.1),
                                                      blurRadius: 10.0),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Add Feedback ',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    letterSpacing: 0.0,
                                                    color:Color(0xFFFFFFFF),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          ),


                        ],
                      ),
                    ),
                  ),
                ),
              ),)
          ],
        ),
      ),
    );
  }
  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color:Color(0xFF3A5160).withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: Color(0xFF132342),
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: Color(0xFF3A5160),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void saveDetailsToDatabase() async {
    toggleIcon();
    try {
      // Get the current user ID (you can replace this with your own logic to get the user ID)
      String userId = user.uid;

      // Create a reference to the user's document in Firestore
      DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(userId);

      // Get the existing bucket list array from the user's document
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await userRef.get() as DocumentSnapshot<Map<String, dynamic>>;
      List<dynamic>? existingBucketList =
          userSnapshot.data()?['bucketList']?.cast<dynamic>() ?? [];

      // Create a new bucket list item using the destination details
      Map<String, dynamic> newBucketListItem = {
        'name': widget.myrecommendation.name,
        'city': widget.myrecommendation.city,
        'country': widget.myrecommendation.country,
        'imageURL': widget.myrecommendation.ImageURL,
        'rating': widget.myrecommendation.rating,
        'description': widget.myrecommendation.description,
        'numReview': widget.myrecommendation.numReviews,
        'rankingDenominator': '169',
        'rankingPosition': widget.myrecommendation.rankingPosition,
        'rawRanking': widget.myrecommendation.rawRanking,
        'subCategory': widget.myrecommendation.subCategory,
        'subType': widget.myrecommendation.subType,
      };

      // Add the new bucket list item to the existing array
      existingBucketList!.add(newBucketListItem);

      // Update the bucket list array in the user's document
      await userRef.update({'bucketList': existingBucketList});

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Destination added to your bucket list.',
          style: TextStyle(fontSize: 16),
        ),
      ));
    } catch (error) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Failed to add destination to bucket list.',
          style: TextStyle(fontSize: 16),
        ),
      ));
    }
  }


}