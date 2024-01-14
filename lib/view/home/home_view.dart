import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/utils/common_colors.dart';
import 'package:task/utils/text_style.dart';
import 'package:task/view/home/widget/task_list_view.dart';
import 'package:task/view/task_details/task_details_view.dart';
import 'package:task/widget/app_bar/app_bar.dart';

import '../../helper/helper_function.dart';
import '../../service/auth_service.dart';
import '../../service/database_service.dart';
import '../../widget/task_tile.dart';
import '../../widget/widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String userName = "";

  String email = "";
  AuthService authService = AuthService();
  Stream? tasks;
  bool _isLoading = false;
  String taskName = "";

  String startDate = "";
  String dueDate = "";
  String time= "";
  String stage="";
  String owner="";
  String desc="";
  List<TaskTile> taskTilesList = [];
  String _selectedGroupId = "";
  List<String> deletedTileIds = [];
  String selectedGroupName = ""; // New variable for selected group name
  List<String> groupNames = [];
  List<String> emails = [];

  @override
  void initState() {
    super.initState();
    gettingUserData();
    loadDeletedTiles();
    // Fetch group names when the view is initialized
    fetchGroupNames();
    loadEmails();
  }

  // Add this method to fetch emails
  void loadEmails() async {
    List<String> fetchedEmails = await DatabaseService().getAllEmails();
    setState(() {
      emails = fetchedEmails;
    });
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

  Future<void> fetchGroupNames() async {
    try {
      // Fetch group names from the database
      QuerySnapshot groupSnapshot = await FirebaseFirestore.instance
          .collection("groups")
          .get();

      // Extract unique group names from the snapshot
      Set<String> uniqueNames = groupSnapshot.docs
          .map<String>((doc) => doc["groupName"] as String)
          .toSet();

      // Update the state with the fetched group names and default selected group name
      setState(() {
        groupNames = uniqueNames.toList();
        selectedGroupName = groupNames.isNotEmpty ? groupNames[0] : "";
      });
    } catch (e) {
      print("Error fetching group names: $e");
    }
  }





  Future<void> saveDeletedTiles(List<String> deletedTileIds) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('deletedTiles', deletedTileIds);
  }

  String getProgressText() {
    double progress = taskTilesList.isEmpty ? 1.0 : calculateProgress();
    progress *= 100;
    return "${progress.toStringAsFixed(0)} %";
  }



  void _deleteTask(String taskId) {
    // Implement the logic for deleting the group
    // For example, update the UI and then save the deleted group ID
    setState(() {
      deletedTileIds.add(taskId);
      taskTilesList.removeWhere((tile) => tile.taskId == taskId);
    });

    // Save the updated deletedTileIds to SharedPreferences
    saveDeletedTiles(deletedTileIds);
  }

  Future<void> loadDeletedTiles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    deletedTileIds = prefs.getStringList('deletedTiles') ?? [];
  }
  double calculateProgress() {
    // Assuming that totalTasks is the total number of tasks
    int totalTasks = 15; // Change this according to your requirement
    int completedTasks = taskTilesList.length;

    // Calculate the progress percentage
    double progress = completedTasks / totalTasks;

    // Ensure the progress is between 0 and 1
    return progress.clamp(0.0, 1.0);
  }


  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getTaskName(String input) {
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
      return parts[7]; // Index 6 corresponds to "desc"
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
        .getUserTasks()
        .then((snapshot) {
      setState(() {
        tasks = snapshot;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.whiteColor,
      appBar: AppBarView(
        title: "Create Task",

      ),
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.only(top: 20, left: 26, right: 26, bottom: 10),
          child: Column(
            children: [

             SizedBox(height: 20,),
             //Task heading
             Padding(
               padding: const EdgeInsets.only(top: 20, bottom: 10),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(
                     "Schedule Tasks",
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
              taskList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget overlapped() {
    return Container(child: Text('You can create and see tasks here'));
  }

  taskList() {
    return StreamBuilder(
      stream: tasks,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['tasks'] != null) {
            if (snapshot.data['tasks'].length != 0) {
              List<String> taskNames =
              List<String>.from(snapshot.data['tasks']);

              // Clear existing groupTilesList before re-populating it
              taskTilesList.clear();

              // Populate groupTilesList with GroupTile widgets
              taskTilesList = taskNames
                  .where((taskName) => !deletedTileIds.contains(getId(taskName)))
                  .map(
                    (taskName) => TaskTile(
                   startDate: getStartDate(taskName),
                  dueDate: getDueDate(taskName),
                  time: getTime(taskName),
                  owner: getOwner(taskName),
                  stage: getStage(taskName),
                  taskId: getId(taskName),
                 taskName: getTaskName(taskName),
                  userName: snapshot.data['fullName'],
                  desc: getDesc(taskName),
                  onAddMember: () {
                    _showAddMemberDialog(context, getId(taskName));
                  },
                  onDelete: (){
                    _deleteTask(getId(taskName));
                  },
                      selectedGroupName: selectedGroupName,



                    ),
              )
                  .toList();

              // Return Column with the GroupTile widgets
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: taskTilesList,
                ),
              );
            } else {
              return noTaskWidget();
            }
          } else {
            return noTaskWidget();
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
                "Create a Task",
                textAlign: TextAlign.left,
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.98, // Set width here
                height: MediaQuery.of(context).size.height * 0.98,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dropdown for selecting a group name
                      DropdownButtonFormField<String>(
                        value: selectedGroupName,
                        onChanged: (value) {
                          setState(() {
                            selectedGroupName = value!;
                          });
                        },
                        items: groupNames.map((groupName) {
                          return DropdownMenuItem<String>(
                            value: groupName,
                            child: Text(groupName),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Select a Project',
                        ),
                      ),
                      const SizedBox(height: 10),
                      _isLoading == true
                          ? Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor),
                      )
                          : TextField(
                        onChanged: (val) {
                          setState(() {
                            taskName = val;
                          });
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Task Name',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(20)),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
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
                          labelText: 'Estimated Time',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(20)),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
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
                          labelText: 'Task Owner',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(20)),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
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
                            desc = val;
                          });
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Description',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(20)),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 50),
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
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (taskName.isNotEmpty) {
                      setState(() {
                        _isLoading = true;
                      });

                      // Store the additional data in the database
                      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                          .createTask(
                        userName,
                        FirebaseAuth.instance.currentUser!.uid,
                        taskName,
                        startDate,
                        dueDate,
                        time,
                        stage,
                        owner,
                        desc
                      )
                          .whenComplete(() {
                        _isLoading = false;
                      });

                      Navigator.of(context).pop();
                      showSnackbar(
                        context,
                        Colors.blue,
                        "Task created successfully.",
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("CREATE"),
                )
              ],
            );
          }));
        });
  }

  noTaskWidget() {
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
            "You don't have created any task and being assigned, click add icon to create a one",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          )
        ],
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context, String taskId) {
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
                          child: Text("${userData['fullName']} "),
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
                      if (selectedEmail.isNotEmpty) {
                        bool memberAdded = await addMemberToTask(
                          taskId,
                          selectedEmail,
                          startDate,
                          dueDate,
                          time,
                          stage,
                          owner,
                          desc,
                        );

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
            }
          },
        );
      },
    );
  }



  Future<bool> addMemberToTask(String taskId, String email,String startDate, String dueDate, String time,String owner, String stage,String desc) async {
    try {
      // Fetch the user UID based on the provided email
      String? newMemberUid = await DatabaseService().getUidByEmail(email);

      if (newMemberUid != null) {
        // Use the obtained UID to add the user to the group
        await DatabaseService(uid: newMemberUid).createTask(
          userName,
          newMemberUid,
          taskName,
          stage,
          startDate,
          dueDate,
          time,
          owner,
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
