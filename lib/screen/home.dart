import 'package:flutter/material.dart';
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

  bool _progress = false;
  UserEntity _user;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          return StreamBuilder(
              stream: TodoListProvider.of(context).todoLists(_user),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<TodoList> todoLists = snapshot.data;
                  return todoLists.isEmpty
                      ? _buildEmptyApp(theme)
                      : _buildApp(context, theme, todoLists);
                } else {
                  return Container();
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
              return todoList.todos.isNotEmpty
                  ? _buildListView(todoList)
                  : _buildEmptyItems(theme, todoList: todoList);
            }).toList(),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: S.of(context).addTodo,
            onPressed: () => Navigator.pushNamed(context, Routes.addTask, arguments: {
                  'user': _user,
                  'todoList': todoLists[DefaultTabController.of(context).index]
                }),
            child: Icon(Icons.add),
          ),
        );
      }),
    );
  }

  Scaffold _buildEmptyApp(ThemeData theme) {
    return Scaffold(
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
        ],
      ),
    );
  }

  AppBar _buildAppBar({List<TodoList> todoLists}) {
    return AppBar(
        title: Text(S.of(context).appTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            tooltip: S.of(context).menuSort,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            tooltip: S.of(context).menuFilter,
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: _onSelectMenuItem,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  Helper.buildMenuItem(Icons.playlist_add, S.of(context).addList, _menuAddListKey),
                  Helper.buildMenuItem(Icons.list, S.of(context).manageLists, _menuManageListsKey),
                  Helper.buildMenuItem(
                      Icons.settings, S.of(context).menuSettings, _menuSettingsKey),
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

  ListView _buildListView(TodoList todoList) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final Todo todo = todoList.todos[index];
          return _buildListItem(todo, todoList);
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: todoList.todos.length);
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
          style: textStyle,
          overflow: TextOverflow.ellipsis,
        ),
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
      if (input == null || input.isEmpty) {
      } else {
        final TodoList todoList = TodoList(title: input);
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
}
