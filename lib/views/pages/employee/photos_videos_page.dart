// import 'package:flutter/material.dart';
// import 'package:hire_harmony/utils/app_colors.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// class PhotosVideosPage extends StatelessWidget {
//   final List<String> imagePaths = [
//     'lib/assets/images/teacher.jpg',
//     'lib/assets/images/teacher.jpg',
//     'lib/assets/images/teacher.jpg',
//     'lib/assets/images/teacher.jpg',
//     'lib/assets/images/teacher.jpg',
//     'lib/assets/images/teacher.jpg',
//     'lib/assets/images/teacher.jpg',
//   ];

//   PhotosVideosPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: MasonryGridView.builder(
//           physics: const BouncingScrollPhysics(), // لجعل الشبكة قابلة للتمرير
//           gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2, // صورتان في كل صف
//           ),
//           mainAxisSpacing: 8.0,
//           crossAxisSpacing: 8.0,
//           itemCount: imagePaths.length,
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         ImageDetailScreen(imagePath: imagePaths[index]),
//                   ),
//                 );
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withValues(alpha: 0.5),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12.0),
//                   child: Image.asset(
//                     imagePaths[index],
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class ImageDetailScreen extends StatelessWidget {
//   final String imagePath;

//   const ImageDetailScreen({super.key, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors().orange,
//         title: const Text(
//           'Image Preview',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Center(
//         child: InteractiveViewer(
//           child: Image.asset(imagePath),
//         ),
//       ),
//     );
//   }
// }
