# QuickMart MVP

QuickMart is a single-session MVP built for a Flutter Engineer Technical Assessment. It mimics a quick-commerce application (like Swiggy Instamart) with vibrant UI, clean architecture, and robust state management.

## Setup Instructions

1.  **Flutter Version**: Ensure you are using Flutter 3.10+ (Dart 3.0+).
2.  **Dependencies**: Run `flutter pub get` to install all packages.
3.  **Run**: Execute `flutter run` on an emulator or physical device.

## Architectural Choices

This project strictly adheres to **Feature-First Clean Architecture**.

*   **lib/core**: Contains shared elements like custom network client (Dio wrapper), error/failure definitions, and global app themes.
*   **lib/di**: Setup for dependency injection using `get_it`.
*   **lib/features**: Features are separated into `auth`, `cart`, and `dashboard`.
    *   **Data Layer**: Handles external APIs (`FakeStore`) via `Dio` and local storage via `SharedPreferences`. Models extend Entities.
    *   **Domain Layer**: Contains pure business logic. Entities, abstract Repositories, and UseCases are defined here.
    *   **Presentation Layer**: Utilizes `flutter_bloc` for state management and houses the UI widgets/pages.

### State Management
*   **flutter_bloc** is used across the app. 
*   `CartBloc` is instantiated globally in `main.dart` to ensure cart state is accessible anywhere without context tunneling.
*   `DashboardBloc` manages the UI state of the products grid, loading shimmers, and error handling.
*   `AuthBloc` handles mock authentication and validates locally.

### UI/UX
*   The Dashboard features a `SliverAppBar` that changes color based on the selected category to mimic the dynamic Instamart experience.
*   Products utilize a customized "ADD" button that gracefully switches to a `[-] 1 [+]` selector linked directly to the `CartBloc`.
*   A `FloatingCartBanner` listens to `CartBloc` to display global cart metrics.

## Future Improvements (Time Constraints)
*   **Git History**: Due to environmental constraints (git was not found in path), no local git commits could be made during this automated run. In a real scenario, atomic commits would be prefixed with `feat:`, `fix:`, `chore:`, etc.
*   **Persistent Cart**: Currently, the cart is in-memory for the single session MVP. Implementing `CartLocalDataSource` with SQLite or SharedPreferences would make it persistent.
*   **Unit Tests**: UseCases and BLoCs are structured to be highly testable, but tests were omitted due to the 8-10 hour scope constraint and focus on MVP delivery.
