
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../cubit/cubit.dart';

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