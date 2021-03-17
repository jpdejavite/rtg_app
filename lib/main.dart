import 'package:flutter/material.dart';
import 'package:rtg_app/screens/home_screen.dart';
import 'package:rtg_app/screens/welcome_screen.dart';

void main() {
  runApp(RtgApp());
}

class RtgApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.light().copyWith(
      //   textTheme: TextTheme(
      //     bodyText1: TextStyle(color: Colors.red),
      //   ),
      // ),
      // home: BlocProvider(
      //   create: (context) => AlbumsBloc(albumsRepo: AlbumServices()),
      //   child: AlbumsScreen(),
      // ),
      initialRoute: HomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) {
          return WelcomeScreen();
        },
        HomeScreen.id: (context) {
          return HomeScreen();
        }
      },
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
