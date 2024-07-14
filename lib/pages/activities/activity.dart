import 'package:flutter/material.dart';
import 'package:rando/components/buttons/like_button.dart';
import 'package:rando/components/containers/tag_list.dart';
import 'package:rando/components/buttons/link.dart';
import 'package:rando/pages/profile/profile.dart';
import 'package:rando/services/auth.dart';
import 'package:rando/services/firestore/item_service.dart';
import 'package:rando/services/models.dart';
import 'package:rando/components/images/image.dart';
import 'package:rando/services/firestore/user_service.dart';
import 'package:rando/utils/theme/theme.dart';

class ActivityScreen extends StatefulWidget {
  final ItemData item;
  const ActivityScreen({super.key, required this.item});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  AuthService auth = AuthService();
  UserService userService = UserService();
  ItemService itemService = ItemService();
  bool isLiked = false;
  String username = '';
  late Stream<ItemData> itemStream;

  Future<bool> checkAuth() async {
    var user = auth.user!;
    return user.uid == widget.item.uid;
  }

  Future<void> checkLiked() async {
    var user = auth.user!;
    bool liked = await userService.userLikesItem(user.uid, widget.item.id);
    setState(() {
      isLiked = liked;
    });
  }

  Future<void> getUsername() async {
    String name = await userService.getUsername(widget.item.uid);
    setState(() {
      username = name;
    });
  }

  @override
  void initState() {
    super.initState();
    checkLiked();
    getUsername();
    itemStream = itemService.getItemStream(widget.item.id);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    itemService.updateItemLikes(auth.user!.uid, widget.item.id, isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
      ),
      body: StreamBuilder<ItemData>(
          stream: itemStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("Item Not Found."));
            }

            ItemData itemData = snapshot.data!;
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Material(
                  elevation: 15,
                  color: Theme.of(context).colorScheme.surface,
                  shadowColor: Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageWidget(
                          imgURL: itemData.imgURL,
                          width: double.infinity,
                          height: 256,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          itemData.title,
                          style: TextStyle(
                            color: Theme.of(context).textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          itemData.description,
                          style: TextStyle(
                            color: Theme.of(context).subtextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TagListWidget(tags: itemData.tags),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            LinkWidget(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(userID: itemData.uid),
                                ),
                              ),
                              text: '@$username',
                            ),
                            Row(
                              children: [
                                LikeButton(isLiked: isLiked, onTap: toggleLike),
                                const SizedBox(width: 10),
                                Text("${itemData.likes} likes"),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
