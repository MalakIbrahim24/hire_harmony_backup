import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewPage extends StatefulWidget {
  final String orderId;
  final String employeeId;
  final String employeeName;

  const ReviewPage({
    required this.orderId,
    required this.employeeId,
    required this.employeeName,
    super.key,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _reviewController = TextEditingController();
  double rating = 0.0;
  bool isSubmitting = false;
  final _firestore = FirebaseFirestore.instance;
  Future<void> updateEmployeeReviews(
      String employeeId, int totalReviews, double newAverageRating) async {
    try {
      // التأكد من أن employeeId ليس فارغًا
      if (employeeId.isEmpty) {
        print("خطأ: employeeId فارغ!");
        return;
      }

      // التأكد من أن القيم ليست فارغة أو غير صحيحة
      print("🔍 تحديث معلومات الموظف: $employeeId");
      print("📌 عدد التقييمات الجديد: $totalReviews");
      print("⭐ التقييم الجديد: ${newAverageRating.toStringAsFixed(1)}");

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // التحديث باستخدام update
      await firestore.collection('users').doc(employeeId).update({
        'reviewsNum': totalReviews.toString(), // تحويل العدد إلى نص
        'rating':
            newAverageRating.toStringAsFixed(1), // الاحتفاظ برقم عشري واحد
      });

      print("✅ التحديث تم بنجاح!");
    } catch (e) {
      print("⚠️ خطأ أثناء تحديث البيانات: $e");

      // في حال فشل التحديث، جرب set مع merge
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('users').doc(employeeId).set({
          'reviewsNum': totalReviews.toString(),
          'rating': newAverageRating.toStringAsFixed(1),
        }, SetOptions(merge: true));

        print("✅ التحديث باستخدام set(merge: true) تم بنجاح!");
      } catch (e) {
        print("❌ فشل التحديث باستخدام set: $e");
      }
    }
  }

  Future<void> _submitReview() async {
    if (_reviewController.text.trim().isEmpty || rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a rating and a review.')),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // **Check if a review already exists for this order**
      QuerySnapshot existingReview = await _firestore
          .collection('users')
          .doc(widget.employeeId)
          .collection('reviews')
          .where('orderId', isEqualTo: widget.orderId)
          .where('customerId', isEqualTo: userId)
          .get();

      if (existingReview.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You have already reviewed this order.')),
        );
        setState(() {
          isSubmitting = false;
        });
        return;
      }

      // **Fetch user and employee data**
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      DocumentSnapshot empDoc =
          await _firestore.collection('users').doc(widget.employeeId).get();

      if (!userDoc.exists) {
        debugPrint('Error: User document does not exist.');
        return;
      }

      // ✅ **Ensure `reviewsNum` and `rating` exist before accessing them**
      Map<String, dynamic>? empData = empDoc.data() as Map<String, dynamic>?;

      int totalReviews =
          int.tryParse(empData?['reviewsNum']?.toString() ?? '0') ?? 0;
      double currentRating =
          double.tryParse(empData?['rating']?.toString() ?? '0.0') ?? 0.0;
      double newReviewRating = rating;

      totalReviews += 1;
      double newAverageRating =
          ((currentRating * (totalReviews - 1)) + newReviewRating) /
              totalReviews;

      debugPrint('Updated reviewsNum: $totalReviews');
      debugPrint('Updated rating: ${newAverageRating.toStringAsFixed(1)}');

      // **Submit the review**
      String userName = userDoc['name'] ?? 'Anonymous';
      String reviewId = _firestore.collection('reviews').doc().id;

      final reviewData = {
        'reviewId': reviewId,
        'customerId': userId,
        'employeeId': widget.employeeId,
        'orderId': widget.orderId,
        'name': userName,
        'review': _reviewController.text.trim(),
        'rating': rating.toStringAsFixed(1),
        'date': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(widget.employeeId)
          .collection('reviews')
          .doc(reviewId)
          .set(reviewData);

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('completedOrders')
          .doc(widget.orderId)
          .update({'reviewed': true});

      await _firestore
          .collection('users')
          .doc(widget.employeeId)
          .collection('completedOrders')
          .doc(widget.orderId)
          .update({'reviewed': true});

      // ✅ **Ensure that `reviewsNum` and `rating` exist before updating**
      await _firestore.collection('users').doc(widget.employeeId).set(
        {
          'reviewsNum': totalReviews.toString(),
          'rating': newAverageRating.toStringAsFixed(1),
        },
        SetOptions(merge: true),
      );

      debugPrint('✅ Review submitted successfully!');
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!')),
      );
    } catch (e) {
      debugPrint('Firestore Error: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firestore Error: ${e.toString()}')),
      );
    }

    setState(() {
      isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Leave a Review',
          style: GoogleFonts.montserratAlternates(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Review for ${widget.employeeName}',
              style: GoogleFonts.montserratAlternates(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Rate your experience:',
              style: GoogleFonts.montserratAlternates(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    index < rating.toInt() ? Icons.star : Icons.star_border,
                    color: AppColors().orange,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      rating = index + 1.0;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your review...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors().orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Submit Review',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
