import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:katib/core/utils/constants.dart';
import 'package:katib/screens/splash/splash_screen.dart';
import 'package:katib/screens/auth/login_screen.dart';
import 'package:katib/screens/home/home_screen.dart';
import 'package:katib/screens/library/library_screen.dart';
import 'package:katib/screens/projects/projects_screen.dart';
import 'package:katib/screens/editor/editor_screen.dart';
import 'package:katib/screens/extraction/extraction_screen.dart';
import 'package:katib/screens/settings/settings_screen.dart';
import 'package:katib/screens/help/help_screen.dart';
import 'package:katib/widgets/main_scaffold.dart';

/// التطبيق الرئيسي
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // إعداد التوجيه
    final router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const MainScaffold(child: HomeScreen()),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const MainScaffold(child: HomeScreen()),
        ),
        GoRoute(
          path: '/library',
          builder: (context, state) => const MainScaffold(child: LibraryScreen()),
        ),
        GoRoute(
          path: '/projects',
          builder: (context, state) => const MainScaffold(child: ProjectsScreen()),
        ),
        GoRoute(
          path: '/editor/:projectId',
          builder: (context, state) {
            final projectId = state.pathParams['projectId'] ?? '';
            return MainScaffold(
              child: EditorScreen(projectId: projectId),
            );
          },
        ),
        GoRoute(
          path: '/extraction',
          builder: (context, state) => const MainScaffold(child: ExtractionScreen()),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const MainScaffold(child: SettingsScreen()),
        ),
        GoRoute(
          path: '/help',
          builder: (context, state) => const MainScaffold(child: HelpScreen()),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('خطأ'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('الصفحة غير موجودة'),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('الرجوع إلى الصفحة الرئيسية'),
              ),
            ],
          ),
        ),
      ),
    );

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: Theme.of(context),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'),
        Locale('en', 'US'),
      ],
      locale: const Locale('ar', 'AE'),
    );
  }
}
