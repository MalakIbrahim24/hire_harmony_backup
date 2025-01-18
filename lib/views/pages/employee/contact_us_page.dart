import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/employee/help_support_page.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "About App",
          style: TextStyle(
            fontSize: 17,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            const SizedBox(height: 18),
            Text(
              "Developers",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              "Teams",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView(
                children: [
                  buildDeveloperCard(
                    context,
                    name: "Raghad Ammar",
                    role: "UI-UX Designer",
                    image: 'assets/images/woman.png',
                  ),
                  buildDeveloperCard(
                    context,
                    name: "Haneen Yousif",
                    role: "Frontend Developer",
                    image: 'assets/images/gamer.png',
                  ),
                  buildDeveloperCard(
                    context,
                    name: "Malak Ibrahem",
                    role: "Backend Developer",
                    image: 'assets/images/woman.png',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "This program was developed by the developers of Orchida Soft Software Company",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDeveloperCard(BuildContext context,
      {required String name, required String role, required String image}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 14.0, vertical: 8.0), // تقليل المسافات الخارجية قليلًا
      child: Container(
        height: 140, // حجم متوسط للصندوق
        decoration: BoxDecoration(
          color: AppColors().orange, // خلفية الصندوق برتقالية
          border: Border.all(color: AppColors().orangelight, width: 1),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // توسيط المحتوى داخل الصندوق
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40, // حجم متوسط للصورة
                  backgroundImage: AssetImage(image),
                ),
                const SizedBox(width: 50), // تقليل المسافة بين الصورة والنصوص
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.montserratAlternates(
                        textStyle: TextStyle(
                          fontSize: 17, // حجم نص متوسط
                          color: AppColors().white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: GoogleFonts.montserratAlternates(
                        textStyle: TextStyle(
                          fontSize: 13, // حجم نص متوسط
                          color: AppColors().white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 8.0, // حجم مناسب للزر
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpSupportPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Send",
                        style: TextStyle(
                          color: AppColors().navy,
                          fontSize: 13, // حجم نص متوسط للزر
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
