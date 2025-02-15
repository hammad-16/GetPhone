import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oru/utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, newUser }

class AuthProvider extends ChangeNotifier {

  bool _isLoading =false;
  bool get isLoading => _isLoading;
  String phoneNumber = "";
  int otp=0;
  String csrf = "";
  String cookie= "";
  dynamic usernew;
  Future<bool> likeProduct(String listingId, bool isFav) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("http://40.90.224.241:5000/favs"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': cookie,
          'X-Csrf-Token': csrf,
        },
        body: jsonEncode({
          "listingId": listingId,
          "isFav": isFav,
        }),
      );

      if (response.statusCode == 200) {
        print("like done");
        return true;
      } else {
        throw Exception("Response error: ${response.body}");
      }
    } catch (e) {
      throw Exception('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future <bool> validateOtp() async{
    _isLoading = true;
    notifyListeners();
    print(phoneNumber);
    print(otp);
    // return false;
    try{
      //TODO: change to phone
      final response = await http.post(
        Uri.parse("http://40.90.224.241:5000/login/otpValidate"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "countryCode": 91,
          "mobileNumber": int.parse(phoneNumber), // Remove +91 and parse to number
          "otp":otp
        }),
      );

      if(response.statusCode == 200)
      {
        // print(response.headers['set-cookie']);
        String? rawCookies = response.headers['set-cookie'];
        if(rawCookies=="") return false;
        // print(response.headers['set-cookie']);
        cookie = rawCookies!;
        final res = await http.get(
          Uri.parse("http://40.90.224.241:5000/isLoggedIn"),
          headers: {
            'Content-Type': 'application/json',
            'Cookie':rawCookies
          },
        );
        // print(rawCookies);
        if(res.statusCode == 200){
         print("life adf");
        }else{
          print("testing");
        }
        dynamic data = json.decode(res.body);
        csrf = data["csrfToken"];
        usernew = data["user"];

        return true;
        // return true;
      }
      else
      {
        throw Exception('Failed to validate OTP: ${response.body}');
      }
      // return false;
    }
    catch(e)
    {
      throw Exception('Error: $e');
    }
    finally
    {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future <bool> createOtp(String phoneNumber) async{
     _isLoading = true;
     notifyListeners();
     this.phoneNumber = phoneNumber.substring(3);
     phoneNumber = this.phoneNumber;
     try{
       final response = await http.post(
         Uri.parse("http://40.90.224.241:5000/login/otpCreate"),
         headers: {'Content-Type': 'application/json'},
         body: jsonEncode({
           "countryCode": 91,
           "mobileNumber": int.parse(phoneNumber) // Remove +91 and parse to number
         }),
       );

       if(response.statusCode == 200)
         {
          return true;
         }
       else
         {
           throw Exception('Failed to create OTP: ${response.body}');
         }
     }
     catch(e)
    {
      throw Exception('Error: $e');
    }
    finally
        {
          _isLoading = false;
          notifyListeners();
        }
  }







  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthStatus _status = AuthStatus.uninitialized;
  String? _verificationId;
  String? _phoneNumber;
  User? _user;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get dafgphoneNumber => _phoneNumber;

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
