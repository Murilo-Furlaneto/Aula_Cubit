import 'package:aula_cubit/data/model/post_data_model.dart';

abstract class PostRepository {
  Future<List<PostData>> fetchPosts();
}