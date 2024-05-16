import 'package:flutter/material.dart';
import 'package:medipal/main.dart';
import 'package:medipal/pages/language_constants.dart';
import 'package:medipal/constant/images.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageRegionSelect extends StatefulWidget {
  const LanguageRegionSelect({Key? key}) : super(key: key);

  @override
  _LanguageRegionSelectState createState() => _LanguageRegionSelectState();
}

class LanguageProvider extends ChangeNotifier {
  Language _currentLanguage = Language('English', 'en');

  Language get currentLanguage => _currentLanguage;

  void setLanguage(Language language) {
    _currentLanguage = language;
    notifyListeners();
  }
}

class Language {
  final String name;
  final String languageCode;

  Language(this.name, this.languageCode);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Language &&
        other.name == name &&
        other.languageCode == languageCode;
  }

  @override
  int get hashCode => name.hashCode ^ languageCode.hashCode;
}

class _LanguageRegionSelectState extends State<LanguageRegionSelect> {
  Language english = Language('English', 'en');
  Language spanish = Language('Español', 'es');
  Language french = Language('Le Français', 'fr');
  Language hindi = Language('हिन्दी', 'hi');
  Language arabic = Language('العربية', 'ar');
  Language swahili = Language('kiswahili', 'sw');
  Language zulu = Language('isiZulu', 'zu');

  List<Language> languages = [];

  Language dropdownValue = Language('English', 'en');

  @override
  void initState() {
    super.initState();
    languages = [
      english,
      spanish,
      french,
      hindi,
      arabic,
      swahili,
      zulu,
    ];
    dropdownValue = english; // Default language
    _loadLanguage();
  }

  _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      for (Language language in languages) {
        if (language.languageCode == languageCode) {
          setState(() {
            dropdownValue = language;
          });
          break;
        }
      }
    }
  }

  _saveLanguage(Language language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', language.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).languageAndRegion),
      ),
      body: Center(
        child: DropdownButton<Language>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (Language? language) async {
            if (language != null) {
              Locale _locale = await setLocale(language.languageCode);
              MyApp.setLocale(context, _locale);
              _saveLanguage(language);
              setState(() {
                dropdownValue = language;
              });
            }
          },
          items: languages.map<DropdownMenuItem<Language>>((Language language) {
            return DropdownMenuItem<Language>(
              value: language,
              child: Text(language.name),
            );
          }).toList(),
        ),
      ),
    );
  }
}
