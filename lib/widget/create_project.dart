// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:task/widget/widgets.dart';
//
// import '../service/database_service.dart';
// class CreateProjectScreen extends StatefulWidget {
//   const CreateProjectScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CreateProjectScreen> createState() => _CreateProjectScreenState();
// }
//
// class _CreateProjectScreenState extends State<CreateProjectScreen> {
//
//   bool _isLoading = false;
//   String groupName = "";
//   String stage = "";
//   String startDate = "";
//   String dueDate = "";
//   String owner = "";
//   String taskName = "";
//   String desc = "";
//   String userName = "";
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text(
//         "Create a Project",
//         textAlign: TextAlign.left,
//       ),
//
//       content: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.98, // Set width here
//         height: MediaQuery.of(context).size.height * 0.98,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _isLoading == true
//                   ? Center(
//                 child: CircularProgressIndicator(
//                   color: Theme.of(context).primaryColor,
//                 ),
//               )
//                   : TextField(
//                 onChanged: (val) {
//                   setState(() {
//                     groupName = val;
//                   });
//                 },
//                 style: const TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                   labelText: 'Project Name',
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: Theme.of(context).primaryColor),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   // other decoration properties...
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 onChanged: (val) {
//                   setState(() {
//                     startDate = val;
//                   });
//                 },
//                 style: const TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                   labelText: 'Start Date',
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: Theme.of(context).primaryColor),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   // other decoration properties...
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 onChanged: (val) {
//                   setState(() {
//                     dueDate = val;
//                   });
//                 },
//                 style: const TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                   labelText: 'Due Date',
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: Theme.of(context).primaryColor),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   // other decoration properties...
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 onChanged: (val) {
//                   setState(() {
//                     stage = val;
//                   });
//                 },
//                 style: const TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                   labelText: 'Stage',
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: Theme.of(context).primaryColor),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   // other decoration properties...
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 onChanged: (val) {
//                   setState(() {
//                     owner = val;
//                   });
//                 },
//                 style: const TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                   labelText: 'Created by',
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: Theme.of(context).primaryColor),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   // other decoration properties...
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 onChanged: (val) {
//                   setState(() {
//                     desc = val;
//                   });
//                 },
//                 style: const TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                   labelText: 'Description',
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: Theme.of(context).primaryColor),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   // other decoration properties...
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red),
//           child: const Text("CANCEL"),
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             if (groupName != "" && startDate!="" && dueDate!= "" && owner!="" && stage!="" && desc!="") {
//               setState(() {
//                 _isLoading = true;
//               });
//               await DatabaseService(
//                 uid: FirebaseAuth.instance.currentUser!.uid,
//               ).createGroup(
//                   userName,
//                   FirebaseAuth.instance.currentUser!.uid,
//                   groupName,
//                   startDate,
//                   dueDate,
//                   stage,
//                   owner,
//                   desc
//               ).whenComplete(() {
//                 _isLoading = false;
//               });
//               Navigator.of(context).pop();
//               showSnackbar(
//                 context,
//                 Colors.green,
//                 "Project created successfully.",
//               );
//             }
//           },
//           style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red),
//           child: const Text("CREATE"),
//         )
//       ],
//     );
//   }
// }
