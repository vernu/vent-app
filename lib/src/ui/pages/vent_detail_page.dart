import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:vent/src/blocs/auth/auth_bloc.dart';
import 'package:vent/src/blocs/vent_detail/vent_detail_bloc.dart';
import 'package:vent/src/models/comment.dart';
import 'package:vent/src/models/vent.dart';
import 'package:vent/src/repository/vent_repository.dart';

class VentDetailPage extends StatefulWidget {
  _VentDetailPageState createState() => _VentDetailPageState();
  final Vent vent;
  VentDetailPage(this.vent);
}

class _VentDetailPageState extends State<VentDetailPage> {
  VentDetailBloc ventDetailBloc;
  GlobalKey<FormState> commentFormKey = GlobalKey<FormState>();
  String comment;
  @override
  initState() {
    super.initState();
    ventDetailBloc = VentDetailBloc();
    ventDetailBloc.add(VentCommentsLoadRequested(vent: widget.vent));
    VentRepository().addVentView(widget.vent.id);
  }

  @override
  Widget build(contex) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ventDetailBloc),
        ],
        child: Scaffold(
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
                          ? formatTime(
                              widget.vent.createdAt.millisecondsSinceEpoch)
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
              TextButton(
                onPressed: () {
                  VentRepository().reportVent(ventId: widget.vent.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Report Submitted')));
                },
                child: Text(
                  'Report',
                ),
              ),
              Divider(),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthenticationSuccess) {
                    return Container(
                      height: 230,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: commentFormKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    maxLines: 5,
                                    minLines: 5,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      // prefixIcon: Icon(
                                      //   Icons.comment,
                                      // ),
                                      labelText: "Comment",
                                      hintText: "Write your comment here..",
                                    ),
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return 'Please enter comment';
                                      }
                                      comment = val;
                                      return null;
                                    },
                                  ),
                                  BlocBuilder<VentDetailBloc, VentDetailState>(
                                    builder: (context, state) {
                                      if (state.submittingComment) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return RaisedButton(
                                        onPressed: () async {
                                          if (commentFormKey.currentState
                                              .validate()) {
                                            context.read<VentDetailBloc>().add(
                                                VentCommentSubmitted(
                                                    vent: widget.vent,
                                                    comment: comment));
                                          }
                                        },
                                        child: Text('Send'),
                                      );
                                    },
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Sign in to submit a comment'),
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.message),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Comments (${widget.vent.commentCount})',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              BlocBuilder<VentDetailBloc, VentDetailState>(
                builder: (context, state) {
                  List<Comment> comments = state.ventComments;
                  if (state.commentsLoadingStatus ==
                      CommentsLoadingStatus.Loading) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CupertinoActivityIndicator(),
                        Text('Loading Comments')
                      ],
                    );
                  } else if (state.commentsLoadingStatus ==
                      CommentsLoadingStatus.LoadingFailed) {
                    return Center(child: Text('Failed Loading Comments'));
                  } else if (state.commentsLoadingStatus ==
                      CommentsLoadingStatus.Loaded) {
                    if (state.ventComments.length == 0) {
                      return Center(child: Text('There are no comments yet'));
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
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
                                        child: Text(
                                            comments[index].userName ??
                                                comments[index].userId,
                                            // '${widget.vent.user != null ? widget.vent.user.name : "Anonymous"}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .accentColor
                                                        .withOpacity(0.9)))),
                                    Text(
                                      formatTime(comments[index]
                                          .createdAt
                                          .millisecondsSinceEpoch),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        comments[index].comment,
                                        maxLines: 10,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        VentRepository().reportVentComment(
                                            ventId: widget.vent.id,
                                            commentId: comments[index].id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text('Report Submitted')));
                                      },
                                      child: Text(
                                        'Report',
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ));
                        });
                  }
                  return SizedBox();
                },
              ),
            ]),
          ),
        ));
  }
}
