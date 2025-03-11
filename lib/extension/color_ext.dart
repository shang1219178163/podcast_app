//
//  color_ext.dart
//  flutter_templet_project
//
//  Created by shang on 7/16/21 2:08 PM.
//  Copyright © 7/16/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';

extension ColorExt on Color {
  /// 颜色字典
  static final colorsMap = <Color, String>{
    Colors.white: "white",
    Colors.black: "black",
    Colors.pink: "pink",
    Colors.purple: "purple",
    Colors.deepPurple: "deepPurple",
    Colors.indigo: "indigo",
    Colors.blue: "blue",
    Colors.lightBlue: "lightBlue",
    Colors.cyan: "cyan",
    Colors.teal: "teal",
    Colors.green: "green",
    Colors.lightGreen: "lightGreen",
    Colors.lime: "lime",
    Colors.yellow: "yellow",
    Colors.amber: "amber",
    Colors.orange: "orange",
    Colors.deepOrange: "deepOrange",
    Colors.brown: "brown",
    Colors.grey: "grey",
    Colors.blueGrey: "blueGrey",
    Colors.redAccent: "redAccent",
    Colors.pinkAccent: "pinkAccent",
    Colors.purpleAccent: "purpleAccent",
    Colors.deepPurpleAccent: "deepPurpleAccent",
    Colors.indigoAccent: "indigoAccent",
    Colors.blueAccent: "blueAccent",
    Colors.lightBlueAccent: "lightBlueAccent",
    Colors.cyanAccent: "cyanAccent",
    Colors.tealAccent: "tealAccent",
    Colors.greenAccent: "greenAccent",
    Colors.lightGreenAccent: "lightGreenAccent",
    Colors.limeAccent: "limeAccent",
    Colors.yellowAccent: "yellowAccent",
    Colors.amberAccent: "amberAccent",
    Colors.orangeAccent: "orangeAccent",
    Colors.deepOrangeAccent: "deepOrangeAccent",
  };

  ///随机颜色
  static Color get random {
    return Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      1,
    );
  }



  /// 颜色名称描述
  String get nameDes {
    if (colorsMap.keys.contains(this)) {
      return colorsMap[this] ?? "";
    }
    return toString();
  }

  // /// 颜色名称描述
  // String get toRadixString {
  //   final result = "#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}";
  //   return result;
  // }
}
