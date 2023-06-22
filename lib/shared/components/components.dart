
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Widget defaultButton({
 double width = double.infinity,
  Color background = Colors.blue,
  double radius = 3.0,
  required Function buttonPressed,
  required String text,


}) => Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
width: width,

child: MaterialButton(
onPressed:(){},
child: Text(
text.toUpperCase(),
style:TextStyle(
color:Colors.white,
),
),

),
);
Widget roundedButton({

  double width =double.infinity,
  Color background = Colors.blue,
  double radius = 20.0,
  required Function buttonPressed,
  required String text,

}) =>
    Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
width: width,

child: MaterialButton(
onPressed:(){},
child: Text(
text.toUpperCase(),
style:TextStyle(
color:Colors.white,
),
),

),
);
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
   onTap,
  onSubmit,
  onChange,
  required String labelText,
  required IconData prefix,
  required validate,
  IconData? suffix,
  isClickable = true,
}) => TextFormField(
controller: controller,
keyboardType: type,
onTap:onTap,
  validator: validate,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  enabled: isClickable,

  decoration: InputDecoration(
    labelText: labelText,
    prefixIcon: Icon(prefix,),
    suffixIcon: Icon(suffix,),
    border: OutlineInputBorder(),


  ),

);
Widget roundedFormField({
  required TextEditingController controller,
  required TextInputType type,
   onTap,
  onSubmit,
  onChange,
  required String labelText,
  required IconData prefix,
  IconData? suffix,
  required validate,
  Function? suffixPressed,
   isClickable = true,
}) => TextFormField(
controller: controller,
keyboardType: type,
onTap:onTap,
  validator: validate,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  enabled: isClickable,

  decoration: InputDecoration(
    labelText: labelText,
    prefixIcon: Icon(prefix,),
    suffixIcon: Icon(suffix,),

    border: OutlineInputBorder(
      borderSide:
      BorderSide(width: 3, color: Colors.greenAccent),
      borderRadius: BorderRadius.circular(50.0),
    ),


  ),

);

Widget buildTaskItem(Map model, context)=> Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(
  
      children: [
  
        CircleAvatar(
  
          backgroundColor: Colors.blueAccent,
  
          radius: 40.0,
  
          child: Text(
  
            '${model['time']} ',
  
          ),
  
        ),
  
        SizedBox(
  
          width: 20.0,
  
        ),
  
        Expanded(
  
          child: Column(
  
            mainAxisSize:MainAxisSize.min ,
  
            crossAxisAlignment: CrossAxisAlignment.start,
  
            children: [
  
               Text(
  
                  '${model['title']}',
  
                  style: TextStyle(
  
                    fontSize: 18.0,
  
                    fontWeight: FontWeight.bold,
  

  
                ),
  
              ),
  
              Text(
  
                '${model['date']}',
  
                style: TextStyle(
  
                  color: Colors.grey,
  
                ),
  
              ),
  
  
  
            ],
  
          ),
  
        ),
  
        SizedBox(
  
          width: 20.0,
  
        ),
  

  

  
  
  
  
      ],
  
    ),
  
  ),
);
Widget tasksBuilder({
 required  List<Map> tasks,}) => ConditionalBuilder(
  condition: tasks.length  >0,
  builder: (context) => ListView.separated(
      itemBuilder: (context, index) => buildTaskItem(tasks[index] , context),
      separatorBuilder: (context, index) => myDivider(),
      itemCount: tasks.length),
  fallback: (context) => Center(
    child: Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children:[
          Icon(
            Icons.menu,
            size: 100,
            color:Colors.grey,
          ),
          Text(
            'No Tasks Yet , Please Add Some Tasks',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ]
    ),
  ),
);

Widget myDivider() =>Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);
void navigateTo(context , widget) => Navigator.push(
  context, MaterialPageRoute(
    builder: (context) => widget
  ),
);
void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => widget,),
        (Route<dynamic> route) => false,);
