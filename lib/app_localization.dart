import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';


class AppLocalizations {
  final Locale locale;
  Map<String, String> _localizedStrings = {}; // Initialize to an empty map

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  Future<bool> load() async {
    String filePath = 'i18n/${locale.languageCode}.json';
    print('Loading localization data from: $filePath');
    try {
      String jsonString = await rootBundle.loadString(filePath);
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
      print('Loaded localization data: $_localizedStrings');
      return true;
    } catch (e, stacktrace) {
      print('Error loading localization files: $e');
      print('Stacktrace: $stacktrace');
      return false;
    }
  }


  String translate(String key) {
    return _localizedStrings[key] ?? key; // Fallback to the key if the translation does not exist
  }
}


class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'id'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async{
    AppLocalizations appLocalizations = AppLocalizations(locale);
    await appLocalizations.load();
    return appLocalizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}