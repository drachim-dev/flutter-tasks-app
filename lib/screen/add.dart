import 'package:flutter/material.dart';
import 'package:tasks_flutter_v2/common/helper.dart';
import 'package:tasks_flutter_v2/generated/i18n.dart';
import 'package:tasks_flutter_v2/model/todo.dart';
import 'package:tasks_flutter_v2/model/todo_list.dart';
import 'package:tasks_flutter_v2/model/user_entity.dart';
import 'package:tasks_flutter_v2/widget/todo_bloc_provider.dart';

class Add extends StatefulWidget {
  Add({@required this.user, @required this.todoList, this.todo});

  final UserEntity user;
  final TodoList todoList;
  final Todo todo;

  @override
  _AddState createState() => _AddState(user: user, todoList: todoList, todo: todo);
}

class _AddState extends State<Add> {
  final UserEntity user;
  final TodoList todoList;
  final Todo todo;

  static const String _menuDeleteKey = '_menuDeleteKey';

  TextEditingController _titleController;
  TextEditingController _descController;

  _AddState({@required this.user, @required this.todoList, Todo todo})
      : todo = todo ?? Todo(position: todoList.todos.length);

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: todo.title);
    _descController = TextEditingController(text: todo.note);
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
              _buildReminderCard(theme),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send),
          tooltip: S.of(context).createTodo,
          onPressed: () {
            todo.title = _titleController.text;
            todo.note = _descController.text;

            if (todo.id == null) {
              TodoListProvider.of(context).addTodo(user, todoList, todo);
            } else {
              TodoListProvider.of(context).updateTodo(user, todoList, todo);
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
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                Helper.buildMenuItem(Icons.delete, S.of(context).deleteTodo, _menuDeleteKey),
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
        TodoListProvider.of(context).deleteTodos(user, todoList, [todo]);
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
        hintText: S.of(context).todoTitle,
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
        labelText: S.of(context).todoDesc,
        contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        filled: true,
      ),
    );
  }

  ExpansionTile _buildReminderCard(ThemeData theme) {
    final Icon reminderIcon = todo.reminderSet
        ? Icon(Icons.notifications_active, color: theme.accentColor)
        : Icon(Icons.notifications_off);

    return ExpansionTile(
      title: Text('Time reminder'),
      initiallyExpanded: todo.reminderSet,
      onExpansionChanged: (bool value) {
        setState(() {
          todo.reminderSet = value;
        });
      },
      leading: reminderIcon,
      children: <Widget>[
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
                Icon(Icons.calendar_today, color: Colors.grey),
                Icon(Icons.access_time, color: Colors.grey),
              ]),
              //buildOptionColumn(dateTitle1, timeTitle1, 0),
              //buildOptionColumn(dateTitle2, timeTitle2, 1),
              //buildOptionColumn(dateTitle3, timeTitle3, 2),
            ],
          ),
        ),
      ],
    );
  }
}
