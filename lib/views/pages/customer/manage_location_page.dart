import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hire_harmony/utils/app_colors.dart';


class ManageLocationPage extends StatefulWidget {
  const ManageLocationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ManageLocationPageState createState() => _ManageLocationPageState();
}

class _ManageLocationPageState extends State<ManageLocationPage> {
  late GoogleMapController mapController;
  LatLng _currentPosition = const LatLng(17.3850, 78.4867); // Default position (Hyderabad)
  bool _isLoadingLocation = false;

  // لتحديد الموقع الحالي
  void _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      setState(() => _isLoadingLocation = false);
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _isLoadingLocation = false;
      mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    });
  }

  // واجهة المستخدم
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Address'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text('Home'),
            subtitle: const Text('Plot no.209, Kavuri Hills, Madhapur, Telangana'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton.icon(
              icon: Icon(Icons.add_location_alt, color: AppColors().blue),
              label: const Text('Add another address'),
              onPressed: () => _showAddressBottomSheet(context),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _isLoadingLocation
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: (controller) => mapController = controller,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('currentLocation'),
                        position: _currentPosition,
                      ),
                    },
                    onTap: (LatLng tappedPoint) {
                      setState(() {
                        _currentPosition = tappedPoint;
                      });
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // نافذة لإضافة العنوان
  void _showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
              left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Edit / Update Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'House/Flat Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Landmark (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChoiceChip(label: Text('Home'), selected: true),
                  ChoiceChip(label: Text('Other'), selected: false),
                ],
              ),
             const  SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Update address'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}