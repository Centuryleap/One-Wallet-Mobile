import 'package:flutter/material.dart';


class Utils {

  static ScaffoldFeatureController scaffoldMessengerSnackBar( BuildContext context, String message){
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

}