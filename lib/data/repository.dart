import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/data/network_service.dart';

class Repository {
  final NetworkSerivce networkSerivce;
  Repository({required this.networkSerivce});

  Future<List<Todo>> fetchTodos() async {
    final todos = await networkSerivce.fetchTodos();
    return todos.map((e) => Todo.fromJson(e)).toList();
  }

  Future<bool> changeCompletion(bool complete, int id) async {
    final patchObject = {"completed": complete.toString()};
    return await networkSerivce.patchTodo(patchObject, id);
  }

  Future<Todo> addTodo(String message) async {
    final todoObject = {"userId": "10", "title": message, "completed": "false"};
    final todo = await networkSerivce.addTodo(todoObject);
    print(todo);
    return Todo.fromJson(todo);
  }

  Future<bool> deleteTodo(int? id) async {
    return await networkSerivce.deleteTodo(id);
  }

  Future<bool> updateTodo(String message, int? id) async {
    final patchObject = {"title": message};
    return await networkSerivce.patchTodo(patchObject, id!);
  }
}
