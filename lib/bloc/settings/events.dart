import 'package:equatable/equatable.dart';

abstract class SettingsEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetBackupEvent extends SettingsEvents {}

class ConfigureDriveBackupEvent extends SettingsEvents {}

class DoDriveBackupEvent extends SettingsEvents {}

class DriveBackupChoosenEvent extends SettingsEvents {
  final bool useLocal;
  DriveBackupChoosenEvent(this.useLocal);
}
