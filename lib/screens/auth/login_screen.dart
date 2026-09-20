import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:katib/core/utils/constants.dart';
import 'package:katib/widgets/auth_card.dart';

/// شاشة تسجيل الدخول
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // أيقونة التطبيق
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // اسم التطبيق
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // وصف التطبيق
              Text(
                AppConstants.appSlogan,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // بطاقة تسجيل الدخول
              AuthCard(
                onGuestLogin: () {
                  // الدخول كضيف
                  context.go('/home');
                },
                onEmailLogin: () {
                  // تسجيل الدخول عبر البريد الإلكتروني
                  // TODO: تنفيذ تسجيل الدخول
                  context.go('/home');
                },
                onGoogleLogin: () {
                  // تسجيل الدخول عبر Google
                  // TODO: تنفيذ تسجيل الدخول
                  context.go('/home');
                },
                onPhoneLogin: () {
                  // تسجيل الدخول عبر رقم الهاتف
                  // TODO: تنفيذ تسجيل الدخول
                  context.go('/home');
                },
              ),
              
              const SizedBox(height: 24),
              
              // نص تسجيل حساب جديد
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لا تملك حسابًا؟',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      // الانتقال إلى شاشة تسجيل حساب جديد
                      // TODO: تنفيذ تسجيل حساب جديد
                    },
                    child: Text(
                      'سجل الآن',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // نص استعادة كلمة المرور
              TextButton(
                onPressed: () {
                  // الانتقال إلى شاشة استعادة كلمة المرور
                  // TODO: تنفيذ استعادة كلمة المرور
                },
                child: Text(
                  'نسيت كلمة المرور؟',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
