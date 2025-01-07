import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:intl/intl.dart'; // For date formatting

class ReviewsTapView extends StatelessWidget {
  final String employeeId;

  const ReviewsTapView({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(employeeId)
          .collection('reviews')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "No reviews available",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final reviews = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final data = reviews[index].data() as Map<String, dynamic>;
            final reviewerName = data['name'] ?? 'Anonymous';
            final reviewText = data['review'] ?? '';
            final double rating = (data['rating'] as num?)?.toDouble() ?? 0.0;

            // Convert Timestamp to formatted String
            final Timestamp? timestamp = data['date'] as Timestamp?;
            final String formattedDate = timestamp != null
                ? DateFormat('dd MMM, yyyy').format(timestamp.toDate())
                : 'Unknown Date';

            // Ensure all UI components are Widgets
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors().lightblue,
                child: Text(
                  reviewerName.isNotEmpty
                      ? reviewerName[0].toUpperCase()
                      : 'A', // Default to 'A' if name is empty
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(reviewerName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(reviewText),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (starIndex) => Icon(
                    starIndex < rating.round() ? Icons.star : Icons.star_border,
                    color: AppColors().orange,
                    size: 18,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
