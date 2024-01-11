import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/helper_function.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? fullName;
  String? email;
  String? phone;
  String? designation;
  String? employeeId;
  String? department;

  TextEditingController phoneController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchLocallySavedData();
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
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void fetchLocallySavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString('phone') ?? "";
      designation = prefs.getString('designation') ?? "";
      employeeId = prefs.getString('employeeId') ?? "";
      department = prefs.getString('department') ?? "";
    });

    // Update the corresponding text fields
    phoneController.text = phone!;
    designationController.text = designation!;
    employeeIdController.text = employeeId!;
    departmentController.text = department!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Personal Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Full Name: $fullName',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Email: $email',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Editable text fields
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: designationController,
              decoration: InputDecoration(labelText: 'Designation'),
            ),
            TextField(
              controller: employeeIdController,
              decoration: InputDecoration(labelText: 'Employee ID'),
            ),
            TextField(
              controller: departmentController,
              decoration: InputDecoration(labelText: 'Department'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save entered values locally
                saveLocally();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void saveLocally() async {
    // Save the entered values locally
    phone = phoneController.text;
    designation = designationController.text;
    employeeId = employeeIdController.text;
    department = departmentController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', phone!);
    prefs.setString('designation', designation!);
    prefs.setString('employeeId', employeeId!);
    prefs.setString('department', department!);
  }
}
