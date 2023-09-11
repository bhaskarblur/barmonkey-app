import 'package:flutter/material.dart';

class FriendProvider with ChangeNotifier {
  dynamic _allFriends;
  dynamic get allFriends => _allFriends;

  changeAllFriends(dynamic value) {
    _allFriends = value;
    notifyListeners();
  }

  clearAllFriends() {
    _allFriends = null;
    notifyListeners();
  }

  dynamic _contactFriends;
  dynamic get contactFriends => _contactFriends;

  changeContactFriends(dynamic value) {
    _contactFriends = value;
    notifyListeners();
  }

  clearContactFriends() {
    _contactFriends = null;
    notifyListeners();
  }

  dynamic _mututalFriends;
  dynamic get mutualFriends => _mututalFriends;

  changemutualFriends(dynamic value) {
    _mututalFriends = value;
    notifyListeners();
  }

  clearmutualFriends() {
    _mututalFriends = null;
    notifyListeners();
  }

  dynamic _profile;
  dynamic get profile => _profile;

  changeProfile(dynamic value) {
    _profile = value;
    notifyListeners();
  }

  dynamic _posts;
  dynamic get posts => _posts;

  changePosts(dynamic value) {
    _posts = value;
    notifyListeners();
  }

  clearPosts() {
    _posts = null;
    notifyListeners();
  }

  List<dynamic> _likedBars = [];
  List<dynamic> get likedBars => _likedBars;

  addToLikedBars(dynamic value) {
    _likedBars.add(value);
  }

  notify() {
    notifyListeners();
  }

  clearLikedBars() {
    _likedBars.clear();
    notifyListeners();
  }

  dynamic _friendRequests;
  dynamic get friendRequests => _friendRequests;

  changeFriendRequests(dynamic value) {
    _friendRequests = value;
    notifyListeners();
  }

  clearFriendRequests() {
    _friendRequests = null;
    notifyListeners();
  }

  dynamic _search;
  dynamic get search => _search;

  changeSearch(dynamic value) {
    _search = value;
    notifyListeners();
  }

  clearSearch() {
    _search = null;
    notifyListeners();
  }
}
