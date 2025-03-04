import 'package:flutter/material.dart';

import 'custom_theme/text_theme.dart';
import 'custom_theme/elevated_button_theme.dart';

import 'custom_theme/outlined_button_theme.dart';
import 'custom_theme/text_field_theme.dart';
import 'custom_theme/checkbox_theme.dart';
import 'custom_theme/chip_theme.dart';
import 'custom_theme/appbar_theme.dart';
import 'custom_theme/bottom_sheet_theme.dart';


class TAppTheme {
  TAppTheme._(); //constructor

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: const Color(0xFFF9AFA6),
    scaffoldBackgroundColor: Colors.white,

    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFF9AFA6),
    scaffoldBackgroundColor: Colors.black,

    textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.darkChipTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,

  );

}