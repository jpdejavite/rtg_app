import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;

class SettingsScreen extends StatefulWidget {
  static String id = 'settings_screen';

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  GoogleSignInAccount _currentUser;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId:
    //     '826451127529-aqcb4r7m1eu287iht0ugq86t1nmkuvo6.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/drive',
    ],
  );

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });

      if (_currentUser != null) {
        _handleGetContact(_currentUser);
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    print("Loading drive files...");
    final http.Response response = await http.get(
      Uri.parse('https://www.googleapis.com/drive/v3/files'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      print("People API gave a ${response.statusCode} "
          "response. Check logs for details.");
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    print('People API ${response.statusCode} response: ${response.body}');
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

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: Column(children: [
        Text(
            'configurações' + (_currentUser == null ? '' : _currentUser.email)),
        ElevatedButton(
          child: const Text('SIGN IN'),
          onPressed: _handleSignIn,
        ),
      ]),
    );
  }
}
