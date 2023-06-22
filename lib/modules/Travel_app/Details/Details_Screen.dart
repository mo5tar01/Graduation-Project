import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class detailsScreen extends StatefulWidget {
  const detailsScreen({Key? key}) : super(key: key);

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
  @override
  void initState(){
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
                      "https://images4.alphacoders.com/168/thumb-1920-168614.jpg",
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
                              "Eiffel Tower",
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
                                        "Paris, France",
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
                                      Text("4.3",
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
                              child: Row(
                                children: <Widget>[
                                  getTimeBoxUI('24','Visits'),
                                  getTimeBoxUI('Middle Of ','The City'),
                                  getTimeBoxUI('25 ','Activities'),
                                ],
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
                                'Eiffel Tower is one of the world 7 wonders and one of the most visited places in the world',
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
                                        onTap:(){
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text(
                                              "Your Destination Saving.........",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          )
                                          );
                                        },
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFFFFF),
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(12.0),
                                              ),
                                              border: Border.all(
                                                  color:Color(0xFF3A5160).withOpacity(0.2)),
                                            ),
                                            child: Icon(
                                              Icons.add,
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
}