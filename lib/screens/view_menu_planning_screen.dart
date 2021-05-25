import 'package:flutter/material.dart';
import 'package:rtg_app/helper/date_formatter.dart';
import 'package:rtg_app/model/menu_planning.dart';
import 'package:rtg_app/model/recipe.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/screens/save_menu_planning_screen.dart';
import 'package:rtg_app/widgets/custom_toast.dart';
import 'package:rtg_app/widgets/menu_planning_days.dart';
import 'package:rtg_app/widgets/view_recipe_label_text.dart';

class ViewMenuPlanningArguments {
  MenuPlanning menuPlanning;
  final List<Recipe> menuPlanningRecipes;

  ViewMenuPlanningArguments(this.menuPlanning, this.menuPlanningRecipes);
}

class ViewMenuPlanningScreen extends StatefulWidget {
  static String id = 'view_menu_planning_screen';

  final ViewMenuPlanningArguments args;

  ViewMenuPlanningScreen(this.args);

  @override
  _ViewMenuPlanningState createState() => _ViewMenuPlanningState();
}

class _ViewMenuPlanningState extends State<ViewMenuPlanningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).recipe_menu_planning),
      ),
      floatingActionButton: buildFloatingActionButton(),
      body: buildBody(),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      key: Key(Keys.viewMenuPlanningFloatingActionEditButton),
      onPressed: () async {
        final result = await Navigator.pushNamed(
          context,
          SaveMenuPlanningScreen.id,
          arguments: SaveMenuPlanningArguments(
              widget.args.menuPlanning, widget.args.menuPlanningRecipes, null),
        );
        if (result != null && result is MenuPlanning) {
          CustomToast.showToast(
            text: AppLocalizations.of(context).saved_menu_planning,
            context: context,
            time: CustomToast.timeShort,
          );
          setState(() {
            widget.args.menuPlanning = result;
          });
        }
      },
      child: Icon(Icons.edit),
    );
  }

  Widget buildBody() {
    DateTime starAt = DateTime.parse(widget.args.menuPlanning.startAt);
    DateTime endAt = DateTime.parse(widget.args.menuPlanning.endAt);
    return ListView(
      padding: EdgeInsets.all(5),
      shrinkWrap: true,
      children: [
        ViewRecipeLabelText(
          keyString: Keys.viewMenuPlanningStartAtLabelText,
          label: AppLocalizations.of(context).start_at,
          text: DateFormatter.getMenuPlanningDayString(starAt, context),
        ),
        ViewRecipeLabelText(
          keyString: Keys.viewMenuPlanningEndAtLabelText,
          label: AppLocalizations.of(context).end_at,
          text: DateFormatter.getMenuPlanningDayString(endAt, context),
        ),
        SizedBox(height: 16),
        MenuPlannningDays(
            widget.args.menuPlanning.days, widget.args.menuPlanningRecipes),
        Padding(
          padding: EdgeInsets.only(bottom: 80),
        ),
      ],
    );
  }
}
