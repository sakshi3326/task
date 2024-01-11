import 'package:flutter/material.dart';
import '../service/database_service.dart';

class TaskTile extends StatefulWidget {
  final String userName;
  final String taskId;
  String taskName; // Update to mutable for editing
  final Function onAddMember;
  final Function onDelete;
  final String selectedGroupName;
  final String startDate;
  final String dueDate;
  final String stage;
  final String owner;



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
     required this.stage,
     required this.owner,

  }) : super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {





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
              //   "This Project is created by ${widget.userName}",
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
      'Edit ${widget.taskName}',
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
        } else if (result == 'Edit ${widget.taskName}') {
          _editTaskInfoPopup(context);
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Task Name', widget.taskName),
              _buildInfoRow('Project Name', widget.selectedGroupName),
              _buildInfoRow('Start Date', widget.startDate),
              _buildInfoRow('Due Date', widget.dueDate),
              _buildInfoRow('Stage', widget.stage),
              _buildInfoRow('Created by', widget.owner),
              // Add other fields for task information here
            ],
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


  void _editTaskInfoPopup(BuildContext context) {
    TextEditingController taskNameController = TextEditingController(text: widget.taskName);


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskNameController,
                decoration: InputDecoration(labelText: 'Task Name'),
              ),

            ],
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
                // Update task details in the UI
                setState(() {
                  widget.taskName = taskNameController.text.trim();
                });

                // Update task details in the database
                await DatabaseService().updateTaskDetails(widget.taskId, widget.taskName);

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


  Rect _getTapPosition(RenderBox overlay) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    final Offset offset = referenceBox.localToGlobal(Offset.zero, ancestor: overlay);
    return Rect.fromPoints(
      offset,
      offset.translate(referenceBox.size.width, referenceBox.size.height),
    );
  }
}
