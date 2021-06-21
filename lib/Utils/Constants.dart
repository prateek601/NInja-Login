import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constant{

  //////////////////////ScreenSize/////////////////////////////////
  static double returnHeight(BuildContext context){
  return MediaQuery.of(context).size.height;
  }

  static double returnWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
  }
/////////////////////////Color///////////////////////////////////////
  static Color primaryColor = Color(0xFF121212);
  static Color secondaryColor = Colors.black;

//////////////////////////Constant Strings//////////////////////////////////////
  static String users = 'users';
  static String email = 'email';
  static String password = 'password';
  static String name = 'name';
  static String phoneNumber = 'phoneNumber';
  static String location = 'location';
  static String searchKey = 'searchKey';
}