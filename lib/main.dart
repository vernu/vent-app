import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/src/blocs/auth/auth_bloc.dart';
import 'package:vent/src/ui/home.dart';

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
                home: Home(),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
