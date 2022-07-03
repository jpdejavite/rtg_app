import 'dart:io';

import 'package:rtg_app/dao/recipe_label_dao.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/recipe_label.dart';

import '../model/save_recipe_label_response.dart';

class RecipeLabelRepository {
  final recipeLabelDao = RecipeLabelDao();

  Future<List<RecipeLabel>> getAll() => recipeLabelDao.getAll();

  Future<SaveRecipeLabelResponse> save({RecipeLabel label}) =>
      recipeLabelDao.save(label: label);

  Future deleteAll() => recipeLabelDao.deleteAll();

  Future mergeFromBackup({File file}) =>
      recipeLabelDao.mergeFromBackup(file: file);

  Future<DataSummary> getSummary({File file}) =>
      recipeLabelDao.getSummary(file: file);
}
