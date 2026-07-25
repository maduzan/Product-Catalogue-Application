# Product Catalogue Application

A Flutter mobile application that displays a product catalogue with product listing, detail views, favourite management, and user authentication.

---

## Project Overview

The **Product Catalogue Application** is a Flutter app designed to browse a catalogue of products. Users can:

- **Sign in  using an authentication flow.
- **Browse products** in a responsive grid layout with search/filter functionality.
- **View product details** with a larger image, name, price, category, and full description.
- **Toggle favourites** on any product from both the product list and detail screens — favourite status is **persisted locally using Hive** so it survives app restarts.
- **Dark / Light theme** toggle available from the home screen.

API calls are simulated using dummy in-memory data with artificial delays to replicate real network behaviour.

---

## Setup Instructions

### Prerequisites

- Flutter SDK **≥ 3.2.6** installed ([flutter.dev](https://flutter.dev))
- Dart SDK (bundled with Flutter)
- An Android or iOS device / emulator

### Install Dependencies

```bash
flutter pub get
```

### Run the Project

The app supports multiple environments. Use the appropriate entry point:

```bash
# Development
flutter run -t lib/main_development.dart

# Staging
flutter run -t lib/main_staging.dart

# Production
flutter run -t lib/main_production.dart
```

### Build an APK

```bash
# Debug APK
flutter build apk --debug -t lib/main_production.dart

# Release APK
flutter build apk --release -t lib/main_production.dart
```

The output APK will be located at:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Architecture

### Folder Structure

```
lib/
├── app/                        # App-level setup
│   ├── controller/             # App router, theme service, app states
│   ├── model/                  # App-level models
│   ├── view/                   # Root app widget (MaterialApp.router)
│   └── widgets/                # Shared app widgets
│
├── auth/                       # Authentication feature
│   ├── controller/             # AuthService, auth state, repository
│   ├── model/                  # Auth data models
│   └── view/                   # Sign in 
│
├── products/                   # Product Catalogue feature
│   ├── controller/
│   │   ├── product_controller.dart   # ChangeNotifier controller
│   │   ├── repository.dart           # Dummy API calls + Hive persistence
│   │   └── states.dart               # ProductState & ProductDetailState
│   ├── model/
│   │   └── product_model.dart        # ProductModel data class
│   ├── view/
│   │   ├── product_list_home.dart     # Product grid list screen
│   │   └── product_detail_screen.dart # Product detail screen (StatefulWidget)
│   └── widgets/
│       ├── product_card.dart                # Grid card widget
│       ├── product_detail_image.dart        # Hero image widget
│       ├── product_detail_header.dart       # Name, category, price widget
│       ├── product_detail_description.dart  # Description section widget
│       └── product_detail_favourite_button.dart # FAB favourite toggle
│
├── utils/                      # Shared utilities
│   ├── network/                # API client (Dio), response models
│   ├── settings.dart           # App environment settings
│   ├── common_search_bar.dart  # Reusable search bar widget
│   └── ...                     # Other shared widgets & helpers
│
├── boostrap.dart               # App bootstrap (Hive init, GetIt setup)
└── main_*.dart                 # Environment entry points
```

### State Management Approach

The application uses **Provider** (`ChangeNotifier`) for state management:

- **`ProductController`** manages two independent state trees:
  - `ProductState` — controls the product list screen (`ProductInitial`, `ProductLoading`, `ProductSuccess`, `ProductFailed`).
  - `ProductDetailState` — controls the detail screen independently (`ProductDetailInitial`, `ProductDetailLoading`, `ProductDetailSuccess`, `ProductDetailFailed`).
- **`ThemeServiceProvider`** manages the dark/light theme toggle.
- **`AuthService`** manages session/authentication state.
- All singletons are registered and resolved using **GetIt** (service locator).

### API Integration Approach

All API calls are **dummy/simulated** in `ProductsRepository`, which extends a shared `ApiClient` (Dio-based):

- `getProducts()` — simulates `GET /products` with a 1-second delay, returns a list of mock `ProductModel` objects.
- `getProductDetails(productId)` — simulates `GET /products/:id` with a 600ms delay.
- `toggleFavouriteApi(productId, currentState)` — simulates `POST /products/favourite` with a 300ms delay.

**Hive local storage** is used to persist the favourite state of each product by ID across sessions. On `getProducts()`, each product's `isFavourite` is overlaid with its Hive-persisted value so it survives app restarts.

---

## Assumptions

- All product data (name, price, category, image, description) is served from a **simulated in-memory API** rather than a live backend, as the assessment does not specify an external API endpoint.
- **Hive** is used as the local persistence layer for favourite status since it is already part of the project's dependency stack.
- The `isFavourite` flag in the dummy API response is treated as the **default/initial** value for new installations; any user-toggled value stored in Hive takes priority.
- Multiple environments (development, staging, production) are supported via separate entry points, but all environments point to the same dummy data source.

---

## Challenges

### 1. Synchronised Favourite State Across Screens
Ensuring the favourite icon updates correctly and simultaneously on both the **product list screen** (grid card) and the **product detail screen** (floating action button) required careful orchestration. This was solved by updating both `ProductState` and `ProductDetailState` optimistically within `toggleFavourite`, followed by an async Hive write, with a rollback mechanism on failure.

### 2. Dedicated State for the Detail Screen
The initial implementation reused the product list state for the detail screen, which caused the detail screen to lose context when navigating back and forward. Introducing a dedicated `ProductDetailState` with its own loading/error/success states and calling `fetchProductDetails` in `initState` resolved this cleanly.

### 3. Persistent Favourites Across App Restarts
Without a real backend, favourite state would be lost on restart. Integrating **Hive** to store a `bool` per product ID and merging it at the repository layer (in `getProducts`) ensured persistence without changing the controller or view layers.

---

## Improvements

- **Real API Integration** — Replace dummy repository methods with actual HTTP endpoints using Dio interceptors, authentication headers, and proper error models.
- **Pagination** — Add infinite scroll pagination to the product list for larger catalogues using `infinite_scroll_pagination`.
- **Product Categories Filter** — Add a horizontal category chip filter bar above the product grid to allow quick filtering by category.
- **Favourites Screen** — Add a dedicated tab/screen listing only favourited products.
- **Product Search Debounce** — Add debounce to the search bar to reduce unnecessary filter operations on rapid typing.
- **Image Caching** — Integrate `cached_network_image` to cache product images locally and reduce repeated network loads.
- **Unit & Widget Tests** — Add tests for `ProductController`, `ProductsRepository`, and key widgets using `mocktail` (already in dev dependencies).
- **Localisation** — Add multi-language support using Flutter's built-in `flutter_localizations`.
- **Accessibility** — Add semantic labels to icon buttons and images for better screen reader support.
