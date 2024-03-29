import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tasks_flutter_v2/common/helper.dart';
import 'package:tasks_flutter_v2/generated/i18n.dart';
import 'package:tasks_flutter_v2/model/todo.dart';
import 'package:tasks_flutter_v2/model/todo_list.dart';
import 'package:tasks_flutter_v2/model/user_entity.dart';
import 'package:tasks_flutter_v2/routes.dart';
import 'package:tasks_flutter_v2/widget/todo_bloc_provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  static const String _menuAddListKey = '_menuAddListKey';
  static const String _menuManageListsKey = '_menuManageListsKey';
  static const String _menuSettingsKey = '_menuSettingsKey';

  NotificationAppLaunchDetails notificationDetails;
  Todo notificationDetailsTodo;

  bool _progress = false;
  UserEntity _user;

  List<TodoList> _todoLists;
  AnimationController _fabController;

  @override
  void initState() {
    super.initState();

    _fabController =
        AnimationController(vsync: this, value: 0.0, duration: Duration(milliseconds: 250));
    _fabController.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    notificationDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    // notificationDetailsTodo = await TodoListProvider.of(context).todo(_user, '222').first;

    if (notificationDetails.didNotificationLaunchApp) {
      notificationDetailsTodo =
          await TodoListProvider.of(context).todo(_user, notificationDetails.payload).first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return FutureBuilder(
        future: TodoListProvider.of(context).getCurrentUser(),
        builder: (context, snapshot) {
          // not logged in
          if (!snapshot.hasData) {
            return _buildLoginScreen(context, theme);
          }

          // logged in
          _user = snapshot.data;
          initNotifications();

          return StreamBuilder<List<TodoList>>(
              stream: TodoListProvider.of(context).todoLists(_user),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  _todoLists = snapshot.data;
                  return _buildApp(context, theme, _todoLists);
                } else {
                  return _buildEmptyApp(theme);
                }
              });
        });
  }

  Scaffold _buildLoginScreen(BuildContext context, ThemeData theme) {
    final double titleIconSize = 128.0;
    final Color titleColor = Colors.white;
    final TextStyle titleTextStyle = theme.textTheme.headline.copyWith(color: titleColor);

    final double msgIconSize = 96.0;
    final Color msgColor = Colors.grey;
    final TextStyle msgTextStyle = theme.textTheme.subhead.copyWith(color: msgColor);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: theme.accentColor,
            height: MediaQuery.of(context).size.height / 2.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check,
                  size: titleIconSize,
                  color: titleColor,
                ),
                Text(S.of(context).appTitle, style: titleTextStyle)
              ],
            ),
          ),
          _progress == true ? LinearProgressIndicator() : SizedBox(height: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(S.of(context).getStartedMessage, style: msgTextStyle),
                SizedBox(height: 32),
                IconButton(
                  iconSize: msgIconSize,
                  splashColor: theme.accentColor.withOpacity(0.5),
                  highlightColor: Colors.transparent,
                  color: msgColor,
                  icon: Icon(Icons.backup),
                  onPressed: () {
                    setState(() {
                      _progress = true;
                    });

                    TodoListProvider.of(context).loginViaGoogle().then((user) {
                      setState(() {
                        _progress = false;
                      });
                    });
                  },
                ),
                Text(
                  S.of(context).loginButtonLabel,
                  style: msgTextStyle,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  DefaultTabController _buildApp(BuildContext context, ThemeData theme, List<TodoList> todoLists) {
    return DefaultTabController(
      length: todoLists.length,
      child: Builder(builder: (BuildContext context) {
        return Scaffold(
          appBar: _buildAppBar(todoLists: todoLists),
          body: TabBarView(
            children: todoLists.map((todoList) {
              return StreamBuilder<List<Todo>>(
                  stream: TodoListProvider.of(context).todosByList(_user, todoList.id),
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data.isNotEmpty
                        ? _buildListView(snapshot.data, todoList)
                        : _buildEmptyItems(theme, todoList: todoList);
                  });
            }).toList(),
          ),
          floatingActionButton: ScaleTransition(
            scale: _fabController,
            child: FloatingActionButton(
              tooltip: S.of(context).addTodo,
              onPressed: () => Navigator.pushNamed(context, Routes.addTask, arguments: {
                'user': _user,
                'todoList': todoLists[DefaultTabController.of(context).index]
              }),
              child: Icon(Icons.add),
            ),
          ),
        );
      }),
    );
  }

  Scaffold _buildEmptyApp(ThemeData theme) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: _buildEmptyItems(theme),
    );
  }

  Center _buildEmptyItems(ThemeData theme, {TodoList todoList}) {
    final Color fontColor = Colors.grey;
    final TextStyle titleTextStyle = theme.textTheme.headline.copyWith(color: fontColor);
    final TextStyle msgTextStyle = theme.textTheme.subhead.copyWith(color: fontColor);
    final String msgTitle = S.of(context).emptyMessageTitle;
    final String msgNoTodoList = S.of(context).hintCreateTodoLists;
    final String msgNoTodos = S.of(context).hintCreateTodos;
    final String message = todoList == null ? msgNoTodoList : msgNoTodos;

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
          Text(message, style: msgTextStyle),
          SizedBox(height: 32),
          if (todoList == null)
            Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: RaisedButton.icon(
                    color: theme.accentColor,
                    onPressed: _addTodoList,
                    icon: Icon(Icons.add),
                    label: Text(S.of(context).addList)))
        ],
      ),
    );
  }

  AppBar _buildAppBar({List<TodoList> todoLists}) {
    return AppBar(
        title: Text(S.of(context).appTitle),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _onSelectMenuItem,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              Helper.buildMenuItem(Icons.playlist_add, S.of(context).addList, _menuAddListKey),
              Helper.buildMenuItem(Icons.list, S.of(context).manageLists, _menuManageListsKey),
              Helper.buildMenuItem(Icons.settings, S.of(context).menuSettings, _menuSettingsKey),
            ],
          )
        ],
        bottom: todoLists == null ? null : _buildTabBar(todoLists));
  }

  TabBar _buildTabBar(List<TodoList> todoLists) {
    return TabBar(
      isScrollable: true,
      tabs: todoLists.map((todoList) {
        return Tab(text: todoList.title);
      }).toList(),
    );
  }

  NotificationListener _buildListView(List<Todo> todos, TodoList todoList) {
    return NotificationListener(
      onNotification: (t) {
        if (t is UserScrollNotification && t.metrics.maxScrollExtent != 0.0) {
          if (t.direction == ScrollDirection.reverse) {
            //_fabController.reverse();
          } else if (t.direction == ScrollDirection.forward) {
            //_fabController.forward();
          }
        }
      },
      child: ReorderableListView(
        padding: const EdgeInsets.all(8),
        children: todos.map((todo) {
          return Column(
            key: Key(todo.id),
            children: <Widget>[
              _buildListItem(todo, todoList),
              Divider(),
            ],
          );
        }).toList(),
        onReorder: (oldIndex, newIndex) => _onReorder(context, todos, todoList, oldIndex, newIndex),
      ),
    );
  }

  ListTile _buildListItem(Todo todo, TodoList todoList) {
    final TextStyle textStyle =
        TextStyle(decoration: todo.complete ? TextDecoration.lineThrough : null);

    return ListTile(
        leading: Checkbox(
            value: todo.complete,
            onChanged: (bool isChecked) => _toggleTodo(todoList, todo, isChecked)),
        title: Text(
          todo.title,
          maxLines: 1,
          style: textStyle,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: todo.note.isNotEmpty
            ? Text(
                todo.note,
                maxLines: 1,
                style: textStyle,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: todo.reminderSet ? Text(Helper.formatDateTime(todo.reminder)) : null,
        onTap: () => _tapTodo(todoList, todo));
  }

  void _onSelectMenuItem(String value) {
    switch (value) {
      case _menuAddListKey:
        _addTodoList();
        break;
      case _menuManageListsKey:
        Navigator.pushNamed(context, Routes.manageLists, arguments: {'user': _user});
        break;
      case _menuSettingsKey:
        break;
      default:
    }
  }

  void _addTodoList() {
    Helper.showInputDialog(context, title: S.of(context).addList, hint: S.of(context).nameOfList)
        .then((input) {
      if (input != null && input.isNotEmpty) {
        final TodoList todoList =
            TodoList(title: input, position: _todoLists == null ? 0 : _todoLists.length);
        TodoListProvider.of(context).addTodoList(_user, todoList);
      }
    });
  }

  void _toggleTodo(TodoList todoList, Todo todo, bool isChecked) {
    todo.complete = isChecked;
    TodoListProvider.of(context).updateTodo(_user, todoList, todo);
  }

  void _tapTodo(final TodoList todoList, final Todo todo) {
    Navigator.pushNamed(context, Routes.editTask,
        arguments: {'user': _user, 'todoList': todoList, 'todo': todo});
  }

  void _onReorder(BuildContext context, List<Todo> todos, TodoList todoList, oldIndex, newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Todo todo = todos.removeAt(oldIndex);
    todos.insert(newIndex, todo);

    todos.forEach((element) {
      element.position = todos.indexOf(element) * -1;
    });

    TodoListProvider.of(context).updateTodo(_user, todoList, todo);
  }
}
