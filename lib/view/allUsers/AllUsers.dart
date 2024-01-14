import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../../service/database_service.dart';
import '../../widget/widgets.dart';
import '../signup/register.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> allUserData = [];
  String specificUserEmail = "adminuser1@gmail.com";
  @override
  void initState() {
    super.initState();
    fetchAllUsersData();
  }

  void fetchAllUsersData() async {
    try {
      List<Map<String, dynamic>> usersData =
      await DatabaseService().getAllEmailsAndfullNames();

      setState(() {
        allUserData = usersData;
      });
    } catch (e) {
      print("Error fetching all user data: $e");
    }
  }

  bool shouldShowFAB() {
    return _auth.currentUser?.email == specificUserEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Available Users'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: allUserData.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ListView.builder(
            itemCount: allUserData.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(allUserData[index]['fullName'] ?? ""),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Department: ${allUserData[index]['dpt'] ?? ""}"),
                    Text("Email: ${allUserData[index]['email'] ?? ""}"),
                  ],
                ),
              );
            },
          ),
        )
            : Text(
          'No users available.',
          style: TextStyle(fontSize: 18),
        ),
      ),
      floatingActionButton: shouldShowFAB()
          ? FloatingActionButton(
        onPressed: () {
          // Handle FAB button press
          nextScreen(context, const RegisterPage());
        },
        child: Icon(Icons.add),
      )
          : null,
    );
  }
}