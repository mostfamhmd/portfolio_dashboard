import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'services/storage_service.dart';
import 'providers/portfolio_provider.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/personal_info_screen.dart';
import 'screens/skills_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/experience_screen.dart';
import 'screens/social_links_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'widgets/loading_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final storageService = StorageService();

  runApp(PortfolioDashboardApp(storageService: storageService));
}

final _router = GoRouter( 
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/personal-info',
      builder: (context, state) => const PersonalInfoScreen(),
    ),
    GoRoute(
      path: '/skills',
      builder: (context, state) => const SkillsScreen(),
    ),
    GoRoute(
      path: '/projects',
      builder: (context, state) => const ProjectsScreen(),
    ),
    GoRoute(
      path: '/experience',
      builder: (context, state) => const ExperienceScreen(),
    ),
    GoRoute(
      path: '/social-links',
      builder: (context, state) => const SocialLinksScreen(),
    ),
  ],
);

class PortfolioDashboardApp extends StatelessWidget {
  final StorageService storageService;

  const PortfolioDashboardApp({
    super.key,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PortfolioProvider(storageService),
      child: MaterialApp.router(
        title: 'Portfolio Dashboard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
        builder: (context, child) {
          return Consumer<PortfolioProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const DashboardLoadingScreen();
              }
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
