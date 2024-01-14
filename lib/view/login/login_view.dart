
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task/utils/local_images.dart';
import 'package:task/view/signup/register.dart';
import 'package:task/view/welcome/welcome_view.dart';

import '../../helper/helper_function.dart';
import '../../service/auth_service.dart';
import '../../service/database_service.dart';
import '../../widget/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email  = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor),
      )
          : SingleChildScrollView(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Buddy",
                    style: TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text("Login now to see what they are assigning",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400)),
                  Image.asset(LocalImages.icEmailBenner),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColor,
                        )),
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },

                    // check tha validation
                    validator: (val) {
                      return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val!)
                          ? null
                          : "Please enter a valid email";
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                        labelText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        )),
                    validator: (val) {
                      if (val!.length < 6) {
                        return "Password must be at least 6 characters";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        "Sign In",
                        style:
                        TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () {
                        login();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //don't have account
                  // Text.rich(TextSpan(
                  //   text: "Don't have an account? ",
                  //   style: const TextStyle(
                  //       color: Colors.black, fontSize: 14),
                  //   children: <TextSpan>[
                  //     TextSpan(
                  //         text: "Register here",
                  //         style: const TextStyle(
                  //             color: Colors.black,
                  //             decoration: TextDecoration.underline),
                  //         recognizer: TapGestureRecognizer()
                  //           ..onTap = () {
                  //             nextScreen(context, const RegisterPage());
                  //           }),
                  //   ],
                  // )),
                ],
              )),
        ),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        bool loginSuccess = await authService.loginWithUserNameandPassword(email, password);

        if (loginSuccess) {
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);

          // Check if the snapshot has documents
          if (snapshot.docs.isNotEmpty) {
            // Access the data
            String design = snapshot.docs[0]['design'] ?? "";
            String dpt = snapshot.docs.length > 1 ? snapshot.docs[1]['dpt'] ?? "" : "";
            String userEmail = snapshot.docs.length > 2 ? snapshot.docs[2]['email'] ?? "" : "";
            String fullName = snapshot.docs.length > 3 ? snapshot.docs[3]['fullName'] ?? "" : "";
            String phn = snapshot.docs.length > 5 ? snapshot.docs[5]['phn'] ?? "" : "";

            // saving the values to our shared preferences
            await HelperFunctions.saveUserLoggedInStatus(true);
            await HelperFunctions.saveUserDesignSF(design);
            await HelperFunctions.saveUserDptSF(dpt);
            await HelperFunctions.saveUserEmailSF(userEmail);
            await HelperFunctions.saveUserNameSF(fullName);
            await HelperFunctions.saveUserPhoneSF(phn);

            // Navigate to the welcome view
            nextScreenReplace(context, const WelComeView());
          } else {
            // Handle the case where no data is found
            showSnackbar(context, Colors.red, "No user data found.");
          }
        } else {
          showSnackbar(context, Colors.red, "Login failed. Please check your credentials.");
        }
      } catch (e) {
        // Handle any potential exceptions
        print("Error during login: $e");
        showSnackbar(context, Colors.red, "An error occurred during login.");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


}