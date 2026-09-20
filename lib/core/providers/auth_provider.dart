import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/file_model.dart';
import '../services/services.dart';

// ============ AUTH PROVIDERS ============

final authServiceProvider = Provider<AuthService>((ref) {
  final authService = AuthService();
  ref.onDispose(() async {
    await authService.close();
  });
  return authService;
});

final authStateProvider = StreamProvider<UserModel?>((ref) async* {
  final authService = ref.watch(authServiceProvider);
  
  // Initialize auth service
  await authService.init();
  
  // Check current user
  if (authService.isLoggedIn) {
    yield authService.currentUserModel;
  } else {
    yield null;
  }
  
  // Listen to auth state changes
  await for (final user in authService.authStateChanges) {
    if (user != null) {
      yield authService.currentUserModel;
    } else {
      yield null;
    }
  }
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).value;
});

final isLoggedInProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

final isGuestProvider = Provider<bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.isGuest;
});

// ============ AUTH ACTION PROVIDERS ============

final signInWithEmailProvider = FutureProvider.family<UserModel?, (String, String)>((ref, args) async {
  final (email, password) = args;
  final authService = ref.read(authServiceProvider);
  return await authService.signInWithEmailAndPassword(email, password);
});

final signInWithGoogleProvider = FutureProvider<UserModel?>((ref) async {
  final authService = ref.read(authServiceProvider);
  return await authService.signInWithGoogle();
});

final signUpWithEmailProvider = FutureProvider.family<UserModel?, (String, String, String)>((ref, args) async {
  final (email, password, name) = args;
  final authService = ref.read(authServiceProvider);
  return await authService.signUpWithEmailAndPassword(email, password, name);
});

final signOutProvider = FutureProvider<void>((ref) async {
  final authService = ref.read(authServiceProvider);
  await authService.signOut();
});

final continueAsGuestProvider = FutureProvider<void>((ref) async {
  final authService = ref.read(authServiceProvider);
  await authService.continueAsGuest();
});

final sendPasswordResetProvider = FutureProvider.family<void, String>((ref, email) async {
  final authService = ref.read(authServiceProvider);
  await authService.sendPasswordResetEmail(email);
});

final updateProfileProvider = FutureProvider.family<void, Map<String, dynamic>>((ref, updates) async {
  final authService = ref.read(authServiceProvider);
  await authService.updateProfile(
    name: updates['name'] as String?,
    photoUrl: updates['photoUrl'] as String?,
    bio: updates['bio'] as String?,
    language: updates['language'] as String?,
    theme: updates['theme'] as String?,
  );
});

final deleteAccountProvider = FutureProvider<void>((ref) async {
  final authService = ref.read(authServiceProvider);
  await authService.deleteAccount();
});
