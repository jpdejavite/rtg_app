import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/bloc/account/account_bloc.dart';
import 'package:rtg_app/bloc/account/events.dart';
import 'package:rtg_app/bloc/account/states.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/account.dart';
import 'package:rtg_app/repository/account_repository.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountScreen extends StatefulWidget {
  static String id = 'account_screen';

  static newAccountBloc() {
    return BlocProvider(
      create: (context) => AccountBloc(
        accountRepository: AccountRepository(),
      ),
      child: AccountScreen(),
    );
  }

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(GetAccountEvent());
    print("GetAccountEvent ");
  }

  Account getAccountFromState(AccountState state) {
    if (state is AccountLoaded) {
      return state.account;
    }
    return null;
  }

  Future<User> signInWithGoogle() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        print('got user->$FirebaseAuth.instance.currentUser');
        return FirebaseAuth.instance.currentUser;
      }

      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      return FirebaseAuth.instance.currentUser;
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
  }

  List<Widget> buildAccountInfo(BuildContext context, AccountState state) {
    List<Widget> children = [
      Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          AppLocalizations.of(context).account,
          style: Theme.of(context).textTheme.headline5,
        ),
      )
    ];

    Account account = getAccountFromState(state);

    if (account != null) {
      children.addAll(buildConfigureAccountFields());
    }

    return children;
  }

  List<Widget> buildConfigureAccountFields() {
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
        onPressed: () async {
          User user = await signInWithGoogle();
          if (user != null) print(user.email);
          print(user.uid);

          try {
            FirebaseFirestore db = FirebaseFirestore.instance;
            DocumentSnapshot doc =
                await db.collection('users/asdas/recipes').doc('uuid-v4').get();

            print("${doc.id} => ${doc.data()}");
            // context.read<AccountBloc>().add(ConfigureLocalAccountEvent());
          } on Exception catch (e) {
            // TODO
            print('recipes exception->$e');
          }
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
        builder: (BuildContext context, AccountState state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).account),
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          shrinkWrap: true,
          children: [
            ...buildAccountInfo(context, state),
          ],
        ),
      );
    });
  }
}
