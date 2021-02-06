import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:vent/src/models/vent.dart';
import 'package:vent/src/repository/vent_repository.dart';

class VentDetailPage extends StatefulWidget {
  _VentDetailPageState createState() => _VentDetailPageState();
  final Vent vent;
  VentDetailPage(this.vent);
}

class _VentDetailPageState extends State<VentDetailPage> {
  @override
  initState() {
    super.initState();
    VentRepository().addVentView(widget.vent.id);
  }

  @override
  Widget build(contex) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vent.title),
      ),
      body: SafeArea(
        child: ListView(padding: EdgeInsets.all(8), children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Icon(
              CupertinoIcons.profile_circled,
              size: 60,
            ),
            Column(
              children: [
                Text(
                  "Anonymous",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor),
                ),
                Text(
                  widget.vent.createdAt != null
                      ? formatTime(widget.vent.createdAt.millisecondsSinceEpoch)
                      : '',
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            )
          ]),
          Divider(),
          Text("${widget.vent.title}",
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Theme.of(context).accentColor.withOpacity(0.9))),
          SizedBox(height: 5),
          Text(
            "${widget.vent.vent}",
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyText2,
          )
          ,
          Text('Comments'),
        ]),
      ),
    );
  }
}
