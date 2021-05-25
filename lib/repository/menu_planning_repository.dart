import 'dart:io';

import 'package:rtg_app/dao/menu_planning_dao.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/menu_planning.dart';
import 'package:rtg_app/model/menu_planning_collection.dart';
import 'package:rtg_app/model/save_menu_planning_response.dart';

class MenuPlanningRepository {
  final menuPlanningDao = MenuPlanningDao();

  Future<MenuPlanningCollection> fetch({int limit}) =>
      menuPlanningDao.fetch(limit: limit);

  Future<SaveMenuPlanningResponse> save(MenuPlanning menuPlanning) =>
      menuPlanningDao.save(menuPlanning: menuPlanning);

  Future deleteAll() => menuPlanningDao.deleteAll();

  Future mergeFromBackup({File file}) =>
      menuPlanningDao.mergeFromBackup(file: file);

  Future<DataSummary> getSummary({File file}) =>
      menuPlanningDao.getSummary(file: file);
}
