import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/local_images.dart';
import 'package:task/utils/text_style.dart';
import 'package:task/view/create_task/create_task_view.dart';
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
  List onBorderingData = [
    {
      "image": LocalImages.icUIDesign,
      "taskText": "UI Design",
      "taskTime": "09:00 AM To 11:00 AM",
    },
    {
      "image": LocalImages.icAppDev,
      "taskText": "App Development",
      "taskTime": "12:30 PM To 02:00 PM",
    },
    {
      "image": LocalImages.icWebDev,
      "taskText": "Web Development",
      "taskTime": "04:00 PM To 06:00 PM",
    },
    {
      "image": LocalImages.icDeshBoard,
      "taskText": "Dashboard Design",
      "taskTime": "09:00 PM To 10:00 PM",
    },
    {
      "image": LocalImages.icAccounting,
      "taskText": "Accounting",
      "taskTime": "11:00 PM To 11:45 PM",
    },
  ];
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Schedule ",
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
          return AlertDialog(
            title: const Text(
              "Create a Project",
              textAlign: TextAlign.left,
            ),

            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.98, // Set width here
              height: MediaQuery.of(context).size.height * 0.98,
              child: SingleChildScrollView(
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
                      onChanged: (val) {
                        setState(() {
                          startDate = val;
                        });
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Start Date',
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
                        dueDate = val;
                        });
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Due Date',
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
                          stage = val;
                        });
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Stage',
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
                          owner = val;
                        });
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Created by',
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
                          borderRadius: BorderRadius.circular(20),
                        ),
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
                  if (groupName != "" && startDate!="" && dueDate!= "" && owner!="" && stage!="" && desc!="") {
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
  void _showAddMemberDialog(BuildContext context, String groupId) {
    TextEditingController emailController = TextEditingController();
    List<String> uniqueEmails = emails.toSet().toList(); // Remove duplicates

    String selectedEmail = uniqueEmails.isNotEmpty ? uniqueEmails[0] : ''; // Set default value

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Member"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modify this TextField to a DropdownButtonFormField
              DropdownButtonFormField<String>(
                value: selectedEmail,
                onChanged: (value) {
                  setState(() {
                    selectedEmail = value!;
                  });
                },
                items: uniqueEmails.map<DropdownMenuItem<String>>((String email) {
                  return DropdownMenuItem<String>(
                    value: email,
                    child: Text(email),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Email',
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
                if (selectedEmail.isNotEmpty) {
                  bool memberAdded = await addMemberToGroup(groupName, selectedEmail,startDate,dueDate,stage,owner,desc);

                  if (memberAdded) {
                    // Show a Snackbar if the member is added successfully
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Member added successfully."),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // Close the dialog
                    Navigator.of(context).pop();
                  } else {
                    // Handle failure, e.g., show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to add member."),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }



  Future<bool> addMemberToGroup(String groupId, String email,String startDate, String dueDate, String owner, String desc, String stage) async {
    try {
      // Fetch the user UID based on the provided email
      String? newMemberUid = await DatabaseService().getUidByEmail(email);

      if (newMemberUid != null) {
        // Use the obtained UID to add the user to the group
        await DatabaseService(uid: newMemberUid).createGroup(
          userName,
          newMemberUid,
          groupName,
          startDate,
          dueDate,
          owner,
          stage,
          desc
        );

        return true;
      } else {
        print("User with email $email not found");
        return false;
      }
    } catch (e) {
      print("Error adding member: $e");
      return false;
    }
  }


}