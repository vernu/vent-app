import 'package:flutter/material.dart';
import 'package:vent/src/repository/vent_repository.dart';

class SubmitVentPage extends StatefulWidget {
  _SubmitVentPageState createState() => _SubmitVentPageState();
}

class _SubmitVentPageState extends State<SubmitVentPage> {

  GlobalKey<FormState> _submitVentFormKey = GlobalKey<FormState>();
  bool isSubmitting = false;

  String title, vent;

  @override
  Widget build(context) {
    // if (_firebaseAuth.currentUser == null) {
    //   Navigator.pop(context);
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Vent'),
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
                        isSubmitting
                            ? CircularProgressIndicator()
                            : RaisedButton(
                                onPressed: () async {
                                  if (_submitVentFormKey.currentState
                                      .validate()) {
                                    _submitVent(title, vent);
                                  }
                                },
                                child: Text('Submit'))
                      ]),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitVent(title, vent) async {
    setState(() {
      isSubmitting = true;
    });
    await VentRepository()
        .addVent(title: title, vent: vent, tags: []);

    setState(() {
      isSubmitting = false;
    });
  }
}
