import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/bloc/save_menu_planning/events.dart';
import 'package:rtg_app/bloc/save_menu_planning/save_menu_planning_bloc.dart';
import 'package:rtg_app/bloc/save_menu_planning/states.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/helper/date_formatter.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/menu_planning.dart';
import 'package:rtg_app/model/menu_planning_meal.dart';
import 'package:rtg_app/model/menu_planning_meal_type.dart';
import 'package:rtg_app/model/menu_planning_meal_type_preparation.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/repository/menu_planning_repository.dart';
import 'package:rtg_app/widgets/custom_toast.dart';
import 'package:rtg_app/widgets/menu_planning_day.dart';
import 'package:rtg_app/widgets/menu_planning_meal_input.dart';
import 'package:rtg_app/widgets/text_form_section_label.dart';

import '../model/menu_planning_meal_input_action.dart';
import '../widgets/choose_menu_planning_day_dialog.dart';

class SaveMenuPlanningArguments {
  final MenuPlanning editMenuPlanning;
  final List<Recipe> menuPlanningRecipes;
  final List<Recipe> lastUsedGroceryListRecipes;

  SaveMenuPlanningArguments(this.editMenuPlanning, this.menuPlanningRecipes,
      this.lastUsedGroceryListRecipes);
}

class SaveMenuPlanningScreen extends StatefulWidget {
  static String id = 'save_menu_planning_screen';
  final SaveMenuPlanningArguments args;

  SaveMenuPlanningScreen(this.args);

  static newSaveMenuPlanningBloc(args) {
    return BlocProvider(
      create: (context) =>
          SaveMenuPlanningBloc(menuPlanningRepo: MenuPlanningRepository()),
      child: SaveMenuPlanningScreen(args),
    );
  }

  @override
  _SaveMenuPlanningState createState() => _SaveMenuPlanningState();
}

