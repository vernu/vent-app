import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vent/src/repository/theme_repsository.dart';
import 'package:vent/src/ui/theme/app_themes.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(appThemeData[defaultAppTheme]));

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ThemeInitial) {
      yield ThemeState(appThemeData[await ThemeRepository().getCurrentTheme()]);
    }
    if (event is ThemeChanged) {
      await ThemeRepository().setTheme(event.theme);
      yield ThemeState(appThemeData[await ThemeRepository().getCurrentTheme()]);
    }
  }
}
