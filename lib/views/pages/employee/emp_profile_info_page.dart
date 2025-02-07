import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_harmony/services/employee/cubit/employee_cubit.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/employee/build_static_button.dart';
import 'package:hire_harmony/views/widgets/employee/photo_tab_view.dart';
import 'package:hire_harmony/views/widgets/employee/reviews_tab_view.dart';
import 'package:google_fonts/google_fonts.dart';

class EmpProfileInfoPage extends StatefulWidget {
  final String employeeId;
  const EmpProfileInfoPage({super.key, required this.employeeId});

  @override
  State<EmpProfileInfoPage> createState() => _EmpProfileInfoPageState();
}

class _EmpProfileInfoPageState extends State<EmpProfileInfoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditing = false;
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // جلب بيانات الموظف عند تحميل الصفحة
    context.read<EmployeeCubit>().fetchEmployeeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
void _showAddServiceDialog(BuildContext context) {
  final TextEditingController serviceController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Add Service',
            style: GoogleFonts.montserratAlternates(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            )),
        content: TextField(
          controller: serviceController,
          decoration: InputDecoration(
            hintText: 'Enter service name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (serviceController.text.isNotEmpty) {
                context.read<EmployeeCubit>().addService(serviceController.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.montserratAlternates(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.check : Icons.edit,
              color: AppColors().orange,
            ),
            onPressed: () {
              if (_isEditing) {
                context
                    .read<EmployeeCubit>()
                    .updateAboutMe(_aboutMeController.text);
                context
                    .read<EmployeeCubit>()
                    .updateLocation(_locationController.text);
              }

              setState(() {
                _isEditing = !_isEditing; // تبديل وضع التعديل
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<EmployeeCubit, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoaded) {
            // تحديث الحقول القابلة للتعديل
            _aboutMeController.text = state.aboutMe;
            _locationController.text = state.location;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        state.profileImageUrl,
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 160),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name, Location, and Rating
                  Center(
                    child: Column(
                      children: [
                        Text(
                          state.name,
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _isEditing
                            ? TextField(
                                controller: _locationController,
                                decoration: InputDecoration(
                                  hintText: 'Enter your location',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                            : Text(
                                state.location,
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                        Text(
                          '${state.rating} (${state.reviewsNum} reviews)',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.isAvailable ? 'Available' : 'Not Available',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: state.isAvailable ? Colors.green : Colors.red,
                        ),
                      ),
                      Switch(
                        value: state.isAvailable,
                        onChanged: (value) {
                          context.read<EmployeeCubit>().updateAvailability(value);
                        },
                        activeColor: AppColors().orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // About Me
                  Text(
                    'About me',
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _aboutMeController,
                    enabled: _isEditing,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 16,
                      color: _isEditing
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // My Services
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      'My Services',
      style: GoogleFonts.montserratAlternates(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
    if (_isEditing) // إظهار زر الإضافة فقط عند التعديل
      IconButton(
        icon: Icon(Icons.add, color: AppColors().orange),
        onPressed: () {
          _showAddServiceDialog(context);
        },
      ),
  ],
),
const SizedBox(height: 8),
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: state.services.map((service) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Stack(
          clipBehavior: Clip.none, // للسماح بعرض زر الإكس خارج الحواف
          alignment: Alignment.topRight,
          children: [
            buildStaticButton(service), // ✅ نفس التصميم القديم
            if (_isEditing) // ✅ زر الحذف يظهر فقط عند التعديل
              Positioned(
                top: -6, // ضبط المكان ليكون خارج الحواف
                right: -6,
                child: GestureDetector(
                  onTap: () {
                    context.read<EmployeeCubit>().removeService(service);
                  },
                  child: Container(
                    width: 20, 
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8), // ✅ خلفية شفافة بيضاء
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors().orange, // ✅ لون الإكس برتقالي
                      size: 16, 
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }).toList(),
  ),
),


                  const SizedBox(height: 24),

                  // Tabs Section
                  TabBar(
                    dividerColor: AppColors().transparent,
                    controller: _tabController,
                    labelColor: AppColors().orange,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColors().orange,
                    labelStyle: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    tabs: const [
                      Tab(text: 'Photos'),
                      Tab(text: 'Review'),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        PhotoTabView(employeeId: state.id),
                        ReviewsTapView(employeeId: state.id),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Error loading data'));
          }
        },
      ),
    );
  }
}
