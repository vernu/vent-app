import 'package:flutter/material.dart';

enum AppTheme {
  BlueLight,
  BlueDark,
  RedLight,
  RedDark,
  GreenLight,
  GreenDark,
  OrangeLight,
  OrangeDark,
  AmberLight,
  AmberDark,
  DeepOrangeLight,
  DeepOrangeDark,
  DeepPurpleLight,
  DeepPurpleDark,
  BlueGreyLight,
  BlueGreyDark
}
AppTheme defaultAppTheme = AppTheme.DeepPurpleLight;

ThemeData themeData(
    {@required Brightness brightness, @required MaterialColor primarySwatch}) {
  return (ThemeData(
      brightness: brightness,
      primarySwatch: primarySwatch,
      primaryColor: primarySwatch,
      buttonTheme: ButtonThemeData(
          buttonColor: primarySwatch, textTheme: ButtonTextTheme.primary)));
}

final appThemeData = {
  AppTheme.BlueLight:
      themeData(brightness: Brightness.light, primarySwatch: Colors.blue),
  AppTheme.BlueDark:
      themeData(brightness: Brightness.dark, primarySwatch: Colors.blue),
  AppTheme.RedLight:
      themeData(brightness: Brightness.light, primarySwatch: Colors.red),
  AppTheme.RedDark:
      themeData(brightness: Brightness.dark, primarySwatch: Colors.red),
  AppTheme.GreenLight:
      themeData(brightness: Brightness.light, primarySwatch: Colors.green),
  AppTheme.GreenDark:
      themeData(brightness: Brightness.dark, primarySwatch: Colors.green),
  AppTheme.OrangeLight:
      themeData(brightness: Brightness.light, primarySwatch: Colors.orange),
  AppTheme.OrangeDark:
      themeData(brightness: Brightness.dark, primarySwatch: Colors.orange),
  AppTheme.AmberLight:
      themeData(brightness: Brightness.light, primarySwatch: Colors.amber),
  AppTheme.AmberDark:
      themeData(brightness: Brightness.dark, primarySwatch: Colors.amber),
  AppTheme.DeepOrangeLight:
      themeData(brightness: Brightness.light, primarySwatch: Colors.deepOrange),
  AppTheme.DeepOrangeDark:
      themeData(brightness: Brightness.dark, primarySwatch: Colors.deepOrange),
  AppTheme.DeepPurpleLight:
      themeData(brightness: Brightness.light, primarySwatch: Colors.deepPurple),
  AppTheme.DeepPurpleDark:
      themeData(brightness: Brightness.dark, primarySwatch: Colors.deepPurple),
  AppTheme.BlueGreyLight:
      themeData(brightness: Brightness.light, primarySwatch: Colors.blueGrey),
  AppTheme.BlueGreyDark:
      themeData(brightness: Brightness.dark, primarySwatch: Colors.blueGrey),
};
