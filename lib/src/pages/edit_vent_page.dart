import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vent/src/models/vent.dart';

class EditVentPage extends StatefulWidget {
  _EditVentPageState createState() => _EditVentPageState();
  final Vent vent;
  const EditVentPage(
    this.vent, {
    Key key,
  }) : super(key: key);
}

class _EditVentPageState extends State<EditVentPage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  GlobalKey<FormState> _submitVentFormKey = GlobalKey<FormState>();
  bool isUpdating = false;
  String title, vent;

  @override
  Widget build(context) {
    if (_firebaseAuth.currentUser == null) {
      Navigator.pop(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Vent'),
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
                      initialValue: widget.vent.title,
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
                      initialValue: widget.vent.vent,
                      keyboardType: TextInputType.multiline,
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
                      isUpdating
                          ? CircularProgressIndicator()
                          : RaisedButton(
                              onPressed: () async {
                                if (_submitVentFormKey.currentState
                                    .validate()) {
                                  _updateVent(title, vent);
                                }
                              },
                              child: Text('Update'))
                    ]),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  _updateVent(title, vent) async {
    setState(() {
      isUpdating = true;
    });
    await _firebaseFirestore.collection('vents').doc(widget.vent.id).update({
      'title': title,
      'vent': vent,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    setState(() {
      isUpdating = false;
    });
    Navigator.pop(context);
  }
}
