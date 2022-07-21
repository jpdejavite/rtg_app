import 'package:rtg_app/dao/recipes_dao.dart';
import 'package:rtg_app/database/sembast_database.dart';

class DatbaseHelper {
  static final dbProvider = SembastDatabaseProvider.dbProvider;

  static final RecipesDao recipesDao = RecipesDao();

  static initDB(String user) async {
    recipesDao.deleteAll();
  }
}
