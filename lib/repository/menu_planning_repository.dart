import 'dart:io';

import 'package:rtg_app/dao/menu_planning_dao.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/menu_planning.dart';
import 'package:rtg_app/model/menu_planning_collection.dart';
import 'package:rtg_app/model/save_menu_planning_response.dart';
import 'package:rtg_app/model/search_menu_plannings_params.dart';

class MenuPlanningRepository {
  final menuPlanningDao = MenuPlanningDao();

  Future<MenuPlanningCollection> fetch(SearchMenuPlanningParams searchParams) =>
      menuPlanningDao.fetch(searchParams);

  Future<SaveMenuPlanningResponse> save(MenuPlanning menuPlanning) =>
      menuPlanningDao.save(menuPlanning: menuPlanning);

  Future deleteAll() => menuPlanningDao.deleteAll();

  Future mergeFromBackup({File file}) =>
      menuPlanningDao.mergeFromBackup(file: file);

  Future<DataSummary> getSummary({File file}) =>
      menuPlanningDao.getSummary(file: file);
}
