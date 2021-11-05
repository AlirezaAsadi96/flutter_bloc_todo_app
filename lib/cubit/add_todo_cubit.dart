import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/cubit/todo_cubit.dart';
import 'package:todo_app/data/repository.dart';

part 'add_todo_state.dart';

class AddTodoCubit extends Cubit<AddTodoState> {
  final Repository repository;
  final TodoCubit todoCubit;
  AddTodoCubit({required this.repository, required this.todoCubit})
      : super(AddTodoInitial());

  void addTodo(String message) {
    if (message.isEmpty) {
      emit(AddTodoError(error: "message is empty"));
      return;
    }
    emit(AddingTodo());

    repository.addTodo(message).then((todo) {
      print(todo);
      todoCubit.addTodo(todo);
      emit(TodoAdded());
    });
  }
}
