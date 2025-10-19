import 'package:aula_cubit/data/model/post_data_model.dart';
import 'package:aula_cubit/data/datasource/remote/service/post_service.dart';
import 'package:aula_cubit/data/repository/post_repository.dart';

class PostRepositoryImpl extends PostRepository {
  final PostService service;

  PostRepositoryImpl({required this.service});

  @override
  Future<List<PostData>> fetchPosts() {
    return service.fetchPosts();
  }
}
