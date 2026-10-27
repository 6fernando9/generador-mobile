# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**KrakenDraw Mobile** - Flutter mobile application for the KrakenDraw client dashboard. Consumes the **Backend-Draw** API (Express 5 + TypeScript + Prisma 6 + PostgreSQL) running on `http://localhost:4000/api`.

### Key Features Implemented
- **Splash Screen**: Animated "KrakenDraw" title with neon background and particle effects
- **Authentication**: Login/Register with form validation, JWT cookie persistence via Dio + CookieJar
- **Dashboard**: Three-tab layout (Resumen/Overview, Historial/Downloads, Membresías/Payments) with metrics cards, quick actions
- **Profile Management**: View profile, edit profile, change password, avatar support, logout
- **Skeleton Loaders**: Comprehensive shimmer-based loading states for all async screens
- **Dark/Light Mode**: Full Material 3 theming with neon aesthetic adapting to both themes
- **Service Layer**: Clean separation with AuthService, UsuarioService, DashboardService, PagosService, LogsService

---

## Commands

### Development
```bash
# Run on Chrome (web)
flutter run -d chrome

# Run on Linux desktop
flutter run -d linux

# Run on Android (requires device/emulator)
flutter run -d android

# Hot reload: press 'r' in terminal, hot restart: 'R'
```

### Build
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Web build
flutter build web --release

# Linux desktop
flutter build linux --release
```

### Code Quality
```bash
# Analyze (static analysis)
flutter analyze

# Format code
dart format --set-exit-if-changed .

# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate code (Freezed, Riverpod, JSON Serializable)
dart run build_runner build --delete-conflicting-outputs

