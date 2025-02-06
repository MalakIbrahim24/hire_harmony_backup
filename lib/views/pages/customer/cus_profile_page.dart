import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/customer_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/customer/build_menu_container.dart';
import 'package:hire_harmony/views/widgets/customer/state_item.dart';
import 'package:hire_harmony/views/widgets/shimmer_page.dart';

class CusProfilePage extends StatefulWidget {
  const CusProfilePage({super.key});

  @override
  State<CusProfilePage> createState() => _CusProfilePageState();
}

class _CusProfilePageState extends State<CusProfilePage> {
  final CustomerServices _customerServices = CustomerServices();

  Map<String, dynamic>? userData;
  int orderCount = 0;
  int ticketCount = 0;
  int pendingRequestCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _customerServices.fetchUserData();
    final orders = await _customerServices.fetchOrderCount();
    final tickets = await _customerServices.fetchTicketCount();
    final pendingRequests = await _customerServices.fetchPendingRequestCount();

    setState(() {
      userData = user;
      orderCount = orders;
      ticketCount = tickets;
      pendingRequestCount = pendingRequests;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          title: Text(
            'Profile',
            style: GoogleFonts.montserratAlternates(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: isLoading
            ? const ShimmerPage()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userData?['img'] != null
                        ? NetworkImage(userData!['img'])
                        : const AssetImage('lib/assets/images/customer.png')
                            as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData?['name'] ?? 'Unnamed User',
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    userData?['email'] ?? 'No email provided',
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors().grey,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatItem(
                            label: ' Orders \n Complete',
                            value: orderCount.toString()),
                        StatItem(
                            label: ' Support \n Tickets',
                            value: ticketCount.toString()),
                        StatItem(
                            label: ' Pending \n Requests',
                            value: pendingRequestCount.toString()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Expanded(
                    child: buildMenuContainer(),
                  ),
                ],
              ),
      ),
    );
  }
}
