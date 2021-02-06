import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:vent/src/models/comment.dart';
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
                      fontSize: 21,
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
              // maxLines: 5,
              overflow: TextOverflow.clip,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 24,
                  color: Theme.of(context).accentColor.withOpacity(0.9))),
          SizedBox(height: 5),
          Text(
            "${widget.vent.vent}",
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Divider(),
          Row(
            children: [
              Icon(Icons.message),
              SizedBox(width: 5,),
              Text(
                'Comments',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 18,),
              ),
            ],
          ),
          FutureBuilder<List<Comment>>(
              future: VentRepository().getVentComments(widget.vent.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text('Anonymous',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .accentColor
                                                      .withOpacity(0.9)))),
                                  Text(
                                    formatTime(snapshot.data[index].createdAt
                                        .millisecondsSinceEpoch),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                snapshot.data[index].comment,
                                maxLines: 10,
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        ));
                      });
                }
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CupertinoActivityIndicator(),
                      Text('Loading Comments')
                    ],
                  ),
                );
              }),
        ]),
      ),
    );
  }
}
