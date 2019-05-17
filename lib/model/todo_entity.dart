import 'package:meta/meta.dart';
import 'package:tasks_flutter_v2/model/uuid.dart';

class TodoEntity {
  final String id;
  final String title;
  final String note;
  final int position;
  final bool complete;

  TodoEntity({String id, this.title, this.note, @required this.position, this.complete = false})
      : this.id = id ?? Uuid().generateV4();

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ note.hashCode ^ position.hashCode ^ complete.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          note == other.note &&
          position == other.position &&
          complete == other.complete;

  Map<String, Object> toJson() {
    return {
      "title": title,
      "note": note,
      "position": position,
      "complete": complete,
    };
  }

  @override
  String toString() {
    return 'TodoEntity{id: $id, title: $title, note: $note, position: $position, complete: $complete}';
  }

  static TodoEntity fromJson(Map<dynamic, dynamic> json) {
    return TodoEntity(
      id: json["id"] as String,
      title: json["title"] as String,
      note: json["note"] as String,
      position: json["position"] as int,
      complete: json["complete"] as bool,
    );
  }
}
