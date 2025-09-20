# MindSpace Frontend-Backend Authentication Integration

## Overview
The frontend and backend authentication systems have been successfully connected. Users can now register and login with different roles (user, mentor, admin).

## Backend Setup
1. Start your Node.js backend server:
   ```bash
   cd src
   npm install
   npm start
   ```
   
2. Make sure your `.env` file includes:
   ```
   PORT=3000
   MONGODB_URI=your_mongodb_connection_string
   JWT_SECRET=your_jwt_secret
   JWT_REFRESH_SECRET=your_refresh_token_secret
   ```

## Frontend Setup
1. Install Flutter dependencies:
   ```bash
   cd frontend
   flutter pub get
   ```

2. Update the API configuration if your backend runs on a different port:
   - Edit `frontend/lib/core/constants/api_config.dart`
   - Change `baseUrl` to match your backend URL

3. Run the Flutter app:
   ```bash
   flutter run
   ```

## Features Implemented

### Authentication Flow
- ✅ User registration with username, full name, email, password, and role
- ✅ User login with username and password
- ✅ JWT token management (access + refresh tokens)
- ✅ Automatic token storage using SharedPreferences
- ✅ Auth state management using Riverpod
- ✅ Role-based registration (user/mentor/admin)

### Frontend Components
- ✅ Updated login page with username authentication
- ✅ Updated signup page with role selection dropdown
- ✅ Auth provider for state management
- ✅ Auth wrapper for automatic authentication checking
- ✅ Token refresh functionality
- ✅ Error handling and user feedback

### Backend Integration
- ✅ Connected to existing backend auth endpoints
- ✅ Supports user registration (`/auth/register`)
- ✅ Supports user login (`/auth/login`)
- ✅ Supports token refresh (`/auth/refresh-token`)
- ✅ Supports profile retrieval (`/auth/profile/:userId`)

## File Structure

### Frontend
```
frontend/lib/
├── core/
│   └── constants/
│       └── api_config.dart          # API configuration
├── data/
│   ├── models/
│   │   ├── user.dart               # User data model
│   │   ├── auth_response.dart      # API response models
│   │   ├── login_request.dart      # Login request model
│   │   └── register_request.dart   # Registration request model
│   ├── services/
│   │   └── auth_service.dart       # API service calls
│   └── repositories/
│       └── auth_repository.dart    # Data management layer
├── presentation/
│   ├── providers/
│   │   └── auth_provider.dart      # Riverpod state management
│   ├── pages/auth/
│   │   ├── login_page.dart         # Updated login UI
│   │   └── signup_page.dart        # Updated signup UI
│   └── widgets/
│       └── auth_wrapper.dart       # Auth state wrapper
└── main.dart                       # App entry point with ProviderScope
```

## Usage

### Registration
1. Open the app (starts with login screen)
2. Tap "Sign Up"
3. Fill in:
   - Username (3-20 characters)
   - Full Name
   - Email
   - Role (User/Mentor/Admin)
   - Password + Confirmation
4. Tap "Sign Up"

### Login
1. Enter your username and password
2. Tap "Sign In"
3. App navigates to dashboard on success

### Authentication States
- **Initial**: App loading/checking auth
- **Loading**: API call in progress
- **Authenticated**: User logged in successfully
- **Unauthenticated**: User needs to log in
- **Error**: Authentication failed

## API Endpoints Used

- `POST /auth/register` - User registration
- `POST /auth/login` - User login
- `POST /auth/refresh-token` - Token refresh
- `GET /auth/profile/:userId` - Get user profile

## Error Handling
- Network errors shown via SnackBar
- Form validation for all input fields
- JWT token automatic refresh
- Persistent login state across app restarts

## Next Steps
To extend this implementation:
1. Add logout functionality with backend cleanup
2. Implement password reset flow
3. Add email verification
4. Enhance error messages and loading states
5. Add biometric authentication option
6. Implement auto-login on app start