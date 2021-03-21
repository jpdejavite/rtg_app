import 'dart:async';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;


final todoTABLE = 'Todo';

class SembastDatabaseProvider {
  static final SembastDatabaseProvider dbProvider = SembastDatabaseProvider();


  // File path to a file in the current directory
  String _dbKey = 'main_sembast.db';
  DatabaseFactory dbFactory = databaseFactoryIo;

  var _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
final appDocDir = await getApplicationDocumentsDirectory();
    await appDocDir.create(recursive: true);
    final path = p.join(appDocDir.path, _dbKey);

    // We use the database factory to open the database
    return await dbFactory.openDatabase(path);
  }
}
