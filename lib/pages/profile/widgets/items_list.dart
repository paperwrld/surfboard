// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/core/services/auth_service.dart';
import 'package:rando/core/models/models.dart';

// components
import 'package:rando/shared/cards/activity_card.dart';
import 'package:rando/core/services/user_service.dart';
import 'package:rando/shared/widgets/buttons/defualt_button.dart';

class ItemListWidget extends StatefulWidget {
  final String userID;

  const ItemListWidget({super.key, required this.userID});

  @override
  State<ItemListWidget> createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  // firestore
  final UserService userService = UserService();

  var currentUser = AuthService().user!;

  Future<void> refreshItems() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshItems,
      child: StreamBuilder<List<ItemData>>(
        stream: userService.readUserItemStream(widget.userID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("error: ${snapshot.error.toString()}"));
          } else if (snapshot.hasData) {
            // data found
            List<ItemData> items = snapshot.data!;
            if (widget.userID == currentUser.uid && items.isEmpty) {
              return ListView(
                children: [
                  const Text("You have not created any activities yet!"),
                  const SizedBox(height: 15),
                  DefualtButton(
                    inverted: false,
                    text: "Create an activity!",
                    onTap: () => Navigator.pushNamed(context, '/create'),
                  ),
                ],
              );
            } else if (widget.userID != currentUser.uid && items.isEmpty) {
              return const Center(
                child: Text("User has not created an activity yet!"),
              );
            } else {
              return GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  ItemData item = items[index];
                  return ItemCardWidget(item: item);
                },
              );
            }
          } else {
            // data is empty..
            return const Text("No Lists Found in Firestore. Check Database");
          }
        },
      ),
    );
  }
}