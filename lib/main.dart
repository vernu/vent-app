import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vent/src/home.dart';

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
          if(snapshot.hasError){
            print(snapshot.error.toString());
            }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Vent',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: Home(),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
