import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task/utils/local_images.dart';
import 'package:task/view/welcome/welcome_view.dart';

import '../../helper/helper_function.dart';
import '../../service/auth_service.dart';
import '../../widget/widgets.dart';
import '../login/login_view.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  String phn ="";
  String design = "";


  String dpt = "Sales"; // Set a default value
  List<String> designationOptions = [
    "Sales",
    "Marketing",
    "Customer Service",
    "Operations",
    "Management",
    "Finance",
    "HR and Admin",
    "Tech",
  ];


  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
          child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor))
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
                  const Text(
                      "Create User Now To Grow Your Business",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400)),
                  // Image.asset(LocalImages.icIntroduction),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: "Full Name",
                        prefixIcon: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                        )),
                    onChanged: (val) {
                      setState(() {
                        fullName = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "Name cannot be empty";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //email
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
                  //password
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
                  //phone
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: "Phone",
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Theme.of(context).primaryColor,
                        )),
                    onChanged: (val) {
                      setState(() {
                        phn = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "phone cannot be empty";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //department
                  DropdownButtonFormField<String>(
                    value: dpt,
                    decoration: textInputDecoration.copyWith(
                      labelText: "Department",
                      prefixIcon: Icon(
                        Icons.computer_sharp,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        dpt= val!;
                      });
                    },
                    items: designationOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (val) {
                      if (val == null || val.isEmpty || val == "Option 1") {
                        return "Please select a valid designation";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //designation
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: "Designation",
                        prefixIcon: Icon(
                          Icons.computer_sharp,
                          color: Theme.of(context).primaryColor,
                        )),
                    onChanged: (val) {
                      setState(() {
                        design= val;
                      });
                    },
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "Designation cannot be empty";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //Register button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        "Create",
                        style:
                        TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () {
                        register();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Text.rich(TextSpan(
                  //   text: "Already have an account? ",
                  //   style: const TextStyle(
                  //       color: Colors.black, fontSize: 14),
                  //   children: <TextSpan>[
                  //     TextSpan(
                  //         text: "Login now",
                  //         style: const TextStyle(
                  //             color: Colors.black,
                  //             decoration: TextDecoration.underline),
                  //         recognizer: TapGestureRecognizer()
                  //           ..onTap = () {
                  //             nextScreen(context, const LoginPage());
                  //           }),
                  //   ],
                  // )),
                ],
              )),
        ),
      ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password, phn, dpt, design)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserNameSF(fullName);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserPhoneSF(phn);
          await HelperFunctions.saveUserDptSF(dpt);
          await HelperFunctions.saveUserDesignSF(design);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User created successfully, reopen the app to restore the admin account'),
              duration: Duration(seconds: 6),
            ),
          );

          // Navigate back to the previous screen (AllUsers)
          Navigator.pop(context);
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}