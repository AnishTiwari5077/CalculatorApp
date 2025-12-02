import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorModel with ChangeNotifier {
  String _expression = '';
  String _output = '0';
  bool _isResultShown = false;

  String get expression => _expression;
  String get output => _output;

  void handleButtonPress(String value) {
    switch (value) {
      case 'C':
        _clear();
        break;
      case '⌫':
        _backspace();
        break;
      case '=':
        _evaluate();
        break;
      default:
        _appendValue(value);
        break;
    }
    notifyListeners();
  }

  void _appendValue(String value) {
    if (_isResultShown) {
      if (_isOperator(value)) {
        _expression = _output + value;
      } else {
        _expression = value;
      }
      _isResultShown = false;
    } else {
      if (_isOperator(value) &&
          _expression.isNotEmpty &&
          _isOperator(_expression[_expression.length - 1])) {
        // Replace the last operator with the new one
        _expression = _expression.substring(0, _expression.length - 1) + value;
      } else if (_expression.isEmpty && _isOperator(value) && value != '-') {
        return;
      } else if (_expression.isNotEmpty &&
          _expression[_expression.length - 1].contains(RegExp(r'[0-9)]')) &&
          value == '(') {
        _expression += '×(';
      }
      // Handle ')' followed by number or '(' → add multiplication
      else if (_expression.isNotEmpty &&
          _expression[_expression.length - 1] == ')' &&
          value.contains(RegExp(r'[0-9(]'))) {
        _expression += '×$value';
      }
      // Prevent multiple decimal points in the same number
      else if (value == '.') {
        // Check if the current number already has a decimal point
        final lastNumberMatch = RegExp(r'[\d.]+$').firstMatch(_expression);
        if (lastNumberMatch != null &&
            lastNumberMatch.group(0)!.contains('.')) {
          return; // Already has a decimal point
        }
        _expression += value;
      } else {
        _expression += value;
      }
    }
    _output = _expression;
  }

  void _backspace() {
    if (_isResultShown) {
      _clear();
      return;
    }

    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      _output = _expression.isEmpty ? '0' : _expression;
    }
  }

  void _clear() {
    _expression = '';
    _output = '0';
    _isResultShown = false;
  }

  void _evaluate() {
    if (_expression.isEmpty) return;

    try {
      // Normalize symbols
      String parsedExpr = _expression.replaceAll('×', '*').replaceAll('÷', '/');

      // Check for balanced parentheses
      if (!_areParenthesesBalanced(parsedExpr)) {
        _output = 'Error: Unmatched parentheses';
        _isResultShown = true;
        return;
      }

      final parser = ShuntingYardParser();
      final Expression exp = parser.parse(parsedExpr);
      final evaluator = RealEvaluator();
      final num resultNum = evaluator.evaluate(exp);

      // Handle special cases
      if (resultNum.isNaN) {
        _output = 'Error: Invalid operation';
      } else if (resultNum.isInfinite) {
        _output = 'Error: Division by zero';
      } else {
        final double result = resultNum.toDouble();
        _output = _formatResult(result);
      }

      _expression += ' =';
      _isResultShown = true;
    } catch (e) {
      _output = 'Error: Invalid expression';
      _isResultShown = true;
    }
  }

  bool _areParenthesesBalanced(String expr) {
    int count = 0;
    for (int i = 0; i < expr.length; i++) {
      if (expr[i] == '(') {
        count++;
      } else if (expr[i] == ')') {
        count--;
        if (count < 0) return false;
      }
    }
    return count == 0;
  }

  bool _isOperator(String value) {
    return ['+', '-', '*', '/', '×', '÷'].contains(value);
  }

  String _formatResult(double number) {
    // Handle very large or very small numbers with scientific notation
    if (number.abs() > 1e15 || (number.abs() < 1e-6 && number != 0)) {
      return number.toStringAsExponential(6);
    }

    // For integers, show as integer
    if (number % 1 == 0) {
      return number.toInt().toString();
    }

    // For decimals, limit to reasonable precision
    return number
        .toStringAsFixed(10)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }
}
