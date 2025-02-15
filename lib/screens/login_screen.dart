import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/routes.dart';

// First, create a provider class for managing the checkbox state
class CheckboxProvider extends ChangeNotifier {
  bool _isChecked = false;
  bool get isChecked => _isChecked;

  void toggleCheckbox(bool? value) {
    _isChecked = value ?? false;
    notifyListeners();
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CheckboxProvider(),
      child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  const SizedBox(width: 280),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close)
                  ),
                ],
              )
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0cBwtJxQ14kN_z1ua49yRZyt2qFzu4_vx8A&s",
                  width: 140,
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(
                  "Welcome",
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 22),
                child: Text(
                  "Sign in to continue",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.only(left: 22),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Enter your Phone Number"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter phone number',
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Consumer<CheckboxProvider>(
                      builder: (context, provider, child) => Checkbox(
                        value: provider.isChecked,
                        onChanged: provider.toggleCheckbox,
                      ),
                    ),
                    const Text('Accept '),
                    GestureDetector(
                      onTap: () {

                      },
                      child: const Text(
                        'Terms and condition',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Consumer<CheckboxProvider>(
                  builder: (context, provider, child){
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isChecked ? () async {
                        final phoneNumber = _phoneController.text.trim();
                        if(phoneNumber.isNotEmpty)
                          {
                            try{
                             final check = await authProvider.createOtp(phoneNumber);
                            if(check)
                              {
                                Navigator.pushReplacementNamed(context, AppRoutes.otp);
                              }

                            }
                            catch(e)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e'))
                          );

                        }
                          }

                      } : (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F51B5),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  );
  }
                ),
              ),
            ],
          )
      ),
    );
  }
}