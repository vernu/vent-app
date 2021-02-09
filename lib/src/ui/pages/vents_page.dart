import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vent/src/blocs/vents/vents_bloc.dart';
import 'package:vent/src/models/category.dart';
import 'package:vent/src/ui/widgets/vent_card_1.dart';

class VentsPage extends StatefulWidget {
  final String userId;
  Category category;
  final List<String> tags;
  VentsPage({this.userId, this.category, this.tags = const <String>[]});

  _VentsPageState createState() => _VentsPageState();
}

class _VentsPageState extends State<VentsPage> {
  RefreshController _refreshController = RefreshController(
    initialRefresh: true,
  );
  String appBarTitle = 'Vents';
  VentsBloc ventsBloc;

  @override
  initState() {
    super.initState();
    ventsBloc = VentsBloc();
    if (widget.category != null) {
      appBarTitle = widget.category.name;
    } else if (widget.tags.length > 0) {
      appBarTitle = "TAGS [${widget.tags.join(', ')}]";
    }
  }

  _onRefresh() {
    ventsBloc.add(VentsLoadRequested(
        userId: widget.userId,
        categoryId: widget.category != null ? widget.category.id : null,
        tags: widget.tags));
  }

  _onLoading() {}

  @override
  Widget build(context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ventsBloc),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
          ),
          body: SafeArea(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              header: WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;

                  if (mode == LoadStatus.idle) {
                    body = Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
                  }

                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView(
                padding: EdgeInsets.all(8),
                children: [
                  BlocConsumer(
                    cubit: ventsBloc,
                    listener: (context, state) {
                      if (state.status == Status.Loading) {
                      } else if (state.status == Status.Loaded) {
                        _refreshController.refreshCompleted();
                      } else if (state.status == Status.LoadingFail) {
                        _refreshController.refreshFailed();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Failed loading vents : ${state.error}'),
                          action: SnackBarAction(
                            onPressed: () {
                              _refreshController.requestRefresh();
                            },
                            label: 'Retry',
                          ),
                        ));
                      }
                    },
                    builder: (context, state) {
                      print(state.status);
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.vents.length,
                          itemBuilder: (context, index) {
                            return VentCard1(state.vents[index]);
                          });
                    },
                  ),
                ],
              ),
            ),
          ),
        ));

    //
  }
}
