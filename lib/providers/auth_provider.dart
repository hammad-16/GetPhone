import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, newUser }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthStatus _status = AuthStatus.uninitialized;
  String? _verificationId;
  String? _phoneNumber;
  User? _user;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get phoneNumber => _phoneNumber;

  AuthProvider() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    _user = _auth.currentUser;

    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      final hasName = _user!.displayName != null;

      if (hasName) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.newUser;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    _phoneNumber = phoneNumber;
    _status = AuthStatus.unauthenticated;
    notifyListeners();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        _status = AuthStatus.unauthenticated;
        notifyListeners();
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _status = AuthStatus.unauthenticated;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<bool> verifyOTP(String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      await _signInWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    final userCredential = await _auth.signInWithCredential(credential);
    _user = userCredential.user;

    if (_user != null) {
      _status = _user!.displayName == null
          ? AuthStatus.newUser
          : AuthStatus.authenticated;
      notifyListeners();
    }
  }

  Future<void> setUserName(String name) async {
    if (_user != null) {
      await _user!.updateDisplayName(name);
      _status = AuthStatus.authenticated;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
