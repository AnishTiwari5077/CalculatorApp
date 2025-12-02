# 🧮 Flutter Calculator App

A beautiful, Simple calculator application built with Flutter featuring a modern neumorphic design and advanced mathematical capabilities.

## ✨ Features

### Core Functionality
- ✅ **Basic Operations**: Addition, subtraction, multiplication, and division
- 🔢 **Advanced Math**: Support for parentheses and complex expressions
- 🧠 **Smart Input**: Automatic implicit multiplication (e.g., `2(3+4)` = `2×(3+4)`)
- ⌫ **Backspace**: Delete the last entered character
- 🔄 **Clear Function**: Reset calculator with a single tap
- 🎯 **Error Handling**: Comprehensive validation with user-friendly error messages

### Professional Disp
- 📏 **Dynamic Font Sizing**: Automatically adjusts text size based on result length
- 🔬 **Scientific Notation**: Handles very large and very small numbers elegantly
- 📱 **Scrollable Display**: Horizontal scrolling for extremely long expressions
- 🎨 **Dual Display**: Shows both the expression and result simultaneously

### Smart Features
- 🚫 **Input Validation**: 
  - Prevents multiple consecutive operators
  - Blocks multiple decimal points in a single number
  - Validates balanced parentheses
- 🔄 **Result Chaining**: Continue calculations using previous results
- ⚡ **Real-time Preview**: See your expression as you type

## 📸 Screenshots
![alt](https:)


## 🎨 Design

The app features a modern **neumorphic design** with:
- Soft shadows and depth effects
- Clean, minimal interface
- Color-coded buttons:
  - 🔴 **Red**: Clear button
  - 🟠 **Orange**: Backspace
  - 🟢 **Green**: Equals/Calculate
  - 🔵 **Indigo**: Operators
  - ⚪ **White**: Numbers and decimal point

## 🛠️ Technical Stack

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  math_expressions: ^2.4.0
```

### Architecture
- **State Management**: Provider pattern for reactive UI updates
- **Math Engine**: `math_expressions` package with `ShuntingYardParser`
- **Design Pattern**: MVVM (Model-View-ViewModel)

### Project Structure
```
lib/
├── provider/
│   └── calculator_provider.dart    # Business logic and state management
├── screens/
│   └── calculator_screen.dart
    └── splash_screen.dart
    
└── main.dart  
                         # App entry point

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter-calculator.git
   cd flutter-calculator
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android:**
```bash
flutter build apk --release


## 💡 Usage Examples

### Basic Calculations
```
Input: 123 + 456
Output: 579

Input: 1000 × 250
Output: 250,000
```

### Complex Expressions
```
Input: (5 + 3) × (10 - 2)
Output: 64

Input: 2(3 + 4)
Auto-corrects to: 2×(3+4)
Output: 14
```

### Decimal Operations
```
Input: 15.5 ÷ 2
Output: 7.75

Input: 0.1 + 0.2
Output: 0.3
```

### Large Numbers
```
Input: 999999 × 999999
Output: 999,998,000,001
```

## 🎯 Key Features Explained

### Dynamic Font Sizing
The calculator automatically adjusts the font size based on the result length:
- Short results (≤8 chars): Large, easy-to-read 44px font
- Medium results (≤16 chars): Comfortable 30-36px font
- Long results (>20 chars): Compact 22px font with scrolling

### Error Handling
The app provides specific error messages for different scenarios:
- "Error: Unmatched parentheses" - Missing opening or closing parenthesis
- "Error: Division by zero" - Attempting to divide by zero
- "Error: Invalid operation" - Mathematical impossibility (e.g., NaN)
- "Error: Invalid expression" - Syntax errors in the expression

### Smart Input
- Implicit multiplication: `2(3)` automatically becomes `2×(3)`
- Operator replacement: Typing `5+-` replaces `+` with `-` to give `5-`
- Decimal validation: Prevents multiple decimal points like `3.14.15`

## 🔧 Customization

### Changing Colors
Edit `calculator_screen.dart` to customize button colors:
```dart
Color get buttonColor {
  if (text == 'C') {
    return Colors.redAccent;  // Change clear button color
  } else if (text == '=') {
    return Colors.green.shade500;  // Change equals button color
  }
  // ... more customizations
}
```

### Modifying Button Layout
Update the `buttonRows` array in `CalculatorScreen`:
```dart
final buttonRows = [
  ['C', '(', ')', '⌫'],
  ['7', '8', '9', '÷'],
  // Add or modify rows here
];
```

## 🐛 Known Issues & Future Enhancements

### Potential Improvements
- [ ] Add scientific functions (sin, cos, tan, log, etc.)
- [ ] Implement calculation history
- [ ] Support for percentage calculations
- [ ] Theme customization (dark/light mode)
- [ ] Landscape orientation support
- [ ] Memory functions (M+, M-, MR, MC)
- [ ] Copy/paste functionality

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

### Coding Guidelines
- Follow Flutter best practices
- Maintain consistent code formatting (`flutter format .`)
- Add comments for complex logic
- Test thoroughly before submitting PR

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author
- GitHub: [@Anishtiwari5077](https://github.com/AnishTiwari5077)


⭐ If you found this project helpful, please give it a star!
