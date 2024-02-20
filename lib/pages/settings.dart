import 'package:flutter/material.dart';
import 'package:mob_dev/app_localization.dart';
import 'package:mob_dev/main.dart';

// class SettingsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context).translate('settings')),
//         centerTitle: true,
//       ),
//       body: ListView(
//         children: <Widget>[
//           ListTile(
//             title: Text(AppLocalizations.of(context).translate('changeLanguage')),
//             trailing: DropdownButton<String>(
//               value: Localizations.localeOf(context).languageCode,
//               items: <String>['en', 'id'].map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 if (newValue != null) {
//                   Locale newLocale = Locale(newValue, '');
//                   MyApp.of(context)?.setLocale(newLocale);
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

enum ThemeStyle {
  material,
  cupertino,
}

ThemeStyle currentTheme = ThemeStyle.material;

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('settings')),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(AppLocalizations.of(context).translate('changeLanguage')),
            trailing: DropdownButton<String>(
              value: Localizations.localeOf(context).languageCode,
              items: <String>['en', 'id'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  Locale newLocale = Locale(newValue, '');
                  MyApp.of(context)?.setLocale(newLocale);
                }
              },
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate('changeTheme')),
            trailing: currentTheme == ThemeStyle.material
                ? Text(AppLocalizations.of(context).translate('material'))
                : Text(AppLocalizations.of(context).translate('cupertino')),
            onTap: () {
              MyApp.of(context)?.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}