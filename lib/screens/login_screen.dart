import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
          title: Row(
            children: [
              SizedBox(width:280),
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon:const Icon(Icons.close)

              ),
            ],
          )
      ),
      body:Column(
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 94),
            child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0cBwtJxQ14kN_z1ua49yRZyt2qFzu4_vx8A&s",
            width: 160,),
          ),
          const SizedBox(height:30),
          Padding(
            padding: const EdgeInsets.only(left:94),
            child: Text("Welcome",
            style: TextStyle(
              fontSize: 40,
              color: Colors.blue[700],
              fontWeight: FontWeight.bold
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 94),
            child: Text("Sign in to continue"),
          ),
          SizedBox(height: 40,),
          Text("Enter your Phone Number"),
          TextField()
        ],
      ) 
      // 
      // 
      // Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       TextField(
      //         controller: _phoneController,
      //         keyboardType: TextInputType.phone,
      //         decoration: const InputDecoration(
      //           labelText: 'Phone Number (+91123456789)',
      //           border: OutlineInputBorder(),
      //         ),
      //       ),
      //       const SizedBox(height: 20),
      //       ElevatedButton(
      //         onPressed: () {
      //           final authProvider = Provider.of<AuthProvider>(
      //               context,
      //               listen: false
      //           );
      //           authProvider.verifyPhoneNumber(_phoneController.text);
      //           Navigator.pushNamed(context, AppRoutes.otp);
      //         },
      //         child: const Text('Send OTP'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
