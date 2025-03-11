# Contributing to Readily Reads

Thank you for considering contributing to Readily Reads! This document outlines the process for contributing to this Flutter/Dart mobile application.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Pull Request Process](#pull-request-process)
- [Dart and Flutter Coding Standards](#dart-and-flutter-coding-standards)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Testing Guidelines](#testing-guidelines)
- [Documentation Guidelines](#documentation-guidelines)
- [Issue Reporting Guidelines](#issue-reporting-guidelines)

## Code of Conduct

This project adheres to a Code of Conduct that all contributors are expected to follow. By participating, you agree to uphold this code. Please be respectful and considerate of others.

## Getting Started

### Prerequisites

Before you begin, ensure you have set up the project by following the [Getting Started Guide](./getting-started.md).

### Finding Issues to Work On

- Look for issues labeled with `good first issue` for newcomers
- Check the GitHub issues for existing bugs and feature requests
- Feel free to suggest new features or improvements

## Development Workflow

### 1. Fork and Clone the Repository

1. Fork the repository on GitHub
2. Clone your fork locally:

   ```bash
   git clone https://github.com/[your-username]/readily_reads.git
   cd readily_reads
   ```

3. Add the original repository as an upstream remote:

   ```bash
   git remote add upstream https://github.com/[original-owner]/readily_reads.git
   ```

### 2. Create a Branch

Create a new branch for your feature or bugfix:

```bash
git checkout -b feature/your-feature-name  # for features
# or
git checkout -b bugfix/your-bugfix-name    # for bugfixes
```

Use a descriptive name for your branch that reflects the changes you're making.

### 3. Set Up Your Development Environment

1. Make sure your Flutter SDK is up to date:

   ```bash
   flutter upgrade
   ```

2. Get all dependencies:

   ```bash
   flutter pub get
   ```

### 4. Make Your Changes

- Follow the [Dart and Flutter Coding Standards](#dart-and-flutter-coding-standards) outlined below
- Maintain consistency with the existing code style
- Update documentation if necessary
- Run linters and formatters before committing:

  ```bash
  flutter analyze
  flutter format .
  ```

### 5. Keep Your Branch Updated

Regularly update your branch with changes from the upstream main branch:

```bash
git fetch upstream
git rebase upstream/main
```

Resolve any merge conflicts that arise.

## Pull Request Process

### 1. Create a Pull Request

1. Push your branch to your fork:

   ```bash
   git push origin feature/your-feature-name
   ```

2. Go to the original repository on GitHub
3. Click "New Pull Request"
4. Select your branch and fill out the PR template

### 2. PR Requirements

Ensure your PR meets these requirements:

- The code builds without errors
- All tests pass (`flutter test`)
- Code has been analyzed (`flutter analyze`)
- Documentation is updated if necessary
- Code follows project style guidelines
- Commit messages follow guidelines

### 3. PR Review Process

1. Maintainers will review your PR
2. Address any requested changes
3. Once approved, a maintainer will merge your PR
4. Your contribution will be part of the project!

## Dart and Flutter Coding Standards

### General Guidelines

- Write clean, readable, and maintainable code
- Follow Dart best practices and conventions
- Keep functions and methods small and focused
- Use meaningful variable and function names
- Add comments when necessary to explain complex logic

### Dart Style Guide

- Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `lowerCamelCase` for variables and methods
- Use `UpperCamelCase` for classes, enums, and typedefs
- Use `snake_case` for file names
- Keep line length to a maximum of 80 characters

### Flutter Best Practices

- Extract reusable widgets to separate classes
- Keep widget trees clean and manageable
- Use `const` constructors when possible for better performance
- Follow the existing app architecture pattern
- Follow Material Design guidelines for UI consistency

### Code Organization

Readily Reads follows a file-per-screen organization pattern:

```plaintext
lib/
├── main.dart                  # App entry point
├── splash_screen.dart         # Splash screen
├── login_page.dart            # Login and registration
├── book_list_page.dart        # Book listing
├── book_management_page.dart  # Advanced book management
├── add_book_page.dart         # Add book form
├── edit_book_page.dart        # Edit book form
├── currently_reading_page.dart # Currently reading books
├── book_model.dart            # Book data model and database
├── user_model.dart            # User data model
└── user_session.dart          # Session management
```

When adding new features:
- Consider creating new Dart files for major screens
- Place utility functions in appropriate files
- Maintain the existing organizational pattern

## Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```bash
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Types include:

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Changes that don't affect code functionality (formatting, etc.)
- `refactor`: Code changes that neither fix bugs nor add features
- `test`: Adding or updating tests
- `chore`: Changes to build process or auxiliary tools

Examples:

```plaintext
feat(books): add book rating feature
fix(ui): resolve overflow in book list page
docs: update installation instructions
```

## Testing Guidelines

### Types of Tests

- **Unit Tests**: Test individual functions and classes
- **Widget Tests**: Test UI components
- **Integration Tests**: Test complete features or workflows

### Writing Tests

- Create test files with the `_test.dart` suffix
- Place tests in the `test/` directory matching the structure of `lib/`
- Test both normal cases and edge cases
- Mock dependencies to isolate the code under test
- Use descriptive test names:

  ```dart
  test('should show error message when login fails', () {
    // Test code
  });
  ```

### Running Tests

```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/path/to/test_file.dart

# Run with coverage
flutter test --coverage
```

## Documentation Guidelines

- Update documentation for any feature, API change, or other significant modification
- Write clear, concise, and comprehensive documentation
- Use proper Markdown formatting
- Include code examples where appropriate
- Add dartdoc comments to public APIs:

  ```dart
  /// Returns all books for the specified user.
  /// 
  /// Takes a [userId] parameter to filter books by user.
  /// Throws a [DatabaseException] if the database operation fails.
  Future<List<Book>> getAllBooks(int userId) async {
    // Implementation
  }
  ```

- Check spelling and grammar

## Issue Reporting Guidelines

### Reporting Bugs

When reporting bugs, please include:

1. A clear, descriptive title
2. Steps to reproduce the issue
3. Expected behavior
4. Actual behavior
5. Screenshots (if applicable)
6. Device information:
   - Device model
   - Operating system version
   - Flutter version (`flutter --version`)
7. Any additional context that might be helpful

### Suggesting Features

For feature suggestions:

1. Describe the feature clearly
2. Explain why this feature would be useful
3. Provide examples of how the feature would work
4. Consider including mockups if it's a visual feature

Thank you for contributing to Readily Reads!
