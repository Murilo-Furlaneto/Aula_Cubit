import 'dart:convert';

import 'package:aula_cubit/data/model/post_data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostService {
  final http.Client client;

  PostService({required this.client});
  
  Future<List<PostData>> fetchPosts() async {
    try {
      final response = await client.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        return data.map<PostData>((item) => PostData.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      throw Exception("Erro ao buscar dados: ${e.toString()}");
    }
  }
}