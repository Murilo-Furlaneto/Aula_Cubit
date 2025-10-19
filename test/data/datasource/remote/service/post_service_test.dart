import 'dart:convert';
import 'package:aula_cubit/data/datasource/remote/service/post_service.dart';
import 'package:aula_cubit/data/model/post_data_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late PostService postService;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    postService = PostService(client: mockHttpClient);
    registerFallbackValue(Uri.parse(''));
  });

  group('PostService Tests', () {
    final mockPostsJson = jsonEncode([
      {'userId': 1, 'id': 1, 'title': 'Test Title 1', 'body': 'Test Body 1'},
      {'userId': 1, 'id': 2, 'title': 'Test Title 2', 'body': 'Test Body 2'},
    ]);

    final mockPosts = [
      PostData(userId: 1, id: 1, title: 'Test Title 1', body: 'Test Body 1'),
      PostData(userId: 1, id: 2, title: 'Test Title 2', body: 'Test Body 2'),
    ];

    group('Caminho Feliz', () {
      test('Deve retornar uma lista de PostData quando a chamada for bem-sucedida (200)', () async {
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer(
          (_) async => http.Response(mockPostsJson, 200),
        );

        final result = await postService.fetchPosts();

        expect(result, isA<List<PostData>>());
        expect(result.length, 2);
        expect(result.first.title, 'Test Title 1');
      });
    });

    group('Casos de Erro', () {
      test('Deve lançar uma exceção para status code diferente de 200', () async {
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer(
          (_) async => http.Response('Not Found', 404),
        );

        final call = postService.fetchPosts();

        expect(call, throwsA(isA<Exception>()));
      });

      test('Deve lançar uma exceção quando o cliente http lançar um erro', () async {
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenThrow(Exception('HTTP Error'));

        final call = postService.fetchPosts();

        expect(call, throwsA(isA<Exception>()));
      });
    });

    group('Casos de Borda e Vulnerabilidades', () {
      test('Deve retornar uma lista vazia quando o servidor retornar uma lista vazia (200)', () async {
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer(
          (_) async => http.Response('[]', 200),
        );

        final result = await postService.fetchPosts();

        expect(result, isA<List<PostData>>());
        expect(result, isEmpty);
      });

      test('Deve lançar uma FormatException para JSON inválido', () async {
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer(
          (_) async => http.Response('invalid json', 200),
        );

        final call = postService.fetchPosts();

        expect(call, throwsA(isA<FormatException>()));
      });

      test('Deve lançar um erro se os dados do JSON estiverem malformados (campos faltando)', () async {
        final malformedJson = jsonEncode([
          {'userId': 1, 'id': 1, 'title': 'Only title'},
        ]);
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer(
          (_) async => http.Response(malformedJson, 200),
        );

        final call = postService.fetchPosts();

        expect(call, throwsA(isA<TypeError>()));
      });

      test('Deve lançar um erro se os dados do JSON tiverem tipos errados', () async {
        final wrongTypeJson = jsonEncode([
          {'userId': '1', 'id': '1', 'title': 123, 'body': true},
        ]);
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer(
          (_) async => http.Response(wrongTypeJson, 200),
        );

        final call = postService.fetchPosts();

        expect(call, throwsA(isA<TypeError>()));
      });
    });
  });
}
