import 'package:rtg_app/dao/user_data_dao.dart';
import 'package:rtg_app/model/save_user_data_response.dart';
import 'package:rtg_app/model/user_data.dart';

class UserDataRepository {
  final userDataDao = UserDataDao();

  Future<UserData> getUserData() => userDataDao.getUserData();

  Future<SaveUserDataResponse> save(UserData userData) =>
      userDataDao.save(userData);

  Future deleteAll() => userDataDao.deleteAll();
}
