import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

import 'package:rtg_app/database/sembast_database.dart';
import 'package:rtg_app/errors/errors.dart';

import 'google_auth_client.dart';

class GoogleApi {
  final dbProvider = SembastDatabaseProvider.dbProvider;

  static final String backupFileName = 'rtg_app_backup.bkp';

  static GoogleSignInAccount _currentUser;

  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      drive.DriveApi.driveScope,
    ],
  );

  static GoogleApi _googleApi;

  static GoogleApi getGoogleApi() {
    if (_googleApi != null) {
      return _googleApi;
    }

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _currentUser = account;
    });
    _googleSignIn.signInSilently();

    return GoogleApi();
  }

  String getAccountName() {
    if (_currentUser != null) {
      return _currentUser.email;
    }
    return '';
  }

  Future<drive.File> getBackupOnDrive() async {
    final authHeaders = await _currentUser.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    drive.File file;
    drive.FileList files = await driveApi.files.list();
    files.files.forEach((f) {
      if (f.name == backupFileName) {
        file = f;
      }
    });

    return file;
  }

  Future<drive.File> doBackupOnDrive() async {
    final driveApi = await getDriveApi();
    final result = await driveApi.files
        .create(buildDriveFile(), uploadMedia: await buildDriveMedia());
    return result;
  }

  Future<drive.File> updateBackupOnDrive(String fileId) async {
    final driveApi = await getDriveApi();
    final result = await driveApi.files
        .update(buildDriveFile(), fileId, uploadMedia: await buildDriveMedia());
    return result;
  }

  Future<drive.Media> buildDriveMedia() async {
    final uploadFile = File(await dbProvider.getDatabaseFilePath());
    return new drive.Media(uploadFile.openRead(), uploadFile.lengthSync());
  }

  drive.File buildDriveFile() {
    var driveFile = new drive.File();
    driveFile.name = backupFileName;
    driveFile.description = 'Arquivo de backup do app rtg';
    return driveFile;
  }

  Future<drive.DriveApi> getDriveApi() async {
    final authHeaders = await _currentUser.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    return drive.DriveApi(authenticateClient);
  }

  Future<Error> signIn() async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      if (account == null) {
        return NotFoundError();
      }
      _currentUser = account;
      return null;
    } catch (e) {
      return e;
    }
  }

  Future<void> logout() async {
    return _googleSignIn.disconnect();
  }
}
