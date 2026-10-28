// KrakenDraw Flutter Mobile App - Main Entry Point
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'core/network/api_client.dart';
import 'core/storage/secure_storage.dart';
import 'presentation/splash/splash_page.dart';
import 'presentation/auth/login/login_page.dart';
import 'presentation/auth/register/register_page.dart';
import 'presentation/auth/auth_wrapper.dart';
import 'presentation/dashboard/dashboard_page.dart'
    show DashboardPage;
import 'presentation/profile/profile_page.dart';
import 'presentation/profile/edit_profile_page.dart';
import 'presentation/profile/change_password_page.dart';
import 'presentation/shared/theme/theme_switcher.dart';

/// Global navigator key for navigation without context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// App router configuration
final GoRouter _router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/splash',
  debugLogDiagnostics: true,
  routes: [
    // Splash screen
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),

    // Auth routes (login, register)
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AuthWrapper(),
      routes: [
        GoRoute(
          path: 'login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: 'register',
          name: 'register',
          builder: (context, state) => const RegisterPage(),
        ),
      ],
    ),

    // Protected routes (require authentication)
    ShellRoute(
      navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'shell'),
      builder: (context, state, child) => _AppShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfilePage(),
          routes: [
            GoRoute(
              path: 'edit',
              name: 'edit-profile',
              builder: (context, state) => const EditProfilePage(),
            ),
            GoRoute(
              path: 'change-password',
              name: 'change-password',
              builder: (context, state) => const ChangePasswordPage(),
            ),
          ],
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    // Auth redirect handled by AuthController via navigatorKey
    return null;
  },
);

/// Main app widget
class KrakenDrawApp extends ConsumerWidget {
  const KrakenDrawApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'KrakenDraw',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: _router,
      builder: (context, child) {
        // Apply Google Fonts globally
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.85, 1.15),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

/// App shell with bottom navigation
class _AppShell extends ConsumerStatefulWidget {
  final Widget child;

  const _AppShell({required this.child});

  @override
  ConsumerState<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<_AppShell> {
  int _currentIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.dashboard_rounded,
      activeIcon: Icons.dashboard_rounded,
      label: 'Dashboard',
      route: '/dashboard',
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Perfil',
      route: '/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    _currentIndex = _navItems.indexWhere((item) => location.startsWith(item.route));
    if (_currentIndex == -1) _currentIndex = 0;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index != _currentIndex) {
            context.go(_navItems[index].route);
          }
        },
        destinations: _navItems.map((item) {
          return NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.activeIcon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// App initialization provider
final appInitializationProvider = FutureProvider<void>((ref) async {
  // Initialize secure storage
  await SecureStorage.init();

  // Initialize API client
  await ApiClient.init();

  // Load any cached data
  // await ref.read(authControllerProvider.notifier).initialize();
});

/// Main entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SecureStorage
  await SecureStorage.init();

  // Initialize API client
  await ApiClient.init();

  // Initialize Google Fonts
  await GoogleFonts.pendingFonts([
    GoogleFonts.orbitron(),
    GoogleFonts.spaceGrotesk(),
    GoogleFonts.inter(),
  ]);

  // Run app with ProviderScope
  runApp(
    ProviderScope(
      child: const KrakenDrawApp(),
    ),
  );
}