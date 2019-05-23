import 'package:flutter/material.dart';
import 'package:tasks_flutter_v2/common/helper.dart';
import 'package:tasks_flutter_v2/generated/i18n.dart';
import 'package:tasks_flutter_v2/model/todo_list.dart';
import 'package:tasks_flutter_v2/model/user_entity.dart';
import 'package:tasks_flutter_v2/widget/todo_bloc_provider.dart';

class ListManager extends StatelessWidget {
  final UserEntity user;
  static const String _menuRenameListKey = '_menuRenameListKey';
  static const String _menuDeleteListKey = '_menuDeleteListKey';

  ListManager({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).manageLists),
      ),
      body: StreamBuilder(
          stream: TodoListProvider.of(context).todoLists(user),
          builder: (context, snapshot) {
            return snapshot.hasData ? _buildReorderableList(context, snapshot.data) : Container();
          }),
    );
  }

  Padding _buildReorderableList(BuildContext context, List<TodoList> todoLists) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ReorderableListView(
          children: todoLists.map((todoList) {
            return Column(
              key: Key(todoList.id),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.drag_handle),
                  title: Text(todoList.title),
                  subtitle: Text(S.of(context).todos(todoList.todos.length)),
                  trailing: _buildPopupMenuButton(context, todoList, Icon(Icons.more_vert)),
                ),
                Divider(),
              ],
            );
          }).toList(),
          onReorder: (oldIndex, newIndex) => _onReorder(context, todoLists, oldIndex, newIndex)),
    );
  }

  PopupMenuButton<String> _buildPopupMenuButton(BuildContext context, TodoList todoList,
      [Icon menuIcon]) {
    return PopupMenuButton<String>(
      onSelected: (value) => _onSelectMenuItem(value, context, todoList),
      icon: menuIcon,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            Helper.buildMenuItem(Icons.edit, S.of(context).renameList, _menuRenameListKey),
            Helper.buildMenuItem(Icons.remove_circle, S.of(context).deleteList, _menuDeleteListKey),
          ],
    );
  }

  void _onSelectMenuItem(String value, BuildContext context, TodoList todoList) {
    switch (value) {
      case _menuRenameListKey:
        Helper.showInputDialog(context,
                title: S.of(context).renameList,
                hint: S.of(context).nameOfList,
                input: todoList.title)
            .then((input) {
          if (input != null && input.isNotEmpty) {
            todoList.title = input;
            TodoListProvider.of(context).updateTodoList(user, todoList);
          }
        });
        break;
      case _menuDeleteListKey:
        TodoListProvider.of(context).deleteTodoLists(user, [todoList]);
        break;
    }
  }

  _onReorder(BuildContext context, List<TodoList> todoLists, oldIndex, newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final TodoList todoList = todoLists.removeAt(oldIndex);
    todoLists.insert(newIndex, todoList);

    todoLists.forEach((element) {
      element.position = todoLists.indexOf(element);
      TodoListProvider.of(context).updateTodoList(user, element);
    });
  }
}
