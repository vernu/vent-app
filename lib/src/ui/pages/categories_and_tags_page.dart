import 'package:flutter/material.dart';
import 'package:vent/src/models/category.dart';
import 'package:vent/src/repository/category_repository.dart';

class CategoriesAndTagsPage extends StatefulWidget {
  _CategoriesAndTagsPageState createState() => _CategoriesAndTagsPageState();
}

class _CategoriesAndTagsPageState extends State<CategoriesAndTagsPage> {
  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Text(
            'Categories',
            style: TextStyle(fontSize: 22),
          ),
          FutureBuilder<List<Category>>(
              future: CategoryRepository().getCategories(),
              builder: _categoriesBuilder),
          Text(
            'Tags',
            style: TextStyle(fontSize: 22),
          ),
          Wrap(
            children: List.generate(15, (i) {
              return i + 1;
            })
                .toList()
                .map((i) => Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ActionChip(
                        elevation: 2,
                        backgroundColor: Colors.white10,
                        onPressed: () {},
                        label: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text('#tag_$i'),
                        ),
                      ),
                    ))
                .toList(),
          ),
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
            .map((category) =>
                Card(child: Center(child: Text('${category.name} '))))
            .toList());
  }
}
