// lib/screens/auth/otp_screen.dart
import 'package:flutter/material.dart';
import 'package:oru/widgets/otp_text_input.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/routes.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                const SizedBox(width: 280),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close)),
              ],
            )),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0cBwtJxQ14kN_z1ua49yRZyt2qFzu4_vx8A&s",
                width: 140,
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                textAlign: TextAlign.center,
                "Verify Mobile No.",
                style: TextStyle(
                    fontSize: 35,
                    color: Color(0xFF3F51B5),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              "Please enter the 4 digital verification code sent to your mobile number ",
              style: TextStyle(fontSize: 16),
            ),
            Padding(padding: EdgeInsets.only(top: 10), child: OtpText()),

            ElevatedButton(
              onPressed: () async {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                final result = await authProvider.validateOtp();
                if (result) {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                } else {
                  print("life");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3E468F), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded edges
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              ),
              child: const Text(
                "Verify OTP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ));
  }
}
