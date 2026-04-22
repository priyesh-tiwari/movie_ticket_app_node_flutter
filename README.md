# 🎬 CineMax — Frontend

The Flutter frontend for **CineMax**, a full-featured movie ticket booking app. Browse movies, watch trailers, select seats, and book tickets seamlessly on Android & IOS.

> 🔗 Backend Repository: [cinemax-backend](https://github.com/priyesh-tiwari/movie_ticket_app_node_backend)

---

## 📱 Demo Video

> 🎬 Watch the full app walkthrough here — recommended since some features may not work in the APK due to Render free tier limitations.

[![Watch Demo](https://img.shields.io/badge/▶%20Watch%20Demo-Google%20Drive-blue?style=for-the-badge&logo=google-drive)](https://drive.google.com/drive/folders/19pqh5j9x1kB-Y555iKwShNFAs2sz79Lb?usp=sharing)

---

## 📸 Screenshots

<details>
<summary><b>🔐 Authentication — click to view</b></summary>
<br/>
<p align="center">
  <img src="movie_app_screenshot/splash.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/login.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/signup.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/signup_otp.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/email_otp.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/logout_card.jpg" width="180" hspace="6"/>

</p>
</details>

<details>
<summary><b>🎬 Home & Search — click to view</b></summary>
<br/>
<p align="center">
  <img src="movie_app_screenshot/home.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/home_01.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/home_02.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/home_search_bar.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/search_bar.jpg" width="180" hspace="6"/>
</p>
</details>

<details>
<summary><b>🎟️ Booking Flow — click to view</b></summary>
<br/>
<p align="center">
  <img src="movie_app_screenshot/movie_description.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/select_theater.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/seat.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/payment.jpg" width="180" hspace="6"/>
</p>
</details>

<details>
<summary><b>🧾 Receipt & Profile — click to view</b></summary>
<br/>
<p align="center">
  <img src="movie_app_screenshot/receipt.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/my_bookings.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/profile.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/drawer.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/logout_card.jpg" width="180" hspace="6"/>
</p>
</details>

<details>
<summary><b>🏟️ Admin Panel — click to view</b></summary>
<br/>
<p align="center">
  <img src="movie_app_screenshot/admin_pannel.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/addmin_pannel_01.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/admin_pannel_02.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/add_theater.jpg" width="180" hspace="6"/>
  <img src="movie_app_screenshot/add_showtime.jpg" width="180" hspace="6"/>
</p>
</details>

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

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ^3.8.1
- Dart >= 3.8.1
- Android Studio or VS Code with Flutter extension
- A running CineMax backend (deployed)

### Installation

```bash
git clone https://github.com/priyesh-tiwari/movie_ticket_app_node_flutter.git
cd movie_ticket_app_node_flutter
flutter pub get
flutter run
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
