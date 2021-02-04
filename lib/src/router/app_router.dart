import 'package:flutter/material.dart';
import 'package:vent/src/ui/home.dart';
import 'package:vent/src/ui/pages/edit_vent_page.dart';
import 'package:vent/src/ui/pages/settings_page.dart';
import 'package:vent/src/ui/pages/signup_page.dart';
import 'package:vent/src/ui/pages/submit_vent_page.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings routeSettings) {
    Map args = routeSettings.arguments as Map<String, dynamic>;
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
        break;
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
        break;
      case '/sign_up':
        return MaterialPageRoute(builder: (_) => SignupPage());
        break;
      case '/submit_vent':
        return MaterialPageRoute(builder: (_) => SubmitVentPage());
        break;
      case '/edit_vent':
        return MaterialPageRoute(builder: (_) => EditVentPage(args['vent']));
        break;

      default:
        return MaterialPageRoute(builder: (_) => Home());
        break;
    }
  }
}
