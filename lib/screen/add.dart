import 'package:flutter/material.dart';
import 'package:tasks_flutter_v2/common/helper.dart';
import 'package:tasks_flutter_v2/localizations.dart';
import 'package:tasks_flutter_v2/model/todo.dart';
import 'package:tasks_flutter_v2/model/todo_list.dart';
import 'package:tasks_flutter_v2/widget/todo_bloc_provider.dart';

class Add extends StatefulWidget {
  Add({@required this.todoList, this.todo});

  final TodoList todoList;
  final Todo todo;

  @override
  _AddState createState() => _AddState(todoList: todoList, todo: todo);
}

class _AddState extends State<Add> {
  final TodoList todoList;
  final Todo todo;

  static const String _menuDeleteKey = '_menuDeleteKey';

  TextEditingController _titleController;
  TextEditingController _descController;

  _AddState({@required this.todoList, Todo todo}) : todo = todo ?? Todo(position: 0);

  @override
  void initState() {
    super.initState();

    _titleController = new TextEditingController(text: todo.title);
    _descController = new TextEditingController(text: todo.note);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color titleHintColor = isDark ? Colors.white70 : Colors.white70;

    return Scaffold(
      appBar: _buildAppBar(theme, titleHintColor),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildDescription(theme),
              //_buildReminderCard(theme),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send),
          tooltip: AppLocalizations.of(context).createTodo(),
          onPressed: () {
            todo.title = _titleController.text;
            todo.note = _descController.text;

            if (todo.id == null) {
              TodoListProvider.of(context).addTodo(todoList, todo);
            } else {
              TodoListProvider.of(context).updateTodo(todoList, todo);
            }

            Navigator.pop(context);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  AppBar _buildAppBar(ThemeData theme, Color titleHintColor) {
    return AppBar(
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: _onSelectMenuItem,
          itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<String>>[
            Helper.buildMenuItem(
                Icons.delete, AppLocalizations.of(context).deleteTodo(), _menuDeleteKey),
          ],
        )
      ],
      bottom: PreferredSize(
        preferredSize: Size(0.0, 80.0),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildTitle(theme, titleHintColor)),
      ),
    );
  }

  void _onSelectMenuItem(String value) {
    switch (value) {
      case _menuDeleteKey:
        TodoListProvider.of(context).deleteTodos(todoList, [todo]);
        Navigator.pop(context);
        break;
      default:
    }
  }

  TextField _buildTitle(ThemeData theme, Color titleHintColor) {
    return TextField(
      style: theme.primaryTextTheme.headline,
      cursorColor: theme.accentColor,
      minLines: 1,
      maxLines: 2,
      autocorrect: true,
      textCapitalization: TextCapitalization.sentences,
      controller: _titleController,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).todoTitle(),
        hintStyle: TextStyle(color: titleHintColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      ),
    );
  }

  TextField _buildDescription(ThemeData theme) {
    return TextField(
      style: theme.textTheme.headline,
      minLines: 6,
      maxLines: 8,
      autocorrect: true,
      textCapitalization: TextCapitalization.sentences,
      controller: _descController,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: AppLocalizations.of(context).todoDesc(),
        contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        filled: true,
      ),
    );
  }
}
