import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rando/pages/posts/shared/post_card/view/post_card.dart';

class PostsGrid extends StatelessWidget {
  const PostsGrid({required this.onRefresh, required this.posts, super.key});
  final List<String> posts;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: defaultPadding),
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final postID = posts[index];
          return PostCard(
            postID: postID,
          );
        },
      ),
    );
  }
}
