import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';

class MapProvider with ChangeNotifier {
  LabelMarker _currentPosition = LabelMarker(
      label: 'You',
      markerId: const MarkerId('You'),
      position: LatLng(0, 0));
  LabelMarker get currentPosition => _currentPosition;

  changeCurrentPosition(LabelMarker value) {
    _currentPosition = value;
    notifyListeners();
  }

  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  addMarker(LabelMarker value) {
    _markers.addLabelMarker(value);
    // notifyListeners();
  }

  // removeMarker(String markerId) {
  //   _markers.removeWhere((element) => element.markerId == MarkerId(markerId));
  //   notifyListeners();
  // }

  clearMarker() {
    _markers.clear();
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  bool _showBarDetails = false;
  bool get showBarDetails => _showBarDetails;

  changeShowDetails(bool value) {
    _showBarDetails = value;
    notifyListeners();
  }

  dynamic _selectedMarker;
  dynamic get selectedMarker => _selectedMarker;

  changeSelectedMarker(dynamic value) {
    _selectedMarker = value;
    notifyListeners();
  }

  // final List<Marker> _searchedMarkers = [];
  // List<Marker> get searchedMarkers => _searchedMarkers;

  // addSearchedMarker(Marker value) {
  //   _searchedMarkers.add(value);
  // }

  // clearSearchedMarker() {
  //   _searchedMarkers.clear();
  //   notifyListeners();
  // }
}
