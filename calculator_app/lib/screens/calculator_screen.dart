import 'package:calculator_app/provider/calculator_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CalculatorModel>(context);

    final buttonRows = [
      ['C', '(', ')', '/'],
      ['7', '8', '9', '*'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['0', '.', '='],
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE6EBF0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(),
              // Expression
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  model.expression,
                  style: const TextStyle(fontSize: 26, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              // Output
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  model.output,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Buttons
              Expanded(
                flex: 2,
                child: Column(
                  children: buttonRows.map((row) {
                    return Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: row.map((label) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CalculatorButton(
                                text: label,
                                onTap: () => model.handleButtonPress(label),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CalculatorButton({super.key, required this.text, required this.onTap});

  bool get isOperator =>
      ['+', '-', '*', '/', '=', '(', ')', '×', '÷'].contains(text);

  @override
  Widget build(BuildContext context) {
    final baseColor = const Color(0xFFE6EBF0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-3, -3),
              blurRadius: 6,
            ),
            BoxShadow(
              color: Colors.grey.shade400,
              offset: const Offset(3, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isOperator ? 26 : 22,
              fontWeight: FontWeight.bold,
              color: isOperator ? Colors.indigo : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
