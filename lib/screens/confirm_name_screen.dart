import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/routes.dart';

class ConfirmNameScreen extends StatefulWidget {
  const ConfirmNameScreen({super.key});

  @override
  State<ConfirmNameScreen> createState() => _ConfirmNameScreenState();
}

class _ConfirmNameScreenState extends State<ConfirmNameScreen> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Name')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false
                  );
                  authProvider.setUserName(_nameController.text);
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
