import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tasks_flutter_v2/common/helper.dart';
import 'package:tasks_flutter_v2/generated/i18n.dart';
import 'package:tasks_flutter_v2/model/todo_list.dart';
import 'package:tasks_flutter_v2/model/user_entity.dart';
import 'package:tasks_flutter_v2/widget/todo_bloc_provider.dart';

class ListManager extends StatefulWidget {
  final UserEntity user;
  static const String _menuRenameListKey = '_menuRenameListKey';
  static const String _menuDeleteListKey = '_menuDeleteListKey';

  ListManager({@required this.user});

  @override
  _ListManagerState createState() => _ListManagerState();
}

class _ListManagerState extends State<ListManager> with SingleTickerProviderStateMixin {
  AnimationController _fabController;

  @override
  void initState() {
    super.initState();

    _fabController =
        AnimationController(vsync: this, value: 1.0, duration: Duration(milliseconds: 250));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return StreamBuilder(
        stream: TodoListProvider.of(context).todoLists(widget.user),
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(S.of(context).manageLists),
            ),
            body: snapshot.hasData && snapshot.data.isNotEmpty
                ? _buildReorderableList(theme, context, snapshot.data)
                : _buildEmptyItems(theme, context),
            floatingActionButton: ScaleTransition(
              scale: _fabController,
              child: FloatingActionButton(
                tooltip: S.of(context).addList,
                onPressed: () => _addTodoList(context, snapshot.data),
                child: Icon(Icons.add),
              ),
            ),
          );
        });
  }

  Center _buildEmptyItems(ThemeData theme, BuildContext context) {
    final Color fontColor = Colors.grey;
    final TextStyle titleTextStyle = theme.textTheme.headline.copyWith(color: fontColor);
    final TextStyle msgTextStyle = theme.textTheme.subhead.copyWith(color: fontColor);
    final String msgTitle = S.of(context).emptyMessageTitle;
    final String msgNoTodoList = S.of(context).hintCreateTodoLists;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.local_cafe,
            size: 128.0,
            color: fontColor,
          ),
          SizedBox(height: 16),
          Text(
            msgTitle,
            style: titleTextStyle,
          ),
          SizedBox(height: 32),
          Text(msgNoTodoList, style: msgTextStyle),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  NotificationListener _buildReorderableList(
      ThemeData theme, BuildContext context, List<TodoList> todoLists) {
    final isDark = theme.brightness == Brightness.dark;
    final Color iconColor = isDark ? Colors.white70 : Colors.black12;

    return NotificationListener(
      onNotification: (t) {
        if (t is UserScrollNotification && t.metrics.maxScrollExtent != 0.0) {
          if (t.direction == ScrollDirection.reverse) {
            _fabController.reverse();
          } else if (t.direction == ScrollDirection.forward) {
            _fabController.forward();
          }
        }
      },
      child: ReorderableListView(
          padding: const EdgeInsets.all(8),
          children: todoLists.map((todoList) {
            return Column(
              key: Key(todoList.id),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.drag_handle,
                      color: iconColor,
                    ),
                    title: Text(todoList.title),
                    subtitle: Text(S.of(context).todos(todoList.todos.length)),
                    trailing: _buildPopupMenuButton(
                        context,
                        todoList,
                        Icon(
                          Icons.more_vert,
                          color: iconColor,
                        )),
                  ),
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
            Helper.buildMenuItem(
                Icons.edit, S.of(context).renameList, ListManager._menuRenameListKey),
            Helper.buildMenuItem(
                Icons.remove_circle, S.of(context).deleteList, ListManager._menuDeleteListKey),
          ],
    );
  }

  void _onSelectMenuItem(String value, BuildContext context, TodoList todoList) {
    switch (value) {
      case ListManager._menuRenameListKey:
        Helper.showInputDialog(context,
                title: S.of(context).renameList,
                hint: S.of(context).nameOfList,
                input: todoList.title)
            .then((input) {
          if (input != null && input.isNotEmpty) {
            todoList.title = input;
            TodoListProvider.of(context).updateTodoList(widget.user, todoList);
          }
        });
        break;
      case ListManager._menuDeleteListKey:
        TodoListProvider.of(context).deleteTodoLists(widget.user, [todoList]);
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
      TodoListProvider.of(context).updateTodoList(widget.user, element);
    });
  }

  void _addTodoList(BuildContext context, List<TodoList> todoLists) {
    Helper.showInputDialog(context, title: S.of(context).addList, hint: S.of(context).nameOfList)
        .then((input) {
      if (input != null && input.isNotEmpty) {
        final TodoList todoList =
            TodoList(title: input, position: todoLists == null ? 0 : todoLists.length);
        TodoListProvider.of(context).addTodoList(widget.user, todoList);
      }
    });
  }
}
