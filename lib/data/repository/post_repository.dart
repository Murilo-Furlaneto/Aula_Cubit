import 'package:aula_cubit/data/datasource/remote/model/post_data_model.dart';

abstract class PostRepository {
  Future<List<PostData>> fetchPosts();
}