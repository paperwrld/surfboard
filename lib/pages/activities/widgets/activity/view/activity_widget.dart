import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:rando/pages/activities//cubit/activity_cubit.dart';
import 'package:rando/pages/activities/edit_activity/edit_activity.dart';
import 'package:rando/pages/activities/widgets/activity/view/more_options.dart';
import 'package:rando/pages/profile/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

class Activity extends StatelessWidget {
  const Activity({required this.itemID, super.key});
  final String itemID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemCubit(
        itemsRepository: context.read<ItemsRepository>(),
        userRepository: context.read<UserRepository>(),
      )..streamItem(itemID),
      child: Scaffold(
        appBar: AppBar(title: const Text('Item Details')),
        body: BlocBuilder<ItemCubit, ItemState>(
          builder: (context, state) {
            if (state is ItemLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ItemLoaded) {
              final item = state.item;
              return ActivityWidget(item: item);
            } else if (state is ItemError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}

class ActivityWidget extends StatelessWidget {
  const ActivityWidget({required this.item, super.key});
  final Item item;
  @override
  Widget build(BuildContext context) {
    final user = context.read<ItemCubit>().getUser();
    final isOwner = context.read<ItemCubit>().isOwner(
          item.uid,
          user.uid,
        );
    final likedByUser = user.hasLikedItem(itemID: item.id);
    return Center(
      child: CustomContainer(
        inverted: false,
        horizontal: null,
        vertical: null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: Theme.of(context).textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                MoreOptions(
                  itemID: item.id,
                  userID: item.uid,
                  isOwner: isOwner,
                  imgURL: item.photoURL.toString(),
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (context) => EditActivityPage(itemID: item.id),
                      ),
                    );
                  },
                  onDelete: () {
                    Navigator.pop(context);
                    context.read<ItemCubit>().deleteItem(
                          item.uid,
                          item.id,
                          item.photoURL.toString(),
                        );
                  },
                ),
              ],
            ),
            const SizedBox(height: defaultSpacing),
            Hero(
              tag: item.photoURL.toString(),
              child: ImageWidget(
                borderRadius: defaultBorderRadius,
                photoURL: item.photoURL,
                height: 256,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              item.description,
              style: TextStyle(
                color: Theme.of(context).subtextColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: defaultSpacing),
            TagListWidget(tags: item.tags),
            const SizedBox(height: defaultSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LinkWidget(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (context) => ProfilePage(userID: item.uid),
                    ),
                  ),
                  text: '@${user.username}',
                ),
                LikeButton(
                  likes: item.likes,
                  isLiked: likedByUser,
                  onTap: () => context
                      .read<ItemCubit>()
                      .toggleLike(user.uid, item.id, likedByUser),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}