// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      uid: json['uid'] as String? ?? '',
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imgURL: json['imgURL'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      website: json['website'] as String? ?? '',
      followers: (json['followers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      following: (json['following'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      items:
          (json['items'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      boards: (json['boards'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      likedItems: (json['likedItems'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      likedBoards: (json['likedBoards'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      likedItemsBoardID: json['likedItemsBoardID'] as String? ?? '',
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'uid': instance.uid,
      'username': instance.username,
      'name': instance.name,
      'imgURL': instance.imgURL,
      'bio': instance.bio,
      'website': instance.website,
      'followers': instance.followers,
      'following': instance.following,
      'items': instance.items,
      'boards': instance.boards,
      'likedItems': instance.likedItems,
      'likedBoards': instance.likedBoards,
      'likedItemsBoardID': instance.likedItemsBoardID,
    };

BoardData _$BoardDataFromJson(Map<String, dynamic> json) => BoardData(
      id: json['id'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      imgURL: json['imgURL'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      likedBy: (json['likedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      items:
          (json['items'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$BoardDataToJson(BoardData instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'imgURL': instance.imgURL,
      'title': instance.title,
      'description': instance.description,
      'likes': instance.likes,
      'likedBy': instance.likedBy,
      'items': instance.items,
    };

ItemData _$ItemDataFromJson(Map<String, dynamic> json) => ItemData(
      id: json['id'] as String? ?? '',
      imgURL: json['imgURL'] as String? ?? '',
      uid: json['uid'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      likedBy: (json['likedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$ItemDataToJson(ItemData instance) => <String, dynamic>{
      'id': instance.id,
      'imgURL': instance.imgURL,
      'uid': instance.uid,
      'title': instance.title,
      'description': instance.description,
      'likes': instance.likes,
      'likedBy': instance.likedBy,
      'tags': instance.tags,
    };