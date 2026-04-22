# 🎬 CineMax — Frontend

The Flutter frontend for **CineMax**, a full-featured movie ticket booking app. Browse movies, watch trailers, select seats, and book tickets seamlessly on Android & IOS.

> 🔗 Backend Repository: [cinemax-backend]([https://github.com/yourusername/cinemax-backend](https://github.com/priyesh-tiwari/movie_ticket_app_node_backend))

---

## 📱 Screenshots

> _Add screenshots here_

---
## 📱 Demo Video


---

## ✨ Features

- 🔐 Email & Password Login / Signup with OTP verification
- 🔑 Forgot Password via email reset
- 🖼️ Profile photo upload and edit
- 🎥 Browse and search movies
- 🎞️ Watch movie trailers
- 🏟️ View available theaters and showtimes per movie
- 💺 Interactive seat selection UI with real-time lock status
- 💳 Stripe-powered payment flow
- 🎟️ Booking receipt saved in My Bookings
- 👤 User & Theater Admin role-based UI

---

## 🧱 Tech Stack

| Purpose | Technology |
|---|---|
| Framework | Flutter |
| Language | Dart |
| Auth | JWT (stored locally) |
| HTTP Client | Dio / http |
| Payment | Stripe Flutter SDK |
| State Management |  Provider / Riverpod |
| Local Storage | SharedPreferences/Flutter Secure Storage |

---

## 🗂️ Project Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/          # API base URL, app constants
│   ├── theme/              # App theme, colors, text styles
│   └── utils/              # Helpers, validators
├── models/                 # Data models (Movie, Seat, Booking, User...)
├── services/               # API service classes
├── providers/              # State management
└── screens/
    ├── auth/               # Login, Signup, OTP, Forgot Password
    ├── home/               # Home screen, movie listing
    ├── movie/              # Movie detail, trailer
    ├── booking/            # Theater list, seat selection, payment
    ├── profile/            # User profile, photo edit
    └── my_bookings/        # Booking history and receipts
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK >= 3.x
- Dart >= 3.x
- Android Studio or VS Code with Flutter extension
- A running CineMax backend (deployed)

### Installation

```bash
git clone https://github.com/yourusername/cinemax-frontend.git
cd cinemax-frontend
flutter pub get
```


### Run the App

```bash
# Check connected devices
flutter devices

# Run on connected device or emulator
flutter run
```

### Build Release APK

```bash
flutter build apk --release
```

APK will be generated at:
```
build/app/outputs/flutter-apk/app-release.apk
```

---



## 👤 Role-Based UI

| Role | UI Behaviour |
|---|---|
| User | Browse movies, book tickets, view receipts |
| Theater Admin | Access admin panel to manage theaters, screens, and movies |

Role is determined from the JWT payload on login. Admin screens are only rendered for users with the admin role.

---

## 🌐 Backend

The backend is deployed on [Render](https://render.com).

> ⚠️ **Cold Start Warning:** The free tier backend may take **30–50 seconds** to respond after a period of inactivity. This is expected — not a bug in the app. > ⚠️ **Signup using OTP:** The nodemailer does not work on free tier render plan, so to see the full flow lease refer tothe demo video link attached.

---
