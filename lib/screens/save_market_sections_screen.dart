import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/bloc/save_market_sections/events.dart';
import 'package:rtg_app/bloc/save_market_sections/save_market_sections_bloc.dart';
import 'package:rtg_app/bloc/save_market_sections/states.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/market_section.dart';
import 'package:rtg_app/repository/market_section_repository.dart';
import 'package:rtg_app/widgets/market_section_item.dart';

class SaveMarketSectionsScreen extends StatefulWidget {
  static String id = 'save_market_sections_screen';

  SaveMarketSectionsScreen();

  static newSaveMarketSectionsBloc() {
    return BlocProvider(
      create: (context) => SaveMarketSectionsBloc(
        marketSectionRepository: MarketSectionRepository(),
      ),
      child: SaveMarketSectionsScreen(),
    );
  }

  @override
  _SaveMarketSectionsState createState() => _SaveMarketSectionsState();
}

class _SaveMarketSectionsState extends State<SaveMarketSectionsScreen> {
  List<MarketSection> editMarketSections = [];
  List<MarketSection> marketSectionsToDelete = [];
  Map<MarketSection, FocusNode> focusNodes;
  Map<MarketSection, TextEditingController> textEditingControllers;

  MarketSection itemToFocus;
  bool hasLoaded = false;

  @override
  void initState() {
    super.initState();
    context
        .read<SaveMarketSectionsBloc>()
        .add(LoadMarketSectionsInialDataEvent());

    focusNodes = Map();
    textEditingControllers = Map();

    itemToFocus = null;
  }

  void addFocusNode(MarketSection item) {
    FocusNode focusNode = FocusNode();
    focusNodes[item] = focusNode;
  }

  void addTextEditingController(MarketSection item) {
    textEditingControllers[item] = TextEditingController();
  }

  @override
  void dispose() {
    focusNodes.forEach((i, focus) {
      focus.dispose();
    });
    textEditingControllers.forEach((i, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).edit_market_sections),
      ),
      floatingActionButton: FloatingActionButton(
        key: Key(Keys.saveMarketSectionsFloatingActionSaveButton),
        onPressed: saveMarketSections,
        child: Icon(Icons.done),
      ),
      body: buildBody(),
    );
  }

  void saveMarketSections() {
    editMarketSections = editMarketSections
        .where((marketSection) =>
            marketSection.title != null && marketSection.title.length > 0)
        .toList();
    editMarketSections.asMap().forEach((index, _) {
      editMarketSections[index].groceryListOrder = index;
    });
    context.read<SaveMarketSectionsBloc>().add(SaveMarketSectionsEvent(
        marketSections: editMarketSections,
        marketSectionsToDelete: marketSectionsToDelete));
    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
      status: AppLocalizations.of(context).saving_market_section,
    );
  }

  Widget buildBody() {
    return BlocBuilder<SaveMarketSectionsBloc, SaveMarketSectionsState>(
        builder: (BuildContext context, SaveMarketSectionsState state) {
      if (state is InitalDataLoaded) {
        if (!hasLoaded) {
          editMarketSections = state.marketSections;
          editMarketSections.sort((m1, m2) {
            return Comparable.compare(m1.groceryListOrder, m2.groceryListOrder);
          });
          editMarketSections.forEach((ingredient) {
            addFocusNode(ingredient);
            addTextEditingController(ingredient);
          });
          hasLoaded = true;
        }
      } else if (state is MarketSectionsSaved) {
        EasyLoading.dismiss();
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            Navigator.of(context).pop();
          },
        );
      }

      return buildForm(context);
    });
  }

  MarketSectionItem newMarketSectionItem(
      MarketSection marketSection, int index) {
    return MarketSectionItem(
      key: Key('${Keys.saveMarketSectionsItem}-$index'),
      marketSection: marketSection,
      focusNode: focusNodes[marketSection],
      index: index,
      nameController: textEditingControllers[marketSection],
      onEdit: (MarketSection marketSection, int i) {
        editMarketSections[i] = marketSection;
      },
      onAddNewField: (int i) {
        setState(() {
          MarketSection newItem = MarketSection.newEmptyMarketSection();
          editMarketSections.insert(i + 1, newItem);
          addFocusNode(newItem);
          addTextEditingController(newItem);
          itemToFocus = newItem;
        });
      },
      onRemoveField: (i) {
        setState(() {
          MarketSection removedItem = editMarketSections.removeAt(i);
          marketSectionsToDelete.add(removedItem);
          focusNodes[removedItem].unfocus();
          focusNodes.remove(removedItem);
          textEditingControllers.remove(removedItem);

          itemToFocus = null;
        });
      },
    );
  }

  void onReorderListItems(oldIndex, newIndex) {
    // no change done
    if (oldIndex == newIndex) {
      return;
    }
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      MarketSection marketSection = editMarketSections.removeAt(oldIndex);
      editMarketSections.insert(newIndex, marketSection);
    });
  }

  Widget buildForm(BuildContext context) {
    List<Widget> children = [];

    if (itemToFocus != null) {
      focusNodes[itemToFocus].requestFocus();
    }

    editMarketSections.asMap().forEach((index, item) {
      children.add(newMarketSectionItem(item, index));
    });

    return Column(
      children: [
        Flexible(
          child: ReorderableListView(
            key: Key(Keys.saveMarketSectionsList),
            onReorder: onReorderListItems,
            children: children,
          ),
          flex: 1,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 50),
        )
      ],
    );
  }
}