# Watch for changes during development
dart run build_runner watch --delete-conflicting-outputs
```

### Dependencies
```bash
# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Check outdated
flutter pub outdated
```

---

## Architecture

### Project Structure
```
lib/
├── main.dart                          # App entry, GoRouter, Riverpod ProviderScope, Theme
├── core/
│   ├── constants/
│   │   └── api_endpoints.dart         # Centralized API endpoint paths
│   ├── network/
│   │   ├── api_client.dart            # Dio singleton with CookieJar, interceptors
│   │   ├── api_endpoints.dart         # API endpoint constants
│   │   └── services/                  # Service classes (5 services)
│   │       ├── auth_service.dart      # login, register, logout, me
│   │       ├── usuario_service.dart   # profile CRUD, avatar upload
│   │       ├── dashboard_service.dart # resumen, membresias, tendencia, etc.
│   │       ├── pagos_service.dart     # mi-suscripcion, historial, checkout
│   │       └── logs_service.dart      # download history, regenerar
│   ├── storage/
│   │   └── secure_storage.dart        # flutter_secure_storage wrapper
│   ├── theme/
│   │   ├── app_theme.dart             # Material 3 ThemeData (light/dark)
│   │   └── neon_colors.dart           # Neon color palette constants
│   └── utils/                         # Date formatting, validators, helpers
├── presentation/
│   ├── splash/
│   │   └── splash_page.dart           # Opening screen with animated neon title
│   ├── auth/
│   │   ├── login/login_page.dart      # Email/username + password form
│   │   ├── register/register_page.dart # Username, email, password, confirm
│   │   └── auth_wrapper.dart          # Route guard + AuthController (Riverpod)
│   ├── dashboard/
│   │   ├── dashboard_page.dart        # Main shell with TabBar + BottomNav
│   │   ├── widgets/
│   │   │   ├── metrics_cards.dart     # NeonMetricCard, NeonStatCard
│   │   │   ├── download_history_list.dart # Paginated logs list
│   │   │   └── membership_history_list.dart # Payment history
│   │   └── skeleton/
│   │       ├── metrics_skeleton.dart
│   │       ├── history_list_skeleton.dart
│   │       └── membership_skeleton.dart
│   ├── profile/
│   │   ├── profile_page.dart          # Avatar, stats, sections, actions
│   │   ├── edit_profile_page.dart     # Form with avatar picker
│   │   ├── change_password_page.dart  # Current/new/confirm password
│   │   └── skeleton/
│   │       └── profile_skeleton.dart
│   └── shared/
│       ├── widgets/
│       │   ├── neon_background.dart   # Animated gradient, orbs, particles, grid
│       │   ├── neon_button.dart       # NeonButton, NeonIconButton, NeonFloatingActionButton
│       │   ├── neon_input.dart        # NeonInput, NeonPasswordInput with focus glow
│       │   ├── neon_card.dart         # GlowCard, NeonMetricCard, NeonBadge, NeonAvatar
│       │   └── skeleton_base.dart     # SkeletonBase, SkeletonBox, SkeletonText, etc.
│       └── theme/
│           └── theme_switcher.dart    # ThemeModeNotifier, ThemeToggleButton, ThemeSelectorSheet
```

### State Management: Riverpod
- **StateNotifierProvider**: Complex state (AuthController, form controllers)
- **FutureProvider**: Simple async data (profileProvider, dashboard data)
- **Provider**: Dependencies (ApiClient, SecureStorage, services)

### Navigation: GoRouter
- **Splash** (`/splash`) → **AuthWrapper** checks session
- **Auth routes** (`/auth/login`, `/auth/register`) - nested under `/auth`
- **Protected routes** (`/dashboard`, `/profile/*`) - ShellRoute with bottom NavigationBar
- **Deep links** supported via `context.go()`, `context.push()`

### Network Layer
```
ApiClient (Dio singleton)
  ├── CookieJar (PersistCookieJar) - JWT cookie persistence
  ├── _AuthInterceptor - 401 handling, session sync
  ├── _ErrorInterceptor - Normalizes {message, statusCode, fecha}
  └── LogInterceptor (debug only)

Services (5 classes)
  ├── AuthService      → /api/auth/*
  ├── UsuarioService   → /api/perfil/*
  ├── DashboardService → /api/dashboard/*
  ├── PagosService     → /api/pagos/*
  └── LogsService      → /api/logs/*
```

### Theme System
- **NeonColors**: Static constants for cyan, magenta, purple, green, orange, blue, pink, yellow (dark/light variants)
- **NeonColorScheme**: Complete color schemes for dark/light with glow colors
- **AppTheme**: Material 3 ThemeData with custom NeonThemeExtension
- **ThemeSwitcher**: Runtime theme toggle (light/dark/system) with SharedPreferences persistence

---

## Backend API Contract

### Base URL
`http://localhost:4000/api` (configurable via `--dart-define=API_BASE_URL`)

### Authentication Endpoints
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/register/` | Register (username, email, password) |
| POST | `/auth/login/` | Login → returns `{ usuario, token }` + sets `jwt` cookie |
| POST | `/auth/logout/` | Clears JWT cookie |
| GET | `/auth/me/` | Current user `{ usuario, token }` |

### Profile Endpoints (`/api/perfil/`) - Auth required
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Get authenticated user profile |
| PUT | `/` | Update username, email, profile_icon |
| PUT | `/password` | Change password (current + new) |
| POST | `/icono` | Upload avatar (multipart/form-data) |
| DELETE | `/icono` | Remove avatar |

### Dashboard Endpoints (`/api/dashboard/`) - Auth + `dashboard.ver` permission
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/resumen` | KPIs: generations today/week/month/total with comparisons |
| GET | `/membresias` | Payment gateways & plans used, revenue |
| GET | `/tendencia` | Time series of generations by artifact type |
| GET | `/actividad` | Heatmap of activity by day/hour |
| GET | `/tecnologias` | Distribution by language, framework, etc. |
| GET | `/proyectos-usuarios` | Top projects & users |
| GET | `/contactos` | Contact metrics |

### Payments Endpoints (`/api/pagos/`) - Auth required
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/mi-suscripcion` | Current user subscription |
| GET | `/historial` | User's payment history (paginated) |
| POST | `/checkout` | Create Stripe checkout session |
| POST | `/sincronizar-pendientes` | Sync pending payments |

### Generation Logs (`/api/logs/`) - Auth required
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Paginated history of generations (download history) |
| GET | `/:id` | Get generation detail with diagram snapshot |
| POST | `/:id/regenerar` | Regenerate & download ZIP artifact |

---

## Key Implementation Details

### Cookie Handling
- Backend uses `httpOnly`, `secure`, `sameSite: "none"` cookies on `localhost`
- `dio_cookie_manager` with `PersistCookieJar` handles automatically
- Cookies ignore port → works for both `:3000` (web) and `:4000` (API)

### Timezone
- Backend forces `America/La_Paz` timezone
- Pass `tz` query param to dashboard endpoints for correct date grouping

### File Uploads
- Avatar upload to `/api/perfil/icono` (multipart/form-data)
- Backend uses Floci (S3 local) at `:4566`, bucket `sistema-storage`

### Animation Patterns
- Uses `flutter_animate` with explicit `Animate` widget + effects (not `.animate()` extension)
- Effects: `FadeEffect`, `SlideEffect`, `ScaleEffect`, `ShakeEffect`
- `NeonBackground` uses `AnimationController` for gradient, orbs, particles

### Skeleton Loaders
- `SkeletonBase` wraps any widget with `Shimmer.fromColors`
- Specialized skeletons: `MetricsCardSkeleton`, `HistoryListSkeleton`, `MembershipCardSkeleton`, `ProfileSkeleton`, `AuthFormSkeleton`
- `DirectionalShimmer` for custom directions, `PulseLoader` for opacity animation

---

## Pending Tasks / TODOs

### Immediate (Connect to Real Backend)
1. **Implement API calls in service classes** - Currently mocked with `Future.delayed` and TODO comments
2. **Create Freezed models** for all DTOs matching backend schemas
3. **Run code generation**: `dart run build_runner build --delete-conflicting-outputs`
4. **Connect AuthController** to real `AuthService.login/register/me/logout`
5. **Connect DashboardPage** to `DashboardService.getAll()` or individual endpoints
6. **Connect ProfilePage** to `UsuarioService.getProfile()` and update methods
7. **Connect Membership tab** to `PagosService.getMiSuscripcion()` and `getHistorial()`
8. **Connect History tab** to `LogsService.getLogs()` with pagination

### Code Quality
- [ ] `flutter analyze` → verify 0 errors
- [ ] `flutter test` → add unit/widget tests
- [ ] `dart format --set-exit-if-changed .` → clean formatting

### Future Phases
- Local AI assistant integration (offline LLM)
- Push notifications for generation completion
- Offline-first with local SQLite (drift) + sync
- Biometric authentication
- Tablet/desktop adaptive layouts

---

## Important Files Reference

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry, routing, theme, providers |
| `lib/core/network/api_client.dart` | Dio + CookieJar + interceptors |
| `lib/core/network/api_endpoints.dart` | All API endpoint paths |
| `lib/core/network/services/*.dart` | 5 service classes for API calls |
| `lib/core/theme/app_theme.dart` | Light/dark Material 3 themes |
| `lib/core/theme/neon_colors.dart` | Neon color palette |
| `lib/core/storage/secure_storage.dart` | Secure token/user storage |
| `lib/presentation/splash/splash_page.dart` | Animated opening screen |
| `lib/presentation/auth/auth_wrapper.dart` | Auth state + route guard |
| `lib/presentation/dashboard/dashboard_page.dart` | Main dashboard with 3 tabs |
| `lib/presentation/profile/profile_page.dart` | Profile view + actions |
| `lib/presentation/shared/widgets/neon_background.dart` | Reusable animated background |
| `lib/presentation/shared/widgets/skeleton_base.dart` | All skeleton components |
| `lib/presentation/shared/theme/theme_switcher.dart` | Runtime theme switching |

---

## Verification Checklist

### Manual Testing (with backend running)
- [ ] Backend running on `localhost:4000` (`docker compose up -d` in Backend-Draw + `npm run dev`)
- [ ] Splash shows "KrakenDraw" with animated neon background, auto-navigates after 2-3s
- [ ] Dark/light mode toggle works, neon colors adapt to both themes
- [ ] Skeleton loaders show on dashboard/profile while data loads
- [ ] Login with existing user → JWT cookie stored → Dashboard loads
- [ ] Register new user → Auto-login → Dashboard
- [ ] Dashboard tabs load data: metrics, downloads, memberships
- [ ] Profile page shows user data, avatar loads from Floci
- [ ] Edit profile → changes persist → reflected on backend
- [ ] Change password → works with current password validation
- [ ] Logout → clears cookie/storage → redirects to login
- [ ] Session persists across app restarts

### Automated Checks
- [ ] `flutter analyze` → no errors
- [ ] `flutter test` → all pass
- [ ] `dart format --set-exit-if-changed .` → clean
- [ ] `flutter build apk --release` → successful

---

## Notes for Future Development

1. **Service Classes**: All 5 service classes (`auth_service.dart`, `usuario_service.dart`, `dashboard_service.dart`, `pagos_service.dart`, `logs_service.dart`) currently return mocked data. Replace `Future.delayed` + TODO comments with actual Dio calls.

2. **Freezed Models**: Create models in `lib/data/models/` for: `Usuario`, `AuthResponse`, `LoginRequest`, `RegisterRequest`, `Perfil`, `UpdateProfileRequest`, `ChangePasswordRequest`, `DashboardResumen`, `DashboardMembresias`, `LogGeneracion`, `PagoHistorial`, `SuscripcionActual`, and paginated response wrappers.

3. **Error Handling**: The `_ErrorInterceptor` normalizes backend errors to `{message, statusCode, fecha}`. Use this pattern consistently.

4. **Permissions**: Dashboard requires `dashboard.ver` permission. Ensure test user has this role/permission seeded in backend.

5. **Theme Persistence**: `ThemeModeNotifier` saves to `SharedPreferences` with key `app_theme_mode`.

6. **Linux Build**: Added `-Wno-deprecated-literal-operator` to `linux/CMakeLists.txt` to suppress nlohmann/json warning from `flutter_secure_storage_linux` plugin.