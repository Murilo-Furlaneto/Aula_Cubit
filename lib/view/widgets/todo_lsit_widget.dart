import 'package:aula_cubit/cubits/todo_cubit.dart';
import 'package:flutter/material.dart';

class TodoLsitWidget extends StatelessWidget {
  const TodoLsitWidget({super.key, required this.todos, required this.cubit});

  final List<String> todos;
  final TodoCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            child: Center(child: Text(todos[index][0].toUpperCase())),
          ),
          title: Text(todos[index]),
          trailing: IconButton(
            onPressed: () {
              cubit.removeTodo(index);
            },
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        );
      },
    );
  }
}
