import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Settings Screen',
    style: Theme.of(context).textTheme.bodyText1,);
  }
}
