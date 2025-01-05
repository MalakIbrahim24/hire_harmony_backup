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
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().white,
        title: Text(
          "About App",
          style: TextStyle(
            fontSize: 18,
            color: AppColors().navy,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors().navy),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: AppColors().orange,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Developers",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Teams",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  buildDeveloperCard(
                    context,
                    index: 0,
                    name: "Raghad Ammar",
                    role: "UI-UX Designer",
                    image: 'assets/images/woman.png',
                  ),
                  buildDeveloperCard(
                    context,
                    index: 1,
                    name: "Haneen Yousif",
                    role: "Frontend Developer",
                    image: 'assets/images/gamer.png',
                  ),
                  buildDeveloperCard(
                    context,
                    index: 2,
                    name: "Malak Ibraheem",
                    role: "Backend Developer",
                    image: 'assets/images/woman.png',
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "This program was developed by the developers of Orchida Soft Software Company",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDeveloperCard(BuildContext context,
      {required int index,
      required String name,
      required String role,
      required String image}) {
    bool isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: isSelected ? AppColors().white : AppColors().orange.withAlpha(240),
          border: Border.all(color: AppColors().orangelight, width: 1),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(image),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.montserratAlternates(
                            textStyle: TextStyle(
                              fontSize: 18,
                              color:
                                  isSelected ? AppColors().orange : AppColors().white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          role,
                          style: GoogleFonts.montserratAlternates(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color:
                                  isSelected ? AppColors().orange : AppColors().navy,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
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
                  child: const Text(
                    "Send",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}