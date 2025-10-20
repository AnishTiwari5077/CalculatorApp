import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorModel with ChangeNotifier {
  String _expression = ''; // Expression being typed
  String _output = '0'; // Result or current display
  bool _isResultShown = false;

  String get expression => _expression;
  String get output => _output;

  void handleButtonPress(String value) {
    switch (value) {
      case 'C':
        _clear();
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
      // If a result was just shown, start new expression properly
      if (_isOperator(value)) {
        _expression = _output + value;
      } else {
        _expression = value;
      }
      _isResultShown = false;
    } else {
      // Add implicit multiplication: number followed by '(' → add '*'
      if (_expression.isNotEmpty &&
          _expression[_expression.length - 1].contains(RegExp(r'[0-9)]')) &&
          value == '(') {
        _expression += '*(';
      }
      // Also handle ')' followed immediately by number → add '*'
      else if (_expression.isNotEmpty &&
          _expression[_expression.length - 1] == ')' &&
          value.contains(RegExp(r'[0-9(]'))) {
        _expression += '*$value';
      } else {
        // Normal case
        _expression += value;
      }
    }

    _output = _expression;
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

      // Parse (ShuntingYardParser is fine; GrammarParser is the recommended new parser)
      final parser = ShuntingYardParser();
      final Expression exp = parser.parse(parsedExpr);

      // Evaluate using RealEvaluator (method is `evaluate`, not `eval`)
      final evaluator = RealEvaluator();
      final num resultNum = evaluator.evaluate(exp);

      // Convert to string nicely
      final double result = resultNum.toDouble();
      _output = _formatResult(result);

      _expression += ' =';
      _isResultShown = true;
    } catch (e) {
      _output = 'Error';
      _isResultShown = true;
    }
  }

  bool _isOperator(String value) {
    return ['+', '-', '*', '/', '×', '÷'].contains(value);
  }

  String _formatResult(double number) {
    if (number % 1 == 0) {
      return number.toInt().toString();
    }
    return number.toString();
  }
}
