import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/model/account.dart';
import 'package:rtg_app/repository/account_repository.dart';

import 'events.dart';
import 'states.dart';

class AccountBloc extends Bloc<AccountEvents, AccountState> {
  final AccountRepository accountRepository;
  AccountBloc({
    @required this.accountRepository,
  }) : super(AccountInitState());

  @override
  Stream<AccountState> mapEventToState(AccountEvents event) async* {
    if (event is GetAccountEvent) {
      yield await getAccountEvent(event);
      return;
    }
  }

  Future<AccountLoaded> getAccountEvent(AccountEvents event) async {
    Account account = await accountRepository.getAccount();
    return AccountLoaded(account: account);
  }
}
