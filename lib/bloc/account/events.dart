import 'package:equatable/equatable.dart';

abstract class AccountEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAccountEvent extends AccountEvents {}
