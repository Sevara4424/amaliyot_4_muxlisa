import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // Import math_expressions package

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String displayText = '0';
  String lastButton = ''; // Track the last button pressed

  // Handle button presses
  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        displayText = '0'; // Reset display
        lastButton = '';
      } else if (value == '=') {
        try {
          displayText = _evaluateExpression(displayText); // Evaluate the expression
        } catch (e) {
          displayText = 'Error';
        }
        lastButton = '=';
      } else if (_isOperator(value)) {
        // Allow operator only if last button is not an operator
        if (lastButton != '+' && lastButton != '-' && lastButton != '*' && lastButton != '/' && lastButton != '=') {
          displayText += value;
          lastButton = value;
        }
      } else {
        // Handle decimal point and leading zero cases
        if (value == '.' && displayText.contains('.')) {
          return; // Prevent multiple decimal points
        }

        if (displayText == '0' && value != '.') {
          displayText = value; // Replace the leading zero
        } else {
          displayText += value; // Append new value to the display
        }
        lastButton = value;
      }
    });
  }

  // Check if the button is an operator
  bool _isOperator(String value) {
    return value == '+' || value == '-' || value == '*' || value == '/';
  }

  // Evaluate the expression using the math_expressions library
  String _evaluateExpression(String expression) {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel contextModel = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, contextModel);
      
      // Format result to remove ".0" if it's an integer
      if (result == result.toInt()) {
        return result.toInt().toString(); // Return as integer if result is whole
      } else {
        return result.toString(); // Return as decimal if it's not a whole number
      }
    } catch (e) {
      return 'Error'; // In case of an error in evaluation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Display area for the calculator
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  displayText,
                  style: const TextStyle(fontSize: 48, color: Colors.black),
                ),
              ),
            ),
            // Calculator buttons
            Expanded(
              flex: 4,
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.2, // Adjusted aspect ratio for better button layout
                ),
                itemBuilder: (context, index) {
                  return CalculatorButton(
                    text: buttons[index],
                    onPressed: () => onButtonPressed(buttons[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Buttons for the calculator
  final List<String> buttons = [
    '7', '8', '9', '/',
    '4', '5', '6', '*',
    '1', '2', '3', '-',
    '0', '.', '=', '+',
    'C',
  ];
}

// CalculatorButton widget
class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CalculatorButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12), // Added rounded corners
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
