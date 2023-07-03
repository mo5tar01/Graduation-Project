import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:travel_recommendation/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [

  ];
  List<String> titles = [
    'Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());

  }
  late Database database;




  bool isDark = false;
  ThemeMode appMode = ThemeMode.dark;
  void changeAppMode(){

    isDark = !isDark;


    emit(AppChangeModeState());

  }
}