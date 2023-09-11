import 'package:flutter/material.dart';

class BarsProvider with ChangeNotifier {
  // Searched Bars
  dynamic _searchedBars;
  dynamic get searchedBars => _searchedBars;

  addToSearchedBarList(dynamic value) {
    _searchedBars = value;
    notifyListeners();
  }

  clearSearchedBars() {
    _searchedBars = null;
    notifyListeners();
  }

  // Liked Bars
  List<dynamic> _likedBars = [];
  List<dynamic> get likedBars => _likedBars;

  addToLikedBarList(dynamic value) {
    _likedBars.addAll(value);
    notifyListeners();
  }

  clearLikedBars() {
    _likedBars.clear();
    notifyListeners();
  }

  // popular in Your City Bars
  List<dynamic> _popularInYourCity = [];
  List<dynamic> get popularInYourCity => _popularInYourCity;

  addToPopularInYourCity(dynamic value) {
    _popularInYourCity.addAll(value);
    notifyListeners();
  }

  clearPopularInYourCity() {
    _popularInYourCity.clear();
    notifyListeners();
  }

  // Liked By Your Friends
  List<dynamic> _likedByFriends = [];
  List<dynamic> get likedByFriends => _likedByFriends;

  addToLikedByFriends(dynamic value) {
    _likedByFriends.addAll(value);
    notifyListeners();
  }

  clearLikedByFriends() {
    _likedByFriends.clear();
    notifyListeners();
  }

  dynamic _barDetails;
  dynamic get barDetails => _barDetails;

  changeBarDetails(dynamic value) {
    _barDetails = value;
    notifyListeners();
  }

  clearBarDetails() {
    _barDetails = null;
    notifyListeners();
  }

  List<String> _category = [];
  List<String> get category => _category;

  addToCategory(dynamic value) {
    _category.add(value);
    notifyListeners();
  }

  clearCategory() {
    _category.clear();
  }

  String _selectedCategory = '';
  String get selectedCategory => _selectedCategory;

  changeSelectedCategory(dynamic value) {
    _selectedCategory = value;
    notifyListeners();
  }

  dynamic _barsNearbyUsers;
  dynamic get barsNearbyUsers => _barsNearbyUsers;

  changeBarsNearbyUsers(dynamic value) {
    _barsNearbyUsers = value;
    notifyListeners();
  }

  clearBarsNearbyUsers() {
    _barsNearbyUsers = null;
    notifyListeners();
  }

  List<String> _filterCategory = [];
  List<String> get filterCategory => _filterCategory;

  addToFileterCategory(String value) {
    _filterCategory.add(value);
    notifyListeners();
  }

  removeFromFilterCategory(String value) {
    _filterCategory.remove(value);
    notifyListeners();
  }

  clearFilterCategory() {
    _filterCategory.clear();
    notifyListeners();
  }

  List<String> _filterMusic = [];
  List<String> get filterMusic => _filterMusic;

  addToFileterMusic(String value) {
    _filterMusic.add(value);
    notifyListeners();
  }

  removeFromFilterMusic(String value) {
    _filterMusic.remove(value);
    notifyListeners();
  }

  clearFilterMusic() {
    _filterMusic.clear();
    notifyListeners();
  }

  dynamic _feedType;
  dynamic get feedType => _feedType;

  changeFeedType(dynamic value) {
    _feedType = value;
    notifyListeners();
  }

  clearFeedType() {
    _feedType = null;
    notifyListeners();
  }

  resetFilter() {
    clearFilterCategory();
    clearFilterMusic();
    clearFeedType();
  }

  List<dynamic> _dealBars = [];
  List<dynamic> get dealBars => _dealBars;

  addToDealBarList(dynamic value) {
    _dealBars.addAll(value);
    notifyListeners();
  }

  clearDealBars() {
    _dealBars.clear();
    notifyListeners();
  }
}
