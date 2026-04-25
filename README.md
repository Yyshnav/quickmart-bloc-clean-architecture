# QuickMart MVP

QuickMart is a Flutter MVP for a quick-commerce app (similar to Instamart). It focuses on clean architecture, responsive UI, and smooth user experience.

## 🚀 Setup

1. Ensure Flutter 3.10+ is installed  
2. Run:
   flutter pub get  
3. Start app:
   flutter run  

---

## 🏗️ Architecture

The project follows a **Feature-First Clean Architecture**:

- **core** → common utilities, theme, network handling  
- **di** → dependency injection (get_it)  
- **features** → divided into auth, cart, dashboard  

Each feature includes:
- Data (API & local storage)
- Domain (business logic)
- Presentation (UI with flutter_bloc)

---

## ⚙️ State Management

- Uses **flutter_bloc**
- `CartBloc` → manages cart globally  
- `DashboardBloc` → handles product UI & loading  
- `AuthBloc` → manages login logic  

---

## 🎨 UI Features

- Scroll-hide header with pinned search bar  
- Responsive layout  
- Category-based UI with dynamic colors  
- Add-to-cart button with quantity controls  
- Floating cart summary banner  

---

## ⚠️ Challenges & Solutions

- **Scroll-hide header behavior** was tricky due to sliver coordination.  
  → Solved by properly using `SliverAppBar` (non-pinned) and `SliverPersistentHeader` (pinned) with consistent styling.

- **State management across features** was complex.  
  → Handled using `flutter_bloc` with clear separation and a globally accessible `CartBloc`.

- **Responsive UI issues** on different screens.  
  → Fixed using flexible layouts, proper spacing, and testing on multiple screen sizes.