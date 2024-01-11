import 'package:flutter/material.dart';
import 'package:task/widget/ChatPage.dart';

import '../service/database_service.dart';


class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  String groupName;
  final Function onAddMember;
  final Function onDelete;
  String startDate;
  String dueDate;
  String stage;
  String owner;
  String desc;

  GroupTile({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
    required this.onAddMember,
    required this.onDelete,
    required this.startDate,
    required this.dueDate,
    required this.stage,
    required this.owner,
    required this.desc,
  }) : super(key: key);



  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {



  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.groupId),
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
          _showPopupMenu(context,);
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
                  widget.groupName.substring(0, 1).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              title: Text(
                widget.groupName,
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
      'Add Member in ${widget.groupName}',
      // 'Members List for ${widget.groupName}',
      'Info for ${widget.groupName}',
      'Edit ${widget.groupName}',
      'Chat into ${widget.groupName}'
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
        if (result == 'Add Member in ${widget.groupName}') {
          widget.onAddMember();
        } else if (result == 'Info for ${widget.groupName}') {
          _showGroupInfoPopup(context);
        } else if (result == 'Edit ${widget.groupName}') {
          _editGroupInfoPopup(context);
        } else if (result == 'Chat into ${widget.groupName}') {
          // Navigate to ChatPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName,

            )),
          );
        } else {
          // Handle other options
        }
      }
    });
  }

  void _showMembersList(BuildContext context) {
    DatabaseService().getTaskMembers(widget.groupId).listen((List<String> members) {
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
          title: Text('Members List for ${widget.groupName}'),
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

  void _showGroupInfoPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Project Information'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoRow('Project Name', widget.groupName),
                _buildInfoRow('Start date', widget.startDate),
                _buildInfoRow('Due date', widget.dueDate),
                _buildInfoRow('Stage', widget.stage),
                _buildInfoRow('Created by', widget.owner),
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




  void _editGroupInfoPopup(BuildContext context) {
    TextEditingController groupNameController = TextEditingController(text: widget.groupName);


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit group Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: groupNameController,
                decoration: InputDecoration(labelText: 'Group Name'),
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
                  widget.groupName = groupNameController.text.trim();
                });

                // Update task details in the database
                await DatabaseService().updateGroupDetails(widget.groupId, widget.groupName);

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