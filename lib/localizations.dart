import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  appTitle() => Intl.message(
        'Tasks',
        name: 'appTitle',
        desc: 'Name of the app',
      );

  getStartedMessage() => Intl.message(
        'To get startet, press the button below',
        name: 'getStartedMessage',
        desc: 'Message explaining how to get startet',
      );

  loginButtonLabel() => Intl.message(
        'Turn on backup & sync',
        name: 'loginButtonLabel',
        desc: 'Label of the login button',
      );

  menuSettings() => Intl.message(
        'Settings',
        name: 'menuSettings',
        desc: 'Title for the settings screen',
      );

  menuSort() => Intl.message(
        'Sort',
        name: 'menuSort',
        desc: 'Sort the todos',
      );

  menuFilter() => Intl.message(
        'Filter',
        name: 'menuFilter',
        desc: 'Filter the todos',
      );

  emptyMessageTitle() => Intl.message(
        'Nothing to do',
        name: 'emptyMessageTitle',
        desc: 'Empty message title when there are no items',
      );

  hintCreateTodoLists() => Intl.message(
        'Start by creating a list in the menu above',
        name: 'hintCreateTodoLists',
        desc: 'Message which explains how to create a todoList',
      );

  hintCreateTodos() => Intl.message(
        'Create some tasks by tapping the +',
        name: 'hintCreateTodos',
        desc: 'Message which explains how to create a todo',
      );

  addList() => Intl.message(
        'Add list',
        name: 'addList',
        desc: 'Add a new list',
      );

  nameOfList() => Intl.message(
        'Name',
        name: 'nameOfList',
        desc: 'Name of the list',
      );

  addTodo() => Intl.message(
        'Add task',
        name: 'addTodo',
        desc: 'Add a new todo',
      );

  createTodo() => Intl.message(
        'Create todo',
        name: 'createTodo',
        desc: 'Create the todo',
      );

  deleteTodo() => Intl.message(
        'Delete',
        name: 'deleteTodo',
        desc: 'Delete the todo',
      );

  todoTitle() => Intl.message(
        'Title',
        name: 'todoTitle',
        desc: 'Title of the todo',
      );

  todoDesc() => Intl.message(
        'Description',
        name: 'todoDesc',
        desc: 'Description of the todo',
      );
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
