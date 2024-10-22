import 'dart:math';  // Importa la clase Random

import 'package:flutter/material.dart';
import 'package:game_guess_number/widgets/hamburguer_menu.dart';
import 'package:game_guess_number/widgets/custom_botton_navigation_bar.dart';
import 'package:game_guess_number/widgets/reusable_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guess Game Number',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Adivina el Número'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  late int _targetNumber;
  late int _attemptsLeft;
  late int _maxNumber;
  late int _maxAttempts;
  final List<int> _history = [];
  final List<int> _greaterNumbers = [];
  final List<int> _lesserNumbers = [];
  String _message = '';
  double _difficulty = 0;

  String _messageText = '';
  Color _messageColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _setDifficulty(0);
  }

  // Función para ajustar la dificultad y los límites
  void _setDifficulty(double value) {
    setState(() {
      _difficulty = value;
      if (_difficulty == 0) {
        _maxNumber = 10;
        _maxAttempts = 5;
      } else if (_difficulty == 1) {
        _maxNumber = 20;
        _maxAttempts = 8;
      } else if (_difficulty == 2) {
        _maxNumber = 100;
        _maxAttempts = 15;
      } else if (_difficulty == 3) {
        _maxNumber = 1000;
        _maxAttempts = 25;
      }
      _resetGame();
    });
  }

  // Nueva función para generar el número aleatorio dependiendo de los límites
  void _generateRandomNumber({int? customMax, int? customMin}) {
    Random random = Random();

    int minNumber = customMin ?? 1;  // Usa 1 como mínimo si no se pasa customMin
    int maxNumber = customMax ?? _maxNumber;  // Usa _maxNumber si no se pasa customMax

    // Generar el número aleatorio en el rango [minNumber, maxNumber]
    _targetNumber = random.nextInt(maxNumber - minNumber + 1) + minNumber;
  }

  // Función para reiniciar el juego
  void _resetGame({int? customMax, int? customMin}) {
    _generateRandomNumber(customMax: customMax, customMin: customMin);  // Genera el número objetivo
    _attemptsLeft = _maxAttempts;
    _history.clear();
    _greaterNumbers.clear();
    _lesserNumbers.clear();
    _message = '';
    _messageText = '';
    _controller.clear();
  }

  // Función para verificar el número ingresado por el usuario
  void _checkGuess() {
    int? guess = int.tryParse(_controller.text);
    if (guess == null) {
      setState(() {
        _messageText = 'Por favor, ingresa un número válido.';
      });
      return;
    }

    setState(() {
      _history.add(guess);
      _attemptsLeft--;
      const Color successColor = Colors.green;
      const Color failureColor = Colors.red;
      const Color infoColor = Colors.blue;

      if (guess == _targetNumber) {
        _messageText = '¡Felicidades! Adivinaste el número.';
        _messageColor = successColor;
      } else if (_attemptsLeft == 0) {
        _messageText = 'Lo siento, no te quedan intentos. El número era $_targetNumber.';
        _messageColor = failureColor;
      } else if (guess < _targetNumber) {
        _messageText = 'El número es mayor.';
        _messageColor = failureColor;
        _lesserNumbers.add(guess);
      } else {
        _messageText = 'El número es menor.';
        _messageColor = failureColor;
        _greaterNumbers.add(guess);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Adivina el Número'),
      ),
      endDrawer: HamburgerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(width: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Ingresa un número',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Intentos restantes: $_attemptsLeft'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: _checkGuess,
              child: const Text('Adivinar'),
            ),
            Text(
              _messageText,
              style: TextStyle(color: _messageColor),
            ),
            const Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Números menores'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Números mayores'),
                    ],
                  ),
                ),
              ],
            ),
            const Text('Historial'),
            _history.isEmpty
                ? const SizedBox(
              height: 100,
              child: Center(
                child: Text('No hay historial'),
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text('Intento ${index + 1}: ${_history[index]}'),
                    ),
                  );
                },
              ),
            ),
            Slider(
              value: _difficulty,
              min: 0,
              max: 3,
              divisions: 3,
              label: _difficulty == 0
                  ? 'Fácil'
                  : _difficulty == 1
                  ? 'Medio'
                  : _difficulty == 2
                  ? 'Avanzado'
                  : 'Extremo',
              onChanged: _setDifficulty,
            ),
          ],
        ),
      ),
    );
  }
}
