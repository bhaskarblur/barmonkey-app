import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  dynamic _profile;
  dynamic get profile => _profile;

  chnageProfile(dynamic value) {
    _profile = value;
  }

  List<dynamic> _posts = [];
  List<dynamic> get posts => _posts;

  chnagePosts(dynamic value) {
    if(value!=null) {
      _posts = value;
    }
    else {
      _posts = [];
    }
    notifyListeners();
  }

  addToPosts(dynamic value) {
    _posts.add(value);
  }

  clearPosts() {
    _posts.clear();
    notifyListeners();
  }

  dynamic _likedBars;
  dynamic get likedBars => _likedBars;

  chnageLikedBars(dynamic value) {
    _likedBars = value;
    notifyListeners();
  }

  clearLikedBars() {
    _likedBars = null;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }
}
