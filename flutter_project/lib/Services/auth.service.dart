import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Admin/admin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_project/Pages/login.dart';

class AuthService {
  // Signup method
  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    if (!_isValidEmail(email)) {
      _showToast('Invalid email format.');
      return;
    }

    if (!_isValidPassword(password)) {
      _showToast(
        'Password must be at least 6 characters and include at least one number and one special character.',
      );
      return;
    }

    if (password != confirmPassword) {
      _showToast('Passwords do not match.');
      return;
    }

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      _showToast('Registration successful! Please log in.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const loginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'An account already exists with that email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'network-request-failed':
          message = 'Network error. Please check your connection.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }
      _showToast(message);
    } catch (e) {
      _showToast('An unexpected error occurred. Please try again.');
    }
  }

  // Login method
  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (!_isValidEmail(email)) {
      _showToast('Invalid email format.');
      return;
    }

    if (password.isEmpty) {
      _showToast('Password cannot be empty.');
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _showToast('Login successful!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const Admin()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password. Please try again.';
          break;
        case 'network-request-failed':
          message = 'Network error. Please check your connection.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }
      _showToast(message);
    } catch (e) {
      _showToast('An unexpected error occurred. Please try again.');
    }
  }

  // Signout method
  Future<void> signout({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
      _showToast('Logged out successfully.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const loginScreen()),
      );
    } catch (e) {
      _showToast('An error occurred while logging out.');
    }
  }

  // Utility to validate email format
  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Utility to validate password requirements
  bool _isValidPassword(String password) {
    final RegExp passwordRegex = RegExp(
      r'^(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{6,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  // Toast utility for user feedback
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength:
          Toast.LENGTH_SHORT, // Shorter duration for a cleaner experience
      gravity: ToastGravity.BOTTOM, // Toast appears at the bottom
      backgroundColor: const Color(
          0xAA333333), // A dark, semi-transparent background for a modern look
      textColor: Colors.white, // White text for readability
      fontSize: 16.0, // Slightly larger font for better legibility
    );
  }
}
