import 'package:flutter/material.dart';

class FriendProvider with ChangeNotifier {
  dynamic _allFriends;
  dynamic get allFriends => _allFriends;

  dynamic _friendsStories;
  dynamic get friendsStories => _friendsStories;


  changeAllFriends(dynamic value) {
    _allFriends = value;
    notifyListeners();
  }

  changefriendsStories(dynamic value) {
    _friendsStories = value;
    notifyListeners();
  }

  clearAllFriends() {
    _allFriends = null;
    notifyListeners();
  }

  dynamic _contactFriends;
  dynamic get contactFriends => _contactFriends;
  dynamic _yesNoEvents;
  dynamic get yesNoEvents => _yesNoEvents;

  dynamic _yesEvents;
  dynamic get yesEvents => _yesEvents;

  changeContactFriends(dynamic value) {
    _contactFriends = value;
    notifyListeners();
  }

  changeYesNoEvents(dynamic value) {
    _yesNoEvents = value;
    notifyListeners();
  }

  changeYesEvents(dynamic value) {
    _yesEvents = value;
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

  dynamic _friendRequestsNearBy = [];
  dynamic get friendRequestsNearBy => _friendRequestsNearBy;

  dynamic _friendRequestsQrScan = [];
  dynamic get friendRequestsQrScan => _friendRequestsQrScan;


  dynamic _friendRequestsSearch = [];
  dynamic get friendRequestsSearch => _friendRequestsSearch;

  changeFriendRequests(dynamic value) {
    _friendRequests = value;

    for(var i=0;i<value.length; i++) {
      if(value[i]['source'] == "search") {
        addToFriendRequestsSearch(value[i]);
      }
      else if(value[i]['source'] == "meet") {
        addToFriendRequestsNearby(value[i]);
      }
      else if(value[i]['source'] == "qr_scan") {
        addToFriendRequestsQrScan(value[i]);
      }
    }
    notifyListeners();
  }

  addToFriendRequestsNearby(dynamic value) {
    _friendRequestsNearBy = value;
    notifyListeners();
  }

  addToFriendRequestsSearch(dynamic value) {
    _friendRequestsSearch = value;
    notifyListeners();
  }

  addToFriendRequestsQrScan(dynamic value) {
    _friendRequestsQrScan = value;
    notifyListeners();
  }

  clearFriendRequests() {
    _friendRequests = null;
    notifyListeners();
  }

  clearFriendStories() {
    _friendsStories = null;
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
