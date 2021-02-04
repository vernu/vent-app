import 'package:shared_preferences/shared_preferences.dart';
import 'package:vent/src/ui/theme/app_themes.dart';

class ThemeRepository {
  Future<AppTheme> getCurrentTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppTheme currentTheme;
    String str = sharedPreferences.getString('currentTheme');
    if (str == null) {
      currentTheme = defaultAppTheme;
    }
    try {
      currentTheme = AppTheme.values.firstWhere((e) => e.toString() == str);
    } catch (e) {
      print(e.toString());
      currentTheme = defaultAppTheme;
    }
    return currentTheme;
  }

  Future<void> setTheme(AppTheme theme) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('currentTheme', theme.toString());
  }
}
