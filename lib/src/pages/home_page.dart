import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vent/src/models/vent.dart';
import 'package:vent/src/pages/submit_vent_page.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(context) {
    return ListView(
      children: [
        _firebaseAuth.currentUser == null
            ? Text('signin to vent')
            : RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubmitVentPage()));
                },
                child: Text('Vent'),
              ),
        FutureBuilder<QuerySnapshot>(
            future: _firebaseFirestore.collection('vents').get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              List<Vent> vents = snapshot.data.docs
                  .map((v) => Vent.fromMap(v.id, v.data()))
                  .toList();

              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: vents.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${vents[index].title}"),
                                  Text("${vents[index].vent}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            })
      ],
    );
  }
}
