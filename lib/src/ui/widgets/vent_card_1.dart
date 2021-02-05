import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vent/src/models/vent.dart';
import 'package:vent/src/repository/vent_repository.dart';

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
      child: InkWell(
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 60,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Anonymous",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor),
                    ),
                    SizedBox(height: 5),
                    Text("${widget.vent.title}",
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Theme.of(context)
                                .accentColor
                                .withOpacity(0.9))),
                    SizedBox(height: 5),
                    Text(
                      "${widget.vent.vent}",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 15,
                        ),
                        SizedBox(width: 5),
                        Text('${widget.vent.viewCount}'),
                        SizedBox(width: 15),
                        Icon(
                          Icons.comment,
                          size: 15,
                        ),
                        SizedBox(width: 5),
                        Text('${widget.vent.commentCount}'),
                      ],
                    ),
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
                                      setState(() {
                                        deleting = true;
                                      });

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
      ),
    );
  }
}
