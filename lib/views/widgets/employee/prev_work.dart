
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/employee/photo_tab_view.dart';
import 'package:hire_harmony/views/widgets/employee/reviews_tab_view.dart';


class PrevWork extends StatelessWidget {
  const PrevWork({super.key});


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Previous Work',
            style: GoogleFonts.montserratAlternates(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: AppColors().navy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
          const SizedBox(height: 10),
          DefaultTabController(
            length: 2, // عدد التابات
            child: Column(
              children: [
                TabBar(
                  dividerColor: Colors.transparent,
                  labelColor: AppColors().orange,
                  unselectedLabelColor: AppColors().grey2,
                  indicatorColor: AppColors().orange,
                  tabs: const [
                    Tab(text: 'Photo'),
                    Tab(text: 'Reviews'),
                  ],
                ),
                const SizedBox(
                  height: 300, // الارتفاع المناسب لعرض المحتوى
                  child: TabBarView(
                    children: [
                      PhotoTabView(), // محتوى التاب الأول
                      ReviewsTapView(), // محتوى التاب الثاني
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}