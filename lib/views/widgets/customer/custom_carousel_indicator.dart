import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class CustomCarouselIndicator extends StatefulWidget {
  const CustomCarouselIndicator({super.key});

  @override
  State<CustomCarouselIndicator> createState() =>
      _CustomCarouselIndicatorState();
}

class _CustomCarouselIndicatorState extends State<CustomCarouselIndicator> {
  int _current = 0;
  List<Advertisement> _advertisements = [];
  late CarouselSliderController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CarouselSliderController();
    _loadAdvertisements();
  }

  Future<void> _loadAdvertisements() async {
    final ads = await fetchEmployeeAdvertisements();
    setState(() {
      _advertisements = ads;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_advertisements.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<Widget> imageSliders = _advertisements
        .map((ad) => Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: ad.image,
                  fit: BoxFit.cover,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.0),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40.0, // Move the ad name a bit higher
                  left: 20.0,
                  right: 20.0,
                  child: Text(
                    ad.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  left: 20.0,
                  right: 20.0,
                  child: Text(
                    'By ${ad.employeeName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ))
        .toList();

    return Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.35,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _advertisements.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 30.0,
                height: 3.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? AppColors().orange
                          : AppColors().navy)
                      .withValues(alpha: _current == entry.key ? 0.9 : 0.3),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class Advertisement {
  final String description;
  final String image;
  final String name;
  final String employeeName; // New field

  Advertisement({
    required this.description,
    required this.image,
    required this.name,
    required this.employeeName,
  });
}

Future<List<Advertisement>> fetchEmployeeAdvertisements() async {
  List<Advertisement> advertisements = [];
  try {
    // Reference to Firestore
    final firestore = FirebaseFirestore.instance;

    // Query users with role 'employee'
    final usersSnapshot = await firestore
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .get();

    // Iterate through each employee and fetch advertisements
    for (var userDoc in usersSnapshot.docs) {
      // Fetch employee name, provide a default if null
      final employeeName = userDoc.data()['name']?.toString() ?? 'Unknown';

      final adsCollection = await firestore
          .collection('users')
          .doc(userDoc.id)
          .collection('advertisements')
          .get();

      for (var adDoc in adsCollection.docs) {
        final data = adDoc.data();

        // Safely handle missing fields by providing default values
        advertisements.add(
          Advertisement(
            description: data['description']?.toString() ?? 'No description',
            image: data['image']?.toString() ??
                'https://via.placeholder.com/150', // Default placeholder image
            name: data['name']?.toString() ?? 'No name',
            employeeName: employeeName,
          ),
        );
      }
    }
  } catch (e) {
    print("Error fetching advertisements: $e");
  }
  return advertisements;
}
