// import 'package:flutter/material.dart';
// import 'package:task/utils/common_colors.dart';
// import 'package:task/widget/app_bar/app_bar.dart';
// import 'package:task/widget/custom_button/custom_buttons.dart';
// import 'package:email_auth/email_auth.dart';
//
// class OTPVerifyView extends StatefulWidget {
//   final String email;
//
//   const OTPVerifyView({Key? key, required this.email}) : super(key: key);
//
//   @override
//   State<OTPVerifyView> createState() => _OTPVerifyViewState();
// }
//
// class _OTPVerifyViewState extends State<OTPVerifyView> {
//   TextEditingController otpController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CommonColors.whiteColor,
//       appBar: const AppBarView(
//         title: "OTP Verify",
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: const EdgeInsets.only(left: 26, right: 26),
//           child: Column(
//             children: [
//               Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//                 child: Image.asset("assets/icSendOTP.png"),
//               ),
//               Text(
//                 "Verification",
//                 style: TextStyle(
//                   color: CommonColors.blackColor,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "Enter the code sent to email ${widget.email}",
//                 maxLines: 2,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: CommonColors.textGeryColor,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 height: 50,
//                 child: TextField(
//                   controller: otpController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(
//                     hintText: "Enter OTP",
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 60, bottom: 20),
//                 child: SizedBox(
//                   height: 46,
//                   child: PrimaryButton(
//                     buttonText: "OTP Verify",
//                     callBack: () async {
//                       bool result = EmailAuth(sessionName: 'Example Session', recipientMail: widget.email).validate(otpController.text);
//
//                       if (result) {
//                         Navigator.of(context).pushReplacement(
//                           MaterialPageRoute(
//                             builder: (context) => const WelComeView(),
//                           ),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('Invalid OTP. Please try again.'),
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
