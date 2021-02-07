import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/src/blocs/theme/theme_bloc.dart';
import 'package:vent/src/ui/theme/app_themes.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          ExpansionTile(
              initiallyExpanded: true,
              title: Text('Theme'),
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(8),
                    itemCount: AppTheme.values.length,
                    itemBuilder: (context, index) {
                      final itemAppTheme = AppTheme.values[index];

                      return Card(
                        color: appThemeData[itemAppTheme].backgroundColor,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: RaisedButton(
                                  color:
                                      appThemeData[itemAppTheme].primaryColor,
                                  child: Text(
                                    itemAppTheme
                                        .toString()
                                        .replaceAll('AppTheme.', ''),
                                    style: appThemeData[itemAppTheme]
                                        .textTheme
                                        .bodyText1,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<ThemeBloc>()
                                        .add(ThemeChanged(itemAppTheme));

                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(('Theme Changed')),
                                    ));
                                  }),
                            ),
                          ],
                        ),
                      );
                    })
              ]),
        ],
      )),
    );
  }
}
