import 'package:aula_cubit/cubits/post_cubit.dart';
import 'package:aula_cubit/cubits/todo_cubit.dart';
import 'package:aula_cubit/data/datasource/remote/model/post_data_model.dart';
import 'package:aula_cubit/data/datasource/remote/service/post_service.dart';
import 'package:aula_cubit/data/repository/post_repository.dart';
import 'package:aula_cubit/data/repository/post_repository_impl.dart';
import 'package:aula_cubit/view/pages/home_page.dart';
import 'package:aula_cubit/view/pages/post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoCubit>(create: (_) => TodoCubit()),
        BlocProvider<PostCubit>(
          create: (_) => PostCubit(PostRepositoryImpl(service: PostService(), )),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.indigo),
        home: PostPage(),
      ),
    );
  }
}
