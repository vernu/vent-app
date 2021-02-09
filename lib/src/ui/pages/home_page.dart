import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vent/src/blocs/auth/auth_bloc.dart';
import 'package:vent/src/blocs/vents/vents_bloc.dart';
import 'package:vent/src/ui/widgets/vent_card_1.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RefreshController _refreshController = RefreshController(
    initialRefresh: true,
  );
  VentsBloc ventsBloc;

  @override
  initState() {
    super.initState();
    ventsBloc = VentsBloc();
  }

  _onRefresh() {
    ventsBloc.add(VentsLoadRequested());
  }

  _onLoading() {
    ventsBloc.add(VentsLoadRequested());
  }

  @override
  Widget build(context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ventsBloc),
        ],
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
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthenticationSuccess)
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('What\'s on your mind? ',
                            style: Theme.of(context).textTheme.headline6),
                        RaisedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/submit_vent');
                          },
                          child: Text('Vent here'),
                        ),
                      ],
                    );
                  else
                    return SizedBox();
                },
              ),
              Padding(
                padding: EdgeInsets.all(4),
                child: Text(
                  "Latest Vents",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ),
              BlocConsumer(
                cubit: ventsBloc,
                listener: (context, state) {
                  if (state.status == Status.Loading) {
                  } else if (state.status == Status.Loaded) {
                    _refreshController.refreshCompleted();
                  } else if (state.status == Status.LoadingFail) {
                    _refreshController.refreshFailed();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Failed loading vents : ${state.error}'),
                      action: SnackBarAction(
                        onPressed: () {
                          _refreshController.requestRefresh();
                          // context.read<VentsBloc>().add(VentsLoadRequested());
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
        ));

    //
  }
}
