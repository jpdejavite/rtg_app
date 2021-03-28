import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/api/google_api.dart';
import 'package:rtg_app/bloc/settings/events.dart';
import 'package:rtg_app/bloc/settings/settings_bloc.dart';
import 'package:rtg_app/bloc/settings/states.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/repository/backup_repository.dart';
import 'package:rtg_app/widgets/view_recipe_label_text.dart';

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

  List<Widget> buildBackup(SettingsState state) {
    List<Widget> children = [
      Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          AppLocalizations.of(context).backup,
          style: Theme.of(context).textTheme.headline5,
        ),
      )
    ];

    Backup backup = state is BackupLoaded ? state.backup : null;
    String accountName = state is BackupLoaded ? state.accountName : null;
    if (backup != null && backup.type == BackupType.drive) {
      children.addAll([
        ViewRecipeLabelText(
          label: AppLocalizations.of(context).configured_at,
          text: AppLocalizations.of(context).google_drive,
        ),
        ViewRecipeLabelText(
          label: AppLocalizations.of(context).account,
          text: accountName,
        ),
      ]);

      if (backup.lastestBackupStatus == BackupStatus.pending) {
        children.addAll([
          ViewRecipeLabelText(
            label: AppLocalizations.of(context).status,
            text: AppLocalizations.of(context).pending_click_below_to_retry,
          ),
          ElevatedButton(
            child: Text(AppLocalizations.of(context).do_backup),
            onPressed: () {
              context.read<SettingsBloc>().add(DoDriveBackupEvent());
            },
          )
        ]);
      }
    } else {
      children.addAll([
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
      ]);
    }

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
            ...buildBackup(state),
          ],
        ),
      );
    });
  }
}
