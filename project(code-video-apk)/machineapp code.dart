import 'package:flutter/material.dart'
    show
        Alignment,
        AppBar,
        Brightness,
        BuildContext,
        Center,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        Divider,
        EdgeInsets,
        Expanded,
        FontWeight,
        GestureDetector,
        Key,
        ListView,
        MainAxisAlignment,
        MaterialApp,
        Row,
        Scaffold,
        SingleChildScrollView,
        SizedBox,
        State,
        StatefulWidget,
        StatelessWidget,
        Text,
        TextStyle,
        ThemeData,
        VoidCallback,
        Widget,
        runApp;
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MachineApp());
}

class MachineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Machine App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';
  String _notes = '';

  void _calculateResult() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      setState(() {
        _result = exp.evaluate(EvaluationType.REAL, cm).toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  void _calculateLimit() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      setState(() {
        _result = 'Limit: ' + exp.evaluate(EvaluationType.REAL, cm).toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  void _appendToExpression(String value) {
    setState(() {
      if (value == 'C') {
        // If the value is 'C', clear the expression
        _expression = '';
        _result = ''; // Also clear the result when clearing the expression
      } else {
        _expression += value;
      }
    });
  }

  void _saveNote() {
    if (_notes.isNotEmpty) {
      setState(() {
        _notes += '\n';
      });
    }
    setState(() {
      _notes += _expression + ' = ' + _result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Machine App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[900],
              padding: EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _result,
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 0, color: Colors.white),
          Expanded(
            child: ListView.builder(
              itemCount:
                  5, // Assuming 5 rows of buttons, you can change this according to your design
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CalculatorButton(
                      text: index == 0
                          ? '7'
                          : index == 1
                              ? '8'
                              : index == 2
                                  ? '9'
                                  : index == 3
                                      ? '/'
                                      : 'C',
                      onTap: () => _appendToExpression(index == 3
                          ? '/'
                          : index == 4
                              ? 'C'
                              : '${index + 7}'),
                    ),
                    CalculatorButton(
                      text: index == 0
                          ? '4'
                          : index == 1
                              ? '5'
                              : index == 2
                                  ? '6'
                                  : index == 3
                                      ? '*'
                                      : 'lim',
                      onTap: () => _appendToExpression(index == 3
                          ? '*'
                          : index == 4
                              ? 'lim'
                              : '${index + 4}'),
                    ),
                    CalculatorButton(
                      text: index == 0
                          ? '1'
                          : index == 1
                              ? '2'
                              : index == 2
                                  ? '3'
                                  : index == 3
                                      ? '-'
                                      : '.',
                      onTap: () => _appendToExpression(index == 4
                          ? '.'
                          : index == 3
                              ? '-'
                              : '${index + 1}'),
                    ),
                    if (index == 0)
                      CalculatorButton(
                        text: '0',
                        onTap: () => _appendToExpression('0'),
                      ),
                    if (index == 1)
                      CalculatorButton(
                        text: '=',
                        onTap: _calculateResult,
                        isEqualsButton: true,
                      ),
                    if (index == 2)
                      CalculatorButton(
                        text: '+',
                        onTap: () => _appendToExpression('+'),
                      ),
                    if (index == 3)
                      CalculatorButton(
                        text: 'Save',
                        onTap: _saveNote,
                        isNoteButton: true,
                      ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[900],
              child: SingleChildScrollView(
                child: Text(
                  _notes,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final bool isEqualsButton;
  final bool isNoteButton;
  final VoidCallback onTap;

  const CalculatorButton({
    Key? key,
    required this.text,
    this.isEqualsButton = false,
    this.isNoteButton = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: isEqualsButton
              ? Colors.orange
              : isNoteButton
                  ? Colors.green
                  : Colors.grey[800],
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}