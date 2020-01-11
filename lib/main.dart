import 'package:current_location_view/homePage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  title: "Location",
      theme: ThemeData.dark(),
      initialRoute: "/",
      routes: {"/": (context) => Home()},
    ));
