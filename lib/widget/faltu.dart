// void _showAddMemberDialog(BuildContext context, String taskId) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return FutureBuilder<List<Map<String, dynamic>>>(
//         future: DatabaseService().getAllEmailsAndfullNames(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text("Error: ${snapshot.error}");
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Text("No data available");
//           } else {
//             List<Map<String, dynamic>> usersData = snapshot.data!;
//             String selectedEmail = usersData.isNotEmpty ? usersData[0]['email'] : '';
//
//             return AlertDialog(
//               title: const Text("Add Member"),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   DropdownButtonFormField<String>(
//                     value: selectedEmail,
//                     onChanged: (value) {
//                       setState(() {
//                         selectedEmail = value!;
//                       });
//                     },
//                     items: usersData.map<DropdownMenuItem<String>>((userData) {
//                       return DropdownMenuItem<String>(
//                         value: userData['email'],
//                         child: Text("${userData['fullName']}"),
//                       );
//                     }).toList(),
//                     decoration: InputDecoration(
//                       labelText: 'Member',
//                     ),
//                   ),
//                 ],
//               ),
//               actions: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text("Cancel"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     // Fetch the UID of the selected member based on their email
//                     String? newMemberUid = await DatabaseService().getUidByEmail(selectedEmail);
//
//                     if (newMemberUid != null) {
//                       try {
//                         // Use the obtained UID to add the user to the group
//                         await addMemberToTask(
//                           taskId,
//                           newMemberUid,
//                           taskName,
//                           startDate,
//                           dueDate,
//                           time,
//                           owner,
//                           stage,
//                           desc,
//                         );
//
//                         // Update the UI by calling setState
//                         setState(() {
//                           // Add the new member to the existing GroupTile widget
//                           taskTilesList.add(
//                             TaskTile(
//                               taskId: taskId,
//                               taskName: taskName,
//                               userName: selectedEmail,
//                               startDate: startDate,
//                               dueDate: dueDate,
//                               stage: stage,
//                               owner: owner,
//                               desc: desc,
//                               time: time,
//                               selectedGroupName: selectedGroupName,
//                               onAddMember: () {
//                                 _showAddMemberDialog(context, taskId);
//                               },
//                               onDelete: () {
//                                 _deleteTask(taskId);
//                               },
//                             ),
//                           );
//                         });
//
//                         Navigator.of(context).pop();
//                         showSnackbar(context, Colors.green, "Member added successfully.");
//                       } catch (e) {
//                         print("Error adding member to group: $e");
//                         // Handle the error as needed
//                       }
//                     } else {
//                       print("User with email $selectedEmail not found");
//                     }
//                   },
//                   child: const Text("Add"),
//                 ),
//               ],
//             );
//           }
//         },
//       );
//     },
//   );
// }