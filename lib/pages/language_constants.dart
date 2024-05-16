import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String LANGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String ESPANOL = 'es';
const String ARABIC = 'ar';
const String HINDI = 'hi';
const String FRENCH = 'fr';
const String SWAHILI = 'sw';
const String ZULU = 'zu';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LANGUAGE_CODE) ?? ENGLISH;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, '');
    case ESPANOL:
      return const Locale(ESPANOL, "");
    case ARABIC:
      return const Locale(ARABIC, '');
    case HINDI:
      return const Locale(HINDI, '');
    case FRENCH:
      return const Locale(FRENCH, '');
    case SWAHILI:
      return const Locale(SWAHILI, '');
    case ZULU:
      return const Locale(ZULU, '');

    default:
      return const Locale(ENGLISH, '');
  }
}

AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(context)!;
}
