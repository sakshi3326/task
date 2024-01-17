import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/text_style.dart';
import 'package:task/widget/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/helper_function.dart';
import '../../../service/auth_service.dart';
import '../../../service/database_service.dart';
import '../../../widget/group_tile.dart';

class UpcomingScheduleListView extends StatefulWidget {
  final Function? onTap;
  const UpcomingScheduleListView({this.onTap, Key? key}) : super(key: key);



  @override
  State<UpcomingScheduleListView> createState() => _UpcomingScheduleListViewState();
}

class _UpcomingScheduleListViewState extends State<UpcomingScheduleListView> {
  User? user;
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  String stage= "";
  String startDate="";
  String dueDate="";
  String owner ="";
  String taskName = "";
  String desc = "";
  bool isJoined = false;
  String time = "";

  List<GroupTile> groupTilesList = [];
  String _selectedGroupId = "";
  List<String> deletedTileIds = [];
  List<String> emails = [];

  @override
  void initState() {
    super.initState();
    gettingUserData();
    loadDeletedTiles();
    loadEmails();
    getCurrentUserIdandName();
  }
  getCurrentUserIdandName() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = selectedDate.toLocal().toString();
        } else {
          dueDate = selectedDate.toLocal().toString();
        }
      });
    }
  }



  // Add this method to fetch emails
  void loadEmails() async {
    List<String> fetchedEmails = await DatabaseService().getAllEmails();
    setState(() {
      emails = fetchedEmails;
    });
  }

  Future<void> saveDeletedTiles(List<String> deletedTileIds) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('deletedTiles', deletedTileIds);
  }

  void _deleteGroup(String groupId) {
    // Implement the logic for deleting the group
    // For example, update the UI and then save the deleted group ID
    setState(() {
      deletedTileIds.add(groupId);
      groupTilesList.removeWhere((tile) => tile.groupId == groupId);
    });

    // Save the updated deletedTileIds to SharedPreferences
    saveDeletedTiles(deletedTileIds);
  }

  Future<void> loadDeletedTiles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    deletedTileIds = prefs.getStringList('deletedTiles') ?? [];
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getGroupName(String input) {
    List<String> parts = input.split('_');
    if (parts.length >= 2) {
      // Check if there are at least two parts after splitting
      return parts[1]; // Index 1 corresponds to "groupName"
    } else {
      // Handle the case when there are not enough parts
      return '';
    }
  }

  String getStartDate(String input) {
    List<String> parts = input.split('_');
    if (parts.length >= 3) {
      // Check if there are at least three parts after splitting
      return parts[2]; // Index 2 corresponds to "startDate"
    } else {
      // Handle the case when there are not enough parts
      return '';
    }
  }

  String getDueDate(String input) {
    List<String> parts = input.split('_');
    if (parts.length >= 4) {
      return parts[3]; // Index 3 corresponds to "dueDate"
    } else {
      return '';
    }
  }

  String getOwner(String input) {
    List<String> parts = input.split('_');
    if (parts.length >= 5) {
      return parts[4]; // Index 4 corresponds to "owner"
    } else {
      return '';
    }
  }

  String getStage(String input) {
    List<String> parts = input.split('_');
    if (parts.length >= 6) {
      return parts[5]; // Index 5 corresponds to "stage"
    } else {
      return '';
    }
  }

  String getDesc(String input) {
    List<String> parts = input.split('_');
    if (parts.length >= 7) {
      return parts[6]; // Index 6 corresponds to "desc"
    } else {
      return '';
    }
  }

  String getTime(String input) {
    List<String> parts = input.split('_');
    if (parts.length >= 8) {
      return parts[7];
    } else {
      return '';
    }
  }


  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    joinedOrNot(
        String userName, String groupId, String groupName, String admin) async {
      await DatabaseService(uid: user!.uid)
          .isUserJoined(groupName, groupId, userName,startDate,dueDate,stage,owner,time,desc)
          .then((value) {
        setState(() {
          isJoined = value;
        });
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Schedule Projects ",
                style: CommonStyle.getRalewayFont(
                  color: CommonColors.blackColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CommonColors.bottomIconColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      popUpDialog(context);
                    },
                    child: Text(
                      "+ Add New",
                      style: CommonStyle.getRalewayFont(
                        color: CommonColors.whiteColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        groupList(),
      ],
    );
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              List<String> groupNames =
              List<String>.from(snapshot.data['groups']);

              // Clear existing groupTilesList before re-populating it
              groupTilesList.clear();

              // Populate sList with GroupTile widgets
              groupTilesList = groupNames
                  .where((groupName) => !deletedTileIds.contains(getId(groupName)))
                  .map(
                    (groupName) => GroupTile(

                  groupId: getId(groupName),
                  groupName: getGroupName(groupName),
                  userName: snapshot.data["fullName"],
                  startDate: getStartDate(groupName),
                  dueDate: getDueDate(groupName),
                  stage: getStage(groupName),
                  owner:getOwner(groupName),
                  desc: getDesc(groupName),
                  time: getTime(groupName),
                  onAddMember: () {
                    _showAddMemberDialog(context, getId(groupName));
                  },
                  onDelete: (){
                    _deleteGroup(getId(groupName));
                  },
                ),
              )
                  .toList();

              // Return Column with the GroupTile widgets
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: groupTilesList,
                ),
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
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



  popUpDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: ((context, setState) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: AlertDialog(
              title: const Text(
                "Create a Project",
                textAlign: TextAlign.left,
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _isLoading == true
                          ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                          : TextField(
                        onChanged: (val) {
                          setState(() {
                            groupName = val;
                          });
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Project Name',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // other decoration properties...
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        readOnly: true,
                        onTap: () => _selectDate(context, true),
                        controller: TextEditingController(text: startDate),
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Start Date',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        readOnly: true,
                        onTap: () => _selectDate(context, false),
                        controller: TextEditingController(text: dueDate),
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Due Date',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        onChanged: (val) {
                          setState(() {
                            time = val;
                          });
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Estimated Time(in hours)',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // other decoration properties...
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: stage.isNotEmpty ? stage : "TODO", // Set a default value if stage is empty
                        onChanged: (val) {
                          setState(() {
                            stage = val!;
                          });
                        },
                        items: ["TODO", "In Progress", "Completed", "Pending"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Stage',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // other decoration properties...
                        ),
                      ),

                      const SizedBox(height: 10),
                      TextField(
                        onChanged: (val) {
                          setState(() {
                            owner = val;
                          });
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Project Owner',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // other decoration properties...
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(

                        onChanged: (val) {
                          setState(() {
                            desc = val;
                          });
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Description',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 50),
                          // other decoration properties...
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "" && startDate!="" && dueDate!= "" && time!="" && owner!="" && stage!="" && desc!="") {
                      setState(() {
                        _isLoading = true;
                      });
                      await DatabaseService(
                        uid: FirebaseAuth.instance.currentUser!.uid,
                      ).createGroup(
                          userName,
                          FirebaseAuth.instance.currentUser!.uid,
                          groupName,
                          startDate,
                          dueDate,
                          time,
                          stage,
                          owner,
                          desc
                      ).whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackbar(
                        context,
                        Colors.green,
                        "Project created successfully.",
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red),
                  child: const Text("CREATE"),
                )
              ],
            ),
          );
        }));
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You don't have created any projects and being assigned, click add icon to create a one",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          )
        ],
      ),
    );
  }

  // Modify your _showAddMemberDialog method
