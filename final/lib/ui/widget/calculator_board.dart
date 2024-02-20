import 'package:flutter/material.dart';

class CalculatorBoard extends StatelessWidget {
  final String number;

  const CalculatorBoard({
    super.key,
    this.number = '0',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(55, 39, 36, 1.0),
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: FittedBox(
              child: Text(
                number.isNotEmpty ? number : '0',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
