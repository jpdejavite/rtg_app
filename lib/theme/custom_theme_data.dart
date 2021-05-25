import 'package:flutter/material.dart';

import 'custom_colors.dart';

class CustomThemeData {
  static final iconTheme =
      ThemeData.light().iconTheme.copyWith(color: CustomColors.primaryColor);

  static final secondaryIconTheme =
      ThemeData.light().iconTheme.copyWith(color: Color(0xff04E9C6));

  static final lightTheme = ThemeData.light().copyWith(
    accentColor: CustomColors.primaryColor,
    iconTheme: iconTheme,
    primaryColor: CustomColors.primaryColor,
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all<Color>(CustomColors.primaryColor),
      overlayColor: MaterialStateProperty.all<Color>(CustomColors.primaryColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: CustomColors.ligthGrey,
      unselectedLabelStyle: TextStyle(
        color: CustomColors.ligthGrey,
      ),
    ),
    textTheme: ThemeData.light().textTheme.copyWith(
          headline4: ThemeData.light().textTheme.headline5.copyWith(
                fontSize: 22,
                color: CustomColors.darkRed,
                fontWeight: FontWeight.w700,
              ),
          headline5: ThemeData.light().textTheme.headline5.copyWith(
                fontSize: 18,
                color: CustomColors.darkRed,
                fontWeight: FontWeight.w400,
              ),
          headline6: ThemeData.light().textTheme.headline6.copyWith(
                fontSize: 16,
                color: CustomColors.darkRed,
                fontWeight: FontWeight.w500,
              ),
        ),
    colorScheme: ThemeData.light().colorScheme.copyWith(
          primary: CustomColors.primaryColor,
          primaryVariant: Color(0xffc40007),
          secondary: CustomColors.secondary,
          secondaryVariant: Color(0xff008f5d),
          surface: Color(0xffc40007),
          background: Color(0xfffbe9e7),
          error: ThemeData.light().errorColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.grey[700],
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
  );
}
