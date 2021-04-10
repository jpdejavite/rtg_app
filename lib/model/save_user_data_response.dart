import 'package:rtg_app/model/user_data.dart';

class SaveUserDataResponse {
  final error;
  final UserData userData;

  SaveUserDataResponse({this.error, this.userData});
}
