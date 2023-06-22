import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';
import '../login/travel_login_screen.dart';
class BoardingModel{
  final String image;
  final String title;
  final String body;
  BoardingModel({
    required this.title,
    required this.image,
    required this.body,
});

}
class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

List <BoardingModel> boarding = [
  BoardingModel(
    body:'Places you never heard of before',
    image:'images/pngwing.com (1).png' ,
    title: 'Find New Places',
  ),
  BoardingModel(
    body:'Every Place you want in one place',
    image:'images/clipart1502878.png' ,
    title: 'Explore The World',
  ),
  BoardingModel(
    body:'Join Us Now',
    image:'images/PngItem_5858646.png' ,
    title: 'What Are You Waiting?',
  ),
];

bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed:  ()
          {
            navigateAndFinish(context,  TravelLoginScreen(),);

          },
            child: Text('SKIP'),),
        ],
      ),
    body:Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
        Expanded(
          child: PageView.builder(
            physics: BouncingScrollPhysics(),
            controller: boardController,
            onPageChanged: (int index){
              if (index == boarding.length - 1 ) {
                setState(() {
                  isLast = true;
                });
              }
              else {
                isLast = false;
              }
            },
            itemBuilder: (context, index) => BuildBoardingItem(boarding[index]),
            itemCount: boarding.length,
          ),
        ),
          SizedBox(
            height: 40.0,
          ),
          Row(
            children: [
              SmoothPageIndicator(
                  controller: boardController,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: defaultColor,
                    dotHeight: 10.0,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 5.0,
                  ),
                  count: boarding.length),
              Spacer(),
              FloatingActionButton(onPressed: (){
                if(isLast){
                  navigateAndFinish(context, TravelLoginScreen(),);
                } else {
                  boardController.nextPage(
                duration: Duration(
                milliseconds: 750,
                ),
                curve: Curves.fastLinearToSlowEaseIn,
                );
                }

              },
              child:

              Icon(
                Icons.arrow_forward_ios,

              ),
              backgroundColor: defaultColor,
              )
            ],
          ),
      ]
      ),
    ),
    );
  }

  Widget BuildBoardingItem(BoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Image(
          image: AssetImage('${model.image}'),

        ),
      ),
      SizedBox(
        height: 30.0,
      ),
      Text(
        '${model.title}',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: 15.0,
      ),
      Text(
        '${model.body}',
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),


    ],
  );
}
