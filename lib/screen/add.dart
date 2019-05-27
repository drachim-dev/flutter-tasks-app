import 'package:flutter/material.dart';
import 'package:tasks_flutter_v2/common/helper.dart';
import 'package:tasks_flutter_v2/generated/i18n.dart';
import 'package:tasks_flutter_v2/model/todo.dart';
import 'package:tasks_flutter_v2/model/todo_list.dart';
import 'package:tasks_flutter_v2/model/user_entity.dart';
import 'package:tasks_flutter_v2/widget/radio_button.dart';
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

  TimeOfDay _defaultReminder = TimeOfDay(hour: 8, minute: 0);

  static const String _dateToday = 'Today';
  static const String _dateTomorrow = 'Tomorrow';
  static const String _dateCustom = 'Pick day';
  static const String _timeCustom = 'Pick time';

  int _selectedDateRadio = 0; // pre select first option
  int _selectedTimeRadio = 0; // pre select first option

  DateTime _dateOption1;
  DateTime _dateOption2;
  DateTime _dateOption3;

  TimeOfDay _timeOption1;
  TimeOfDay _timeOption2;
  TimeOfDay _timeOption3;

  _AddState({@required this.user, @required this.todoList, Todo todo})
      : todo = todo ?? Todo(position: todoList.todos.length);

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: todo.title);
    _descController = TextEditingController(text: todo.note);

    _dateOption1 = Helper.getToday();
    _dateOption2 = Helper.getToday().add(Duration(days: 1));

    _timeOption1 = Helper.getNextHour(DateTime.now());
    _timeOption2 = Helper.getNextHour(DateTime.now().add(Duration(hours: 4)));

    if (todo.reminderSet) {
      _dateOption3 = todo.reminder;
      _timeOption3 = TimeOfDay.fromDateTime(todo.reminder);

      _selectedDateRadio = 2;
      _selectedTimeRadio = 2;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleOnDateChanged(int value) {
    if (value == 2) {
      _showDatePicker().then((dateTime) {
        setState(() {
          _dateOption3 = dateTime ?? _dateOption3;
          _selectedDateRadio = value;
        });
      });
    } else {
      setState(() {
        _selectedDateRadio = value;
      });
    }
  }

  void _handleOnTimeChanged(int value) {
    if (value == 2) {
      _showTimePicker().then((timeOfDay) {
        setState(() {
          _timeOption3 = timeOfDay ?? _timeOption3;
          _selectedTimeRadio = value;
        });
      });
    } else {
      setState(() {
        _selectedTimeRadio = value;
      });
    }
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
          child: Icon(Icons.send), tooltip: S.of(context).createTodo, onPressed: _saveTodo),
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

    final String dateTitle1 = _dateToday;
    final String timeTitle1 = Helper.formatTimeOfDay(context, _timeOption1);

    final String dateTitle2 = _dateTomorrow;
    final String timeTitle2 = Helper.formatTimeOfDay(context, _timeOption2);

    final String dateTitle3 = _dateOption3 == null ? _dateCustom : Helper.formatDate(_dateOption3);
    final String timeTitle3 =
        _timeOption3 == null ? _timeCustom : Helper.formatTimeOfDay(context, _timeOption3);

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
              buildOptionColumn(dateTitle1, timeTitle1, 0),
              buildOptionColumn(dateTitle2, timeTitle2, 1),
              buildOptionColumn(dateTitle3, timeTitle3, 2),
            ],
          ),
        ),
      ],
    );
  }

  IntrinsicWidth buildOptionColumn(String dateTitle, String timeTitle, int groupValue) {
    return IntrinsicWidth(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
        RadioButton(
            title: dateTitle,
            groupValue: _selectedDateRadio,
            value: groupValue,
            onChanged: _handleOnDateChanged),
        RadioButton(
            title: timeTitle,
            groupValue: _selectedTimeRadio,
            value: groupValue,
            onChanged: _handleOnTimeChanged),
      ]),
    );
  }

  Future<DateTime> _showDatePicker() async {
    DateTime date = todo.reminder ?? Helper.getToday();
    DateTime firstDate = new DateTime(date.year - 1, date.month, date.day);
    DateTime lastDate = new DateTime(date.year + 3, date.month, date.day);

    return showDatePicker(
        context: context, firstDate: firstDate, initialDate: date, lastDate: lastDate);
  }

  Future<TimeOfDay> _showTimePicker() {
    return showTimePicker(
        context: context,
        initialTime:
            todo.reminder == null ? _defaultReminder : TimeOfDay.fromDateTime(todo.reminder));
  }

  void _saveTodo() {
    todo.title = _titleController.text;
    todo.note = _descController.text;

    if (todo.reminderSet) {
      DateTime selDate;
      switch (_selectedDateRadio) {
        case 0:
          selDate = _dateOption1;
          break;
        case 1:
          selDate = _dateOption2;
          break;
        case 2:
          selDate = _dateOption3;
          break;
      }

      TimeOfDay selTime;
      switch (_selectedTimeRadio) {
        case 0:
          selTime = _timeOption1;
          break;
        case 1:
          selTime = _timeOption2;
          break;
        case 2:
          selTime = _timeOption3;
          break;
      }

      todo.reminder =
          DateTime(selDate.year, selDate.month, selDate.day, selTime.hour, selTime.minute);
    }

    if (todo.id == null) {
      TodoListProvider.of(context).addTodo(user, todoList, todo);
    } else {
      TodoListProvider.of(context).updateTodo(user, todoList, todo);
    }

    Navigator.pop(context);
  }
}
