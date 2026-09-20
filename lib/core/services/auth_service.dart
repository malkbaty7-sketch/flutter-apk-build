import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/file_model.dart';
import '../database/database_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseService _dbService = DatabaseService();
  
  static final AuthService _instance = AuthService._internal();
  
  factory AuthService() => _instance;
  
  AuthService._internal();
  
  User? _currentUser;
  UserModel? _currentUserModel;
  final StreamController<User?> _authStateController = StreamController<User?>.broadcast();
  
  Stream<User?> get authStateChanges => _authStateController.stream;
  
  User? get currentUser => _currentUser;
  UserModel? get currentUserModel => _currentUserModel;
  
  bool get isLoggedIn => _currentUser != null;
  bool get isGuest => _currentUser == null;
  
  Future<void> init() async {
    await _dbService.init();
    
    _firebaseAuth.authStateChanges().listen((user) async {
      _currentUser = user;
      _authStateController.add(user);
      
      if (user != null) {
        // Load user model from database
        await _loadUserModel(user.uid);
      } else {
        _currentUserModel = null;
      }
    });
    
    // Check if there's a cached user
    _currentUser = _firebaseAuth.currentUser;
    if (_currentUser != null) {
      await _loadUserModel(_currentUser!.uid);
    }
  }
  
  Future<void> _loadUserModel(String uid) async {
    try {
      _currentUserModel = await _dbService.getUser(uid);
      
      // If user doesn't exist in local DB, create from Firebase user
      if (_currentUserModel == null && _currentUser != null) {
        _currentUserModel = UserModel(
          id: _currentUser!.uid,
          name: _currentUser!.displayName,
          email: _currentUser!.email,
          photoUrl: _currentUser!.photoURL,
          phone: _currentUser!.phoneNumber,
        );
        await _dbService.addUser(_currentUserModel!);
      }
    } catch (e) {
      // User not found in local DB, create new
      if (_currentUser != null) {
        _currentUserModel = UserModel(
          id: _currentUser!.uid,
          name: _currentUser!.displayName,
          email: _currentUser!.email,
          photoUrl: _currentUser!.photoURL,
          phone: _currentUser!.phoneNumber,
        );
        await _dbService.addUser(_currentUserModel!);
      }
    }
  }
  
  // ============ SIGN IN METHODS ============
  
  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _currentUser = userCredential.user;
      await _loadUserModel(_currentUser!.uid);
      
      // Save login preference
      await _saveLoginPreference('email', email);
      
      return _currentUserModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to sign in with email: $e');
    }
  }
  
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google sign in cancelled');
      }
      
      // Obtain the auth details from the request
      final googleAuth = await googleUser.authentication;
      
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Once signed in, return the UserCredential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      _currentUser = userCredential.user;
      await _loadUserModel(_currentUser!.uid);
      
      // Save login preference
      await _saveLoginPreference('google', null);
      
      return _currentUserModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }
  
  Future<UserModel?> signInWithPhoneNumber(
    String phoneNumber,
    String verificationCode,
  ) async {
    try {
      // This would be part of a two-step process
      // First: send verification code
      // Second: verify with the code
      
      // For now, we'll implement the verification part
      final credential = PhoneAuthProvider.credential(
        verificationId: '', // Would be from first step
        smsCode: verificationCode,
      );
      
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      _currentUser = userCredential.user;
      await _loadUserModel(_currentUser!.uid);
      
      // Save login preference
      await _saveLoginPreference('phone', phoneNumber);
      
      return _currentUserModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to sign in with phone: $e');
    }
  }
  
  Future<void> sendPhoneVerificationCode(String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification on Android devices
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw _handleAuthException(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          // Store verification ID for later use
          _saveVerificationId(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timeout
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      throw Exception('Failed to send verification code: $e');
    }
  }
  
  Future<void> _saveVerificationId(String verificationId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('verification_id', verificationId);
  }
  
  Future<String?> getVerificationId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('verification_id');
  }
  
  Future<void> clearVerificationId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('verification_id');
  }
  
  // ============ SIGN UP ============
  
  Future<UserModel?> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _currentUser = userCredential.user;
      
      // Update display name
      if (_currentUser != null) {
        await _currentUser!.updateDisplayName(name);
        await _currentUser!.reload();
        _currentUser = _firebaseAuth.currentUser;
      }
      
      // Create user model
      _currentUserModel = UserModel(
        id: _currentUser!.uid,
        name: name,
        email: email,
        phone: _currentUser!.phoneNumber,
        photoUrl: _currentUser!.photoURL,
      );
      
      await _dbService.addUser(_currentUserModel!);
      
      // Save login preference
      await _saveLoginPreference('email', email);
      
      return _currentUserModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }
  
  // ============ SIGN OUT ============
  
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      
      _currentUser = null;
      _currentUserModel = null;
      _authStateController.add(null);
      
      // Clear login preferences
      await _clearLoginPreferences();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
  
  // ============ PASSWORD MANAGEMENT ============
  
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }
  
  Future<void> updatePassword(String newPassword) async {
    try {
      if (_currentUser == null) {
        throw Exception('No user logged in');
      }
      
      await _currentUser!.updatePassword(newPassword);
      await _currentUser!.reload();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }
  
  // ============ USER PROFILE ============
  
  Future<void> updateProfile({
    String? name,
    String? photoUrl,
    String? bio,
    String? language,
    String? theme,
  }) async {
    try {
      if (_currentUser == null || _currentUserModel == null) {
        throw Exception('No user logged in');
      }
      
      // Update Firebase display name
      if (name != null) {
        await _currentUser!.updateDisplayName(name);
      }
      
      // Update Firebase photo URL
      if (photoUrl != null) {
        await _currentUser!.updatePhotoURL(photoUrl);
      }
      
      // Update local user model
      _currentUserModel = _currentUserModel!.copyWith(
        name: name,
        photoUrl: photoUrl,
        bio: bio,
        language: language,
        theme: theme,
      );
      
      await _dbService.updateUser(_currentUserModel!);
      
      // Reload user
      await _currentUser!.reload();
      _currentUser = _firebaseAuth.currentUser;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
  
  // ============ SUBSCRIPTION ============
  
  Future<void> updateSubscriptionStatus({
    bool? isPremium,
    String? subscriptionId,
    DateTime? subscriptionExpiry,
  }) async {
    try {
      if (_currentUserModel == null) {
        throw Exception('No user logged in');
      }
      
      _currentUserModel = _currentUserModel!.copyWith(
        isPremium: isPremium ?? _currentUserModel!.isPremium,
        subscriptionId: subscriptionId,
        subscriptionExpiry: subscriptionExpiry,
      );
      
      await _dbService.updateUser(_currentUserModel!);
    } catch (e) {
      throw Exception('Failed to update subscription: $e');
    }
  }
  
  // ============ GUEST MODE ============
  
  Future<void> continueAsGuest() async {
    try {
      // In guest mode, we don't have a Firebase user
      // But we can still use local database
      await _dbService.init();
      
      // Clear any existing user
      _currentUser = null;
      _currentUserModel = null;
      
      // Create a temporary guest user model
      _currentUserModel = UserModel(
        id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Guest',
        isPremium: false,
      );
      
      await _dbService.addUser(_currentUserModel!);
      
      // Save login preference
      await _saveLoginPreference('guest', null);
      
      _authStateController.add(null);
    } catch (e) {
      throw Exception('Failed to continue as guest: $e');
    }
  }
  
  // ============ DELETE ACCOUNT ============
  
  Future<void> deleteAccount() async {
    try {
      if (_currentUser == null) {
        throw Exception('No user logged in');
      }
      
      // Delete user data from local database
      if (_currentUserModel != null) {
        await _dbService.deleteUser(_currentUserModel!.id);
      }
      
      // Delete Firebase user
      await _currentUser!.delete();
      
      // Sign out
      await signOut();
      
      // Clear all preferences
      await _clearLoginPreferences();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
  
  // ============ PREFERENCES ============
  
  Future<void> _saveLoginPreference(String method, String? identifier) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_method', method);
    if (identifier != null) {
      await prefs.setString('login_identifier', identifier);
    } else {
      await prefs.remove('login_identifier');
    }
  }
  
  Future<void> _clearLoginPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('login_method');
    await prefs.remove('login_identifier');
    await prefs.remove('verification_id');
  }
  
  Future<Map<String, String?>> getLoginPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'method': prefs.getString('login_method'),
      'identifier': prefs.getString('login_identifier'),
    };
  }
  
  // ============ ERROR HANDLING ============
  
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return Exception('Invalid email address');
      case 'user-disabled':
        return Exception('User account has been disabled');
      case 'user-not-found':
        return Exception('User not found');
      case 'wrong-password':
        return Exception('Wrong password');
      case 'email-already-in-use':
        return Exception('Email already in use');
      case 'operation-not-allowed':
        return Exception('Operation not allowed');
      case 'weak-password':
        return Exception('Password is too weak');
      case 'invalid-verification-code':
        return Exception('Invalid verification code');
      case 'invalid-phone-number':
        return Exception('Invalid phone number');
      case 'session-expired':
        return Exception('Verification code has expired');
      case 'quota-exceeded':
        return Exception('Too many requests. Please try again later.');
      case 'app-not-authorized':
        return Exception('App not authorized for this operation');
      case 'network-request-failed':
        return Exception('Network error. Please check your connection.');
      default:
        return Exception('Authentication error: ${e.message}');
    }
  }
  
  // ============ CLEANUP ============
  
  Future<void> close() async {
    await _authStateController.close();
  }
  
  static Future<void> dispose() async {
    await _instance.close();
  }
}
