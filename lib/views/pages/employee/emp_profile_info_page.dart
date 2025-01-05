import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/employee/photos_videos_page.dart';
import 'package:hire_harmony/views/widgets/employee/build_static_button.dart';

class EmpProfileInfoPage extends StatefulWidget {
  const EmpProfileInfoPage({super.key});

  @override
  State<EmpProfileInfoPage> createState() => _EmpProfileInfoPageState();
}

class _EmpProfileInfoPageState extends State<EmpProfileInfoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'lib/assets/images/teacher.jpg',
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'House Cleaning',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors().navy2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Jenny Wilson',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star,
                                color: AppColors().orange, size: 20),
                            const SizedBox(width: 4),
                            Text('4.8 (4,479 reviews)',
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 14,
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on,
                                color: AppColors().orange, size: 20),
                            const SizedBox(width: 4),
                            Text('255 Grand Park Avenue, New York',
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 14,
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // About Me
                  Text(
                    'About me',
                    style: GoogleFonts.montserratAlternates(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors().navy2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim nisi ut aliquip. Read more.',
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // My Services
                  Text(
                    'My Services',
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors().navy2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        buildStaticButton('Cleaning house'),
                        const SizedBox(width: 8),
                        buildStaticButton('Cleaning'),
                        const SizedBox(width: 8),
                        buildStaticButton('House Cleaning'),
                        const SizedBox(width: 8),
                        buildStaticButton('Deep Cleaning'),
                        const SizedBox(width: 8),
                        buildStaticButton('Window Cleaning'),
                        const SizedBox(width: 8),
                        buildStaticButton('Furniture Cleaning'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tabs Section
                  TabBar(
                    // ignore: deprecated_member_use
                    dividerColor: AppColors().grey.withOpacity(0.3),
                    controller: _tabController,
                    labelColor: AppColors().orange,
                    // ignore: deprecated_member_use
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColors().orange,
                    tabs: const [
                      Tab(text: 'Photos & Videos'),
                      Tab(text: 'Review'),
                    ],
                  ),
                  SizedBox(
                    height: 400, // Height of TabBarView
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Photos & Videos Tab
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Photos & Videos',
                                  style: GoogleFonts.montserratAlternates(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors().navy2),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PhotosVideosPage()),
                                    );
                                  },
                                  child: Text(
                                    'See All',
                                    style: GoogleFonts.montserratAlternates(
                                      fontSize: 14,
                                      color: AppColors().orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: 2, // Number of photos/videos
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/images/teacher.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        // Review Tab
                        // داخل تبويب "Review" في الكود الأول (EmpProfileInfoPage)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Review',
                                  style: GoogleFonts.montserratAlternates(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors().navy2,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         const ReviewsPage(), // استدعاء صفحة المراجعات الكاملة
                                    //   ),
                                    // );
                                  },
                                  child: Text(
                                    'See All',
                                    style: GoogleFonts.montserratAlternates(
                                      fontSize: 14,
                                      color: AppColors().orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // استبدال ListTile بالقسم الجديد:
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  2, // عدد التقييمات الأولية التي ستظهر هنا
                              itemBuilder: (context, index) {
                                // قائمة التقييمات المصغرة
                                final reviews = [
                                  {
                                    'image': 'assets/images/teacher.jpg',
                                    'name': 'Miles Esther',
                                    'date': '1 Feb, 2020',
                                    'rating': '4.5',
                                    'review':
                                        'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.',
                                  },
                                  {
                                    'image': 'assets/images/teacher.jpg',
                                    'name': 'Henry Arthur',
                                    'date': '21 Sep, 2020',
                                    'rating': '4.0',
                                    'review':
                                        'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet consectetur adipisci velit.',
                                  },
                                ];
                                final review = reviews[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            AssetImage(review['image']!),
                                        radius: 25,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  review['name']!,
                                                  style: GoogleFonts
                                                      .montserratAlternates(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0),
                                                  decoration: BoxDecoration(
                                                    color: AppColors()
                                                        .orange
                                                        // ignore: deprecated_member_use
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.star,
                                                          color: AppColors()
                                                              .orange,
                                                          size: 16),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        review['rating']!,
                                                        style: GoogleFonts
                                                            .montserratAlternates(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: AppColors()
                                                              .orange,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              review['date']!,
                                              style: GoogleFonts
                                                  .montserratAlternates(
                                                fontSize: 12,
                                                color: AppColors().grey,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            if (review['review']!.isNotEmpty)
                                              Text(
                                                review['review']!,
                                                style: GoogleFonts
                                                    .montserratAlternates(
                                                  fontSize: 12,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                  thickness: 1,
                                  // ignore: deprecated_member_use
                                  color: AppColors().grey.withOpacity(0.2),
                                  height: 16,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.8), // خلفية بيضاء شفافة
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      'Message',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'Book Now',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
