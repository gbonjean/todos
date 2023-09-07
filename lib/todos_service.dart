import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todos/todo_model.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class TodosService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Todo>> stream() {
    final snapshots = _db.collection('todos').snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs.map((doc) => Todo.fromJson(doc.id, doc.data())).toList());
  }

  Future<void> create() async {
    final todo = Todo(id: _uuid.v4(), title: '', content: '');
    await _db.collection('todos').add(todo.toJson());
  }

  Future<void> update(Todo todo) async {
    await _db.collection('todos').doc(todo.id).update(todo.toJson());
  }

  Future<void> delete(Todo todo) async {
    await _db.collection('todos').doc(todo.id).delete();
  }
}
