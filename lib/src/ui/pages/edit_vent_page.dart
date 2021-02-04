import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vent/src/models/vent.dart';
import 'package:vent/src/repository/vent_repository.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                        minLines: 5,
                        maxLines: 5,
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
      ),
    );
  }

  _updateVent(title, vent) async {
    setState(() {
      isUpdating = true;
    });
    await VentRepository()
        .updateVent(widget.vent.id, title: title, vent: vent, tags: []);

    setState(() {
      isUpdating = false;
    });
    Navigator.pop(context);
  }
}
