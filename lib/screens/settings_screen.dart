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
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/repository/backup_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:rtg_app/widgets/view_recipe_label_text.dart';
import 'package:rtg_app/widgets/view_recipe_text.dart';
import 'package:sprintf/sprintf.dart';

class SettingsScreen extends StatefulWidget {
  static String id = 'settings_screen';

  static newSettingsBloc() {
    return BlocProvider(
      create: (context) => SettingsBloc(
        backupRepository: BackupRepository(),
        googleApi: GoogleApi.getGoogleApi(),
        recipesRepository: RecipesRepository(),
      ),
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

  Future<void> _showChooseDriveBackup(
      BuildContext ctx, ChooseDriveBackup state) async {
    String localRecipesLastUpdatedAt = "";
    if (state.localSummary.recipes.lastUpdated > 0) {
      final DateTime lastUpdated = DateTime.fromMillisecondsSinceEpoch(
          state.localSummary.recipes.lastUpdated);
      localRecipesLastUpdatedAt =
          DateFormat(AppLocalizations.of(context).backup_at_format)
              .format(lastUpdated);
    }

    String remoteRecipesLastUpdatedAt = "";
    if (state.localSummary.recipes.lastUpdated > 0) {
      final DateTime lastUpdated = DateTime.fromMillisecondsSinceEpoch(
          state.remoteSummary.recipes.lastUpdated);
      remoteRecipesLastUpdatedAt =
          DateFormat(AppLocalizations.of(context).backup_at_format)
              .format(lastUpdated);
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).backup_conflict),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context).backup_conflict_explanation),
                ViewRecipeLabelText(
                  label: AppLocalizations.of(context).local_version,
                  text: sprintf(
                      AppLocalizations.of(context).backup_conflict_details, [
                    state.localSummary.recipes.total,
                    localRecipesLastUpdatedAt
                  ]),
                ),
                ViewRecipeLabelText(
                  label: AppLocalizations.of(context).remote_version,
                  text: sprintf(
                      AppLocalizations.of(context).backup_conflict_details, [
                    state.remoteSummary.recipes.total,
                    remoteRecipesLastUpdatedAt
                  ]),
                ),
                Text(AppLocalizations.of(context).backup_conflict_choose),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).use_local_version),
              onPressed: () {
                Navigator.of(context).pop();
                showChooseDriveBackupConfirmation(ctx, true);
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context).use_remote_version),
              onPressed: () {
                Navigator.of(context).pop();
                showChooseDriveBackupConfirmation(ctx, false);
              },
            ),
          ],
        );
      },
    );
  }

  void showChooseDriveBackupConfirmation(BuildContext ctx, bool useLocal) {
    showDialog<void>(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(sprintf(AppLocalizations.of(context).confirm_version_title, [
            useLocal
                ? AppLocalizations.of(context).local_version
                : AppLocalizations.of(context).remote_version
          ])),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(useLocal
                    ? AppLocalizations.of(context).confirm_local_version
                    : AppLocalizations.of(context).confirm_remote_version),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context).confirm),
              onPressed: () {
                Navigator.of(context).pop();
                ctx.read<SettingsBloc>().add(DriveBackupChoosenEvent(useLocal));
              },
            ),
          ],
        );
      },
    );
  }

  void showChooseDriveBackup(BuildContext context, SettingsState state) {
    if (state is ChooseDriveBackup) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _showChooseDriveBackup(context, state));
    }
  }

  void showLoading(SettingsState state) {
    if (state is DoingDriveBackup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        EasyLoading.show(
          maskType: EasyLoadingMaskType.black,
          status: AppLocalizations.of(context).doing_backup,
        );
      });
    } else {
      EasyLoading.dismiss();
    }
  }

  List<Widget> buildBackupSection(BuildContext context, SettingsState state) {
    List<Widget> children = [
      Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          AppLocalizations.of(context).backup,
          style: Theme.of(context).textTheme.headline5,
        ),
      )
    ];

    showStateError(state);

    showLoading(state);

    showChooseDriveBackup(context, state);

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
        key: Key(Keys.settingsGoogleDriveButtton),
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
            ...buildBackupSection(context, state),
          ],
        ),
      );
    });
  }
}
