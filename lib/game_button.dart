import 'package:flutter/material.dart';

class GameButton {
  // ignore: non_constant_identifier_names
  final Id;
  String text;
  Color bg =  Color(0xff191C21);
  bool enabled;

  // ignore: non_constant_identifier_names
  GameButton({this.Id,this.text="",this.enabled=true});
}
