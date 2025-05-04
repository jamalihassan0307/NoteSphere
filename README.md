<div align="center">
  <h1>
    NoteMinder - Advanced Note Taking & Organization App
  </h1>
  <h3>A Modern Flutter App for Managing Your Notes with Priority & Organization</h3>
</div>

## 📸 Banner
<p align="center">
    <img src="screenshots/notes_banner.png" alt="NoteMinder Banner" width="100%"/>
</p>

<p align="center">
    <img alt="Flutter" src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
    <img alt="Dart" src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
    <img alt="SQLite" src="https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white" />
    <img alt="GetX" src="https://img.shields.io/badge/GetX-8A2BE2?style=for-the-badge&logo=flutter&logoColor=white" />
</p>

## 📸 Screenshots

### Authentication & Onboarding

<table border="1">
  <tr>
    <td align="center">
      <img src="screenshots/login.png" alt="Login Screen" width="250"/>
      <p><b>Login Screen</b></p>
    </td>
    <td align="center">
      <img src="screenshots/create_account.png" alt="Create Account" width="250"/>
      <p><b>Create Account</b></p>
    </td>
    <td align="center">
      <img src="screenshots/create_account1.png" alt="Sign Up Flow" width="250"/>
      <p><b>Sign Up Flow</b></p>
    </td>
  </tr>
</table>

### Note Management & Views

<table border="1">
  <tr>
    <td align="center">
      <img src="screenshots/home_grid.png" alt="Home Grid View" width="250"/>
      <p><b>Grid View</b></p>
    </td>
    <td align="center">
      <img src="screenshots/home_list.png" alt="Home List View" width="250"/>
      <p><b>List View</b></p>
    </td>
    <td align="center">
      <img src="screenshots/listview.png" alt="Enhanced List View" width="250"/>
      <p><b>Enhanced List View</b></p>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="screenshots/high_priority_note.png" alt="High Priority Notes" width="250"/>
      <p><b>High Priority Notes</b></p>
    </td>
    <td align="center">
      <img src="screenshots/medium_priority_note.png" alt="Medium Priority Notes" width="250"/>
      <p><b>Medium Priority Notes</b></p>
    </td>
    <td align="center">
      <img src="screenshots/low_priority_note.png" alt="Low Priority Notes" width="250"/>
      <p><b>Low Priority Notes</b></p>
    </td>
  </tr>
</table>

### Note Editing & Details

<table border="1">
  <tr>
    <td align="center">
      <img src="screenshots/edit_notes.png" alt="Edit Notes" width="250"/>
      <p><b>Edit Notes</b></p>
    </td>
    <td align="center">
      <img src="screenshots/edit_notes1.png" alt="Note Editor" width="250"/>
      <p><b>Note Editor</b></p>
    </td>
    <td align="center">
      <img src="screenshots/notes_detail.png" alt="Note Details" width="250"/>
      <p><b>Note Details</b></p>
    </td>
  </tr>
</table>

### User Management & Settings

<table border="1">
  <tr>
    <td align="center">
      <img src="screenshots/drawer.png" alt="Navigation Drawer" width="250"/>
      <p><b>Navigation Drawer</b></p>
    </td>
    <td align="center">
      <img src="screenshots/profile.png" alt="User Profile" width="250"/>
      <p><b>User Profile</b></p>
    </td>
    <td align="center">
      <img src="screenshots/edit_profile.png" alt="Edit Profile" width="250"/>
      <p><b>Edit Profile</b></p>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="screenshots/setting.png" alt="Settings" width="250"/>
      <p><b>Settings</b></p>
    </td>
    <td align="center">
      <img src="screenshots/search_notes.png" alt="Search Notes" width="250"/>
      <p><b>Search Notes</b></p>
    </td>
  </tr>
</table>

## 📱 Features

- **Modern UI**: Beautiful, intuitive interface with animations
- **Multiple Views**: Switch between grid and list views
- **Note Priority**: Organize notes by importance (High, Medium, Low)
- **Authentication**: Secure login and signup system with persistent sessions
- **User Profiles**: Create and manage your personal profile
- **Note Details**: View comprehensive information about each note
- **Search**: Quickly find notes by title, description, or tags
- **Data Persistence**: Store all your notes locally using SQLite
- **Animations**: Smooth transitions and visual effects

## 🚀 Tech Stack

- **Flutter** (UI Framework)
- **GetX** (State Management)
- **SQLite** (Local Database)
- **Shared Preferences** (Session Management)
- **Flutter Animate** (Animation Library)
- **AnimatedTextKit** (Text Animations)
- **Material Design 3**
- **Flutter Slidable** (Swipe Actions)
- **Flutter Staggered Grid View** (Grid Layout)

## 🔑 Key Features

- ✅ **Note Management**: Create, edit, and delete notes
- ✅ **Priority System**: Categorize notes by importance
- ✅ **Multiple Views**: Toggle between grid and list views
- ✅ **Tagging**: Organize notes with tags
- ✅ **User Authentication**: Secure login with persistent sessions
- ✅ **Profile Management**: Customize your user profile
- ✅ **Offline Access**: Access your notes without internet
- ✅ **Search**: Find notes quickly with powerful search functionality
- ✅ **Beautiful UI**: Modern and intuitive interface with animations

## 📖 How to Use

1. **Create an Account or Login**
   - Sign up with your email and password
   - Profile pictures can be added from camera or gallery
   - Previous sessions are remembered for seamless access

2. **Manage Your Notes**
   - Create new notes with the floating action button
   - Set priority levels (High, Medium, Low)
   - Add tags for better organization
   - Choose note colors for visual categorization

3. **Organize and Filter**
   - Use the drawer menu to filter by priority
   - Search notes by content or tags
   - Switch between grid and list views
   - Star important notes for quick access

4. **User Settings**
   - Update your profile information
   - Change app preferences
   - Manage account settings

## Project Structure

```
lib/
├── controller/
│   ├── authcontroller.dart
│   ├── notecontroller.dart
│   └── signupcontroller.dart
├── db/
│   └── sql.dart
├── model/
│   ├── note.dart
│   └── usermodel.dart
├── page/
│   ├── edit_note_page.dart
│   ├── login.dart
│   ├── note_detail_page.dart
│   ├── notes_page.dart
│   ├── profile_page.dart
│   ├── settings_page.dart
│   └── signup.dart
├── widget/
│   └── note_card_widget.dart
└── main.dart
```

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📦 Installation

Download the APK from:
- [APK/app-release.apk](APK/app-release.apk)

Or clone the repository and build it yourself:
```bash
git clone https://github.com/yourusername/notes_app_with_sql.git
cd notes_app_with_sql
flutter pub get
flutter run
```

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page.

## 👨‍💻 Developer

Developed with ❤️ by [Your Name]
