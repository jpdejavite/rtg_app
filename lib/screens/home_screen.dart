import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/bloc/recipes/recipes_bloc.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

import 'package:rtg_app/widgets/recipes_list_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'edit_recipe_screen.dart';

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
  List<BottomBarNavigationOptions> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _widgetOptions = [
      BottomBarNavigationOptions(
        body: Expanded(
          child: Center(
            child: Text(
              'Index 0: Home',
              style: optionStyle,
              key: Key(Keys.homeBottomBarHomeText),
            ),
          ),
        ),
      ),
      BottomBarNavigationOptions(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, EditRecipeScreen.id);
          },
          child: Icon(Icons.add),
        ),
        body: BlocProvider(
          create: (context) => RecipesBloc(recipesRepo: RecipesRepository()),
          child: RecipesList(),
        ),
      ),
      BottomBarNavigationOptions(
        body: Text(
          'Index 2: School',
          style: optionStyle,
          key: Key(Keys.homeBottomBarListsText),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).home),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Open app settings',
            onPressed: () {
              print('go to settings');
            },
          ),
        ],
      ),
      body: Container(
        child: _body(),
      ),
      floatingActionButton:
          _widgetOptions.elementAt(_selectedIndex).floatingActionButton,
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
        _widgetOptions.elementAt(_selectedIndex).body,
      ],
    );
  }
}

class BottomBarNavigationOptions {
  final Widget body;
  final FloatingActionButton floatingActionButton;
  BottomBarNavigationOptions({this.body, this.floatingActionButton});
}
