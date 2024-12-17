import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_project/Admin/admin.dart';
import 'package:flutter_project/Pages/login.dart';

class AuthService {
  // Signup method
  Future<bool> signup({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    if (!_isValidEmail(email)) {
      _showToast('Invalid email format.');
      return false;
    }

    if (!_isValidPassword(password)) {
      _showToast(
        'Password must be at least 6 characters and include at least one number and one special character.',
      );
      return false;
    }

    if (password != confirmPassword) {
      _showToast('Passwords do not match.');
      return false;
    }

    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save user data (username) to Firestore
      await FirebaseFirestore.instance
          .collection('users') // Firestore collection name
          .doc(userCredential.user!.uid) // Document ID: user's UID
          .set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showToast('Registration successful! Please log in.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const loginScreen()),
      );

      return true;
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
      return false;
    } catch (e) {
      _showToast('An unexpected error occurred. Please try again.');
      return false;
    }
  }

  // Login method
  Future<bool> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (!_isValidEmail(email)) {
      _showToast('Invalid email format.');
      return false;
    }

    if (password.isEmpty) {
      _showToast('Password cannot be empty.');
      return false;
    }

    try {
      // Authenticate user
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Fetch user data from Firestore
      String username = await _getUsername(userCredential.user!.uid);

      if (email == 'admin@example.com') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const Admin()),
        );
      } else {
        // Navigate to User dashboard or replace with user screen
        _showToast('Welcome, $username!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const Admin()), // Replace Admin() with UserDashboard()
        );
      }

      _showToast('Login successful!');
      return true;
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
      return false;
    } catch (e) {
      _showToast('An unexpected error occurred. Please try again.');
      return false;
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

  // Fetch username from Firestore
  Future<String> _getUsername(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        return userDoc['username'] ?? 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      return 'Unknown';
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
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xAA333333),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
