import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vent/src/models/vent.dart';
import 'package:vent/src/repository/vent_repository.dart';
import 'package:vent/src/ui/pages/edit_vent_page.dart';

class VentCard1 extends StatefulWidget {
  _VentCard1State createState() => _VentCard1State();

  final Vent vent;
  VentCard1(this.vent);
}

class _VentCard1State extends State<VentCard1> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool deleting = false;

  Widget build(contex) {
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
                  Text("${widget.vent.title}"),
                  Text("${widget.vent.vent}"),
                ],
              ),
            ),
            _firebaseAuth.currentUser == null
                ? Container()
                : widget.vent.userId == _firebaseAuth.currentUser.uid
                    ? Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pushNamed(context, '/edit_vent',
                                  arguments: {'vent': widget.vent});
                            },
                          ),
                          deleting
                              ? CupertinoActivityIndicator()
                              : IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    deleting = true;
                                    setState(() {});

                                    VentRepository().deleteVent(widget.vent);

                                    setState(() {
                                      deleting = false;
                                    });
                                  }),
                        ],
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
