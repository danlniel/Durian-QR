import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Register a new user
  Future<void> registerUser(String username, String password, String role) async {
    try {
      // WIP Hash the password before storing it
      // Store user data in Firestore with the username as the document ID
      await _firestore.collection('users').doc(username).set({
        'password': password,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('User "$username" registered successfully!');
    } catch (e) {
      print('Error registering user: $e');
    }
  }

  /// ✅ Login user and return user details
  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(username).get();

      if (!userDoc.exists) {
        print('User not found!');
        return null;
      }

      // Get stored hashed password
      String storedPassword = userDoc['password'];

      // Hash the input password and compare
      if (storedPassword == password) {
        print('Login successful!');

        // Return user info excluding password
        return {
          'username': username,
          'role': userDoc['role']
        };
      } else {
        print('Invalid password!');
        return null;
      }
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }
}
