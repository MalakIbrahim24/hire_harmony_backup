import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/customer/best_worker.dart';
import 'package:hire_harmony/views/widgets/customer/category_widget.dart';
import 'package:hire_harmony/views/widgets/customer/custom_carousel_indicator.dart';
import 'package:hire_harmony/views/widgets/customer/populer_service.dart';

class EmpHomePage extends StatelessWidget {
  const EmpHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: Container(
              color: AppColors().orange,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.account_circle_outlined,
                              color: Colors.white, size: 25),
                          const SizedBox(width: 8),
                          Text(
                            'Good Afternoon, Haneen',
                            style: GoogleFonts.montserratAlternates(
                              textStyle: TextStyle(
                                fontSize: 18,
                                color: AppColors().white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.notifications_active_outlined,
                        color: Colors.white,
                        size: 25,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for "Indoor Cleaning"',
                        hintStyle: GoogleFonts.montserratAlternates(
                          textStyle: TextStyle(
                            fontSize: 16,
                            color: AppColors().grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors().grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14),
              child: Column(
                children: [
                  const CustomCarouselIndicator(),
                  const SizedBox(height: 24),
                  //متكرر مرتين لازم تقلليه
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Browse all categories',
                        style: GoogleFonts.montserratAlternates(
                          textStyle: TextStyle(
                            fontSize: 15,
                            color: AppColors().navy,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        //put link to view all categories
                        onTap: () {},
                        child: Text(
                          'View all >',
                          style: GoogleFonts.montserratAlternates(
                            textStyle: TextStyle(
                              fontSize: 13,
                              color: AppColors().orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const CategoryWidget(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Services on Hire Harmony',
                        style: GoogleFonts.montserratAlternates(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: AppColors().navy,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        //put link to view all categories
                        onTap: () {},
                        child: Text(
                          'View all >',
                          style: GoogleFonts.montserratAlternates(
                            textStyle: TextStyle(
                              fontSize: 13,
                              color: AppColors().orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const PopulerService(),
                  const SizedBox(height: 24),

                  Container(
                    width: 400,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors().orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invite your friends & get up to NGN 2,000',
                          style: GoogleFonts.montserratAlternates(
                            textStyle: TextStyle(
                              fontSize: 15,
                              color: AppColors().white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Introduce your friends to the easiest way to find and hire professionals for your needs.',
                          style: GoogleFonts.montserratAlternates(
                            textStyle: TextStyle(
                              fontSize: 13,
                              color: AppColors().white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors().white,
                            foregroundColor: AppColors().navy,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                          ),
                          onPressed: () {
                            // Add your button action here
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Invite Friends',
                                style: GoogleFonts.montserratAlternates(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    color: AppColors().navy,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward, size: 16),
                            ],
                          ),
                        ), 
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                
              
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Best Worker Profile',
                        style: GoogleFonts.montserratAlternates(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: AppColors().navy,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        //put link to view all categories
                        onTap: () {},
                        child: Text(
                          'View all >',
                          style: GoogleFonts.montserratAlternates(
                            textStyle: TextStyle(
                              fontSize: 13,
                              color: AppColors().orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const BestWorker(),
                const SizedBox(height: 40),

                Text('Don’t see what you are looking for?',
                style: GoogleFonts.montserratAlternates(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: AppColors().grey,
                            fontWeight: FontWeight.w600,
                          ),),
                ),
               const SizedBox(height: 10),

                Text('View all services ',
                style: GoogleFonts.montserratAlternates(
                          textStyle: TextStyle(
                            fontSize: 16,
                            color: AppColors().orange,
                            fontWeight: FontWeight.bold,
                          ),),
                ),
                const SizedBox(height: 40),

                ],
               

              ),
            ),
          )),
    );
  }
}
