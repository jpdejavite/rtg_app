import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:rtg_app/api/google_api.dart';
import 'package:rtg_app/bloc/settings/events.dart';
import 'package:rtg_app/bloc/settings/settings_bloc.dart';
import 'package:rtg_app/bloc/settings/states.dart';
import 'package:rtg_app/errors/errors.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/repository/backup_repository.dart';
import 'package:rtg_app/widgets/view_recipe_label_text.dart';
import 'package:rtg_app/widgets/view_recipe_text.dart';

class SettingsScreen extends StatefulWidget {
  static String id = 'settings_screen';

  static newSettingsBloc() {
    return BlocProvider(
      create: (context) => SettingsBloc(
          backupRepository: BackupRepository(),
          googleApi: GoogleApi.getGoogleApi()),
      child: SettingsScreen(),
    );
  }

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(GetBackupEvent());
  }

  Backup getBackupFromEvent(SettingsState state) {
    if (state is BackupLoaded) {
      return state.backup;
    }
    return null;
  }

  String getAccountNameFromEvent(SettingsState state) {
    if (state is BackupLoaded) {
      return state.accountName;
    }
    return null;
  }

  void showStateError(SettingsState state) {
    if (state is ConfigureDriveBackupError) {
      Error e = state.error;
      String message = e.toString();
      if (e is NotFoundError) {
        message = AppLocalizations.of(context).google_user_not_authenticated;
      }

      EasyLoading.showError(message);
      return;
    } else {
      EasyLoading.dismiss();
    }
  }

  void showLoading(SettingsState state) {
    if (state is DoingDriveBackup) {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        status: AppLocalizations.of(context).doing_backup,
      );
    } else {
      EasyLoading.dismiss();
    }
  }

  List<Widget> buildBackupSection(SettingsState state) {
    List<Widget> children = [
      Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          AppLocalizations.of(context).backup,
          style: Theme.of(context).textTheme.headline5,
        ),
      )
    ];

    showLoading(state);

    showStateError(state);

    Backup backup = getBackupFromEvent(state);
    String accountName = getAccountNameFromEvent(state);
    if (backup != null && backup.type == BackupType.drive) {
      children.addAll(buildBackupDriveFields(backup, accountName));
    } else {
      children.addAll(buildConfigureBackupFields());
    }

    return children;
  }

  List<Widget> buildConfigureBackupFields() {
    return [
      Padding(
        padding: EdgeInsets.only(top: 10, bottom: 5),
        child: Text(
          AppLocalizations.of(context).configure_backup,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      ElevatedButton(
        child: Text(AppLocalizations.of(context).google_drive),
        onPressed: () {
          context.read<SettingsBloc>().add(ConfigureDriveBackupEvent());
        },
      )
    ];
  }

  List<Widget> buildBackupDriveFields(Backup backup, String accountName) {
    List<Widget> children = [
      ViewRecipeLabelText(
        label: AppLocalizations.of(context).configured_at,
        text: AppLocalizations.of(context).google_drive,
      ),
      ViewRecipeLabelText(
        label: AppLocalizations.of(context).account,
        text: accountName,
      ),
    ];

    if (backup.lastestBackupStatus == BackupStatus.pending ||
        backup.lastestBackupStatus == BackupStatus.error) {
      children.add(ViewRecipeLabelText(
        label: AppLocalizations.of(context).status,
        text: backup.lastestBackupStatus == BackupStatus.error
            ? AppLocalizations.of(context).backup_error_occurred
            : AppLocalizations.of(context).pending_click_below_to_retry,
      ));

      if (backup.lastestBackupStatus == BackupStatus.error) {
        children.add(ViewRecipeText(
          hasBullet: false,
          hasPaddingTop: true,
          text: backup.error,
        ));
      }
    }

    if (backup.lastestBackupAt != null && backup.lastestBackupAt > 0) {
      final DateTime lastestBackupAt =
          DateTime.fromMillisecondsSinceEpoch(backup.lastestBackupAt);
      children.add(ViewRecipeLabelText(
        label: AppLocalizations.of(context).done_at,
        text: DateFormat(AppLocalizations.of(context).backup_at_format)
            .format(lastestBackupAt),
      ));
    }

    children.add(ElevatedButton(
      child: Text(AppLocalizations.of(context).do_backup),
      onPressed: () {
        context.read<SettingsBloc>().add(DoDriveBackupEvent());
      },
    ));
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
        builder: (BuildContext context, SettingsState state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).settings),
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          shrinkWrap: true,
          children: [
            ...buildBackupSection(state),
          ],
        ),
      );
    });
  }
}
