import 'package:flutter/material.dart';
class AdvertisementCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final VoidCallback onDelete;

  const AdvertisementCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16.0)),
            child: Stack(
              children: [
                Image.network(
                  image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:  TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,

                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2, // Ensure text does not overflow
                        style:
                            TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete, // Call delete function when pressed
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
