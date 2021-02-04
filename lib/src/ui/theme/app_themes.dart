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
AppTheme defaultAppTheme = AppTheme.BlueLight;

final appThemeData = {
  AppTheme.BlueLight:
      ThemeData(brightness: Brightness.light, primarySwatch: Colors.blue),
  AppTheme.BlueDark:
      ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue),
  AppTheme.RedLight:
      ThemeData(brightness: Brightness.light, primarySwatch: Colors.red),
  AppTheme.RedDark:
      ThemeData(brightness: Brightness.dark, primarySwatch: Colors.red),
  AppTheme.GreenLight:
      ThemeData(brightness: Brightness.light, primarySwatch: Colors.green),
  AppTheme.GreenDark:
      ThemeData(brightness: Brightness.dark, primarySwatch: Colors.green),
  AppTheme.OrangeLight:
      ThemeData(brightness: Brightness.light, primarySwatch: Colors.orange),
  AppTheme.OrangeDark:
      ThemeData(brightness: Brightness.dark, primarySwatch: Colors.orange),
  AppTheme.AmberLight:
      ThemeData(brightness: Brightness.light, primarySwatch: Colors.amber),
  AppTheme.AmberDark:
      ThemeData(brightness: Brightness.dark, primarySwatch: Colors.amber),
  AppTheme.DeepOrangeLight:
      ThemeData(brightness: Brightness.light, primarySwatch: Colors.deepOrange),
  AppTheme.DeepOrangeDark:
      ThemeData(brightness: Brightness.dark, primarySwatch: Colors.deepOrange),
  AppTheme.DeepPurpleLight:
      ThemeData(brightness: Brightness.light, primarySwatch: Colors.deepPurple),
  AppTheme.DeepPurpleDark:
      ThemeData(brightness: Brightness.dark, primarySwatch: Colors.deepPurple),
  AppTheme.BlueGreyLight:
      ThemeData(brightness: Brightness.light, primarySwatch: Colors.blueGrey),
  AppTheme.BlueGreyDark:
      ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blueGrey),
};
