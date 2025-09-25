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
    // Validación de campos vacíos y numéricos
    String n1 = _controllerNumero1.text.trim();
    String n2 = _controllerNumero2.text.trim();
    if (op == '√') {
      if (n1.isEmpty || double.tryParse(n1) == null) {
        _showError('Por favor ingresa un número válido para la raíz.');
        return;
      }
    } else {
      if (n1.isEmpty ||
          n2.isEmpty ||
          double.tryParse(n1) == null ||
          double.tryParse(n2) == null) {
        _showError('Por favor ingresa ambos números válidos.');
        return;
      }
    }

    setState(() {
      numero1 = double.tryParse(n1) ?? 0;
      numero2 = double.tryParse(n2) ?? 0;
      operacion = op;
      detalleOperacion = '';
      switch (op) {
        case '+':
          resultado = numero1 + numero2;
          detalleOperacion = '$numero1 + $numero2 = $resultado';
          break;
        case '−':
        case '-':
          resultado = numero1 - numero2;
          detalleOperacion = '$numero1 − $numero2 = $resultado';
          break;
        case '×':
          resultado = numero1 * numero2;
          detalleOperacion = '$numero1 × $numero2 = $resultado';
          break;
        case '÷':
          _manejarDivision(numero1, numero2);
          break;
        case '^':
          resultado = math.pow(numero1, numero2).toDouble();
          detalleOperacion = '$numero1^$numero2 = $resultado';
          break;
        case '√':
          if (numero2 == 0) numero2 = 2; // Raíz cuadrada por defecto
          if (numero1 >= 0 && numero2 > 0) {
            resultado = math.pow(numero1, 1 / numero2).toDouble();
            detalleOperacion =
                '${numero2.toInt()}√$numero1 = ${resultado.toStringAsFixed(4)}';
          } else {
            detalleOperacion =
                'Error: Raíz inválida (número negativo o índice no positivo)';
            resultado = 0;
          }
          break;
      }
    });
  }

  void _showError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  void _manejarDivision(double dividendo, double divisor) {
    if (divisor == 0) {
      // Manejo especial para división por cero
      resultado = double.infinity;
      detalleOperacion = 'Error: División por cero no definida';

      // Mostrar diálogo de error específico
      _mostrarDialogoDivisionPorCero(dividendo);

      // También mostrar SnackBar para feedback inmediato
      _showError('⚠️ Error: No se puede dividir por cero');
    } else if (divisor.abs() < 0.0000001) {
      // Manejo para números muy pequeños que pueden causar problemas
      resultado = double.infinity;
      detalleOperacion = 'Error: División por número demasiado pequeño';
      _showError('⚠️ Error: El divisor es demasiado pequeño');
    } else {
      // División normal
      double cociente = dividendo / divisor;
      double residuo = dividendo % divisor;
      resultado = cociente;

      detalleOperacion =
          '$dividendo ÷ $divisor = ${cociente.toStringAsFixed(4)}';

      // Mostrar detalles adicionales solo si hay residuo significativo
      if (residuo.abs() > 0.0001) {
        detalleOperacion += '\nCociente: ${cociente.toStringAsFixed(4)}';
        detalleOperacion += '\nResiduo: ${residuo.toStringAsFixed(4)}';
      }

      // Verificar si el resultado es muy grande
      if (cociente.abs() > 1e10) {
        detalleOperacion += '\n⚠️ Resultado muy grande';
      }
    }
  }

  void _mostrarDialogoDivisionPorCero(double dividendo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 30),
              const SizedBox(width: 10),
              const Text(
                '¡Error Matemático!',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'División por cero no está definida en matemáticas.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Operación intentada: $dividendo ÷ 0',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• No existe un número que multiplicado por 0 dé un resultado diferente de 0',
                    ),
                    const Text('• El resultado tiende al infinito'),
                    const Text('• Intenta usar un divisor diferente de cero'),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                // Limpiar el segundo campo automáticamente
                _controllerNumero2.clear();
              },
              icon: const Icon(Icons.refresh, color: Colors.blue),
              label: const Text('Corregir'),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.check, color: Colors.green),
              label: const Text('Entendido'),
            ),
          ],
        );
      },
    );
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

  Widget _buildCalculatorButton(
    String symbol,
    Color color, {
    bool isWide = false,
  }) {
    return Expanded(
      flex: isWide ? 2 : 1,
      child: Container(
        height: 50,
        margin: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          onPressed: () => calcular(symbol),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 3,
            shadowColor: Colors.black26,
            padding: EdgeInsets.zero,
          ),
          child: Text(
            symbol,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        title: const Text('🧮 Calculadora Pro'),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 10,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Título de bienvenida
            Container(
              padding: const EdgeInsets.all(15),
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

            const SizedBox(height: 15),

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

            const SizedBox(height: 15),

            // Campo para el segundo número
            TextField(
              controller: _controllerNumero2,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Segundo número / Exponente / Índice de raíz',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.looks_two),
                helperText: 'Para √, deja vacío para raíz cuadrada',
              ),
            ),

            const SizedBox(height: 15),

            // Teclado de calculadora compacto
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Fila 1: Funciones especiales
                  Row(
                    children: [
                      _buildCalculatorButton('^', Colors.blue[700]!),
                      _buildCalculatorButton('√', Colors.blue[700]!),
                      _buildCalculatorButton('÷', Colors.orange[600]!),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Fila 2: Multiplicación y resta
                  Row(
                    children: [
                      _buildCalculatorButton('×', Colors.orange[600]!),
                      _buildCalculatorButton('−', Colors.orange[600]!),
                      _buildCalculatorButton('+', Colors.orange[600]!),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

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
                    ] else ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[300]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red[600], size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                resultado == double.infinity
                                    ? 'INDEFINIDO (∞)'
                                    : 'ERROR',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            const SizedBox(height: 15),

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
