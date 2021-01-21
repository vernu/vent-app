import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vent/src/models/category.dart';

class CategoriesAndTagsPage extends StatefulWidget {
  _CategoriesAndTagsPageState createState() => _CategoriesAndTagsPageState();
}

class _CategoriesAndTagsPageState extends State<CategoriesAndTagsPage> {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
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
          FutureBuilder<QuerySnapshot>(
              future: _firebaseFirestore.collection('categories').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List<Category> categories = snapshot.data.docs
                    .map((i) => Category.fromMap(i.id, i.data()))
                    .toList();
                return GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 2,
                    children: categories
                        .map((category) => Card(
                            child: Center(child: Text('${category.name} '))))
                        .toList());
              }),
          Text(
            'Tags',
            style: TextStyle(fontSize: 22),
          ),
          Wrap(
            children: List.generate(20, (i) {
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
}
