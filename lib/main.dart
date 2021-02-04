import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/src/blocs/auth/auth_bloc.dart';
import 'package:vent/src/router/app_router.dart';
import 'package:vent/src/ui/home.dart';
import 'package:vent/src/ui/pages/edit_vent_page.dart';
import 'package:vent/src/ui/pages/signup_page.dart';
import 'package:vent/src/ui/pages/submit_vent_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return BlocProvider(
              create: (context) => AuthBloc(),
              child: MaterialApp(
                title: 'Vent',
                theme: ThemeData(
                  primarySwatch: Colors.red,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                onGenerateRoute: (routeSettings) =>
                    AppRouter.onGenerateRoute(routeSettings),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
