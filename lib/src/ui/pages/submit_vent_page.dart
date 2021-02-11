import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:vent/src/models/vent_category.dart';
import 'package:vent/src/repository/category_repository.dart';
import 'package:vent/src/repository/vent_repository.dart';
import 'package:vent/src/utils/helpers.dart';

class SubmitVentPage extends StatefulWidget {
  SubmitVentPage({Key key}) : super(key: key);
  _SubmitVentPageState createState() => _SubmitVentPageState();
}

class _SubmitVentPageState extends State<SubmitVentPage> {
  GlobalKey<FormState> _submitVentFormKey = GlobalKey<FormState>();
  bool isSubmitting = false;

  String title, vent;
  List<String> tags = [];
  VentCategory selectedCategory;

  @override
  Widget build(context) {
    // if (_firebaseAuth.currentUser == null) {
    //   Navigator.pop(context);
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Vent'),
        actions: [],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Form(
                  key: _submitVentFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'title', hintText: ''),
                        validator: (val) {
                          setState(() {
                            title = val;
                          });
                          return null;
                        },
                      ),
                      TextFormField(
                        minLines: 5,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration:
                            InputDecoration(labelText: 'vent', hintText: ''),
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'vent field is required';
                          }
                          vent = val;
                          setState(() {});
                          return null;
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: FutureBuilder<List<VentCategory>>(
                            future: CategoryRepository().getCategories(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CupertinoActivityIndicator(),
                                    Text('Loading Categories...'),
                                  ],
                                );
                              }
                              return SmartSelect<VentCategory>.single(
                                title: 'Select category : ',
                                value: null,
                                modalType: S2ModalType.popupDialog,
                                choiceItems: S2Choice.listFrom(
                                  source: snapshot.data,
                                  value: (index, categ) => categ,
                                  title: (index, categ) => categ.name,
                                ),
                                onChange: (state) => setState(
                                    () => {selectedCategory = state.value}),
                                modalStyle: S2ModalStyle(
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                ),
                              );
                            }),
                      ),
                      TextFormField(
                        minLines: 3,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            labelText: 'tags',
                            hintText: 'tags (separate by space)'),
                        validator: (val) {
                          String error;
                          tags = val.replaceAll('#', '').trim().split(' ');

                          tags.forEach((t) {
                            if (!isTagValidString(t)) {
                              error = 'invalid characters';
                            } else {}
                          });

                          setState(() {});
                          return error;
                        },
                      ),
                      Row(children: [
                        isSubmitting
                            ? CircularProgressIndicator()
                            : RaisedButton(
                                onPressed: () async {
                                  if (_submitVentFormKey.currentState
                                      .validate()) {
                                    if (selectedCategory == null) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Please select category'),
                                      ));
                                    } else {
                                      _submitVent();
                                    }
                                  }
                                },
                                child: Text('Submit'))
                      ]),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitVent() async {
    isSubmitting = true;
    setState(() {});
    await VentRepository()
        .addVent(title: title, vent: vent, category: selectedCategory, tags: [
      ...{...tags}
    ] /*remove duplicates*/);

    isSubmitting = false;
    setState(() {});
  }
}
