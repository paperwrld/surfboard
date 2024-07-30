import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

// State definitions
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit({
    required PostRepository postRepository,
  })  : _postRepository = postRepository,
        super(const PostState.initial());

  final PostRepository _postRepository;

  bool isOwner(String postUserID, String currentUserID) {
    return postUserID == currentUserID;
  }

  Future<void> getPost(String postID) async {
    emit(state.fromLoading());
    try {
      final post = await _postRepository.fetchPost(postID);
      if (post.isEmpty) {
        emit(state.fromEmpty());
        return;
      }
      emit(state.fromPostLoaded(post));
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  void streamPost(String postID) {
    emit(state.fromLoading());
    try {
      _postRepository.streamPost(postID).listen(
        (snapshot) {
          emit(state.fromPostLoaded(snapshot));
        },
        onError: (dynamic error) {
          emit(state.fromFailure(PostFailure.fromGetPost()));
        },
      );
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  void streamUserPosts(String userID) {
    emit(state.fromLoading());
    try {
      _postRepository.streamUserPosts(userID).listen(
        (posts) {
          emit(state.fromPostsLoaded(posts));
        },
        onError: (dynamic error) {
          emit(state.fromEmpty());
        },
      );
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  void streamBoardPosts(String boardID) {
    emit(state.fromLoading());
    try {
      _postRepository.streamBoardPosts(boardID).listen(
        (posts) {
          emit(state.fromPostsLoaded(posts));
        },
        onError: (dynamic error) {
          emit(state.fromEmpty());
        },
      );
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  void streamAllPosts() {
    emit(state.fromLoading());
    try {
      _postRepository.streamPosts().listen(
        (posts) {
          emit(state.fromPostsLoaded(posts));
        },
        onError: (dynamic error) {
          emit(state.fromEmpty());
        },
      );
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> editField(String postID, String field, dynamic data) async {
    emit(state.fromLoading());
    await _postRepository.updateField(postID, {field: data});
    emit(state.fromUpdate());
  }

  Future<void> toggleLike(
    String userID,
    String postID, {
    required bool liked,
  }) async {
    emit(state.fromLoading());
    try {
      await _postRepository.updateLikes(
        userID: userID,
        postID: postID,
        isLiked: liked,
      );
      emit(state.fromPostToggle(liked: liked));
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> createPost({
    required String userID,
    required String title,
    required String description,
    required List<String> tags,
    required File? imageFile,
  }) async {
    emit(state.fromLoading());
    try {
      final docID = await _postRepository.createPost(
        Post(
          title: title,
          description: description,
          uid: 'userId', // Replace with actual user ID
          tags: tags,
        ),
        userID,
      );
      if (imageFile != null) {
        await FirebaseFirestore.instance.uploadImage('posts', docID, imageFile);
      }
      emit(state.fromCreated());
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> deletePost(
    String userID,
    String postID,
    String photoURL,
  ) async {
    emit(state.fromLoading());
    try {
      await _postRepository.deletePost(userID, postID, photoURL);
      emit(state.fromDeleted());
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }
}

extension _PostStateExtensions on PostState {
  PostState fromLoading() => copyWith(status: PostStatus.loading);

  PostState fromEmpty() => copyWith(status: PostStatus.empty);

  PostState fromCreated() => copyWith(status: PostStatus.created);

  PostState fromDeleted() => copyWith(status: PostStatus.deleted);

  PostState fromUpdate() => copyWith(status: PostStatus.updated);

  PostState fromPostLoaded(Post post) => copyWith(
        status: PostStatus.loaded,
        post: post,
      );

  PostState fromPostsLoaded(List<Post> posts) => copyWith(
        status: PostStatus.loaded,
        posts: posts,
      );

  PostState fromPostToggle({required bool liked}) => copyWith(
        status: PostStatus.loaded,
        liked: liked,
      );

  PostState fromFailure(PostFailure failure) => copyWith(
        status: PostStatus.failure,
        failure: failure,
      );
}