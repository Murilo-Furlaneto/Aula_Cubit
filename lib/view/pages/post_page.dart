import 'package:aula_cubit/cubits/api_state.dart';
import 'package:aula_cubit/cubits/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool _showList = false;
  late final PostCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<PostCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(    
           children: [
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  cubit.fetchPosts();
                   _showList = true;
                });
              },
              child: const Text('Carregar Posts'),
            ),
          ),
          const SizedBox(height: 20),
          if (_showList)
            Expanded(
              child: BlocBuilder<PostCubit, ApiState>(
                bloc: cubit,
                builder: (context, state) {
                   if (state is InitialState) {
                return Center(
                  child: Text("Nenhuma post foi encontrado"),
                );
              }
                 else if (state is LoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if(state is LoadedState){
                     return ListView.builder(
                    itemCount: cubit.posts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.article),
                        title: Text(cubit.posts[index].title),
                        subtitle: Text('Descrição do post ${cubit.posts[index].body}'),
                      );
                    },
                  );
                  }
                  else {
                    return Center(
                      child: Text(
                        (state as ErrorState).message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                 
                }
              ),
            ),
        ],
      ),
    );
  }
}