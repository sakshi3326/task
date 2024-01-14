import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../helper/helper_function.dart';
import '../../service/database_service.dart';

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
  String? dpt;
  String? design;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String? userEmail = user.email;

        String? storedUserName = await HelperFunctions.getUserNameFromSF();
        String? storedUserPhone = await HelperFunctions.getUserPhoneFromSF();
        String? storedUserDesign = await HelperFunctions.getUserDesignFromSF();
        String? storedUserDpt = await HelperFunctions.getUserDptFromSF();

        Map<String, dynamic>? userInfo =
        await DatabaseService().getUserInfoByEmail(userEmail ?? "");

        setState(() {
          fullName = userInfo?['fullName'] ?? storedUserName ?? "Loading...";
          email = userEmail ?? "Loading...";
          phone = userInfo?['phn'] ?? storedUserPhone ?? "Loading...";
          dpt = userInfo?['dpt'] ?? storedUserDpt ?? "Loading...";
          design = userInfo?['design'] ?? storedUserDesign ?? "Loading...";
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void _editUserInfo() async {
    TextEditingController fullNameController = TextEditingController(text: fullName);
    TextEditingController phoneController = TextEditingController(text: phone);
    TextEditingController dptController = TextEditingController(text: dpt);
    TextEditingController designController = TextEditingController(text: design);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              TextFormField(
                controller: dptController,
                decoration: InputDecoration(labelText: 'Department'),
              ),
              TextFormField(
                controller: designController,
                decoration: InputDecoration(labelText: 'Designation'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Validate and update the values
                String updatedFullName = fullNameController.text;
                String updatedPhone = phoneController.text;
                String updatedDpt = dptController.text;
                String updatedDesign = designController.text;

                // Update the UI
                setState(() {
                  fullName = updatedFullName;
                  phone = updatedPhone;
                  dpt = updatedDpt;
                  design = updatedDesign;
                });

                // Update the values in the database
                await DatabaseService().updateUserInfo(
                  email!,
                  updatedFullName,
                  updatedPhone,
                  updatedDpt,
                  updatedDesign,
                );

                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Personal Information'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editUserInfo,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Full Name: $fullName',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'Phone: $phone',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'Department: $dpt',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'Designation: $design',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
