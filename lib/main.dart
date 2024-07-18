import 'package:flutter/material.dart';
import 'package:game_guess_number/widgets/hamburguer_menu.dart';
import 'package:game_guess_number/widgets/custom_botton_navigation_bar.dart';
import 'package:game_guess_number/widgets/reusable_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guess Game Number',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Adivina el Nùmero'),
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
  //Lista que guarda numeros mayores
  final List<int> _greaterNumbers = [];
  //Lista que guarda numeros menores
  final List<int> _lesserNumbers = [];
  String _message = '';
  double _difficulty = 0;

  String _messageText = '';
  Color _messageColor = Colors.black; // Color por defecto
  //bool _showConfettiAnimation = false; // variable para controlar la animación de confeti

  @override
  void initState() {
    super.initState();
    _setDifficulty(0);
  }

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
  void _resetGame() {
    _targetNumber = (1 + (_maxNumber * (new DateTime.now().millisecondsSinceEpoch % 1000) / 1000)).toInt();
    _attemptsLeft = _maxAttempts;
    _history.clear();
    _greaterNumbers.clear();
    _lesserNumbers.clear();
    _message = '';
    _messageText = '';
    _controller.clear();
  }

  void _checkGuess() {
    int? guess = int.tryParse(_controller.text);
    if (guess == null) {
      setState(() {
        //_message = 'Por favor, ingresa un número válido.';
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
        //_showConfettiAnimation = true;
      } else if (_attemptsLeft == 0) {
        _messageText = 'Lo siento, no te quedan intentos. El número era $_targetNumber.';
        _messageColor = failureColor;
        //_showConfettiAnimation = false;
      } else if (guess < _targetNumber) {
        _messageText = 'El número es mayor.';
        _messageColor = failureColor;
        //_showConfettiAnimation = false;
        //_lesserNumbers.add(guess);
      } else {
        _messageText = 'El número es menor.';
        _messageColor = failureColor;
        //_showConfettiAnimation = false;
        //_greaterNumbers.add(guess);
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
                            borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
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
                      Text('$_attemptsLeft')
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20), // Espacio horizontal entre columnas
            ElevatedButton(
              onPressed: _checkGuess,
              child: Text('Adivinar'),
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
                ? SizedBox(
                  height: 100, // Altura mínima cuando el historial está vacío
                    child: Center(
                      child: Text('No hay historial'),
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // sombra card
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