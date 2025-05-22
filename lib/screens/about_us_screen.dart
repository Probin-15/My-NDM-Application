import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart'; // Import geocoding package

class OSMMapScreen extends StatefulWidget {
  @override
  _OSMMapScreenState createState() => _OSMMapScreenState();
}

class _OSMMapScreenState extends State<OSMMapScreen> {
  late LatLng _currentLocation;
  double _zoom = 13.0;
  late MapController _mapController;
  TextEditingController _searchController = TextEditingController(); // For the search bar
  bool _isSearching = false; // To toggle the visibility of the search bar

  @override
  void initState() {
    super.initState();
    // Default to Changa, India
    _currentLocation = LatLng(22.6031, 72.7362);
    _mapController = MapController();
    _checkPermissionsAndGetLocation();
  }

  // Request location permission and fetch the current location
  Future<void> _checkPermissionsAndGetLocation() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      // Get current location if permission is granted
      _getCurrentLocation();
    } else if (status.isDenied) {
      // Handle permission denied case
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permission denied.'))
      );
    }
  }

  // Get the current location of the device
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    // Move the map to the current location, but only after the widget is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(_currentLocation, _zoom);
    });
  }

  // Function to search for a city and update the map's location
  Future<void> _searchCity(String city) async {
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a city name'))
      );
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(city); // Get list of locations for the city
      if (locations.isNotEmpty) {
        setState(() {
          _currentLocation = LatLng(locations.first.latitude, locations.first.longitude);
        });
        _mapController.move(_currentLocation, _zoom); // Move map to the new location
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('City not found!'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching for city: $e'))
      );
    }
  }

  // Toggle the visibility of the search bar
  void _toggleSearchBar() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(  // Stack to overlay the search bar on top of the map
        children: [
          FlutterMap(
            mapController: _mapController,  // Attach the map controller
            options: MapOptions(
              onTap: (tapPosition, point) {
                setState(() {
                  _currentLocation = point;  // Move marker to tapped point
                });
                _mapController.move(point, _zoom);  // Move the map center on tap
              },
              crs: Epsg3857(),  // The default CRS (Coordinate Reference System)
            ),
            children:[
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a','b','c'],

              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _currentLocation,
                    child: Container(
                      child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Search bar container
          if (_isSearching)
            Positioned(
              top: 25,
              left: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                color: Colors.white,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search city",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        String city = _searchController.text.trim();
                        if (city.isNotEmpty) {
                          _searchCity(city); // Search for city on button press
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enter a city name'))
                          );
                        }
                      },
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (city) {
                    city = city.trim();
                    if (city.isNotEmpty) {
                      _searchCity(city); // Search for city on enter key press
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a city name'))
                      );
                    }
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleSearchBar,
        tooltip: 'Search City',
        child: Icon(_isSearching ? Icons.close : Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  // Zoom-in functionality
  void _onZoomIn() {
    setState(() {
      if (_zoom < 19.0) {
        _zoom += 1.0;
      }
    });
    _mapController.move(_currentLocation, _zoom);  // Apply zoom change
  }

  // Zoom-out functionality
  void _onZoomOut() {
    setState(() {
      if (_zoom > 2.0) {
        _zoom -= 1.0;
      }
    });
    _mapController.move(_currentLocation, _zoom);  // Apply zoom change
  }
}