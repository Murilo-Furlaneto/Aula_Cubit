import 'package:aula_cubit/cubits/api_state.dart';
import 'package:aula_cubit/cubits/post_cubit.dart';
import 'package:aula_cubit/data/model/post_data_model.dart';
import 'package:aula_cubit/data/repository/post_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  group('PostCubit Tests', () {
    late PostCubit postCubit;
    late MockPostRepository mockPostRepository;

    final mockPosts = [
      PostData(userId: 1, id: 1, title: 'Test Title 1', body: 'Test Body 1'),
      PostData(userId: 1, id: 2, title: 'Test Title 2', body: 'Test Body 2'),
    ];

    setUp(() {
      mockPostRepository = MockPostRepository();
      postCubit = PostCubit(mockPostRepository);
    });

    tearDown(() {
      postCubit.close();
    });

    test('O estado inicial deve ser InitialState', () {
      expect(postCubit.state, isA<InitialState>());
    });

    group('Caminho Feliz', () {
      blocTest<PostCubit, ApiState>(
        'Deve emitir [LoadingState, LoadedState] com uma lista de posts quando a busca for bem-sucedida',
        build: () {
          when(() => mockPostRepository.fetchPosts()).thenAnswer((_) async => mockPosts);
          return postCubit;
        },
        act: (cubit) => cubit.fetchPosts(),
        expect: () => [
          isA<LoadingState>(),
          isA<LoadedState<List<PostData>>>().having((state) => state.data, 'data', mockPosts),
        ],
        verify: (_) {
          verify(() => mockPostRepository.fetchPosts()).called(1);
        },
      );
    });

    group('Casos de Erro', () {
      final exception = Exception('Falha ao buscar posts');
      final error = 'Exception: Falha ao buscar posts';

      blocTest<PostCubit, ApiState>(
        'Deve emitir [LoadingState, ErrorState] quando o repositório lançar uma exceção',
        build: () {
          when(() => mockPostRepository.fetchPosts()).thenThrow(exception);
          return postCubit;
        },
        act: (cubit) => cubit.fetchPosts(),
        expect: () => [
          isA<LoadingState>(),
          isA<ErrorState>().having((state) => state.message, 'message', "Erro ao buscar dados: $error"),
        ],
        verify: (_) {
          verify(() => mockPostRepository.fetchPosts()).called(1);
        },
      );

      final formatException = FormatException('JSON malformado');
      blocTest<PostCubit, ApiState>(
        'Deve emitir [LoadingState, ErrorState] quando ocorrer um erro de parsing (FormatException)',
        build: () {
          when(() => mockPostRepository.fetchPosts()).thenThrow(formatException);
          return postCubit;
        },
        act: (cubit) => cubit.fetchPosts(),
        expect: () => [
          isA<LoadingState>(),
          isA<ErrorState>().having((state) => state.message, 'message', "Erro ao buscar dados: $formatException"),
        ],
        verify: (_) {
          verify(() => mockPostRepository.fetchPosts()).called(1);
        },
      );
    });

    // Teste 4: Casos de Borda
    group('Casos de Borda', () {
      blocTest<PostCubit, ApiState>(
        'Deve emitir [LoadingState, LoadedState] com uma lista vazia quando o repositório retornar uma lista vazia',
        build: () {
          when(() => mockPostRepository.fetchPosts()).thenAnswer((_) async => []);
          return postCubit;
        },
        act: (cubit) => cubit.fetchPosts(),
        expect: () => [
          isA<LoadingState>(),
          isA<LoadedState<List<PostData>>>().having((state) => state.data, 'data', isEmpty),
        ],
        verify: (_) {
          verify(() => mockPostRepository.fetchPosts()).called(1);
        },
      );

      final postsWithEmptyData = [
        PostData(userId: 1, id: 1, title: '', body: ''),
        PostData(userId: 2, id: 2, title: 'Title', body: ''),
      ];
      blocTest<PostCubit, ApiState>(
        'Deve lidar com posts com dados vazios (strings vazias)',
        build: () {
          when(() => mockPostRepository.fetchPosts()).thenAnswer((_) async => postsWithEmptyData);
          return postCubit;
        },
        act: (cubit) => cubit.fetchPosts(),
        expect: () => [
          isA<LoadingState>(),
          isA<LoadedState<List<PostData>>>().having((state) => state.data, 'data', postsWithEmptyData),
        ],
        verify: (_) {
          verify(() => mockPostRepository.fetchPosts()).called(1);
        },
      );
    });
    
    group('Testes de Concorrência', () {
      final posts1 = [PostData(userId: 1, id: 1, title: 'First Call', body: 'Body1')];
      final posts2 = [PostData(userId: 2, id: 2, title: 'Second Call', body: 'Body2')];
      blocTest<PostCubit, ApiState>(
        'Deve lidar com múltiplas chamadas a fetchPosts, refletindo o estado da chamada mais recente',
        build: () {
          when(() => mockPostRepository.fetchPosts()).thenAnswer((_) async {
            await Future.delayed(const Duration(milliseconds: 100));
            return posts1;
          });
          return postCubit;
        },
        act: (cubit) async {
          cubit.fetchPosts(); 
          
          when(() => mockPostRepository.fetchPosts()).thenAnswer((_) async => posts2);
          await cubit.fetchPosts();
        },
        expect: () => [
          isA<LoadingState>(),
          isA<LoadingState>(),
          isA<LoadedState<List<PostData>>>().having((state) => state.data.first.title, 'title', 'Second Call'),
        ],
        verify: (_) {
          verify(() => mockPostRepository.fetchPosts()).called(2);
        },
      );
    });
  });
}
