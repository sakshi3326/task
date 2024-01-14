// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:task/widget/widgets.dart';
//
// import '../service/database_service.dart';
//
// class AddProjectScreen extends StatefulWidget {
//   @override
//   _AddProjectScreenState createState() => _AddProjectScreenState();
// }
//
// class _AddProjectScreenState extends State<AddProjectScreen> {
//   String groupName = "";
//   String startDate = "";
//   String dueDate = "";
//   String stage = "";
//   String owner = "";
//   String desc = "";
//   String userName="";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Create a Project"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextField(
//                 onChanged: (val) {
//                   setState(() {
//                     groupName = val;
//                   });
//                 },
//                 style: const TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                   labelText: 'Project Name',
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
//                   // other decoration properties...
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (groupName != "" && startDate!="" && dueDate!= "" && owner!="" && stage!="" && desc!="") {
//                     setState(() {
//
//                     });
//                     await DatabaseService(
//                       uid: FirebaseAuth.instance.currentUser!.uid,
//                     ).createGroup(
//                         userName,
//                         FirebaseAuth.instance.currentUser!.uid,
//                         groupName,
//                         startDate,
//                         dueDate,
//                         stage,
//                         owner,
//                         desc
//                     ).whenComplete(() {
//
//                     });
//                     Navigator.of(context).pop();
//                     showSnackbar(
//                       context,
//                       Colors.green,
//                       "Project created successfully.",
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   primary: Theme.of(context).primaryColor,
//                 ),
//                 child: const Text("CREATE"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
