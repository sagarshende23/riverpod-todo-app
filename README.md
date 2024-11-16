# Flutter Todo App

A modern, feature-rich Todo application built with Flutter, showcasing best practices in mobile app development.

## Features

- 📱 Clean, modern UI with Material Design 3
- 🎨 Dynamic theme support (Light/Dark mode)
- 💾 Local persistence using Hive
- 📊 Task grouping (Today, Tomorrow, Important, Not Important)
- ↩️ Undo/Redo support for actions
- ⚡ Fast and responsive animations
- 🔄 State management with Riverpod

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
