import 'package:flutter/material.dart';

/// بطاقة تسجيل الدخول
class AuthCard extends StatelessWidget {
  final VoidCallback onGuestLogin;
  final VoidCallback onEmailLogin;
  final VoidCallback onGoogleLogin;
  final VoidCallback onPhoneLogin;

  const AuthCard({
    super.key,
    required this.onGuestLogin,
    required this.onEmailLogin,
    required this.onGoogleLogin,
    required this.onPhoneLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // زر الدخول كضيف
            OutlinedButton.icon(
              onPressed: onGuestLogin,
              icon: const Icon(Icons.person_outline_rounded),
              label: const Text('الدخول كضيف'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // خط فاصل
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'أو',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // زر تسجيل الدخول عبر البريد الإلكتروني
            ElevatedButton.icon(
              onPressed: onEmailLogin,
              icon: const Icon(Icons.email_rounded),
              label: const Text('البريد الإلكتروني'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // زر تسجيل الدخول عبر Google
            OutlinedButton.icon(
              onPressed: onGoogleLogin,
              icon: Image.asset(
                'assets/icons/google.png',
                height: 24,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.g_mobiledata_rounded,
                  color: Colors.red,
                ),
              ),
              label: const Text('تسجيل الدخول عبر Google'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // زر تسجيل الدخول عبر رقم الهاتف
            OutlinedButton.icon(
              onPressed: onPhoneLogin,
              icon: const Icon(Icons.phone_rounded),
              label: const Text('رقم الهاتف'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
