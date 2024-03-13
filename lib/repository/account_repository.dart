import 'package:rtg_app/dao/account_dao.dart';
import 'package:rtg_app/model/account.dart';
import 'package:rtg_app/model/save_account_response.dart';

class AccountRepository {
  final accountDao = AccountDao();

  Future<Account> getAccount() => accountDao.getAccount();

  Future<SaveAccountResponse> save({Account account}) =>
      accountDao.save(account: account);

  Future deleteAll() => accountDao.deleteAll();
}
