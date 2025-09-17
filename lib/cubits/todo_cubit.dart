import 'package:aula_cubit/cubits/todo_state.dart';
import 'package:bloc/bloc.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(InitialTodoState());

  final List<String> _todos = [];

  List<String> get todos => _todos;

  Future<void> addTodo(String todo) async {
    emit(LoadingTodoState());

    Future.delayed(const Duration(seconds: 1));

    if (_todos.contains(todo)) {
      emit(ErrorTodoState("Você já adicionou essa tarefa"));
      return;
    } else {
      _todos.add(todo);
      emit(LoadedTodoState(_todos));
    }
  }

  void removeTodo(int index) {
    emit(LoadingTodoState());

    Future.delayed(const Duration(seconds: 1));

    if (_todos.contains(_todos.elementAt(index))) {
      _todos.removeAt(index);
      emit(LoadedTodoState(_todos));
    } else {
      emit(ErrorTodoState("Esse item não está presente na lista"));
    }
  }
}
