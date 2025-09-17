import 'dart:convert';

import 'package:aula_cubit/data/datasource/remote/model/post_data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostService {
  
  Future<List<PostData>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        return data.map<PostData>((item) => PostData.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      Exception("Erro ao buscar dados: ${e.toString()}");
      debugPrint("Erro ao buscar dados: ${e.toString()}");
      return [];
    }
  }
}