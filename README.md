Driver App 🚖

A simple Flutter driver application demo that showcases login → assigned order → navigation → geofence checks → pickup → delivery flow.
Includes an optional order history feature.

📌 Features

Driver login with dummy credentials

Assigned order screen with step-by-step workflow

Geofence checks (with demo mode for emulator)

Google Maps navigation launch

Order delivery flow (Start → Pickup → Deliver)

Order history (bonus feature)

Clean UI with Material 3 styling

🛠️ Setup Instructions
Prerequisites

Flutter SDK
installed

Android Studio / VS Code with Flutter extension

A device/emulator with internet access

Steps
# 1. Clone the repository
git clone https://github.com/TusharRastogi04/driver_app.git
cd driver_app

# 2. Get dependencies
flutter pub get

# 3. Run the app
flutter run

🔑 Dummy Credentials

Use these to log in:

Email: driver@example.com

Password: password123

📱 Demo Flow (shown in video)

Login with dummy credentials

View assigned order details

Navigate to restaurant → geofence check → Pickup

Navigate to customer → geofence check → Delivery

(Bonus) Check Order History

📂 Project Structure
lib/
├── main.dart
├── src/
│    ├── screens/
│    │    ├── login_screen.dart
│    │    ├── assigned_order_screen.dart
│    │    └── order_history_screen.dart
│    └── services/
│         ├── location_service.dart
│         └── geofence_service.dart

📜 Assumptions

Only one active order is assigned at a time.

Geofence radius is set to 50 meters.

Demo mode bypasses geofence restrictions for testing.

No backend integration (all data is dummy & local).

🎥 Demo Video

Loom video link: https://www.loom.com/share/fc5cdeeeeb6d4501997d0265834e41cf?sid=96f106b5-731f-4949-aa2e-2fe090d7ede0

👨‍💻 Author

Tushar Rastogi