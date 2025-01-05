import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class ReviewsTapView extends StatelessWidget {
  const ReviewsTapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors().navy,
                ),
              ),
              
               TextButton(
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: AppColors().orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    // NAvigator to ReviewPage
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const ReviewsPage()),
                    // );
                  },
                ),
              
            ],
          ),
          const SizedBox(height: 10),

          // Star Rating Summary
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(5, (index) {
                  return Row(
                    children: [
                      Text(
                        '${5 - index}', 
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 150,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: (5 - index) * 0.2, // Adjust percentage
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors().orange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    '4.0',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors().navy,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < 4 ? Icons.star : Icons.star_border,
                        color: AppColors().orange,
                        size: 18,
                      ),
                    ),
                  ),
                  const Text(
                    '(238 reviews)',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}