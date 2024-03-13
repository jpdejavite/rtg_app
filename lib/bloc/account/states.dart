import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/account.dart';

abstract class AccountState extends Equatable {
  @override
  List<Object> get props => [];
}

class AccountInitState extends AccountState {}

class AccountLoaded extends AccountState {
  final Account account;
  AccountLoaded({this.account});
  @override
  List<Object> get props => [account];
}
