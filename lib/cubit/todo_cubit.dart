import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/data/repository.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final Repository repository;
  TodoCubit({required this.repository}) : super(TodoInitial());

  void fetchTodo() {
    repository.fetchTodos().then((todos) {
      emit(TodosLoaded(todos: todos));
    });
  }

  void changeCompletion(Todo todo) {
    repository.changeCompletion(!todo.completed!, todo.id!).then((isChanged) {
      print(isChanged);
      if (isChanged) todo.completed = !todo.completed!;
      updateTodoList();
    });
  }

  void updateTodoList() {
    final currentState = state;
    if (currentState is TodosLoaded) {
      emit(TodosLoaded(todos: currentState.todos));
    }
  }

  void addTodo(Todo todo) {
    final currentState = state;
    if (currentState is TodosLoaded) {
      final todoList = currentState.todos;
      todoList.add(todo);

      emit(TodosLoaded(todos: todoList));
    }
  }

  void deleteTodo(Todo todo) {
    final currentState = state;
    if (currentState is TodosLoaded) {
      final todoList =
          currentState.todos.where((el) => el.id != todo.id).toList();
      emit(TodosLoaded(todos: todoList));
    }
  }
}
