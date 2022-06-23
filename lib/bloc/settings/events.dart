import 'package:equatable/equatable.dart';

abstract class SettingsEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetBackupEvent extends SettingsEvents {}

class ConfigureLocalBackupEvent extends SettingsEvents {}

class DoLocalBackupEvent extends SettingsEvents {}
