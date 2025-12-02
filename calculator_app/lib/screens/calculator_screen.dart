import 'package:calculator_app/provider/calculator_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonRows = [
      ['C', '(', ')', '⌫'],
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '-'],
      ['0', '.', '=', '+'],
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE6EBF0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(),

              // Expression Display
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(2, 2),
                      blurRadius: 8,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-2, -2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Expression
                    SizedBox(
                      height: 40,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Consumer<CalculatorModel>(
                          builder: (context, model, child) {
                            return Text(
                              model.expression.isEmpty ? ' ' : model.expression,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Output
                    SizedBox(
                      height: 65,
                      child: Consumer<CalculatorModel>(
                        builder: (context, model, child) {
                          final isError = model.output.startsWith('Error');
                          final outputLength = model.output.length;

                          // Dynamic font size based on output length
                          double fontSize;
                          if (isError) {
                            fontSize = 20;
                          } else if (outputLength <= 8) {
                            fontSize = 44;
                          } else if (outputLength <= 12) {
                            fontSize = 36;
                          } else if (outputLength <= 16) {
                            fontSize = 30;
                          } else if (outputLength <= 20) {
                            fontSize = 26;
                          } else {
                            fontSize = 22;
                          }

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                model.output,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: isError
                                      ? Colors.red.shade600
                                      : Colors.black87,
                                  letterSpacing: isError
                                      ? 0
                                      : (fontSize > 30 ? 1.5 : 1),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

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
                              padding: const EdgeInsets.all(6.0),
                              child: CalculatorButton(
                                text: label,
                                onTap: () => context
                                    .read<CalculatorModel>()
                                    .handleButtonPress(label),
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

  bool get isOperator => ['+', '-', '×', '÷', '(', ')'].contains(text);

  bool get isSpecial => text == 'C' || text == '⌫';

  Color get buttonColor {
    if (text == 'C') {
      return Colors.redAccent;
    } else if (text == '⌫') {
      return Colors.orange.shade400;
    } else if (text == '=') {
      return Colors.green.shade500;
    } else if (isOperator) {
      return Colors.indigo.shade400;
    } else {
      return Colors.white;
    }
  }

  Color get textColor {
    if (isSpecial || text == '=' || isOperator) {
      return Colors.white;
    } else {
      return Colors.black87;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 8,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.grey.shade400,
                offset: const Offset(4, 4),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: text == '⌫'
                    ? 24
                    : (isOperator || isSpecial ? 28 : 24),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
