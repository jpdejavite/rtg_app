import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/bloc/grocery_lists/events.dart';
import 'package:rtg_app/bloc/grocery_lists/grocery_lists_bloc.dart';
import 'package:rtg_app/bloc/grocery_lists/states.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/grocery_lists_collection.dart';
import 'package:rtg_app/model/search_grocery_lists_params.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/widgets/loading.dart';
import 'package:rtg_app/widgets/loading_row.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'grocery_lists_row.dart';

class GroceryLists extends StatefulWidget {
  final Key key;
  final Function(GroceryList groceryList) onTapGroceryList;

  GroceryLists({this.key, this.onTapGroceryList});

  static newGroceryListsBloc(
      {Key key, final Function(GroceryList groceryList) onTapGroceryList}) {
    return BlocProvider(
      create: (context) =>
          GroceryListsBloc(groceryListsRepository: GroceryListsRepository()),
      child: GroceryLists(
        key: key,
        onTapGroceryList: onTapGroceryList,
      ),
    );
  }

  @override
  GroceryListsState createState() => GroceryListsState();
}

class GroceryListsState extends State<GroceryLists> {
  @override
  void initState() {
    super.initState();
    loadGroceryLists();
  }

  loadGroceryLists() async {
    context.read<GroceryListsBloc>().add(
          StartFetchGroceryListsEvent(
            SearchGroceryListsParams(offset: 0, limit: 20),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _body(),
    );
  }

  _body() {
    return Column(
      children: [
        BlocBuilder<GroceryListsBloc, GroceryListsListState>(
            builder: (BuildContext context, GroceryListsListState state) {
          // if (state is ReciesError) {
          //   final error = state.error;
          //   String message = '${error.message}\nTap to Retry.';
          //   return ErrorTxt(
          //     message: message,
          //     onTap: loadGroceryLists,
          //   );
          // }
          GroceryListsCollection groceryListsCollection;
          if (state is GroceryListsLoaded) {
            groceryListsCollection = state.groceryListsCollection;
          }

          if (groceryListsCollection == null ||
              groceryListsCollection.groceryLists == null) {
            return Loading();
          }

          if (groceryListsCollection.groceryLists.length > 0) {
            return _list(groceryListsCollection);
          }

          return Expanded(
            child: Center(
              child: Text(
                AppLocalizations.of(context).empty_grocery_list,
                key: Key(Keys.groceryListsEmptyText),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _list(GroceryListsCollection groceryListsCollection) {
    bool hasLoadedAll = (groceryListsCollection.groceryLists.length ==
        groceryListsCollection.total);
    return Expanded(
      child: ListView.builder(
        itemCount:
            groceryListsCollection.groceryLists.length + (hasLoadedAll ? 0 : 1),
        itemBuilder: (_, index) {
          if (index == groceryListsCollection.groceryLists.length) {
            context.read<GroceryListsBloc>().add(FetchGroceryListsEvent(
                SearchGroceryListsParams(
                    limit: 20,
                    offset: groceryListsCollection.groceryLists.length)));
            return LoadingRow();
          }

          GroceryList groceryList = groceryListsCollection.groceryLists[index];
          Widget groceryListRow = GroceryListListRow(
            groceryList: groceryList,
            index: index,
            onTap: (int i) {
              widget.onTapGroceryList(groceryListsCollection.groceryLists[i]);
            },
          );
          if (hasLoadedAll &&
              index == groceryListsCollection.groceryLists.length - 1) {
            return Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: groceryListRow,
            );
          }
          return groceryListRow;
        },
      ),
    );
  }
}
