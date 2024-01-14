import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task/view/upcoming_task/widget/upcoming_schedule_list.dart';
import 'package:task/widget/widgets.dart';

import '../service/database_service.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  final String startDate;
  final String dueDate;
  final String desc;
  final String stage;
  final String owner;

  const GroupInfo({
    Key? key,
    required this.adminName,
    required this.groupName,
    required this.startDate,
    required this.dueDate,
    required this.desc,
    required this.stage,
    required this.groupId,
    required this.owner
  }) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.groupName),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       showDialog(
        //         barrierDismissible: false,
        //         context: context,
        //         builder: (context) {
        //           return AlertDialog(
        //             title: const Text("Exit"),
        //             content: const Text("Are you sure you want to exit the group?"),
        //             actions: [
        //               IconButton(
        //                 onPressed: () {
        //                   Navigator.pop(context);
        //                 },
        //                 icon: const Icon(
        //                   Icons.cancel,
        //                   color: Colors.red,
        //                 ),
        //               ),
        //               IconButton(
        //                 onPressed: () async {
        //                   DatabaseService(
        //                     uid: FirebaseAuth.instance.currentUser!.uid,
        //                   ).toggleGroupJoin(
        //                     widget.groupId,
        //                     getName(widget.adminName),
        //                     widget.groupName,
        //                     widget.owner,
        //                     widget.stage,
        //                     widget.startDate,
        //                     widget.dueDate,
        //                     widget.desc
        //                   ).whenComplete(() {
        //                     nextScreenReplace(
        //                       context,
        //                       const UpcomingScheduleListView(),
        //                     );
        //                   });
        //                 },
        //                 icon: const Icon(
        //                   Icons.done,
        //                   color: Colors.green,
        //                 ),
        //               ),
        //             ],
        //           );
        //         },
        //       );
        //     },
        //     icon: const Icon(Icons.exit_to_app),
        //   ),
        // ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for Group Name
            Row(
              children: [
                Text(
                  "Group Name: ${widget.groupName}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Row for Start Date and Due Date
            Row(
              children: [
                Text("Start Date: ${widget.startDate}"),
                const SizedBox(width: 20),

              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text("Due Date: ${widget.dueDate}"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text("Stage: ${widget.stage}"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text("Owner: ${widget.owner}"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text("Description: ${widget.desc}"),
              ],
            ),
            // Admin Tile
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      Text("Admin: ${getName(widget.adminName)}"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Member List
            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          getName(snapshot.data['members'][index])
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(getName(snapshot.data['members'][index])),
                      subtitle: Text(getId(snapshot.data['members'][index])),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }
}
