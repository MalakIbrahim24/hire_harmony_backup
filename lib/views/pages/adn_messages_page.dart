import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class AdnMessagesPage extends StatefulWidget {
  const AdnMessagesPage({super.key});

  @override
  State<AdnMessagesPage> createState() => _AdnMessagesPageState();
}

class _AdnMessagesPageState extends State<AdnMessagesPage> {
  @override
  Widget build(BuildContext context) {
    //final cubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      backgroundColor:
          AppColors().white, // Sets the Scaffold's background color
      extendBody: true,
      body: const Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.0),
        child: SafeArea(
          child: Column(),
        ),
      ),
    );
  }
}
