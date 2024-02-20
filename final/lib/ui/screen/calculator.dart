import 'package:calculator_basic_final/ui/widget/widget.dart';
import 'package:calculator_basic_final/util/util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorViewModel _viewModel = CalculatorViewModel(Calculator());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _viewModel.load();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Calculator'),
      ),
      body: ValueListenableBuilder<Calculator>(
        valueListenable: _viewModel,
        builder: (context, calculator, child) => Column(
          children: [
            CalculatorBoard(
              number: calculator.result,
            ),
            Row(
              children: [
                Expanded(
                  child: CalculatorButton.complex(
                    text: 'AC',
                    onTap: (buttonText) => _perform(
                      buttonText,
                      save: true,
                    ),
                  ),
                ),
                Expanded(
                  child: CalculatorButton.complex(
                    text: '+/-',
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
                Expanded(
                  child: CalculatorButton.complex(
                    text: '<',
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
                Expanded(
                  child: CalculatorButton.operator(
                    text: '/',
                    operator: calculator.operator,
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CalculatorButton.simple(
                    text: '7',
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
                Expanded(
                  child: CalculatorButton.simple(
                    text: '8',
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
                Expanded(
                  child: CalculatorButton.simple(
                    text: '9',
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
                Expanded(
                  child: CalculatorButton.operator(
                    text: 'x',
                    operator: calculator.operator,
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CalculatorButton.simple(
                    text: '4',
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
                Expanded(
                  child: CalculatorButton.simple(
                    text: '5',
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
                Expanded(
                  child: CalculatorButton.simple(
                    text: '6',
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
                Expanded(
                  child: CalculatorButton.operator(
                    text: '-',
                    operator: calculator.operator,
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CalculatorButton.simple(
                    text: '1',
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
                Expanded(
                  child: CalculatorButton.simple(
                    text: '2',
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
                Expanded(
                  child: CalculatorButton.simple(
                    text: '3',
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
                Expanded(
                  child: CalculatorButton.operator(
                    text: '+',
                    operator: calculator.operator,
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CalculatorButton.simple(
                    text: '0',
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
                Expanded(
                  child: CalculatorButton.simple(
                    text: '.',
                    onTap: (buttonText) => _perform(buttonText),
                  ),
                ),
                Expanded(
                  child: CalculatorButton.operator(
                    text: '=',
                    onTap: (buttonText) => _perform(
                      buttonText,
                      save: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _perform(
    String buttonText, {
    bool save = false,
  }) async {
    _viewModel.calculate(buttonText);

    if (save) {
      await _viewModel.save();
    }
  }
}

abstract class ICalculatorLocalDataSource {
  String get key;

  Future<void> setString(String value);

  Future<String?> getString();
}

class CalculatorLocalDataSource implements ICalculatorLocalDataSource {
  @override
  String get key => 'calculator';

  @override
  Future<void> setString(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Future<String?> getString() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}

class CalculatorDataSource {
  final ICalculatorLocalDataSource _localDataSource;

  CalculatorDataSource(this._localDataSource);

  Future<void> save(String value) {
    return _localDataSource.setString(value);
  }

  Future<String> fetch() async {
    final String value = await _localDataSource.getString() ?? '';
    return value;
  }
}

class Calculator {
  String _result;

  String get result => _result;

  Calculator({
    String? result,
  }) : _result = result ?? '0';

  String _num1 = '0';
  String _num2 = '0';

  String _operator = '';

  String get operator => _operator;

  void calculate(String buttonText) {
    switch (buttonText) {
      case 'AC':
        _performClear();
      case '+/-':
        _performConvert();
      case '<':
        _performBackspace();
      case '+':
      case '-':
      case 'x':
      case '/':
        _performOperator(buttonText);
      case '=':
        _performCalculator();
      case '.':
        _performDecimalPoint();
      default:
        _performInputNumber(buttonText);
    }
  }

  void _performClear() {
    _result = '0';
    _num1 = '0';
    _num2 = '0';
    _operator = '';
  }

  void _performConvert() {
    if (_result == '0') return;
    if (_result.startsWith('-')) {
      _result = _result.replaceFirst('-', '');
    } else {
      _result = '-$_result';
    }
  }

  void _performBackspace() {
    if (_result.length > 2) {
      _result = _result.substring(0, _result.length - 1);
      return;
    }

    if (_result.startsWith('-')) {
      _result = '0';
      return;
    }

    if (_result.length > 1) {
      _result = _result.substring(0, _result.length - 1);
    } else {
      _result = '0';
    }
  }

  void _performOperator(String operator) {
    if (_operator.isEmpty) {
      _num1 = _result;
      _result = '0';
    }

    _operator = operator;
  }

  void _performCalculator() {
    final double number;
    switch (_operator) {
      case '+':
        number = double.parse(_num1) + double.parse(_num2);
      case '-':
        number = double.parse(_num1) - double.parse(_num2);
      case 'x':
        number = double.parse(_num1) * double.parse(_num2);
      case '/':
        number = double.parse(_num1) / double.parse(_num2);
      default:
        number = double.parse(_result);
    }

    final String result = IFormatter.normalize(number);
    _result = result;
    _num1 = result;
    _num2 = '0';
    _operator = '';
  }

  void _performDecimalPoint() {
    if (_result.contains('.')) return;
    _result = '$_result.';
  }

  void _performInputNumber(String number) {
    final String result = _result == '0' ? number : _result + number;

    if (_operator.isNotEmpty) {
      _num2 = result;
    }

    _result = result;
  }
}

class CalculatorViewModel extends ValueNotifier<Calculator> {
  CalculatorViewModel(super.calculator);

  Future<void> load() async {
    final String result = await CalculatorDataSource(CalculatorLocalDataSource()).fetch();
    value = Calculator(result: result);
  }

  Future<void> save() async {
    await CalculatorDataSource(CalculatorLocalDataSource()).save(value.result);
  }

  void calculate(String buttonText) {
    value.calculate(buttonText);
    notifyListeners();
  }
}
