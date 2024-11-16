# Flutter Todo App

A modern, feature-rich Todo application built with Flutter, showcasing best practices in mobile app development.

[![Deploy to Github Pages](https://github.com/[YOUR_USERNAME]/todo_app/actions/workflows/web.yml/badge.svg)](https://github.com/[YOUR_USERNAME]/todo_app/actions/workflows/web.yml)

## 📱 Screenshots

<div align="center">
  <table>
    <tr>
      <td align="center">
        <img src="screenshots/1.png" width="200px" alt="Todo App Screenshot 1"/>
      </td>
      <td align="center">
        <img src="screenshots/2.png" width="200px" alt="Todo App Screenshot 2"/>
      </td>
      <td align="center">
        <img src="screenshots/3.png" width="200px" alt="Todo App Screenshot 3"/>
      </td>
    </tr>
    <tr>
      <td align="center">
        <img src="screenshots/4.png" width="200px" alt="Todo App Screenshot 4"/>
      </td>
      <td align="center">
        <img src="screenshots/5.png" width="200px" alt="Todo App Screenshot 5"/>
      </td>
      <td align="center">
        <img src="screenshots/6.png" width="200px" alt="Todo App Screenshot 6"/>
      </td>
    </tr>
  </table>
</div>

## 🚀 Live Demo

Check out the live demo of the app: https://[YOUR_USERNAME].github.io/todo_app

## ✨ Features

- 📱 Clean, modern UI with Material Design 3
- 🎨 Dynamic theme support (Light/Dark mode)
- 💾 Local persistence using Hive
- 📊 Task grouping and organization
- ↩️ Undo/Redo support for actions
- ⚡ Fast and responsive animations
- 🔄 State management with Riverpod

## 🔧 Installation & Setup

1. Clone the repository
```bash
git clone https://github.com/[YOUR_USERNAME]/todo_app.git
```

2. Get Flutter packages
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## 🌐 Web Deployment

This app is automatically deployed to GitHub Pages using GitHub Actions. The deployment workflow:

1. Triggers on push to main branch
2. Sets up Flutter environment
3. Enables web support
4. Builds the web app
5. Deploys to GitHub Pages

To deploy to your own GitHub Pages:

1. Fork this repository
2. Go to repository Settings > Pages
3. Set Source to "GitHub Actions"
4. Push changes to main branch
5. Check Actions tab for deployment status
6. Access your app at `https://[YOUR_USERNAME].github.io/todo_app`

## Architecture

The app follows a feature-first architecture with clean separation of concerns:

```
lib/
├── src/
│   ├── common/
│   │   ├── constants/
│   │   ├── providers/
│   │   └── theme/
│   └── features/
│       └── todo/
│           ├── domain/
│           │   └── models/
│           ├── presentation/
│           │   ├── providers/
│           │   ├── screens/
│           │   └── widgets/
└── main.dart
```

## Technologies Used

- Flutter
- Riverpod for state management
- Hive for local storage
- Material Design 3

## Getting Started

1. **Prerequisites**
   - Flutter (latest version)
   - Dart SDK
   - Android Studio / VS Code

2. **Installation**
   ```bash
   # Clone the repository
   git clone [repository-url]

   # Navigate to project directory
   cd todo_app

   # Get dependencies
   flutter pub get

   # Run the app
   flutter run
   ```

3. **Build**
   ```bash
   # Generate Hive adapters
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Dependencies

```yaml
flutter_riverpod: ^2.4.9
hive: ^2.2.3
hive_flutter: ^1.1.0
```

## Features in Detail

### Task Management
- Create, update, and delete tasks
- Mark tasks as complete/incomplete
- Group tasks by category
- Undo deleted tasks

### UI/UX
- Smooth animations
- Intuitive gestures
- Responsive design
- Error handling with user feedback

### Data Persistence
- Local storage using Hive
- Automatic state persistence
- Fast data access

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Riverpod for state management
- Hive for local storage solution
