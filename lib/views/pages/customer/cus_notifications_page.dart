import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class CusNotificationsPage extends StatefulWidget {
  const CusNotificationsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CusNotificationsPageState createState() => _CusNotificationsPageState();
}

class _CusNotificationsPageState extends State<CusNotificationsPage> {
  // قائمة الإشعارات مع حالات المقروء والتوسع
  List<Map<String, dynamic>> notifications = [
    {
      'title': 'Apply Success',
      'description':
          'You have applied for a job at Queenify Group as UI Designer',
      'time': '10h ago',
      'isRead': false,
      'isExpanded': false,
    },
    {
      'title': 'Complete your profile',
      'description':
          'Please verify your profile information to continue using this app',
      'time': '4 June',
      'isRead': true,
      'isExpanded': false,
    },
    {
      'title': 'haneen daoud replaid ',
      'description':
          'Congratulations! You have interview calls tomorrow. Check schedule here.',
      'time': '4m ago',
      'isRead': false,
      'isExpanded': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors().white,
      appBar: AppBar(
        backgroundColor: AppColors().transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors().navy),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Notification',
          style: GoogleFonts.montserratAlternates(
            textStyle: TextStyle(
              fontSize: 18,
              color: AppColors().navy,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Save action
            },
            child: Text(
              'Clear All',
              style: GoogleFonts.montserratAlternates(
                textStyle: TextStyle(
                  fontSize: 16,
                  color: AppColors().orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return _buildNotificationCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard(int index) {
    final notification = notifications[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          // عكس حالة التوسع عند الضغط
          notification['isExpanded'] = !notification['isExpanded'];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // مدة الحركة
        curve: Curves.easeInOut, // منحنى الحركة
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification['isRead']
              ? Colors.grey.shade200
              : AppColors().orangelight, // اللون للمقروء وغير المقروء
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2), // تأثير الظل
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.circle,
                    color: notification['isRead']
                        ? Colors.grey
                        : AppColors()
                            .orange, // لون الأيقونة للمقروء وغير المقروء
                    size: 10),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    notification['title'],
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors().navy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  notification['time'],
                  style: TextStyle(fontSize: 12, color: AppColors().grey3),
                ),
              ],
            ),
            // إضافة الوصف فقط في حالة التوسع
            if (notification['isExpanded']) ...[
              const SizedBox(height: 8),
              Text(
                notification['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: notification['isRead']
                      ? AppColors().grey
                      : AppColors().navy2,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      // تحديث حالة المقروء
                      notification['isRead'] = true;
                    });
                  },
                  //if statment

                  child: Text(
                    notification['isRead'] ? ' ' : 'Mark as read',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors().orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}



/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class CusNotificationsPage extends StatefulWidget {
  const CusNotificationsPage({super.key});

  @override
  State<CusNotificationsPage> createState() => _CusNotificationsPageState();
}

class _CusNotificationsPageState extends State<CusNotificationsPage> {
  final List<Map<String, String>> recentNotifications = List.generate(
    10,
    (index) => {
      "title": "Haneen daoud",
      "description": "Replied your message.",
      "time": "${index+1} hour ",
      "image": "assets/images/teacher.jpg",
    },
  );

  final List<Map<String, String>> earlierNotifications = List.generate(
    5,
    (index) => {
      "title": "Special Discount",
      "description": "Get 40% off on all services",
      "time": "Sat, 10:30am",
      "image": "assets/images/chef.png",
    },
  );

  final List<Map<String, String>> achievedNotifications = List.generate(
    5,
    (index) => {
      "title": "Achievement Unlocked",
      "description": "Thanks for being a loyal user!",
      "time": "Fri, 2:15pm",
      "image": "assets/images/mechanic.png",
    },
  );
  List<Map<String, String>> displayedNotifications = [];
  String activeTab = "Recent";
  @override
  void initState() {
    super.initState();
    // Initialize with recent notifications
    displayedNotifications = recentNotifications;
  }

  void switchTab(String tab) {
    setState(() {
      activeTab = tab;
      if (tab == "Recent") {
        displayedNotifications = recentNotifications;
      } else if (tab == "Earlier") {
        displayedNotifications = earlierNotifications;
      } else if (tab == "Achieved") {
        displayedNotifications = achievedNotifications;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      appBar: AppBar(
        backgroundColor: AppColors().white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors().navy),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Notification',
          style: GoogleFonts.montserratAlternates(
            textStyle: TextStyle(
              fontSize: 18,
              color: AppColors().navy,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Save action
            },
            child: Text(
              'Clear All',
              style: GoogleFonts.montserratAlternates(
                textStyle: TextStyle(
                  fontSize: 16,
                  color: AppColors().orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => switchTab("Recent"),
                  child: Text(
                    "Recent",
                    style: TextStyle(
                      color: AppColors().orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => switchTab("Earlier"),
                  child: Text(
                    "Earlier",
                    style: TextStyle(color: AppColors().grey, fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () => switchTab("Achieved"),
                  child: Text(
                    "Achieved",
                    style: TextStyle(color: AppColors().grey, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          // Notification List
          Expanded(
            child: ListView.builder(
              itemCount: displayedNotifications.length,
              itemBuilder: (context, index) {
                final notification = displayedNotifications[index];
                return ListTile(
                  
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(notification["image"]!),
                  ),
                  title: Text(
                    notification["title"]!,
                    style: GoogleFonts.montserratAlternates(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: AppColors().navy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    notification["description"]!,
                    style: (TextStyle(
                      fontSize: 10,
                      color: AppColors().grey,
                    )),
                  ),
                  trailing: Text(
                    notification["time"]!,
                    style: TextStyle(color: AppColors().grey, fontSize: 12),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/