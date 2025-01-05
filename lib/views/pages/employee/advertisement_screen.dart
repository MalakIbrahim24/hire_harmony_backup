import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/employee/add_advertisement_dialog.dart';

class AdvertisementScreen extends StatelessWidget {
  final List<Map<String, String>> advertisements = [
    {
      "image":
          "https://www.thespruce.com/thmb/-6Od6ewV0j7P5-tga6n5XYSpvzc=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-1327576000-010986211f2f46f28e1a32615da231f8.jpg",
      "title": "Get 50% Off Cleaning Service",
      "description":
          "Enjoy a spotless home with 50% off. Book now for professional cleaning at half the price!",
      "button": "Book Now and Save Big!"
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/previews/038/820/179/non_2x/ai-generated-workers-using-pressure-washer-to-clean-driveways-for-professional-cleaning-service-free-photo.jpeg",
      "title": "Book Your Cleaning Now",
      "description":
          "Transform your home today! Limited-time offer for cleaning services.",
      "button": "Book Now"
    },
    {
      "image":
          "https://cdn.pixabay.com/photo/2017/09/14/12/54/cleanliness-2747772_960_720.jpg",
      "title": "Professional Cleaning Services",
      "description":
          "Expert cleaners at your service. Affordable and reliable.",
      "button": "Contact Us"
    },
  ];

  AdvertisementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Advertisements"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: advertisements.length,
        itemBuilder: (context, index) {
          final ad = advertisements[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: AdvertisementCard(
              image: ad["image"]!,
              title: ad["title"]!,
              description: ad["description"]!,
              buttonText: ad["button"]!,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors().orange,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddAdvertisementDialog(),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AdvertisementCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String buttonText;

  const AdvertisementCard({super.key, 
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
            child: Image.network(
              image,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey.shade700,
                  size: 50,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  description,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
