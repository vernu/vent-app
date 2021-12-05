import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vent/src/blocs/categories_and_tags/categories_and_tags_bloc.dart';

class CategoriesAndTagsPage extends StatefulWidget {
  _CategoriesAndTagsPageState createState() => _CategoriesAndTagsPageState();
}

class _CategoriesAndTagsPageState extends State<CategoriesAndTagsPage>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  Widget build(context) {
    super.build(context);
    return BlocConsumer<CategoriesAndTagsBloc, CategoriesAndTagsState>(
      listener: (context, state) {
        if (state.status == Status.Loading) {
        } else if (state.status == Status.Loaded) {
          _refreshController.refreshCompleted();
        } else if (state.status == Status.LoadingFail) {
          _refreshController.refreshFailed();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Loading failed  : ${state.error}'),
            action: SnackBarAction(
              onPressed: () {
                // _refreshController.requestRefresh();
                context
                    .read<CategoriesAndTagsBloc>()
                    .add(CategoriesAndTagsLoadRequested());
              },
              label: 'Retry',
            ),
          ));
        }
      },
      builder: (context, state) {
        return SmartRefresher(
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
            onRefresh: () => context
                .read<CategoriesAndTagsBloc>()
                .add(CategoriesAndTagsLoadRequested()),
            // onLoading: _onLoading,
            child: ListView(
              padding: EdgeInsets.all(8),
              children: [
                //if(state is CategoriesAndTagsLoaded){}
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(CupertinoIcons.folder_open),
                    SizedBox(width: 10),
                    Text(
                      'Categories',
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 2,
                    children: state.categories
                        .map((category) => Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/vents',
                                      arguments: {'category': category});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.4),
                                          Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Center(
                                        child: Text('${category.name} '))),
                              ),
                            ))
                        .toList()),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(CupertinoIcons.tags),
                    SizedBox(width: 10),
                    Text(
                      'Popular Tags',
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
                Wrap(
                    children: state.tags.map((tag) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ActionChip(
                      elevation: 2,
                      backgroundColor: Colors.white10,
                      onPressed: () {
                        Navigator.pushNamed(context, '/vents', arguments: {
                          'tags': ['${tag.id}']
                        });
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text('#${tag.id} (${tag.ventCount})'),
                      ),
                    ),
                  );
                }).toList())
              ],
            ));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
