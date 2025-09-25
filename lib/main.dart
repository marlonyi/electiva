import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Primera App'),
          backgroundColor: Colors.indigo,
        ),
        body: const PaginaPrincipal(),
      ),
    );
  }
}

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.favorite, color: Colors.red, size: 30.0),
                SizedBox(width: 10),
                Text(
                  '¡Hola, Flutter!',
                  style: TextStyle(fontSize: 28.0, color: Colors.indigo),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SegundaPantalla(),
                ),
              );
              const snackBar = SnackBar(
                content: Text('¡Bienvenido a la segunda pagina! 🎉'),
                duration: Duration(seconds: 6),
                backgroundColor: Colors.indigo,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text('Presióname'),
          ),
        ],
      ),
    );
  }
}

class SegundaPantalla extends StatelessWidget {
  const SegundaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segunda Pantalla'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mensaje de bienvenida
              Container(
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.indigo, width: 2),
                ),
                child: const Text(
                  '¡Bienvenido a la clase de Electiva!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 30),

              // Pregunta
              const Text(
                '¿Quieres entrar a la calculadora?',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Botones de respuesta
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Botón SÍ
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PantallaCalculadora(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text('SÍ 👍', style: TextStyle(fontSize: 18)),
                  ),

                  // Botón NO
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.sentiment_dissatisfied,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 8),
                                const Text('¡Ouch!'),
                              ],
                            ),
                            content: const Text(
                              'Tampoco te queríamos aquí 😏\n\n¡Es broma! Esperamos que cambies de opinión pronto.',
                            ),
                            backgroundColor: Colors.orange[50],
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('😅 Entendido'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text('NO 👎', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Botón volver
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Volver atrás'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PantallaCalculadora extends StatefulWidget {
  const PantallaCalculadora({super.key});

  @override
  State<PantallaCalculadora> createState() => _PantallaCalculadoraState();
}

class _PantallaCalculadoraState extends State<PantallaCalculadora> {
  double numero1 = 0;
  double numero2 = 0;
  double resultado = 0;
  String operacion = '';
  String detalleOperacion = '';
  bool esperandoSegundoNumero = false;

  final TextEditingController _controllerNumero1 = TextEditingController();
  final TextEditingController _controllerNumero2 = TextEditingController();

  void calcular(String op) {
    // Validación para operaciones que solo requieren un número
    if (op == '√') {
      if (_controllerNumero1.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Por favor ingresa el número!'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    } else {
      // Validación para operaciones que requieren dos números
      if (_controllerNumero1.text.isEmpty || _controllerNumero2.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Por favor ingresa ambos números!'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    setState(() {
      numero1 = double.tryParse(_controllerNumero1.text) ?? 0;
      numero2 = double.tryParse(_controllerNumero2.text) ?? 0;
      operacion = op;
      detalleOperacion = '';

      switch (op) {
        case '+':
          resultado = numero1 + numero2;
          detalleOperacion = '$numero1 + $numero2 = $resultado';
          break;
        case '-':
          resultado = numero1 - numero2;
          detalleOperacion = '$numero1 - $numero2 = $resultado';
          break;
        case '×':
          resultado = numero1 * numero2;
          detalleOperacion = '$numero1 × $numero2 = $resultado';
          break;
        case '÷':
          if (numero2 != 0) {
            double cociente = numero1 / numero2;
            double residuo = numero1 % numero2;
            resultado = cociente;
            detalleOperacion =
                '$numero1 ÷ $numero2 = ${cociente.toStringAsFixed(2)}';
            if (residuo != 0) {
              detalleOperacion += ' (residuo: ${residuo.toStringAsFixed(2)})';
            }
          } else {
            detalleOperacion = 'Error: División por cero';
            resultado = 0;
          }
          break;
        case '^':
          resultado = math.pow(numero1, numero2).toDouble();
          detalleOperacion = '$numero1^$numero2 = $resultado';
          break;
        case '√':
          if (numero2 == 0) numero2 = 2; // Raíz cuadrada por defecto
          if (numero1 >= 0) {
            resultado = math.pow(numero1, 1 / numero2).toDouble();
            detalleOperacion =
                '${numero2.toInt()}√$numero1 = ${resultado.toStringAsFixed(4)}';
          } else {
            detalleOperacion =
                'Error: No se puede calcular raíz de número negativo';
            resultado = 0;
          }
          break;
      }
    });
  }

  void limpiar() {
    setState(() {
      _controllerNumero1.clear();
      _controllerNumero2.clear();
      numero1 = 0;
      numero2 = 0;
      resultado = 0;
      operacion = '';
      detalleOperacion = '';
    });
  }

  Widget _buildOperationButton(String symbol, String name, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () => calcular(symbol),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                symbol,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(name, style: const TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerNumero1.dispose();
    _controllerNumero2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧮 Calculadora Científica'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Título de bienvenida
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: const Text(
                '¡Gracias por hacer parte de la clase!\nAquí tienes tu calculadora 🎉',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // Campo para el primer número
            TextField(
              controller: _controllerNumero1,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Primer número',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.looks_one),
              ),
            ),

            const SizedBox(height: 20),

            // Campo para el segundo número / exponente / base
            TextField(
              controller: _controllerNumero2,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Segundo número / Exponente / Índice de raíz',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.looks_two),
                helperText: 'Para √, deja vacío para raíz cuadrada por defecto',
              ),
            ),

            const SizedBox(height: 20),

            // Botones de operaciones básicas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOperationButton('+', 'Sumar', Colors.blue),
                _buildOperationButton('-', 'Restar', Colors.red),
                _buildOperationButton('×', 'Multiplicar', Colors.green),
                _buildOperationButton('÷', 'Dividir', Colors.orange),
              ],
            ),

            const SizedBox(height: 10),

            // Botones de operaciones avanzadas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOperationButton('^', 'Potencia', Colors.purple),
                _buildOperationButton('√', 'Raíz', Colors.teal),
              ],
            ),

            const SizedBox(height: 20),

            // Mostrar resultado
            if (operacion.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      '📊 Resultado de la Operación',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        detalleOperacion.isNotEmpty
                            ? detalleOperacion
                            : 'Calculando...',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (!detalleOperacion.contains('Error')) ...[
                      const SizedBox(height: 10),
                      Text(
                        '= ${resultado.toStringAsFixed(4)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botón limpiar
                ElevatedButton(
                  onPressed: limpiar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('🗑️ Limpiar'),
                ),

                // Botón volver
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('⬅️ Volver'),
                ),
              ],
            ),

            // Espaciado final para evitar overflow
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
