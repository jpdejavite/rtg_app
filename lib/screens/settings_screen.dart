import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/bloc/settings/events.dart';
import 'package:rtg_app/bloc/settings/settings_bloc.dart';
import 'package:rtg_app/bloc/settings/states.dart';
import 'package:rtg_app/helper/date_formatter.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/repository/backup_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:rtg_app/widgets/view_recipe_label_text.dart';
import 'package:rtg_app/widgets/view_recipe_text.dart';
import 'package:share_plus/share_plus.dart';

import '../errors/errors.dart';
import '../helper/env_helper.dart';
import '../theme/custom_colors.dart';
import '../widgets/custom_toast.dart';

class SettingsScreen extends StatefulWidget {
  static String id = 'settings_screen';

  static newSettingsBloc() {
    return BlocProvider(
      create: (context) => SettingsBloc(
        backupRepository: BackupRepository(),
        recipesRepository: RecipesRepository(),
      ),
      child: SettingsScreen(),
    );
  }

  @override
  _SettingsState createState() => _SettingsState();
}

class BackupDetails {
  String configuredAtText;
  String doBackupText;

  BackupDetails({this.configuredAtText, this.doBackupText});
}

class _SettingsState extends State<SettingsScreen> {
  static Map<BackupType, BackupDetails> _backupDetails = new Map();

  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(GetBackupEvent());
  }

  void buildBackupDetailsMap() {
    _backupDetails[BackupType.drive] = BackupDetails(
      configuredAtText: AppLocalizations.of(context).google_drive,
      doBackupText: AppLocalizations.of(context).do_backup,
    );
    _backupDetails[BackupType.local] = BackupDetails(
      configuredAtText: AppLocalizations.of(context).local,
      doBackupText: AppLocalizations.of(context).generate_local_file,
    );
  }

  Backup getBackupFromState(SettingsState state) {
    if (state is BackupLoaded) {
      return state.backup;
    }
    return null;
  }

  String getFilePathFromState(SettingsState state) {
    if (state is LocalBackupDone) {
      return state.filePath;
    }
    return null;
  }

  void processErrorFromState(SettingsState state) {
    if (state is ImportBackupDone) {
      Error error = state.error;
      if (error != null) {
        CustomToast.showToast(
          text: (error is InvalidBackupFile)
              ? AppLocalizations.of(context).wrong_file_extension_for_backup
              : AppLocalizations.of(context).error_to_import_file,
          context: context,
          time: CustomToast.timeShort,
        );
      } else {
        CustomToast.showToast(
          text: AppLocalizations.of(context).file_successfully_imported,
          context: context,
          time: CustomToast.timeShort,
        );
      }
    }
    return null;
  }

  List<Widget> buildBackupSection(BuildContext context, SettingsState state) {
    buildBackupDetailsMap();

    List<Widget> children = [
      Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          AppLocalizations.of(context).backup,
          style: Theme.of(context).textTheme.headline5,
        ),
      )
    ];

    Backup backup = getBackupFromState(state);
    if (backup != null && backup.type != BackupType.none) {
      children.addAll(buildBackupFields(backup, state));
    } else {
      children.addAll(buildConfigureBackupFields());
    }
    processErrorFromState(state);

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
        key: Key(Keys.settingsLocalButtton),
        child: Text(AppLocalizations.of(context).generate_local_file),
        onPressed: () {
          context.read<SettingsBloc>().add(ConfigureLocalBackupEvent());
        },
      )
    ];
  }

  List<Widget> buildBackupFields(Backup backup, SettingsState state) {
    List<Widget> children = [
      ViewRecipeLabelText(
        keyString: Keys.settingsConfiguredAtText,
        label: AppLocalizations.of(context).configured_at,
        text: _backupDetails[backup.type].configuredAtText,
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
      children.add(ViewRecipeLabelText(
        label: AppLocalizations.of(context).done_at,
        text: DateFormatter.formatDateInMili(backup.lastestBackupAt,
            AppLocalizations.of(context).backup_at_format),
      ));
    }

    String filePath = getFilePathFromState(state);
    if (filePath != null) {
      if (EnvHelper.isShareBackupFileEnabled()) {
        Share.shareFiles([filePath],
            text: AppLocalizations.of(context).backup_file_name);
      }
    }

    children.add(ElevatedButton(
      key: Key(Keys.settingsDoBackupButton),
      child: Text(_backupDetails[backup.type].doBackupText),
      onPressed: () {
        context.read<SettingsBloc>().add(DoLocalBackupEvent());
      },
    ));
    children.add(ElevatedButton(
      key: Key(Keys.settingsImportBackupButton),
      child: Text(AppLocalizations.of(context).import_local_file),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(CustomColors.ligthGrey),
      ),
      onPressed: () async {
        FilePickerResult result = await FilePicker.platform.pickFiles();

        if (result == null) {
          CustomToast.showToast(
            text: AppLocalizations.of(context).not_possible_to_read_file,
            context: context,
            time: CustomToast.timeShort,
          );
          return;
        }
        context
            .read<SettingsBloc>()
            .add(ImportLocalBackupEvent(result.files.single.path));
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
