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
    return StreamBuilder(
        stream: TodoListProvider.of(context).todoLists(user),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<TodoList> todoLists = snapshot.data;
            return ListView.separated(
                itemBuilder: (context, index) {
                  final TodoList todoList = todoLists[index];
                  return ListTile(
                    title: Text(todoList.title),
                    trailing: _buildPopupMenuButton(context, todoList, Icon(Icons.more_vert)),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: todoLists.length);
          } else {
            return Container();
          }
        });
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
        break;
      case _menuDeleteListKey:
        TodoListProvider.of(context).deleteTodoLists(user, [todoList]);
        break;
    }
  }
}