class _SaveMenuPlanningState extends State<SaveMenuPlanningScreen>
    with RestorationMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RestorableDateTime _startAtDate;
  DateTime _endAtDate;
  List<DateTime> days;
  Map<int, List<MenuPlanningMeal>> mealsMap;
  RestorableRouteFuture<DateTime> _restorableDatePickerRouteFuture;

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime initialDate =
            DateTime.fromMillisecondsSinceEpoch(arguments as int);
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: initialDate,
          firstDate: initialDate.subtract(Duration(days: 365)),
          lastDate: initialDate.add(Duration(days: 365)),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(_startAtDate, 'selected_date');
    registerForRestoration(
        getRestorableDatePickerRouteFuture(), 'date_picker_route_future');
  }

  RestorableRouteFuture<DateTime> getRestorableDatePickerRouteFuture() {
    if (_restorableDatePickerRouteFuture == null) {
      _restorableDatePickerRouteFuture = RestorableRouteFuture<DateTime>(
        onComplete: _selectStartAtDate,
        onPresent: (NavigatorState navigator, Object arguments) {
          return navigator.restorablePush(
            _datePickerRoute,
            arguments: _startAtDate.value.millisecondsSinceEpoch,
          );
        },
      );
    }
    return _restorableDatePickerRouteFuture;
  }

  @override
  String get restorationId => 'widget.save_menu_planning_screen';

  void _selectStartAtDate(DateTime newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _startAtDate.value = newSelectedDate;
        _endAtDate = _startAtDate.value.add(Duration(days: 6));

        int count = 0;
        for (DateTime b = DateTime.fromMicrosecondsSinceEpoch(
                newSelectedDate.microsecondsSinceEpoch);
            b.microsecondsSinceEpoch <= _endAtDate.microsecondsSinceEpoch;
            b = b.add(Duration(days: 1))) {
          if (count < days.length) {
            days[count] = b;
          }
          count++;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    days = [];
    mealsMap = Map();
    if (widget.args.editMenuPlanning == null) {
      DateTime now = DateTime.now();
      DateTime startAt = now.add(Duration(days: 1));
      _startAtDate = RestorableDateTime(startAt);
      _endAtDate = now.add(Duration(days: 7));
      int count = 0;
      for (DateTime b = DateTime.fromMicrosecondsSinceEpoch(
              startAt.microsecondsSinceEpoch);
          b.microsecondsSinceEpoch <= _endAtDate.microsecondsSinceEpoch;
          b = b.add(Duration(days: 1))) {
        days.add(b);
        mealsMap[count] = [];
        count++;
      }
    } else {
      _startAtDate = RestorableDateTime(
          DateTime.parse(widget.args.editMenuPlanning.startAt));
      _endAtDate = DateTime.parse(widget.args.editMenuPlanning.endAt);
      int count = 0;
      widget.args.editMenuPlanning.days.forEach((day, meals) {
        days.add(DateTime.parse(day));
        mealsMap[count] = meals;
        count++;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.args.editMenuPlanning == null
            ? AppLocalizations.of(context).new_menu_planning
            : AppLocalizations.of(context).edit_menu_planning),
      ),
      floatingActionButton: FloatingActionButton(
        key: Key(Keys.saveMenuPlanningFloatingActionSaveButton),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            context.read<SaveMenuPlanningBloc>().add(SaveMenuPlanningEvent(
                menuPlanning: getMenuPlanningFromInputs()));
            EasyLoading.show(
              maskType: EasyLoadingMaskType.black,
              status: AppLocalizations.of(context).saving_menu_planning,
            );
          }
        },
        child: Icon(Icons.done),
      ),
      body: buildBody(),
    );
  }

  MenuPlanning getMenuPlanningFromInputs() {
    Map<String, List<MenuPlanningMeal>> daysMap = Map();
    days.asMap().forEach((index, day) {
      daysMap[DateFormatter.formatDate(day, MenuPlanning.dateFormat)] =
          mealsMap[index];
    });

    return MenuPlanning(
      id: widget.args.editMenuPlanning != null
          ? widget.args.editMenuPlanning.id
          : null,
      createdAt: widget.args.editMenuPlanning != null
          ? widget.args.editMenuPlanning.createdAt
          : CustomDateTime.current.millisecondsSinceEpoch,
      updatedAt: CustomDateTime.current.millisecondsSinceEpoch,
      type: MenuPlanningType.week,
      startAt:
          DateFormatter.formatDate(_startAtDate.value, MenuPlanning.dateFormat),
      endAt: DateFormatter.formatDate(_endAtDate, MenuPlanning.dateFormat),
      days: daysMap,
    );
  }

  Widget buildBody() {
    return BlocBuilder<SaveMenuPlanningBloc, SaveMenuPlanningState>(
        builder: (BuildContext context, SaveMenuPlanningState state) {
      EasyLoading.dismiss();
      if (state is MenuPlanningSaved) {
        if (state.response.error != null) {
          CustomToast.showToast(
            text: AppLocalizations.of(context).generic_error_save_menu_planning,
            context: context,
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => Navigator.pop(context, state.response.menuPlanning));
        }
      }

      return buildForm(context);
    });
  }

  List<Widget> buildDateFields() {
    List<Widget> fields = [
      Row(
        children: [
          Text(
            AppLocalizations.of(context).start_at,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                DateFormatter.getMenuPlanningDayString(
                    _startAtDate.value, context),
                key: Key(Keys.saveMenuPlanningStartAtText),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            key: Key(Keys.saveMenuPlanningStartAtIcon),
            onPressed: () async {
              getRestorableDatePickerRouteFuture().present();
            },
          )
        ],
      ),
      Row(
        children: [
          Text(
            AppLocalizations.of(context).end_at,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                DateFormatter.getMenuPlanningDayString(_endAtDate, context),
                key: Key(Keys.saveMenuPlanningEndAtText),
              ),
            ),
          ),
        ],
      ),
    ];

    return fields;
  }

  void removeMeal(int dayIndex, int mealIndex) {
    setState(() {
      mealsMap[dayIndex].removeAt(mealIndex);
    });
  }

  void duplicateMeal(int mealIndex, MenuPlanningMeal meal) {
    ChooseMenuPlanningDayDialog.showChooseMenuPlanningDayDialog(
        title: AppLocalizations.of(context).duplicate_meal,
        context: context,
        days: days,
        onSelectDay: (int index) {
          setState(() {
            mealsMap[index].add(meal);
          });
        });
  }

  void moveMeal(int oldDayIndex, int mealIndex, MenuPlanningMeal meal) {
    ChooseMenuPlanningDayDialog.showChooseMenuPlanningDayDialog(
        title: AppLocalizations.of(context).move_meal,
        context: context,
        days: days,
        onSelectDay: (int newDayIndex) {
          setState(() {
            mealsMap[newDayIndex].add(meal);
            mealsMap[oldDayIndex].removeAt(mealIndex);
          });
        });
  }

  Widget buildForm(BuildContext context) {
    List<Widget> fields = [
      ...buildDateFields(),
      TextFormSectionLabelFields(AppLocalizations.of(context).days_caps),
    ];

    days.asMap().forEach((dayIndex, day) {
      fields.add(
        MenuPlanningDay(
          day: day,
          index: dayIndex,
          onAddMeal: () {
            setState(() {
              mealsMap[dayIndex].add(MenuPlanningMeal(
                  description: "",
                  preparation: MenuPlanningMealPreparation.cook,
                  type: defaultMenuPlanningMealTypeOption(mealsMap[dayIndex])));
            });
          },
        ),
      );
      mealsMap[dayIndex].asMap().forEach((mealIndex, meal) {
        fields.add(
          MenuPlanningMealInput(
            meal: meal,
            uniqueIndex: '$dayIndex-$mealIndex',
            onActionPressed: (MenuPlanningMealInputAction action) {
              switch (action) {
                case MenuPlanningMealInputAction.remove:
                  return removeMeal(dayIndex, mealIndex);
                case MenuPlanningMealInputAction.duplicate:
                  return duplicateMeal(mealIndex, meal);
                case MenuPlanningMealInputAction.move:
                  return moveMeal(dayIndex, mealIndex, meal);
              }
            },
            onUpdate: (newMeal) {
              mealsMap[dayIndex][mealIndex] = newMeal;
            },
            lastUsedGroceryListRecipes: widget.args.lastUsedGroceryListRecipes,
            menuPlanningRecipes: widget.args.menuPlanningRecipes,
          ),
        );
      });
    });

    // floating action button
    fields.add(SizedBox(
      height: 60,
    ));

    return Form(
      key: _formKey,
      child: Container(
        child: ListView(
          padding: EdgeInsets.all(5),
          shrinkWrap: true,
          children: fields,
        ),
      ),
    );
  }
}
