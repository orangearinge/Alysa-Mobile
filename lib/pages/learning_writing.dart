// import 'package:flutter/material.dart';
// import 'level1_page.dart';
// import 'level2_page.dart';
// import 'level3_page.dart';
// import 'level4_page.dart';

// class LearningWriting extends StatelessWidget {
//   const LearningWriting({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Judul
//               Text(
//                 'LEARNING WRITING',
//                 style: TextStyle(
//                   color: Colors.blue[800],
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.2,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Deskripsi
//               const Text(
//                 'Explore all the existing job roles based on your\ninterest and study major',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.black54,
//                   fontSize: 14,
//                   height: 1.5,
//                 ),
//               ),
//               const SizedBox(height: 40),

//               // Lesson + Level 1
//               buildLessonCard(context, 'Lesson 1', 'LEVEL 1', const Level1Page()),

//               // Lesson + Level 2
//               buildLessonCard(context, 'Lesson 1', 'LEVEL 2', const Level2Page()),

//               // Lesson + Level 3
//               buildLessonCard(context, 'Lesson 1', 'LEVEL 3', const Level3Page()),

//               // Lesson + Level 4
//               buildLessonCard(context, 'Lesson 1', 'LEVEL 4', const Level4Page()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget reusable untuk setiap Lesson
//   Widget buildLessonCard(
//       BuildContext context, String lesson, String level, Widget targetPage) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             lesson,
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//               fontSize: 15,
//             ),
//           ),
//           const SizedBox(height: 8),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => targetPage),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue[100],
//                 foregroundColor: Colors.blue[900],
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Text(
//                 level,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
