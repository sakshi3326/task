import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // reference for our collections
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
  FirebaseFirestore.instance.collection("groups");
  final CollectionReference taskCollection =
  FirebaseFirestore.instance.collection("tasks");


  Future<Map<String, dynamic>> getGroupDetails(String groupId) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore.collection('groups').doc(groupId).get();
      return documentSnapshot.data() as Map<String, dynamic>;
    } catch (error) {
      print('Error fetching group details: $error');
      throw error;
    }
  }


  Future<void> updateGroupDetails(
      String groupId,
      String groupName,
      String startDate,
      String dueDate,
      String time,
      String owner,
      String stage,
      String desc,
      ) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'groupName': groupName,
        'startDate': startDate,
        'dueDate': dueDate,
        'time': time,
        'owner': owner,
        'stage': stage,
        'desc': desc,
      });
    } catch (error) {
      print('Error updating group details: $error');
      throw error;
    }
  }

  Future<void> updateTaskDetails(
      String taskId,
      String taskName,
      String startDate,
      String dueDate,
      String time,
      String owner,
      String stage,
      String desc,
      ) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'taskName': taskName,
        'startDate': startDate,
        'dueDate': dueDate,
        'time': time,
        'owner': owner,
        'stage': stage,
        'desc': desc,
      });
    } catch (error) {
      print('Error updating task details: $error');
      throw error;
    }
  }

  Future<Map<String, dynamic>> getTaskDetails(String taskId) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore.collection('tasks').doc(taskId).get();
      return documentSnapshot.data() as Map<String, dynamic>;
    } catch (error) {
      print('Error fetching task details: $error');
      throw error;
    }
  }
  // Update user information in the database
  Future<void> updateUserInfo(
      String email,
      String updatedFullName,
      String updatedPhone,
      String updatedDpt,
      String updatedDesign,
      ) async {
    try {
      // Get the user document reference by email
      QuerySnapshot snapshot =
      await userCollection.where("email", isEqualTo: email).limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        // Update the user information in the database
        DocumentReference userDocumentReference = snapshot.docs[0].reference;
        await userDocumentReference.update({
          "fullName": updatedFullName,
          "phn": updatedPhone,
          "dpt": updatedDpt,
          "design": updatedDesign,
        });
      }
    } catch (e) {
      print("Error updating user info: $e");
    }
  }

  // Retrieve user information by email
  Future<Map<String, dynamic>?> getUserInfoByEmail(String email) async {
    try {
      QuerySnapshot snapshot = await userCollection
          .where("email", isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs[0].data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user info by email: $e");
      return null;
    }
  }
  // get user UID by email
  Future<String?> getUidByEmail(String email) async {
    try {
      QuerySnapshot snapshot = await userCollection
          .where("email", isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs[0]["uid"];
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting UID by email: $e");
      return null;
    }
  }

  // saving the userdata
  Future savingUserData(String fullName, String email, String phn, String dpt, String design) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "phn": phn,
      "dpt": dpt,
      "design": design,
      "groups": [],
      "tasks": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
    await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  getUserTasks() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating a group
// Modify the createGroup method to return groupDocumentReference
  Future<DocumentReference> createGroup(String userName, String id, String groupName, String startDate, String dueDate, String time, String stage, String owner, String desc) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "startDate": startDate,
      "dueDate": dueDate,
      "time": time,
      "stage": stage,
      "owner": owner,
      "desc": desc,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
      // other fields...
    });

    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_${groupName}_${startDate}_${dueDate}_${owner}_${stage}_${desc}_$time"]),

    });

    return groupDocumentReference;
  }

  // creating a task
  Future createTask(String userName, String id, String taskName, String startDate, String dueDate, String time, String stage, String owner, String desc) async {
    DocumentReference taskDocumentReference = await taskCollection.add({
      "taskName": taskName,
      "taskIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "taskId": "",
      "recentMessage": "",
      "recentMessageSender": "",
      "startDate": startDate,
      "dueDate": dueDate,
      "stage": stage,
      "owner": owner,
      "time":time,
      "desc": desc,
    });
    // update the members
    await taskDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "taskId": taskDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "tasks":
      FieldValue.arrayUnion(["${taskDocumentReference.id}_${taskName}_${startDate}_${dueDate}_${owner}_${stage}_${desc}_$time"])
    });
  }

// Add a method in your DatabaseService to fetch all emails
  Future<List<String>> getAllEmails() async {
    try {
      QuerySnapshot snapshot = await userCollection.get();
      List<String> emails = snapshot.docs.map((doc) => doc['email'] as String).toList();
      return emails;
    } catch (e) {
      print("Error getting emails: $e");
      return [];
    }
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  Future getTaskAdmin(String taskId) async {
    DocumentReference d = taskCollection.doc(taskId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
   getGroupMembers(String groupId) {
    return groupCollection.doc(groupId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        List<dynamic> members = snapshot['members'] ?? [];
        return members.cast<String>().toList();
      } else {
        return [];
      }
    });
  }

  // get task members
  Stream<List<String>> getTaskMembers(String taskId) {
    return taskCollection.doc(taskId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        List<dynamic> members = snapshot['members'] ?? [];
        return members.cast<String>().toList();
      } else {
        return [];
      }
    });
  }



  // search
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName, String startDate, String dueDate, String time, String owner, String stage, String desc) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_${groupName}_${startDate}_${dueDate}_${owner}_${stage}_${desc}_$time")) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isUserJoinedTask(
      String taskName, String taskId, String userName, String startDate, String dueDate, String time,String owner, String stage, String desc) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['tasks'];
    if (groups.contains("${taskId}_${taskName}_${startDate}_${dueDate}_${owner}_${stage}_${desc}_$time")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName, String startDate, String dueDate,String time, String stage,String owner, String desc) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_${groupName}_${startDate}_${dueDate}_${owner}_${stage}_${desc}_$time")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_${groupName}_${startDate}_${dueDate}_${owner}_${stage}_${desc}_$time"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_${groupName}_${startDate}_${dueDate}_${owner}_${stage}_${desc}_$time"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  Future toggleTaskJoin(
      String taskId, String userName, String taskName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference taskDocumentReference = taskCollection.doc(taskId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> tasks = await documentSnapshot['tasks'];

    // if user has our groups -> then remove then or also in other part re join
    if (tasks.contains("${taskId}_$taskName")) {
      await userDocumentReference.update({
        "tasks": FieldValue.arrayRemove(["${taskId}_$taskName"])
      });
      await taskDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "tasks": FieldValue.arrayUnion(["${taskId}_$taskName"])
      });
      await taskDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  Future<List<Map<String, dynamic>>> getAllEmailsAndfullNames() async {
    try {
      QuerySnapshot snapshot = await userCollection.get();
      List<Map<String, dynamic>> usersData = snapshot.docs
          .map((doc) => {
        'email': doc['email'] as String,
        'fullName': doc['fullName'] as String,
        'dpt':doc['dpt'] as String

      })
          .toList();
      return usersData;
    } catch (e) {
      print("Error getting emails and names: $e");
      return [];
    }
  }




}