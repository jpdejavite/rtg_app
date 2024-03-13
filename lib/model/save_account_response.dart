import 'package:rtg_app/model/account.dart';

class SaveAccountResponse {
  final error;
  final Account account;

  SaveAccountResponse({this.error, this.account});
}
