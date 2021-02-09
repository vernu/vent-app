import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vent/src/models/category.dart';
import 'package:vent/src/models/tag.dart';
import 'package:vent/src/repository/category_repository.dart';
import 'package:vent/src/repository/tag_repository.dart';

class CategoriesAndTagsPage extends StatefulWidget {
  _CategoriesAndTagsPageState createState() => _CategoriesAndTagsPageState();
}

class _CategoriesAndTagsPageState extends State<CategoriesAndTagsPage> {
  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        padding: EdgeInsets.all(8),
        children: [
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
          FutureBuilder<List<Category>>(
              future: CategoryRepository().getCategories(),
              builder: _categoriesBuilder),
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
          SizedBox(height: 10),
          FutureBuilder<List<Tag>>(
              future: TagRepository().getTags(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return Wrap(
                    children: snapshot.data.map((tag) {
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
                }).toList());
              }),
        ],
      ),
    );
  }

  Widget _categoriesBuilder(context, snapshot) {
    if (!snapshot.hasData) {
      return Center(child: CircularProgressIndicator());
    }
    List<Category> categories = snapshot.data;
    return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 2,
        children: categories
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
                              Theme.of(context).primaryColor.withOpacity(0.4),
                              Theme.of(context).primaryColor.withOpacity(0.1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Center(child: Text('${category.name} '))),
                  ),
                ))
            .toList());
  }
}
