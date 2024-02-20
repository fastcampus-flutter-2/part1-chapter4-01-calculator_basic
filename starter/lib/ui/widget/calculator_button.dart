import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final bool isSelected;
  final Function(String) onTap;

  const CalculatorButton({
    super.key,
    required this.text,
    this.backgroundColor = const Color.fromRGBO(90, 90, 90, 1.0),
    this.isSelected = false,
    required this.onTap,
  });

  factory CalculatorButton.simple({
    required String text,
    required Function(String) onTap,
  }) {
    return CalculatorButton(
      text: text,
      onTap: onTap,
    );
  }

  factory CalculatorButton.complex({
    required String text,
    required Function(String) onTap,
  }) {
    return CalculatorButton(
      text: text,
      backgroundColor: const Color.fromRGBO(30, 30, 30, 1.0),
      onTap: onTap,
    );
  }

  factory CalculatorButton.operator({
    required String text,
    String operator = '',
    required Function(String) onTap,
  }) {
    return CalculatorButton(
      text: text,
      backgroundColor: const Color.fromRGBO(255, 158, 11, 1.0),
      isSelected: text == operator,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: () => onTap.call(text),
        child: SizedBox(
          height: 50,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withOpacity(isSelected ? 1.0 : 0.1),
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
