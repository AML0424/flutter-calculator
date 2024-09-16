import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';

  void _addToExpression(String value) {
    List<String> operators = ['+', '-', '*', '/', '^']; // Added '^' for exponentiation
    setState(() {
      if (_expression.isNotEmpty && operators.contains(value)) {
        _expression += ' ';
      }

      _expression += value;

      if (_expression.isNotEmpty && operators.contains(value)) {
        _expression += ' ';
      }
    });
  }

  void _calculateResult() {
    try {
      final result = evalExpression(_expression);
      setState(() {
        _result = result.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  double evalExpression(String expression) {
    List<String> tokens = expression.split(' ');
    List<String> operators = ['+', '-', '*', '/', '^']; // Added '^' for exponentiation
    List<String> output = [];
    List<String> stack = [];

    for (String token in tokens) {
      if (!operators.contains(token)) {
        output.add(token);
      } else {
        while (stack.isNotEmpty &&
            operators.contains(stack.last) &&
            getPrecedence(token) <= getPrecedence(stack.last)) {
          output.add(stack.removeLast());
        }
        stack.add(token);
      }
    }

    while (stack.isNotEmpty) {
      output.add(stack.removeLast());
    }

    return evaluatePostfix(output);
  }

  int getPrecedence(String operator) {
    if (operator == '+' || operator == '-') {
      return 1;
    } else if (operator == '*' || operator == '/') {
      return 2;
    } else if (operator == '^') { // Added precedence for '^' (exponentiation)
      return 3;
    } else {
      return 0;
    }
  }

  double evaluatePostfix(List<String> postfix) {
    List<String> operators = ['+', '-', '*', '/', '^']; // Added '^' for exponentiation
    List<double> stack = [];
    double result;

    for (String token in postfix) {
      if (!operators.contains(token)) {
        stack.add(double.parse(token));
      } else {
        double operand2 = stack.removeLast();
        double operand1 = stack.removeLast();

        if (token == '+') {
          result = operand1 + operand2;
          stack.add(result);
        } else if (token == '-') {
          result = operand1 - operand2;
          stack.add(result);
        } else if (token == '*') {
          result = operand1 * operand2;
          stack.add(result);
        } else if (token == '/') {
          result = operand1 / operand2;
          stack.add(result);
        } else if (token == '^') { // Added case for '^' (exponentiation)
          result = operand1;
          for (int i = 0; i < operand2 - 1; i++) {
            result *= operand1;
          }
          stack.add(result);
        }
      }
    }

    return stack.first;
  }

  void _clearExpression() {
    setState(() {
      _expression = '';
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Calculator'),
      ),
      body: Container(
        width: 400, // Set the desired width constraint
        height: 600, // Set the desired height constraint
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.bottomRight,
                child: Text(
                  '$_expression = $_result',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Divider(height: 1),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              children: [
                CalculatorButton(
                  text: '7',
                  onPressed: () => _addToExpression('7'),
                ),
                CalculatorButton(
                  text: '8',
                  onPressed: () => _addToExpression('8'),
                ),
                CalculatorButton(
                  text: '9',
                  onPressed: () => _addToExpression('9'),
                ),
                CalculatorButton(
                  text: '/',
                  onPressed: () => _addToExpression('/'),
                ),
                CalculatorButton(
                  text: '4',
                  onPressed: () => _addToExpression('4'),
                ),
                CalculatorButton(
                  text: '5',
                  onPressed: () => _addToExpression('5'),
                ),
                CalculatorButton(
                  text: '6',
                  onPressed: () => _addToExpression('6'),
                ),
                CalculatorButton(
                  text: '*',
                  onPressed: () => _addToExpression('*'),
                ),
                CalculatorButton(
                  text: '1',
                  onPressed: () => _addToExpression('1'),
                ),
                CalculatorButton(
                  text: '2',
                  onPressed: () => _addToExpression('2'),
                ),
                CalculatorButton(
                  text: '3',
                  onPressed: () => _addToExpression('3'),
                ),
                CalculatorButton(
                  text: '-',
                  onPressed: () => _addToExpression('-'),
                ),
                CalculatorButton(
                  text: '0',
                  onPressed: () => _addToExpression('0'),
                ),
                CalculatorButton(
                  text: '.',
                  onPressed: () => _addToExpression('.'),
                ),
                CalculatorButton(
                  text: '=',
                  onPressed: _calculateResult,
                ),
                CalculatorButton(
                  text: '+',
                  onPressed: () => _addToExpression('+'),
                ),
                CalculatorButton(
                  text: 'C',
                  onPressed: _clearExpression,
                ),
                CalculatorButton(
                  text: '^', // Added button for exponentiation
                  onPressed: () => _addToExpression('^'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CalculatorButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}