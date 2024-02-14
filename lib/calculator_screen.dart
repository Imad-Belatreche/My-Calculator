import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_calculator/button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = '';
  String operator = '';
  String number2 = '';

  void onButtonTap(String value) {
    if (value == Buttons.del) {
      delete();
      return;
    }
    if (value == Buttons.clr) {
      clearAll();
      return;
    }
    if (value == Buttons.calculate) {
      calculate();
      return;
    }
    appendValue(value);
  }

  // #########################
  // Perform the calculations

  void calculate() {
    if (number1.isEmpty || number2.isEmpty || operator.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);
    double result = 0;

    switch (operator) {
      case Buttons.add:
        result = num1 + num2;
        break;
      case Buttons.subtract:
        result = num1 - num2;
        break;
      case Buttons.multiply:
        result = num1 * num2;
        break;
      case Buttons.divide:
        result = num1 / num2;
        break;
      case Buttons.xten:
        result = num1 * pow(10, num2);
        break;
      default:
        break;
    }

    setState(() {
      number1 = '$result';
      if (number1.endsWith('.0')) {
        number1 = number1.substring(0, number1.length - 2);
      }
      number2 = '';
      operator = '';
    });
  }

  // #########################
  // Delete one number from expression

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operator.isNotEmpty) {
      operator = '';
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

  // #########################
  // Clear all numbers and operators

  void clearAll() {
    setState(() {
      number1 = '';
      operator = '';
      number2 = '';
    });
  }

  // #########################
  // Append enterd values
  void appendValue(String value) {
    // if operand is pressed and is not '.'
    if (value != Buttons.dot && int.tryParse(value) == null) {
      // operand button pressed
      if (operator.isNotEmpty && number2.isNotEmpty) {
        // Calculate the equation befor assigning the new operand
        calculate();
      }
      operator = value;
    }
    // assign value to number 1
    else if (number1.isEmpty || operator.isEmpty) {
      // check if value is '.'
      if (value == Buttons.dot && number1.contains(Buttons.dot)) return;
      // when pressing '.' we display it as '0.'
      if (value == Buttons.dot && number1.isEmpty || number1 == Buttons.n0) {
        value = '0.';
      }
      number1 += value;
    }
    // assign value to number 2
    else if (number2.isEmpty || operator.isNotEmpty) {
      // check if value is '.'
      if (value == Buttons.dot && number2.contains(Buttons.dot)) return;
      // when pressing '.' we display it as '0.'
      if (value == Buttons.dot && number2.isEmpty || number2 == Buttons.n0) {
        value = '0.';
      }
      number2 += value;
    } else if (value == Buttons.clr) {
      number1 = '';
      operator = '';
      number2 = '';
      value = '';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '$number1$operator$number2'.isEmpty
                        ? '0'
                        : '$number1$operator$number2',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            // input buttons
            Wrap(
              children: Buttons.buttonValues.map((value) {
                if (screenSize.width > 300) {
                  return SizedBox(
                    height: (screenSize.width - 100) / 4,
                    width: (screenSize.width) / 5,
                    child: buildButton(value),
                  );
                } else {
                  return SizedBox(
                    height: (screenSize.width) / 4,
                    width: (screenSize.width) / 5,
                    child: buildButton(value),
                  );
                }
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        clipBehavior: Clip.hardEdge,
        shape: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        color: [Buttons.clr, Buttons.del].contains(value)
            ? Colors.deepOrange
            : Colors.white,
        child: InkWell(
          onTap: () => onButtonTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
