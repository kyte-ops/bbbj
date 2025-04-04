import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Enum to define the application mode
enum AppMode {
  development,
  production,
}

// Simple User class to store user information
class User {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool isInstructor;
  
  User({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isInstructor = false,
  });

  // Create a demo user for development mode
  factory User.demo() {
    return User(
      uid: 'demo-user-id',
      email: 'demo@example.com',
      displayName: 'Demo User',
      photoUrl: null,
      isInstructor: false,
    );
  }

  // Create user from Firebase user data
  factory User.fromFirestore(Map<String, dynamic> data, String uid, String email, String? displayName) {
    return User(
      uid: uid,
      email: email,
      displayName: displayName,
      photoUrl: null,
      isInstructor: data['isInstructor'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'isInstructor': isInstructor,
      'createdAt': DateTime.now().toIso8601String(),
      'lastLogin': DateTime.now().toIso8601String(),
    };
  }
}

class AuthService with ChangeNotifier {
  User? _currentUser;
  AppMode _appMode = AppMode.development; // Default to development mode
  bool _isLoading = false;
  
  User? get currentUser => _currentUser;
  AppMode get appMode => _appMode;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  
  // Set the application mode
  Future<void> setAppMode(AppMode mode) async {
    _appMode = mode;
    
    // Save the mode setting to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_mode', mode.toString());
    
    notifyListeners();
  }
  
  // Initialize the service by loading saved state
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString('app_mode');
    
    if (savedMode != null && savedMode.contains('production')) {
      _appMode = AppMode.production;
    } else {
      _appMode = AppMode.development;
    }
    
    // Check if user is already logged in
    final savedUser = prefs.getString('user_id');
    if (savedUser != null) {
      // In dev mode, create a demo user
      if (_appMode == AppMode.development) {
        _currentUser = User.demo();
      }
      // In prod mode, we'd normally reconnect to Firebase here
    }
    
    notifyListeners();
  }
  
  // Sign in with development mode (one click)
  Future<User?> signInDevelopment() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      _currentUser = User.demo();
      
      // Save user to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', _currentUser!.uid);
      
      _isLoading = false;
      notifyListeners();
      return _currentUser;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
  
  // In production mode, this would connect to Firebase
  Future<User?> signInWithEmail(String email, String password) async {
    if (_appMode == AppMode.development) {
      return signInDevelopment();
    }
    
    // For production, we'll implement Firebase authentication later
    throw UnimplementedError('Email sign-in is only available in production mode with Firebase');
  }
  
  // In production mode, this would connect to Firebase Google Auth
  Future<User?> signInWithGoogle() async {
    if (_appMode == AppMode.development) {
      return signInDevelopment();
    }
    
    // For production, we'll implement Firebase Google Auth later
    throw UnimplementedError('Google sign-in is only available in production mode with Firebase');
  }
  
  // Register with email in production mode
  Future<User?> registerWithEmail(String email, String password) async {
    if (_appMode == AppMode.development) {
      return signInDevelopment();
    }
    
    // For production, we'll implement Firebase registration later
    throw UnimplementedError('Email registration is only available in production mode with Firebase');
  }
  
  // Sign out the user
  Future<void> signOut() async {
    _currentUser = null;
    
    // Remove user from shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    
    notifyListeners();
  }
}