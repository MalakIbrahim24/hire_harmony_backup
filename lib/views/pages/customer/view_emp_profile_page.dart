import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/customer_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
//import 'package:hire_harmony/views/pages/chatePage.dart';
//import 'package:hire_harmony/views/pages/chatePage.dart';
import 'package:hire_harmony/views/pages/map_page.dart';
import 'package:hire_harmony/views/widgets/customer/cus_photo_tab_view.dart';
import 'package:hire_harmony/views/widgets/employee/reviews_tab_view.dart';

class ViewEmpProfilePage extends StatefulWidget {
  final String employeeId;

  const ViewEmpProfilePage({required this.employeeId, super.key});

  @override
  State<ViewEmpProfilePage> createState() => _ViewEmpProfilePageState();
}

class _ViewEmpProfilePageState extends State<ViewEmpProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> services = []; // تخزين قائمة الخدمات
  bool isAvailable = false; // افتراضيًا، الموظف غير متاح
  // final CustomerServices _customerServices = CustomerServices();

  Map<String, dynamic>? employeeData;
  bool isFavorite = false;
  final String? loggedInUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    employeeData =
        await CustomerServices.instance.fetchEmployeeData(widget.employeeId);
    isFavorite = await CustomerServices.instance.isFavorite(widget.employeeId);

    if (employeeData != null) {
      services = List<String>.from(employeeData!['services'] ?? []);
      isAvailable = employeeData!['availability'] ?? false;
    }

    setState(() {});
  }

  Future<void> _toggleFavorite() async {
    await CustomerServices.instance
        .toggleFavoriteEmp(widget.employeeId, isFavorite, employeeData);
    setState(() => isFavorite = !isFavorite);
  }

  Future<void> _sendRequest() async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Send Request',
            style:
                GoogleFonts.montserratAlternates(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleController,
                  decoration:
                      const InputDecoration(hintText: 'Enter the title here')),
              const SizedBox(height: 8),
              TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      hintText: 'Enter your description here')),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.red))),
            TextButton(
              onPressed: () async {
                if (!mounted) return;
                bool success = await CustomerServices.instance.sendRequest(
                  widget.employeeId,
                  titleController.text.trim(),
                  descriptionController.text.trim(),
                );

                if (!context.mounted) return;
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Request sent successfully!')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to send request.')));
                }
              },
              child: Text('Confirm',
                  style: GoogleFonts.montserratAlternates(
                      color: AppColors().orange)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (employeeData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
                bottom: 80), // Add padding to prevent overlap
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.network(
                        employeeData!['img'] ??
                            'https://via.placeholder.com/150',
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name and Details
                  Center(
                    child: Column(
                      children: [
                        Text(
                          employeeData!['name'] ?? 'Unnamed Employee',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star,
                                color: AppColors().orange, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '${employeeData!['rating']} (${employeeData!['reviewsNum']} reviews)',
                              style: GoogleFonts.montserratAlternates(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        if (employeeData!.containsKey('Address') &&
                            employeeData!['Address'] != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0), // مسافة صغيرة قبل العنوان
                            child: Center(
                              child: Text(
                                employeeData![
                                    'Address'], // عرض العنوان من Firestore
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors().orange,
                                ),
                              ),
                            ),
                          ),
                        if (employeeData!.containsKey('location') &&
                            employeeData!['location'] != null &&
                            employeeData!['location']['latitude'] != null &&
                            employeeData!['location']['longitude'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapScreen(
                                          employeeId: widget.employeeId),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.location_on,
                                    color: Colors.white),
                                label: Text(
                                  'See Location',
                                  style: GoogleFonts.montserratAlternates(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors().orange,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // About Me Section with Favorite Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'About me',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            _toggleFavorite();
                          })
                    ],
                  ),
                  const SizedBox(height: 8),

                  Text(
                    employeeData!['about'] ??
                        'This employee has not added any description.',
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
// My Services Section
                  if (services.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'My Services',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: services.map((service) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color:
                                    AppColors().orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppColors().orange, width: 1),
                              ),
                              child: Text(
                                service,
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors().orange,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),

                  // Tabs Section
                  TabBar(
                    dividerColor: AppColors().transparent,
                    controller: _tabController,
                    labelColor: AppColors().orange,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColors().orange,
                    labelStyle: const TextStyle(
                      fontSize: 16.5, // Text size for selected tabs
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14, // Text size for unselected tabs
                      fontWeight: FontWeight.normal,
                    ),
                    tabs: const [
                      Tab(text: 'Photos'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                  SizedBox(
                    height: 400, // Height of TabBarView
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        CusPhotoTabView(
                          employeeId: widget.employeeId,
                        ),
                        ReviewsTapView(
                          employeeId: widget.employeeId,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Buttons at the Bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: isAvailable
                        ? _sendRequest
                        : null, // ❌ تعطيل الزر إذا لم يكن متاحًا
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().orange.withValues(
                          alpha: isAvailable
                              ? 1.0
                              : 0.5), // ❌ تغيير اللون ليظهر كأنه غير نشط
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Text(
                      'Send request',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isAvailable ? Colors.white : AppColors().grey,
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
