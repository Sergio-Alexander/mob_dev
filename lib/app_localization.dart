import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
    print("PLS WORKKKK FUCK");
    try {
      print("are my json files loading???");
      String jsonString = await rootBundle.loadString('i18n/${locale.languageCode}.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
      print("ITS LOADING maybe??");
      return true;
    } catch (e, stacktrace) {
      print('Error loading localization files: $e');
      print('Stacktrace: $stacktrace');
      return false;
    }
  }


  String translate(String key) {
    print("hiiiii");
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
  Future<AppLocalizations> load(Locale locale) {
    print("IS THIS LOADING???");
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}