import 'package:meta/meta.dart';
import 'package:tasks_flutter_v2/model/todo_entity.dart';

class Todo {
  final String id;
  String title;
  String note;
  int position;
  bool complete;

  Todo({this.id, this.title = '', this.note = '', @required this.position, this.complete = false});

  Todo copyWith({String id, String title, String note, int position, bool complete}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      position: position ?? this.position,
      complete: complete ?? this.complete,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ note.hashCode ^ position.hashCode ^ complete.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          note == other.note &&
          position == other.position &&
          complete == other.complete;

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, note: $note, position: $position, complete: $complete}';
  }

  TodoEntity toEntity() {
    return TodoEntity(id: id,
        title: title,
        note: note,
        position: position,
        complete: complete);
  }

  static Todo fromEntity(TodoEntity entity) {
    return Todo(
      id: entity.id,
      title: entity.title,
      note: entity.note,
      position: entity.position,
      complete: entity.complete ?? false,
    );
  }
}
