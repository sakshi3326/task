import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../helper/helper_function.dart';
import '../../service/database_service.dart';


class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? fullName;
  String? email;
  List<String> allUserEmails = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Use the helper functions to get stored values
        String? storedUserName = await HelperFunctions.getUserNameFromSF();
        String? storedUserEmail = await HelperFunctions.getUserEmailFromSF();

        // Set the values to state
        setState(() {
          fullName = storedUserName ?? "Loading...";
          email = storedUserEmail ?? "Loading...";
        });

        // Fetch all user emails from the database
        fetchAllUserEmails();
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void fetchAllUserEmails() async {
    try {
      // Use your DatabaseService to get all emails
      List<String> emails = await DatabaseService().getAllEmails();

      // Set the state with the list of emails
      setState(() {
        allUserEmails = emails;
      });
    } catch (e) {
      print("Error fetching all user emails: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Available Users'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (allUserEmails.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: allUserEmails.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(allUserEmails[index]),
                    );
                  },
                ),
              ),
            if (allUserEmails.isEmpty)
              Text(
                'No users available.',
                style: TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}
