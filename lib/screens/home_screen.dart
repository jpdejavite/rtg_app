import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/api/services.dart';
import 'package:rtg_app/bloc/recipes/bloc.dart';
import 'dart:developer';

import 'package:rtg_app/widgets/recipes_list_widget.dart';

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
        title: Text('Início'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Open app settings',
            onPressed: () {
              // handle the press
              log('go to setting');
            },
          ),
        ],
      ),
      body: Container(
        child: _body(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Receitas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Listas',
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
