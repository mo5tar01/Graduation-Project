import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommendation/layout/TravelApp/cubit/states.dart';

import '../../../modules/Travel_app/BucketList/bucketListScreen.dart';
import '../../../modules/Travel_app/Main/Home_Screen.dart';
import '../../../modules/Travel_app/SettingsScreen/settings_screen.dart';
import '../../../modules/Travel_app/recommendations/recommendations_screen.dart';


class ShopCubit extends Cubit<ShopStates>{
  ShopCubit() : super(ShopInitialState());
  static ShopCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget>bottomScreens =[
    HomeScreen(),
    bucketListScreen(),
    recommendationScreen(),
    SettingScreen(),
  ];
  void changeBottom(int index){
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

}