// Modify your _showAddMemberDialog method
  void _showAddMemberDialog(BuildContext context, String groupId) {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: DatabaseService().getAllEmailsAndfullNames(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text("No data available");
            } else {
              List<Map<String, dynamic>> usersData = snapshot.data!;
              String selectedEmail = usersData.isNotEmpty ? usersData[0]['email'] : '';

              return AlertDialog(
                title: const Text("Add Member"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedEmail,
                      onChanged: (value) {
                        setState(() {
                          selectedEmail = value!;
                        });
                      },
                      items: usersData.map<DropdownMenuItem<String>>((userData) {
                        return DropdownMenuItem<String>(
                          value: userData['email'],
                          child: Text("${userData['fullName']}"),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Member',
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Fetch the UID of the selected member based on their email
                      String? newMemberUid = await DatabaseService().getUidByEmail(selectedEmail);

                      if (newMemberUid != null) {
                        try {
                          // Use the obtained UID to add the user to the group
                          await addMemberToGroup(
                            groupId,
                            newMemberUid,
                            groupName,
                            startDate,
                            dueDate,
                            time,
                            owner,
                            stage,
                            desc,
                          );

                          // Update the UI by calling setState
                          setState(() {
                            // Add the new member to the existing GroupTile widget
                            groupTilesList.add(
                              GroupTile(
                                groupId: groupId,
                                groupName: groupName,
                                userName: selectedEmail,
                                startDate: startDate,
                                dueDate: dueDate,
                                stage: stage,
                                owner: owner,
                                desc: desc,
                                time: time,
                                onAddMember: () {
                                  _showAddMemberDialog(context, groupId);
                                },
                                onDelete: () {
                                  _deleteGroup(groupId);
                                },
                              ),
                            );
                          });

                          Navigator.of(context).pop();
                          showSnackbar(context, Colors.green, "Member added successfully.");
                        } catch (e) {
                          print("Error adding member to group: $e");
                          // Handle the error as needed
                        }
                      } else {
                        print("User with email $selectedEmail not found");
                      }
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

// Move the addMemberToGroup method outside the widget
  Future<void> addMemberToGroup(
      String groupId,
      String memberId,
      String groupName,
      String startDate,
      String dueDate,
      String time,
      String owner,
      String stage,
      String desc,
      ) async {
    try {
      DocumentReference groupRef = DatabaseService().groupCollection.doc(groupId);

      // Get the admin UID from the admin field
      String adminUid = await DatabaseService().getGroupAdmin(groupId);

      await groupRef.update({
        'members': FieldValue.arrayUnion([adminUid, memberId]),
      });

      // Add the group tile to the member's collection
      await DatabaseService().userCollection.doc(memberId).collection('groups').doc(groupId).set({
        'groupName': groupName,
        'startDate': startDate,
        'dueDate': dueDate,
        'time': time,
        'owner': owner,
        'stage': stage,
        'desc': desc,
      });

      // Update the groups field in the member's document
      await DatabaseService().userCollection.doc(memberId).update({
        'groups': FieldValue.arrayUnion(["${groupId}_${groupName}_${startDate}_${dueDate}_${owner}_${stage}_${desc}_$time"]),
      });
    } catch (e) {
      print("Error adding member to group: $e");
      throw e;
    }
  }

}