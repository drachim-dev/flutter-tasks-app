import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  static PopupMenuItem<String> buildMenuItem(IconData icon, String label, String key) {
    return PopupMenuItem<String>(
      value: key,
      child: Row(
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(right: 24.0), child: Icon(icon)),
          Text(label),
        ],
      ),
    );
  }

  static Future<String> showInputDialog(BuildContext context,
      {@required String title, @required String hint, String input}) {
    const String _cancel = 'Cancel';
    const String _confirm = 'Ok';
    final TextEditingController _textEditingController = TextEditingController(text: input);

    AlertDialog dialog = AlertDialog(
      title: Text(title),
      content: TextField(
        style: Theme.of(context).textTheme.headline,
        maxLines: 1,
        autocorrect: true,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        controller: _textEditingController,
        decoration: InputDecoration(hintText: hint),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text(_cancel),
          onPressed: () {
            Navigator.of(context).pop();
            _textEditingController.clear();
          },
        ),
        FlatButton(
          child: const Text(_confirm),
          onPressed: () {
            Navigator.of(context).pop(_textEditingController.text);
            _textEditingController.clear();
          },
        ),
      ],
    );

    return showDialog(context: context, builder: (_) => dialog);
  }

  static DateTime getToday() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static TimeOfDay getNextHour(final DateTime date) {
    return TimeOfDay.fromDateTime(DateTime(date.year, date.month, date.day, date.hour + 1));
  }

  static String formatDate(final DateTime date) {
    return DateFormat.MMMd().format(date);
  }

  static String formatTime(final DateTime date) {
    return DateFormat.Hm().format(date);
  }

  static String formatTimeOfDay(BuildContext context, final TimeOfDay timeOfDay) {
    return timeOfDay.format(context);
  }

  static String formatDateTime(final DateTime date) {
    return formatDate(date) + ' at ' + formatTime(date);
  }
}
