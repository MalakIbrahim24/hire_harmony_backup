import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:intl/intl.dart';

class ReviewsPage extends StatelessWidget {
  final String employeeId;

  const ReviewsPage({required this.employeeId, super.key});

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
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error fetching reviews: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No reviews available.'),
          );
        }

        final reviews = snapshot.data!.docs;

        return ListView.separated(
          itemCount: reviews.length,
          separatorBuilder: (context, index) => Divider(
            thickness: 1,
            color: AppColors().grey.withValues(alpha: 0.3),
          ),
          itemBuilder: (context, index) {
            final review = reviews[index].data() as Map<String, dynamic>;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: review['userImage'] != null &&
                            review['userImage'].toString().isNotEmpty
                        ? NetworkImage(review['userImage'])
                        : const AssetImage('lib/assets/images/customer.png')
                            as ImageProvider,
                    radius: 25,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              review['name'] ?? 'Anonymous',
                              style: GoogleFonts.montserratAlternates(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color:
                                    AppColors().orange.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.star,
                                      color: AppColors().orange, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    review['rating']?.toString() ?? 'N/A',
                                    style: GoogleFonts.montserratAlternates(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppColors().orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          review['date'] is Timestamp
                              ? DateFormat('d MMM, yyyy').format(
                                  (review['date'] as Timestamp).toDate(),
                                )
                              : review['date'] ?? '',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 12,
                            color: AppColors().grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (review['review'] != null &&
                            review['review'].isNotEmpty)
                          Text(
                            review['review'],
                            style: GoogleFonts.montserratAlternates(
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
