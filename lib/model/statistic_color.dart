import 'dart:ui';

import 'package:flutter/material.dart';

Color colorState(String state){
  switch(state){
    case "Created": return Colors.grey;
    case "In Process": return Colors.purple;
    case "Done": return Colors.green;
    case "Ended": return Colors.red;
    default: throw Error();
  }
}