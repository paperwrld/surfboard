import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/posts.dart';
import 'package:rando/features/posts/shared/shuffle_posts/cubit/shuffle_index_cubit.dart';

class ShuffledPostsPage extends StatelessWidget {
  const ShuffledPostsPage({required this.boardID, super.key});
  final String boardID;
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: 'Shuffled Posts'),
      ),
      body: BlocProvider(
        create: (context) => PostCubit(
          postRepository: context.read<PostRepository>(),
        )..shufflePostList(boardID),
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              final posts = state.posts;
              return PostViewController(posts: posts);
            } else if (state.isEmpty) {
              return const Center(child: PrimaryText(text: 'Board is empty.'));
            } else {
              return const Center(
                child: PrimaryText(text: 'Something went wrong'),
              );
            }
          },
        ),
      ),
    );
  }
}

class PostViewController extends StatelessWidget {
  const PostViewController({required this.posts, super.key});
  final List<Post> posts;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShuffleIndexCubit(),
      child: BlocBuilder<ShuffleIndexCubit, int>(
        builder: (context, state) {
          return Center(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PostView(
                  post: posts[state],
                  postCubit: context.read<PostCubit>(),
                ),
                const VerticalSpacer(),
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        inverted: false,
                        text: 'Last',
                        onTap: () {
                          if (state > 0) {
                            context.read<ShuffleIndexCubit>().decrement();
                          }
                        },
                      ),
                    ),
                    const HorizontalSpacer(),
                    Expanded(
                      child: ActionButton(
                        inverted: true,
                        text: 'Next',
                        onTap: () {
                          if (state < posts.length - 1) {
                            context.read<ShuffleIndexCubit>().increment();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
