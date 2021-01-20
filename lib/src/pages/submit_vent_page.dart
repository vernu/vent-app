import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SubmitVentPage extends StatefulWidget {
  _SubmitVentPageState createState() => _SubmitVentPageState();
}

class _SubmitVentPageState extends State<SubmitVentPage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  GlobalKey<FormState> _submitVentFormKey = GlobalKey<FormState>();
  bool isSubmitting = false;

  String title, vent;

  @override
  Widget build(context) {
    if (_firebaseAuth.currentUser == null) {
      Navigator.pop(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Vent'),
        actions: [],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Form(
                key: _submitVentFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'title', hintText: ''),
                      validator: (val) {
                        setState(() {
                          title = val;
                        });
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'vent', hintText: ''),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'vent field is required';
                        }
                        setState(() {
                          vent = val;
                        });
                        return null;
                      },
                    ),
                    Row(children: [
                      isSubmitting
                          ? CircularProgressIndicator()
                          : RaisedButton(
                              onPressed: () async {
                                if (_submitVentFormKey.currentState
                                    .validate()) {
                                  _submitVent(title, vent);
                                }
                              },
                              child: Text('Continue'))
                    ]),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  _submitVent(title, vent) async {
    setState(() {
      isSubmitting = true;
    });
    await _firebaseFirestore.collection('vents').add({
      'userId': _firebaseAuth.currentUser.uid,
      'title': title,
      'vent': vent,
      'createdAt': FieldValue.serverTimestamp(),
    });
    DocumentSnapshot userDocSnapshot = await _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .get();

    if (userDocSnapshot.exists) {
      userDocSnapshot.reference.update({'numVents': FieldValue.increment(1)});
    }
    setState(() {
      isSubmitting = false;
    });
  }
}
