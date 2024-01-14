import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/database_service.dart';

class TaskTile extends StatefulWidget {
  final String userName;
  final String taskId;
  String taskName; // Update to mutable for editing
  final Function onAddMember;
  final Function onDelete;
  final String selectedGroupName;
   String startDate;
   String dueDate;
   String time;
   String stage;
   String owner;
   String desc;



   TaskTile({
    Key? key,
    required this.taskId,
    required this.taskName,
    required this.userName,
    required this.onAddMember,
    required this.onDelete,
     required this.selectedGroupName,
     required this.startDate,
     required this.dueDate,
     required this.time,
     required this.stage,
     required this.owner,
     required this.desc,

  }) : super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {

  late SharedPreferences _prefs;
  late bool _isDismissed;
  void initState() {
    super.initState();
    _initPrefs();
    _fetchTaskDetails();
  }

  // Fetch the latest task details from the database
  Future<void> _fetchTaskDetails() async {
    try {
      // Assuming you have a method in your DatabaseService to fetch group details
      Map<String, dynamic> taskDetails = await DatabaseService().getTaskDetails(widget.taskId);

      setState(() {
        // Update widget's state with the latest data
        widget.taskName = taskDetails['taskName'];
        widget.startDate = taskDetails['startDate'];
        widget.dueDate = taskDetails['dueDate'];
        widget.time = taskDetails['time'];
        widget.owner = taskDetails['owner'];
        widget.stage = taskDetails['stage'];
        widget.desc = taskDetails['desc'];
      });
    } catch (error) {
      print('Error fetching group details: $error');
    }
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _isDismissed = _prefs.getBool(widget.taskId) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.taskId),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          widget.onDelete();
          _prefs.setBool(widget.taskId, true); // Mark as dismissed in SharedPreferences
          setState(() {
            _isDismissed = true;
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          _showPopupMenu(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
                child: Text(
                  widget.taskName.substring(0, 1).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              title: Text(
                widget.taskName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              // subtitle: Text(
              //   "This Project is created by ${widget.a}",
              //   style: const TextStyle(fontSize: 13),
              // ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPopupMenu(BuildContext context) async {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final List<String> options = [
      'Add Member in ${widget.taskName}',
      // 'Members List for ${widget.taskName}',
      'Info for ${widget.taskName}',
      // 'Edit ${widget.taskName}',
    ];

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        _getTapPosition(overlay),
        Offset.zero & overlay.size,
      ),
      items: options.map((String option) {
        return PopupMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      elevation: 8.0,
    ).then<void>((String? result) {
      if (result != null) {
        if (result == 'Add Member in ${widget.taskName}') {
          widget.onAddMember();
        } else if (result == 'Members List for ${widget.taskName}') {
          _showMembersList(context);
        } else if (result == 'Info for ${widget.taskName}') {
          _showTaskInfoPopup(context);
        } else {
          // Handle other options
        }
      }
    });
  }

  void _showMembersList(BuildContext context) {
    DatabaseService().getTaskMembers(widget.taskId).listen((List<String> members) {
      _showMembersPopup(context, members);
    }, onError: (error) {
      print("Error fetching members: $error");
    });
  }

  void _showMembersPopup(BuildContext context, List<String> members) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Members List for ${widget.taskName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: members.map((member) => Text(member)).toList(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showTaskInfoPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Task Information'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Task Name', widget.taskName),
                _buildInfoRow('Project Name', widget.selectedGroupName),
                _buildInfoRow('Start Date', widget.startDate),
                _buildInfoRow('Due Date', widget.dueDate),
                _buildInfoRow('Estimated time', widget.time),
                _buildInfoRow('Stage', widget.stage),
                _buildInfoRow('Task Owner', widget.owner),
                _buildInfoRow('Description', widget.desc),
                // Add other fields for task information here
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            ElevatedButton(
              onPressed: () {
                // Close the current dialog
                Navigator.of(context).pop();
                // Open the edit dialog
                _editTaskInfoPopup(context);
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _editTaskInfoPopup(BuildContext context) async {
    TextEditingController taskNameController = TextEditingController(text: widget.taskName);
    TextEditingController startDateController = TextEditingController(text: widget.startDate);
    TextEditingController dueDateController = TextEditingController(text: widget.dueDate);
    TextEditingController timeController = TextEditingController(text: widget.time);
    TextEditingController ownerController = TextEditingController(text: widget.owner);
    TextEditingController stageController = TextEditingController(text: widget.stage);
    TextEditingController descController = TextEditingController(text: widget.desc);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: taskNameController, decoration: InputDecoration(labelText: 'Task Name')),
                TextField(controller: startDateController, decoration: InputDecoration(labelText: 'Start Date')),
                TextField(controller: dueDateController, decoration: InputDecoration(labelText: 'Due Date')),
                TextField(controller: timeController, decoration: InputDecoration(labelText: 'Time')),
                TextField(controller: ownerController, decoration: InputDecoration(labelText: 'Owner')),
                TextField(controller: stageController, decoration: InputDecoration(labelText: 'Stage')),
                TextField(controller: descController, decoration: InputDecoration(labelText: 'Description')),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Update the widget's state
                setState(() {
                  widget.taskName = taskNameController.text.trim();
                  widget.startDate = startDateController.text.trim();
                  widget.dueDate = dueDateController.text.trim();
                  widget.time = timeController.text.trim();
                  widget.owner = ownerController.text.trim();
                  widget.stage = stageController.text.trim();
                  widget.desc = descController.text.trim();
                });

                // Update the details in the database
                await DatabaseService().updateTaskDetails(
                  widget.taskId,
                  widget.taskName,
                  widget.startDate,
                  widget.dueDate,
                  widget.time,
                  widget.owner,
                  widget.stage,
                  widget.desc,
                );

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Add an Edit popup dialog

  Rect _getTapPosition(RenderBox overlay) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    final Offset offset = referenceBox.localToGlobal(Offset.zero, ancestor: overlay);
    return Rect.fromPoints(
      offset,
      offset.translate(referenceBox.size.width, referenceBox.size.height),
    );
  }
}
