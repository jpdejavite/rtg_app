import 'package:rtg_app/dao/recipes_dao.dart';
import 'package:rtg_app/database/sembast_database.dart';

class DatbaseHelper {
  static final dbProvider = SembastDatabaseProvider.dbProvider;

  static final RecipesDao recipesDao = RecipesDao();

  static initDB(String user) async {
    recipesDao.deleteAll();
    // await db.transaction((txn) async {
    //   for (int i = 0; i < 200; i++) {
    //     await store.add(txn, {
    //       'title': 'Receita ' + i.toString().padLeft(3, '0'),
    //       'createdAt': CustomDateTime.current.millisecondsSinceEpoch,
    //       'updatedAt': CustomDateTime.current.millisecondsSinceEpoch,
    //       'instructions': 'Instrucao' + i.toString().padLeft(3, '0'),
    //       'ingredients': [
    //         {
    //           'quantity': 1,
    //           'name': 'Ingrediente-1-' + i.toString().padLeft(3, '0')
    //         },
    //         {
    //           'quantity': 2,
    //           'name': 'Ingrediente-2-' + i.toString().padLeft(3, '0')
    //         },
    //         {
    //           'quantity': 3,
    //           'name': 'Ingrediente-3-' + i.toString().padLeft(3, '0')
    //         }
    //       ]
    //     });
    //   }
    // });
  }
}
