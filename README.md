# Cinamate - Flutter App

A complete Flutter application using the **MVVM architecture with Provider** to consume the **TMDB REST API** and **Firebase Services**. The app includes secure authentication, real-time data persistence, and a premium media tracking experience.

## 🏗️ Architecture

- **MVVM Pattern**: Models, Views, ViewModels (Providers)
- **Provider**: State management (ChangeNotifier and Provider)
- **Repository Pattern**: Abstraction layer for TMDB API and Firebase Firestore
- **ChangeNotifierProvider**: Dependency injection and state propagation

## 📁 Project Structure
```text
lib/
├── main.dart                       # Entry point with MultiProvider
├── core/
│   ├── theme/
│   │   └── app_theme.dart          # Custom Dark/Orange Cinamate theme
│   ├── constants/
│   │   └── api_constants.dart      # TMDB API URLs and keys
│   └── widgets/                    # Reusable UI components (PosterCard, etc.)
├── data/
│   └── models/
│       └── content_item.dart       # Core data model with JSON serialization
├── features/
│   ├── auth/
│   │   └── screens/                # Login, Register, Forgot Password
│   ├── home/
│   │   └── screens/                # Trending, Top Rated discovery
│   ├── details/
│   │   └── screens/                # Cast, Summary, and Status Toggles
│   ├── search/
│   │   └── screens/                # Dynamic filtering and search
│   ├── profile/
│   │   └── screens/                # User stats and settings
│   └── library/
│       └── screens/                # Real-time Watchlist & Favorites
├── providers/
│   └── auth_provider.dart          # Global authentication state
├── repositories/
│   └── content_repository.dart     # Data orchestration layer
└── services/
    ├── tmdb_service.dart           # REST client for TMDB
    └── firestore_service.dart      # Firebase database operations
```

## 🚀 Setup
### Prerequisites

- Flutter SDK (>= 3.9.2)
- Dart SDK
- A Firebase project configured for Android
- A TMDB API Key

### Installation

1. Clone the repository:
   ```bash
   git clone <your-repository-url>
   cd cinamate
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Add your `google-services.json` to `android/app/`.

4. Run the application:
   ```bash
   flutter run
   ```

## 🔧 API Configuration

The app consumes data from TMDB. Since the real configuration file is secured, you must create it from the template:

1. Rename `lib/core/constants/api_constants.dart.example` to `lib/core/constants/api_constants.dart`.
2. Add your [TMDB API Key](https://www.themoviedb.org/documentation/api) to the file:

```dart
class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String apiKey = 'your-tmdb-api-key-here';
}
```

## 📱 Features
### Authentication

- ✅ Email and password authentication
- ✅ Google Sign-In integration
- ✅ Secure session persistence
- ✅ Password reset functionality
- ✅ Form validation and error handling

### Movie & TV Discovery

- ✅ Horizontal grids with poster images
- ✅ Dynamic "See All" categorized views
- ✅ Real-time search with filtering (All, Movies, TV)
- ✅ Infinite-scroll feel via TMDB integration
- ✅ Pull-to-refresh home feed
- ✅ Smooth Hero animations for transitions

### Personal Library

- ✅ Custom Watchlist tracking
- ✅ Favorites management
- ✅ "Watched" history logging
- ✅ Instant sync across devices using Firestore Streams
- ✅ Clean tab-based navigation

## 🎨 Cinamate Theme

The app follows a premium dark-aesthetic design system:

- **Primary Colors**: Vibrant Orange set against a Deep Dark background with Contrasting Card elements.
- **Visual Effects**: Smooth transitions and modern UI effects.
- **Typography**: Simple and easy-to-read fonts.

## 🔑 Provider Pattern

The app uses **ChangeNotifier** for state management. Example:

```dart
// Access Provider for actions (listen: false)
final authProvider = Provider.of<AuthProvider>(context, listen: false);
authProvider.loginWithEmail(email, password);

// Or using modern extension methods:
context.read<AuthProvider>().logout();

// Access and listen to state changes:
final user = context.watch<AuthProvider>().user;
if (user != null) {
  return HomeScreen();
}
```

## 📦 Main Dependencies
```yaml
dependencies:
  firebase_core: ^3.8.0           # Firebase initialization
  firebase_auth: ^5.3.3           # Authentication service
  cloud_firestore: ^5.0.0         # NoSQL database
  provider: ^6.1.1                # State management
  http: ^1.2.0                    # REST API client
  google_sign_in: ^6.1.6          # Social auth
  shared_preferences: ^2.2.2      # Local simple storage
  cupertino_icons: ^1.0.8         # Icon set
```

## 🔒 Security

- Firebase Auth for secure user isolation
- Firestore Security Rules for data privacy
- **API Key Protection**: Sensitive keys hidden via `.gitignore`
- Clean Client-side validation for all inputs

## 📄 License

This project is an educational model.

## 👥 Authors

- **Ibraheem Awad** ([IB3W](https://github.com/IB3W))
- **Ahmad Sawafta** ([ahmadsawafta2](https://github.com/ahmadsawafta2))
- **Fares Khader** ([fareskhader](https://github.com/fareskhader))

Developed with focus on MVVM + Provider architecture and clean code standards.
