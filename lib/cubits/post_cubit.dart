import 'dart:core';
import 'dart:collection';

import 'package:aula_cubit/cubits/api_state.dart';
import 'package:aula_cubit/data/datasource/remote/model/post_data_model.dart';
import 'package:aula_cubit/data/repository/post_repository.dart';
import 'package:bloc/bloc.dart';

class PostCubit extends Cubit<ApiState> {
  PostCubit(this.repository) : super(InitialState());

  final PostRepository repository;
  List<PostData> _posts = [];

  UnmodifiableListView<PostData> get posts => UnmodifiableListView(_posts);

  Future<List<PostData>> fetchPosts() async {
    emit(LoadingState());
    try {
      final List<PostData> postsResponse = await repository.fetchPosts();
      await Future.delayed(const Duration(seconds: 1));
      _posts = postsResponse;
      emit(LoadedState<List<PostData>>(postsResponse));
      return postsResponse;
    } catch (e) {
      emit(ErrorState("Erro ao buscar dados: ${e.toString()}"));
      return [];
    }
  }
}