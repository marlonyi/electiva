import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  double numero1 = 0;
  double numero2 = 0;
  double resultado = 0;
  String operacion = '';
  String detalleOperacion = '';

  final TextEditingController _controllerNumero1 = TextEditingController();
  final TextEditingController _controllerNumero2 = TextEditingController();

  // Estado para saber cuál campo está activo
  bool _primerCampoActivo = true;

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
      _primerCampoActivo = true; // Resetear al primer campo
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    const Icon(Icons.calculate, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'Calculadora',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: limpiar,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Pantalla estilo glassmorphism
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Input fields row
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controllerNumero1,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Número 1',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.45),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onTap:
                                      () => setState(
                                        () => _primerCampoActivo = true,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _controllerNumero2,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Número 2',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.45),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onTap:
                                      () => setState(
                                        () => _primerCampoActivo = false,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white24, height: 18),
                          // Resultado grande
                          SizedBox(
                            height: 56,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              reverse: true,
                              child: Text(
                                detalleOperacion.isNotEmpty
                                    ? detalleOperacion
                                    : resultado != 0
                                    ? resultado.toString()
                                    : 'Aquí aparecerá el resultado',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Teclado con estilo moderno
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      children: [
                        // Row 1
                        Row(
                          children: [
                            _buildRoundButton('7'),
                            _buildRoundButton('8'),
                            _buildRoundButton('9'),
                            _buildRoundButton(
                              '÷',
                              color: Colors.deepOrangeAccent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildRoundButton('4'),
                            _buildRoundButton('5'),
                            _buildRoundButton('6'),
                            _buildRoundButton(
                              '×',
                              color: Colors.deepOrangeAccent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildRoundButton('1'),
                            _buildRoundButton('2'),
                            _buildRoundButton('3'),
                            _buildRoundButton(
                              '−',
                              color: Colors.deepOrangeAccent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildRoundButton('C', color: Colors.redAccent),
                            _buildRoundButton('0'),
                            _buildRoundButton('=', color: Colors.greenAccent),
                            _buildRoundButton(
                              '+',
                              color: Colors.deepOrangeAccent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildRoundButton(
                              '^',
                              color: Colors.lightBlueAccent,
                            ),
                            _buildRoundButton(
                              '√',
                              color: Colors.lightBlueAccent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundButton(String text, {Color color = Colors.grey}) {
    void handleTap() {
      if (text == 'C') {
        limpiar();
      } else if (text == '=') {
        // nothing special; calculations happen in calcular when operation buttons are pressed
      } else if (_isNumeric(text)) {
        _addDigit(text);
      } else {
        calcular(text);
      }
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        height: 64,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: handleTap,
            splashColor: Colors.white24,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.95), color.withOpacity(0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isNumeric(String text) {
    return double.tryParse(text) != null;
  }

  void _addDigit(String digit) {
    setState(() {
      if (_primerCampoActivo) {
        _controllerNumero1.text += digit;
      } else {
        _controllerNumero2.text += digit;
      }
    });
  }

  @override
  void dispose() {
    _controllerNumero1.dispose();
    _controllerNumero2.dispose();
    super.dispose();
  }
}
