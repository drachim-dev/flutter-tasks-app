import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
class S implements WidgetsLocalizations {
  const S();

  static S current;

  static const GeneratedLocalizationsDelegate delegate =
    GeneratedLocalizationsDelegate();

  static S of(BuildContext context) => Localizations.of<S>(context, S);

  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get addList => "Add list";
  String get addTodo => "Add task";
  String get appTitle => "Tasks";
  String get createTodo => "Create task";
  String get deleteList => "Delete list";
  String get deleteTodo => "Delete";
  String get emptyMessageTitle => "Nothing to do";
  String get getStartedMessage => "To get startet, press the button below";
  String get hintCreateTodoLists => "Start by creating a list";
  String get hintCreateTodos => "Create some tasks by tapping the +";
  String get loginButtonLabel => "Turn on backup & sync";
  String get manageLists => "Manage lists";
  String get menuFilter => "Filter";
  String get menuSettings => "Settings";
  String get menuSort => "Sort";
  String get nameOfList => "Name";
  String get reminder => "Reminder";
  String get renameList => "Rename list";
  String get todoDesc => "Description";
  String get todoTitle => "Title";
  String todos(dynamic todosCount) {
    switch (todosCount.toString()) {
      case "1":
        return "$todosCount item";
      default:
        return "$todosCount items";
    }
  }
}

class $de extends S {
  const $de();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get deleteList => "Liste löschen";
  @override
  String get nameOfList => "Name";
  @override
  String get getStartedMessage => "Um zu beginnen, bitte den Button unten drücken";
  @override
  String get reminder => "Erinnerung";
  @override
  String get todoDesc => "Beschreibung";
  @override
  String get loginButtonLabel => "Backup & Sync aktivieren";
  @override
  String get appTitle => "Tasks";
  @override
  String get hintCreateTodoLists => "Erstelle als erstes eine Liste";
  @override
  String get hintCreateTodos => "Erstelle neue Aufgaben, indem du + drückst";
  @override
  String get addTodo => "Aufgabe hinzufügen";
  @override
  String get emptyMessageTitle => "Alles erledigt";
  @override
  String get menuSettings => "Einstellungen";
  @override
  String get addList => "Liste hinzufügen";
  @override
  String get manageLists => "Listen verwalten";
  @override
  String get renameList => "Liste umbenennen";
  @override
  String get menuFilter => "Filtern";
  @override
  String get deleteTodo => "Löschen";
  @override
  String get todoTitle => "Titel";
  @override
  String get createTodo => "Aufgabe erstellen";
  @override
  String get menuSort => "Sortieren";
  @override
  String todos(dynamic todosCount) {
    switch (todosCount.toString()) {
      case "1":
        return "$todosCount Aufgabe";
      default:
        return "$todosCount Aufgaben";
    }
  }
}

class $en extends S {
  const $en();
}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("de", ""),
      Locale("en", ""),
    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback, bool withCountry = true}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported, withCountry);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback, bool withCountry = true}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported, withCountry);
    };
  }

  @override
  Future<S> load(Locale locale) {
    final String lang = getLang(locale);
    if (lang != null) {
      switch (lang) {
        case "de":
          S.current = const $de();
          return SynchronousFuture<S>(S.current);
        case "en":
          S.current = const $en();
          return SynchronousFuture<S>(S.current);
        default:
          // NO-OP.
      }
    }
    S.current = const S();
    return SynchronousFuture<S>(S.current);
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale, true);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;

  ///
  /// Internal method to resolve a locale from a list of locales.
  ///
  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported, bool withCountry) {
    if (locale == null || !_isSupported(locale, withCountry)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  ///
  /// Returns true if the specified locale is supported, false otherwise.
  ///
  bool _isSupported(Locale locale, bool withCountry) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        // Language must always match both locales.
        if (supportedLocale.languageCode != locale.languageCode) {
          continue;
        }

        // If country code matches, return this locale.
        if (supportedLocale.countryCode == locale.countryCode) {
          return true;
        }

        // If no country requirement is requested, check if this locale has no country.
        if (true != withCountry && (supportedLocale.countryCode == null || supportedLocale.countryCode.isEmpty)) {
          return true;
        }
      }
    }
    return false;
  }
}

String getLang(Locale l) => l == null
  ? null
  : l.countryCode != null && l.countryCode.isEmpty
    ? l.languageCode
    : l.toString();
