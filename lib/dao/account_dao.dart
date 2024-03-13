import 'dart:async';
import 'package:rtg_app/database/sembast_database.dart';
import 'package:rtg_app/model/account.dart';
import 'package:rtg_app/model/save_account_response.dart';
import 'package:sembast/sembast.dart';

class AccountDao {
  final dbProvider = SembastDatabaseProvider.dbProvider;
  final String recordKey = 'account';

  Future<Account> getAccount() async {
    var store = StoreRef.main();
    var db = await dbProvider.database;

    var record = await store.record(recordKey).get(db);
    if (record == null) {
      Account account = Account.emptyAccount();
      await store.record(recordKey).put(db, account.toRecord());
      return account;
    }

    Account account = Account.fromRecord(record);
    return account;
  }

  Future deleteAll() async {
    var db = await dbProvider.database;
    await StoreRef.main().record(recordKey).delete(db);
  }

  Future<SaveAccountResponse> save({Account account}) async {
    try {
      var store = StoreRef.main();
      var db = await dbProvider.database;

      await store.record(recordKey).put(db, account.toRecord());

      return SaveAccountResponse(account: account);
    } catch (e) {
      return SaveAccountResponse(error: e);
    }
  }
}
