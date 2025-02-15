import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class OtpText extends StatefulWidget {
  @override
  _OtpTextState createState() => _OtpTextState();
}

class _OtpTextState extends State<OtpText> {
  final List<TextEditingController> _controllers =
  List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(4, (index) => FocusNode());
  int otpValue = 0;

  void _onOtpEntered() {
    String otp = _controllers.map((e) => e.text).join();
    if (otp.length == 4) {
      setState(() {
        otpValue = int.parse(otp);
      });
      // print("Entered OTP: $otpValue");
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      authProvider.otp = otpValue;
    }
  }


@override
Widget build(BuildContext context) {
  return Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      if (index < 3) {
                        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                      } else {
                        _onOtpEntered();
                        FocusScope.of(context).unfocus();
                      }
                    }
                  },
                ),
              );
            }),
          ),
          SizedBox(height: 20),
          Text(
            "Didn't receive OTP?",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Resend OTP in", style: TextStyle(fontSize: 14)),
              SizedBox(width: 5),
              Text("0:23 Sec", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    ),
  );
}
}