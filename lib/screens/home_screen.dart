import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/api/services.dart';
import 'package:rtg_app/bloc/recipes/bloc.dart';
import 'package:rtg_app/keys/keys.dart';

import 'package:rtg_app/widgets/recipes_list_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //
  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    Expanded(
      child: Center(
        child: Text(
          'Index 0: Home',
          style: optionStyle,
          key: Key(Keys.homeBottomBarHomeText),
        ),
      ),
    ),
    BlocProvider(
      create: (context) => RecipesBloc(recipesRepo: RecipeServices()),
      child: RecipesList(),
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
      key: Key(Keys.homeBottomBarListsText),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).home),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Open app settings',
            onPressed: () {
              // handle the press
              print('go to setting');
            },
          ),
        ],
      ),
      body: Container(
        child: _body(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              key: Key(Keys.homeBottomBarHomeIcon),
            ),
            label: AppLocalizations.of(context).home,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_books,
              key: Key(Keys.homeBottomBarRecipesIcon),
            ),
            label: AppLocalizations.of(context).recipes,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              key: Key(Keys.homeBottomBarListsIcon),
            ),
            label: AppLocalizations.of(context).lists,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  _body() {
    return Column(
      children: [
        _widgetOptions.elementAt(_selectedIndex),
      ],
    );
  }
}
