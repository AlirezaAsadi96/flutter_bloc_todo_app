import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/cubit/todo_cubit.dart';
import 'package:todo_app/data/models/todo.dart';
import 'package:todo_app/data/repository.dart';

part 'edit_todo_state.dart';

class EditTodoCubit extends Cubit<EditTodoState> {
  final Repository repository;
  final TodoCubit todoCubit;
  EditTodoCubit({required this.repository, required this.todoCubit})
      : super(EditTodoInitial());

  void deleteTodo(Todo todo) {
    emit(TodoEditing());
    repository.deleteTodo(todo.id).then((isDeleted) {
      if (isDeleted) {
        todoCubit.deleteTodo(todo);
        emit(TodoEdited());
      }
    });
  }

  void updateTodo(Todo todo, String message) {
    if (message.isEmpty) {
      emit(EditTodoError(error: "Message is empty"));
      return;
    }

    emit(TodoEditing());

    repository.updateTodo(message, todo.id).then((isEdited) {
      if (isEdited) {
        todo.title = message;
        todoCubit.updateTodoList();
        emit(TodoEdited());
      }
    });
  }
}
