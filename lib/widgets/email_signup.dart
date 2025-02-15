import 'package:flutter/material.dart';

class EmailSignupWidget extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  void _onSubmit() {
    String email = _emailController.text;
    if (email.isNotEmpty) {
      // Handle email submission logic here
      print("Email submitted: $email");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color:Color(0xFFFFC72C),
          borderRadius:  BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Get Notified About Our Latest Offers and Price Drops',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your email here',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: ElevatedButton(
              onPressed: _onSubmit,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: Colors.black,
              ),
              child: Text("Send Email", style: TextStyle(color: Colors.white)),
            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
