import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorModel with ChangeNotifier {
  String _expression = '';
  String _output = '0';
  bool _isResultShown = false;

  String get expression => _expression;
  String get output => _output;

  /// Handles all button presses
  void handleButtonPress(String buttonText) {
    switch (buttonText) {
      case 'C':
        _clear();
        break;
      case '=':
        _evaluate();
        break;
      default:
        _appendExpression(buttonText);
        break;
    }
    notifyListeners();
  }

  /// Append pressed button to expression
  void _appendExpression(String value) {
    if (_isResultShown && RegExp(r'[0-9(]').hasMatch(value)) {
      // Start a new calculation if last was result
      _expression = '';
      _output = '0';
      _isResultShown = false;
    }

    // Prevent invalid repeated operators
    if (_expression.isNotEmpty &&
        RegExp(r'[+\-*/÷×%]').hasMatch(value) &&
        RegExp(r'[+\-*/÷×%]').hasMatch(_expression[_expression.length - 1])) {
      _expression =
          _expression.substring(0, _expression.length - 1) +
          value; // replace operator
    } else {
      _expression += value;
    }

    _output = _expression;
  }

  /// Evaluate the full expression using modern math_expressions API
  void _evaluate() {
    if (_expression.isEmpty) return;

    try {
      String parsedExpr = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('%', '/100');

      // Automatically insert * for implicit multiplication like 5(5+5)
      parsedExpr = parsedExpr.replaceAllMapped(
        RegExp(r'(\d|\))\('),
        (match) => '${match.group(1)}*(',
      );

      // Use modern ShuntingYardParser
      final parser = ShuntingYardParser();
      final Expression exp = parser.parse(parsedExpr);

      // Evaluate safely
      final evaluator = RealEvaluator();
      final num resultNum = evaluator.evaluate(exp);

      _output = _formatResult(resultNum.toDouble());
      _expression += ' =';
      _isResultShown = true;
    } catch (e) {
      _output = 'Error';
      _isResultShown = true;
    }

    notifyListeners();
  }

  /// Reset calculator
  void _clear() {
    _expression = '';
    _output = '0';
    _isResultShown = false;
    notifyListeners();
  }

  /// Format result to remove trailing .0
  String _formatResult(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    } else {
      String formatted = value.toStringAsFixed(8);
      formatted = formatted.replaceFirst(RegExp(r'\.?0+$'), '');
      return formatted;
    }
  }
}
