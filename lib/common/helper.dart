import 'package:flutter/material.dart';

class Helper {
  static PopupMenuItem<String> buildMenuItem(IconData icon, String label) {
    return PopupMenuItem<String>(
      value: label,
      child: Row(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 24.0), child: Icon(icon)),
          Text(label),
        ],
      ),
    );
  }

  static Future showInputDialog(BuildContext context,
      {@required String title, @required String hint, String input}) {
    const String _cancel = 'Cancel';
    const String _confirm = 'Ok';
    final TextEditingController _textEditingController =
        TextEditingController(text: input);

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
}
