# Glass Flask — Project Report

**Course / Program:** CodeAlpha Flutter Internship  
**Project Title:** Glass Flask — Glassmorphic Flashcard Quiz App  
**Developer:** Loszole  
**Repository:** https://github.com/Loszole/Glass-Flask-Flash-Card-  
**Version:** 1.0.0  
**Date:** April 2026  

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Objectives](#2-objectives)
3. [System Requirements](#3-system-requirements)
4. [Architecture & Design](#4-architecture--design)
5. [Feature Implementation](#5-feature-implementation)
6. [UI/UX Design System](#6-uiux-design-system)
7. [Data Management](#7-data-management)
8. [Testing & Validation](#8-testing--validation)
9. [Challenges & Solutions](#9-challenges--solutions)
10. [Conclusion](#10-conclusion)
11. [Internship Submission Checklist](#11-internship-submission-checklist)
12. [Deliverables](#12-deliverables)

---

## 1. Introduction

Glass Flask is a cross-platform mobile application developed using the Flutter framework. The app is designed as an interactive flashcard study tool that allows users to create, manage, and quiz themselves on question-and-answer pairs. Beyond its functional purpose, the project was intentionally designed using the **"Glassmorphic Focus"** visual language — a tech-forward UI theme characterised by frosted glass panels, ambient gradient backdrops, smooth 3D animations, and bold geometric typography.

The project was completed as part of the CodeAlpha Flutter internship programme and demonstrates practical proficiency in Flutter state management, custom widget development, local persistence, animation engineering, and responsive theming.

---

## 2. Objectives

| # | Objective | Status |
|---|-----------|--------|
| 1 | Build a fully functional flashcard quiz app | ✅ Complete |
| 2 | Implement create, read, update, delete (CRUD) for flashcards | ✅ Complete |
| 3 | Persist data locally across app restarts | ✅ Complete |
| 4 | Apply the Glassmorphic Focus design theme | ✅ Complete |
| 5 | Implement a 3D card-flip animation for revealing answers | ✅ Complete |
| 6 | Replace standard linear progress bar with a donut ring chart | ✅ Complete |
| 7 | Support both dark and light themes with persistent toggle | ✅ Complete |
| 8 | Deploy to Android emulator and publish source to GitHub | ✅ Complete |

---

## 3. System Requirements

### Development Environment

| Tool | Version |
|------|---------|
| Flutter SDK | 3.41.4 (stable) |
| Dart SDK | ^3.11.1 |
| Android SDK | 36.1.0 (API 36) |
| Target emulator | Pixel 6 — Android 16 (API 36) x86_64 |
| IDE | Visual Studio Code |
| OS | Windows 11 |

### Runtime Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.2 | Reactive state management |
| `shared_preferences` | ^2.3.2 | Local key-value persistence |
| `uuid` | ^4.5.1 | Unique ID generation for cards |
| `google_fonts` | ^8.0.2 | Poppins font family |
| `cupertino_icons` | ^1.0.8 | Icon set |

### Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_launcher_icons` | ^0.14.4 | Multi-platform icon generation |
| `flutter_lints` | ^6.0.0 | Static analysis rules |

---

## 4. Architecture & Design

### 4.1 Architectural Pattern

The application follows the **Provider pattern** (a recommended Flutter architecture for small-to-medium apps), separating concerns into three layers:

```
┌──────────────────────────────────┐
│         Presentation Layer        │
│   Screens + Widgets (Flutter UI)  │
└────────────────┬─────────────────┘
                 │  context.watch / context.read
┌────────────────▼─────────────────┐
│         State Layer               │
│   FlashcardProvider               │
│   ThemeProvider                   │
│   (ChangeNotifier via Provider)   │
└────────────────┬─────────────────┘
                 │  async read/write
┌────────────────▼─────────────────┐
│         Data Layer                │
│   SharedPreferences (JSON)        │
└──────────────────────────────────┘
```

### 4.2 File Structure

```
lib/
├── main.dart
├── models/
│   └── flashcard.dart
├── providers/
│   ├── flashcard_provider.dart
│   └── theme_provider.dart
├── screens/
│   ├── splash_screen.dart
│   ├── quiz_screen.dart
│   ├── manage_screen.dart
│   └── add_edit_screen.dart
├── theme/
│   └── app_theme.dart
└── widgets/
    ├── app_backdrop.dart
    ├── glass_panel.dart
    ├── flashcard_widget.dart
    └── progress_ring.dart
```

### 4.3 State Management

Two `ChangeNotifier` classes are registered at the root via `MultiProvider`:

- **`FlashcardProvider`** — Manages the list of flashcards, the currently active card index, and whether the answer is visible. All navigation methods (`nextCard`, `previousCard`) and CRUD operations (`addCard`, `editCard`, `deleteCard`) call `notifyListeners()` after mutation and then asynchronously persist state to `SharedPreferences`.

- **`ThemeProvider`** — Holds a `ThemeMode` enum value (`light`, `dark`, or `system`). The `toggleTheme()` method flips between light and dark, notifies listeners, and writes the new value to `SharedPreferences` so it is restored on next launch.

---

## 5. Feature Implementation

### 5.1 Flashcard Model

Each card is a simple immutable Dart class with three fields: `id` (UUID v4), `question`, and `answer`. It implements `toJson` / `fromJson` for serialization and a `copyWith` factory for immutable updates.

### 5.2 CRUD Operations

The Manage screen (`manage_screen.dart`) renders the full card list as a `ListView`. Each tile exposes Edit and Delete icon buttons. Deleting triggers a confirmation `AlertDialog` before the card is removed. The Add / Edit screen (`add_edit_screen.dart`) is a validated `Form` with two `TextFormField` inputs.

### 5.3 Quiz Flow

The quiz screen (`quiz_screen.dart`) displays one card at a time. The user taps **Show Answer** to trigger `toggleAnswer()` on the provider, which changes state and causes `FlashcardWidget` to animate from the question face to the answer face. Previous / Next buttons navigate the deck; the answer-visible flag is reset on every card change.

### 5.4 3D Flip Card Animation

`FlashcardWidget` is a `StatefulWidget` with a single `AnimationController` (duration: 650 ms, curve: `easeInOutCubicEmphasized`). On `didUpdateWidget`, the controller either forwards or reverses based on `isAnswerVisible`. The `AnimatedBuilder` reads the animation value as an angle in radians and applies it via `Transform` with a perspective entry (`Matrix4.setEntry(3,2,0.0011)`). When the angle exceeds π/2, the widget switches to rendering the back face (counter-rotating by π to keep text readable).

### 5.5 Donut Progress Ring

`ProgressRing` is a `CustomPainter` widget. It draws three `Arc` passes on a `Canvas`:
1. A muted track ring (full 360°)
2. A blurred glow arc (soft bloom effect using `MaskFilter.blur`)
3. A gradient-filled progress arc using a `SweepGradient` shader

The percentage label is rendered as a `Column` of `Text` widgets centered via `Stack` over the painter.

### 5.6 Glassmorphic UI

`GlassPanel` wraps any child in a `BackdropFilter` (blur σ = 22) with a `DecoratedBox` that applies a semi-transparent white fill, a subtle white border, and a deep shadow. In dark mode, the fill and border opacities are reduced to prevent over-brightness against the darker backdrop.

`AppBackdrop` renders a full-screen `LinearGradient` container with three radial `_GlowOrb` blobs at fixed positions to create the ambient lighting effect. Both light and dark variants have distinct gradient stops and orb intensities.

### 5.7 Dark / Light Theme

`AppTheme` exposes two factory methods — `light()` and `dark()` — both delegating to a shared `_buildTheme()` method parameterised by brightness-specific color tokens. This avoids code duplication while ensuring every component (AppBar, dialogs, inputs, buttons, FAB, icons) is styled correctly for each mode.

### 5.8 Splash Screen

A `SplashScreen` widget is the initial route. It displays the Glass Flask logo centred on a deep radial gradient background and auto-navigates to `QuizScreen` after 2 seconds using a `FadeTransition` page route.

---

## 6. UI/UX Design System

### 6.1 Color Palette

| Role | Light Mode | Dark Mode |
|------|-----------|-----------|
| Background base | `#6C7A98` (slate) | `#0D1527` (midnight) |
| Gradient end | `#4E5977` | `#0B1222` |
| Surface / Card | `rgba(255,255,255,0.18)` | `rgba(255,255,255,0.08)` |
| On-surface text | `#15233D` (ink) | `#E6EDFF` (mist) |
| Primary accent | `#4D5B79` | `#9EB8FF` (periwinkle) |
| Secondary accent | `#98E7F5` (aqua) | `#98E7F5` |

### 6.2 Typography

All text uses **Poppins** loaded via `google_fonts`:

| Style | Size | Weight | Use |
|-------|------|--------|-----|
| Title Large | 22pt | 700 | Screen titles, card titles |
| Title Medium | 18pt | 600 | Card content |
| Body Medium | 14pt | 500 | Supporting text, hints |
| Label Large | 13pt | 700 | Chip labels, form labels |

### 6.3 Spacing & Shape

- **Border radius:** 18 px (buttons) → 24 px (panels) → 32 px (flashcard)
- **Screen padding:** 20 px horizontal
- **Glass blur:** σ = 22 px via `ImageFilter.blur`
- **Card shadow:** `rgba(21, 35, 61, 0.15)` @ 30 px blur, 16 px Y offset

---

## 7. Data Management

### 7.1 Persistence Strategy

All data is stored locally using `SharedPreferences`. The flashcard list is serialised as a JSON string (`jsonEncode`) and stored under the key `"flashcards"`. On app start the provider decodes this string back into `List<Flashcard>`. Theme preference is stored as a plain string under `"theme_mode"`.

No network calls or external database is used — the app is fully offline.

### 7.2 Default Seed Data

On first launch (when no stored data exists), the provider seeds five sample cards covering general knowledge topics so the quiz screen is immediately usable without requiring the user to add cards first.

### 7.3 ID Strategy

UUIDs are generated with `uuid` (v4 algorithm). Using stable, globally-unique IDs prevents collisions when cards are edited or when the list is re-ordered in the future.

---

## 8. Testing & Validation

### 8.1 Static Analysis

All Dart files were validated with `flutter analyze lib` throughout development. The final build reports **no issues** (0 errors, 0 warnings, 0 hints).

### 8.2 Manual Testing (Emulator)

All features were manually verified on the **Pixel 6 emulator (Android 16, API 36)**:

| Test Case | Result |
|-----------|--------|
| App launches and shows splash screen | ✅ Pass |
| Splash auto-navigates to quiz after 2 s | ✅ Pass |
| Default cards load on first launch | ✅ Pass |
| Answer flip animates in 3D (650 ms) | ✅ Pass |
| Donut ring increments on Next | ✅ Pass |
| Previous / Next navigation disables at boundaries | ✅ Pass |
| Add card form validates empty inputs | ✅ Pass |
| New card appears immediately in quiz | ✅ Pass |
| Edit card updates content across restarts | ✅ Pass |
| Delete card with confirmation dialog | ✅ Pass |
| Dark mode toggle persists after restart | ✅ Pass |
| Light mode glass panels render correctly | ✅ Pass |
| Dark mode glass panels render correctly | ✅ Pass |
| App icon appears on home screen | ✅ Pass |
| App name shows "Glass Flask" in launcher | ✅ Pass |

---

## 9. Challenges & Solutions

### 9.1 3D Flip Without a Plugin

**Challenge:** Flutter does not have a built-in card-flip widget. Third-party flip packages impose layout constraints incompatible with the `Expanded` container in the quiz layout.

**Solution:** Implemented the flip entirely with a native `AnimationController` + `Transform` using a `Matrix4` perspective-projection matrix. The front and back faces are rendered as separate widget subtrees; the active face is selected by checking whether the animation angle exceeds π/2.

### 9.2 BackdropFilter Performance on Emulator

**Challenge:** `BackdropFilter` (used for glass panels) can cause jank on emulated hardware because the emulator renders in software.

**Solution:** This is expected emulator behaviour and does not reflect physical device performance. The `Skipped N frames` warnings in the debug console stem from the emulator's software renderer, not from the app logic.

### 9.3 Windows Symlink Restriction for google_fonts

**Challenge:** `flutter pub add google_fonts` reported a symlink warning on Windows because Developer Mode was not enabled.

**Solution:** The package still installed and compiled correctly via the pub cache — Developer Mode is only needed for symlink-based plugin linking on Windows desktop targets, not for Android/iOS builds.

### 9.4 Missing Splash Asset on Hot Restart

**Challenge:** The splash screen referenced `assets/splash/app.png`, but the splash folder was empty. A hot restart after adding the file still failed because assets are bundled at compile time.

**Solution:** Copied the logo PNG into the splash asset path and performed a full `flutter run` rebuild (not just a hot reload/restart) to re-bundle the assets into the APK.

---

## 10. Conclusion

Glass Flask successfully delivers a polished, fully functional flashcard study app within the scope of the CodeAlpha internship brief. All eight original objectives were met:

- The CRUD system is clean and reactive, backed by local JSON persistence
- The Glassmorphic Focus design is applied consistently across all screens via a reusable `GlassPanel` widget and a centralised `AppTheme`
- The 3D flip micro-interaction significantly improves the study experience compared to a plain text swap
- The donut progress ring gives users an at-a-glance view of session progress without taking up screen real estate
- Dark mode provides a comfortable low-light study environment with a persisted preference

The codebase is modular and follows Flutter best practices — stateless widgets where possible, provider-driven reactivity, and a single source of truth for theme data — making it straightforward to extend with features such as spaced repetition scoring, card categories, or cloud sync in future iterations.

---

## 11. Internship Submission Checklist

This section maps the delivered implementation directly to the internship task statement.

| Required Item (Task 1) | Evidence in Project | Status |
|---|---|---|
| Flashcard has question front and answer back with Show Answer | Quiz flow in `quiz_screen.dart` + `flashcard_widget.dart` flip behavior | ✅ Completed |
| Next and Previous navigation | Navigation controls and boundary checks in `FlashcardProvider` and quiz UI | ✅ Completed |
| Add, edit, and delete flashcards | Manage screen list actions + add/edit form + delete confirmation | ✅ Completed |
| Simple and clean user interface | Glassmorphic layout with clear hierarchy, readable typography, responsive spacing | ✅ Completed |

Additional value added beyond requirement:

- 3D flip-card micro-interaction
- Donut progress ring
- Dark/light theme with persisted preference
- Custom app icon and launcher branding (Glass Flask)

---

## 12. Deliverables

The following deliverables are included in the submission repository:

- Source code (Flutter project)
- Updated README with task coverage and run instructions
- Full project report (`REPORT.md`)
- App screenshots in `Screenshot/`
- Custom app icon assets in `assets/icon/`
- Splash logo asset in `assets/splash/`

Recommended submission bundle for internship portal:

1. GitHub repository URL
2. README
3. REPORT
4. Optional APK release build

---

*Report prepared by Loszole — CodeAlpha Flutter Internship, April 2026*
