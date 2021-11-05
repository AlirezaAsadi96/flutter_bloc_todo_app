import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/add_todo_cubit.dart';
import 'package:todo_app/cubit/edit_todo_cubit.dart';
import 'package:todo_app/data/models/todo.dart';

import '../cubit/todo_cubit.dart';
import '../data/network_service.dart';
import '../data/repository.dart';
import '../presentation/screens/add_todo_screen.dart';
import '../presentation/screens/edit_todo_screen.dart';
import '../presentation/screens/todos_screen.dart';

class AppRouter {
  late Repository repository;
  late TodoCubit todoCubit;
  AppRouter() {
    repository = Repository(networkSerivce: NetworkSerivce());
    todoCubit = TodoCubit(repository: repository);
  }

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: todoCubit,
            child: const TodosScreen(),
          ),
        );
      case "/edit_todo":
        final todo = settings.arguments as Todo;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                EditTodoCubit(repository: repository, todoCubit: todoCubit),
            child: EditTodoScreen(
              todo: todo,
            ),
          ),
        );
      case "/add_todo":
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                AddTodoCubit(repository: repository, todoCubit: todoCubit),
            child: AddTodoScreen(),
          ),
        );
      default:
        return MaterialPageRoute(builder: (ctx) => Container());
    }
  }
}
