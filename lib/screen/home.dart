import 'package:flutter/material.dart';
import 'package:tasks_flutter_v2/common/helper.dart';
import 'package:tasks_flutter_v2/model/todo.dart';
import 'package:tasks_flutter_v2/model/todo_list.dart';
import 'package:tasks_flutter_v2/model/user_entity.dart';
import 'package:tasks_flutter_v2/routes.dart';
import 'package:tasks_flutter_v2/widget/todo_bloc_provider.dart';

class Home extends StatefulWidget {
  Home({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState(title: title);
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  static const String _addList = 'Add list';
  static const String _openSettings = 'Settings';
  final String title;

  UserEntity _user;
  bool _progress = false;

  _HomeState({@required this.title});

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

    if (_user == null) return _buildLoginScreen(context, theme);

    return StreamBuilder(
        stream: TodoListProvider
            .of(context)
            .todoLists,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<TodoList> todoLists = snapshot.data;
            return todoLists.isEmpty ? _buildEmptyApp(theme) : _buildApp(context, theme, todoLists);
          }
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
            height: MediaQuery
                .of(context)
                .size
                .height / 2.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check,
                  size: titleIconSize,
                  color: titleColor,
                ),
                Text('Tasks', style: titleTextStyle)
              ],
            ),
          ),
          _progress == true ? LinearProgressIndicator() : SizedBox(height: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('To get startet, press the button below', style: msgTextStyle),
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
                        _user = user;
                        _progress = false;
                      });
                    });
                  },
                ),
                Text(
                  'Turn on backup & sync',
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
            onPressed: () =>
                Navigator.pushNamed(context, Routes.addTask,
                    arguments: {'todoList': todoLists[DefaultTabController
                        .of(context)
                        .index]}),
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
    final String msgTitle = 'Nothing to do';
    final String msgNoTodoList = 'Start by creating a list in the menu above';
    final String msgNoTodos = 'Create some tasks by tapping the +';
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
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: _onSelectMenuItem,
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<String>>[
              Helper.buildMenuItem(Icons.playlist_add, _addList),
              Helper.buildMenuItem(Icons.settings, _openSettings),
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
      case _addList:
        _addTodoList();
        break;
      case _openSettings:
        break;
      default:
    }
  }

  void _addTodoList() {
    Helper.showInputDialog(context, title: 'New list', hint: 'Name').then((input) {
      if (input == null || input.isEmpty) {
      } else {
        final TodoList todoList = TodoList(title: input);
        TodoListProvider.of(context).addTodoList(todoList);
      }
    });
  }

  void _toggleTodo(TodoList todoList, Todo todo, bool isChecked) {
    todo.complete = isChecked;
    TodoListProvider.of(context).updateTodo(todoList, todo);
  }

  void _tapTodo(final TodoList todoList, final Todo todo) {
    Navigator.pushNamed(context, Routes.editTask, arguments: {'todoList': todoList, 'todo': todo});
  }
}
