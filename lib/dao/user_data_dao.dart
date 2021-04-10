import 'dart:async';
import 'package:rtg_app/database/sembast_database.dart';
import 'package:rtg_app/model/save_user_data_response.dart';
import 'package:rtg_app/model/user_data.dart';
import 'package:sembast/sembast.dart';

class UserDataDao {
  final dbProvider = SembastDatabaseProvider.dbProvider;
  final String recordKey = 'user_data';

  Future<UserData> getUserData() async {
    var store = StoreRef.main();
    var db = await dbProvider.database;

    var record = await store.record(recordKey).get(db);
    if (record == null) {
      UserData userData = UserData(
        dimissRecipeTutorial: false,
      );
      await store.record(recordKey).put(db, userData.toRecord());
      return userData;
    }

    UserData userData = UserData.fromRecord(record);
    return userData;
  }

  Future deleteAll() async {
    var db = await dbProvider.database;
    await StoreRef.main().record(recordKey).delete(db);
  }

  Future<SaveUserDataResponse> save(UserData userData) async {
    try {
      var store = StoreRef.main();
      var db = await dbProvider.database;

      await store.record(recordKey).put(db, userData.toRecord());

      return SaveUserDataResponse(userData: userData);
    } catch (e) {
      return SaveUserDataResponse(error: e);
    }
  }
}
