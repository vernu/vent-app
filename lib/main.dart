import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/src/blocs/auth/auth_bloc.dart';
import 'package:vent/src/blocs/theme/theme_bloc.dart';
import 'package:vent/src/router/app_router.dart';

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
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => ThemeBloc()..add(ThemeInitial()),
                ),
                BlocProvider(
                  create: (_) => AuthBloc(),
                ),
              ],
              child: BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) {
                  return MaterialApp(
                    title: 'Vent',
                    // theme: ThemeData(
                    //   primarySwatch: Colors.red,
                    //   visualDensity: VisualDensity.adaptivePlatformDensity,
                    // ),
                    theme: state.themeData,
                    onGenerateRoute: (routeSettings) =>
                        AppRouter.onGenerateRoute(routeSettings),
                  );
                },
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
