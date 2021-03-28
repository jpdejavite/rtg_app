import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import "package:http/http.dart" as http;
import 'package:rtg_app/database/sembast_database.dart';

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
      print('id ${f.id} , name ${f.name} ');
      if (f.name == backupFileName) {
        file = f;
      }
    });

    return file;

    // final Stream<List<int>> mediaStream =
    //     Future.value([104, 105]).asStream().asBroadcastStream();
    // var media = new drive.Media(mediaStream, 2);
    // var driveFile = new drive.File();
    // driveFile.name = "hello_world.txt";
    // final result = await driveApi.files.create(driveFile, uploadMedia: media);
    // print("Upload result: $result");

    // print("Loading drive files...");
    // final http.Response response = await http.get(
    //   Uri.parse('https://www.googleapis.com/drive/v3/files'),
    //   headers: await _currentUser.authHeaders,
    // );
    // if (response.statusCode != 200) {
    //   print("People API gave a ${response.statusCode} "
    //       "response. Check logs for details.");
    //   print('People API ${response.statusCode} response: ${response.body}');
    //   return null;
    // }
    // final driveFilesResponse = json.decode(response.body);

    // GoogleDriveFile file;
    // var fileJson = driveFilesResponse['files'];
    // if (fileJson != null && fileJson is List<Object>) {
    //   fileJson.forEach((jsonObject) {
    //     print(jsonObject);
    //     if (jsonObject is Map<String, Object>) {
    //       GoogleDriveFile googleDriveFile =
    //           GoogleDriveFile.fromJson(jsonObject);
    //       print('id ${googleDriveFile.id} , name ${googleDriveFile.name} ');
    //       if (googleDriveFile.name == backupFileName) {
    //         file = googleDriveFile;
    //       }
    //     }
    //   });
    // }

    // return file;
    // final Map<String, dynamic> data = json.decode(response.body);
    // final String? namedContact = _pickFirstNamedContact(data);
    // setState(() {
    //   if (namedContact != null) {
    //     _contactText = "I see you know $namedContact!";
    //   } else {
    //     _contactText = "No contacts to display.";
    //   }
    // });
  }

  Future<void> doBackupOnDrive() async {
    final authHeaders = await _currentUser.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    final uploadFile = File(await dbProvider.getDatabaseFilePath());
    var media = new drive.Media(uploadFile.openRead(), uploadFile.lengthSync());
    var driveFile = new drive.File();
    driveFile.name = backupFileName;
    driveFile.description = 'Arquivo de backup do app rtg';
    final result = await driveApi.files.create(driveFile, uploadMedia: media);
    print("Upload result: $result");

    // print("Loading drive files...");
    // final http.Response response = await http.get(
    //   Uri.parse('https://www.googleapis.com/drive/v3/files'),
    //   headers: await _currentUser.authHeaders,
    // );
    // if (response.statusCode != 200) {
    //   print("People API gave a ${response.statusCode} "
    //       "response. Check logs for details.");
    //   print('People API ${response.statusCode} response: ${response.body}');
    //   return null;
    // }
    // final driveFilesResponse = json.decode(response.body);

    // GoogleDriveFile file;
    // var fileJson = driveFilesResponse['files'];
    // if (fileJson != null && fileJson is List<Object>) {
    //   fileJson.forEach((jsonObject) {
    //     print(jsonObject);
    //     if (jsonObject is Map<String, Object>) {
    //       GoogleDriveFile googleDriveFile =
    //           GoogleDriveFile.fromJson(jsonObject);
    //       print('id ${googleDriveFile.id} , name ${googleDriveFile.name} ');
    //       if (googleDriveFile.name == backupFileName) {
    //         file = googleDriveFile;
    //       }
    //     }
    //   });
    // }

    // return file;
    // final Map<String, dynamic> data = json.decode(response.body);
    // final String? namedContact = _pickFirstNamedContact(data);
    // setState(() {
    //   if (namedContact != null) {
    //     _contactText = "I see you know $namedContact!";
    //   } else {
    //     _contactText = "No contacts to display.";
    //   }
    // });
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

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = new http.Client();

  GoogleAuthClient(this._headers);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class NotFoundError extends Error {
  @override
  String toString() {
    return "not found";
  }
}
