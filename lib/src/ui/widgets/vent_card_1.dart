import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_formatter/time_formatter.dart';
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
        onTap: () async {
          Navigator.pushNamed(context, '/vent_detail',
              arguments: {'vent': widget.vent});
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                CupertinoIcons.profile_circled,
                size: 60,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${widget.vent.user != null ? widget.vent.user.name : widget.vent.userName}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                        Text(
                          widget.vent.createdAt != null
                              ? formatTime(
                                  widget.vent.createdAt.millisecondsSinceEpoch)
                              : '',
                          style: Theme.of(context).textTheme.bodyText2,
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    Text("${widget.vent.title}",
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Theme.of(context)
                                .colorScheme.secondary
                                .withOpacity(0.9))),
                    SizedBox(height: 5),
                    Text(
                      "${widget.vent.vent}",
                      textAlign: TextAlign.justify,
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
                        Spacer(),
                        _firebaseAuth.currentUser == null
                            ? Container()
                            : widget.vent.userId ==
                                    _firebaseAuth.currentUser.uid
                                ? Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/edit_vent',
                                              arguments: {'vent': widget.vent});
                                        },
                                      ),
                                      deleting
                                          ? CupertinoActivityIndicator()
                                          : IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () async {
                                                setState(() {
                                                  deleting = true;
                                                });
                                                await VentRepository()
                                                    .deleteVent(widget.vent);
                                                if (mounted)
                                                  setState(() {
                                                    deleting = false;
                                                  });
                                              }),
                                    ],
                                  )
                                : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
