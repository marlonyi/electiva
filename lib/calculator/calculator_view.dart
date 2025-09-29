import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/responsive_helper.dart';

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
        height: ResponsiveHelper.isDesktop(context) ? 60 : 50,
        margin: EdgeInsets.all(
          ResponsiveHelper.getResponsiveSpacing(context, 2.0),
        ),
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
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 20),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Título de bienvenida
              Container(
                padding: ResponsiveHelper.getResponsivePadding(context),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[800]!, Colors.grey[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                child: Text(
                  '¡Gracias por hacer parte de la clase!\n🧮 Calculadora Profesional 🧮',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      18,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 15),
              ),

              // Campo para el primer número
              TextField(
                controller: _controllerNumero1,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                ),
                decoration: InputDecoration(
                  labelText: 'Primer número',
                  labelStyle: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      14,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.looks_one),
                  contentPadding: ResponsiveHelper.getResponsivePadding(
                    context,
                  ),
                ),
              ),

              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 15),
              ),

              // Campo para el segundo número
              TextField(
                controller: _controllerNumero2,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                ),
                decoration: InputDecoration(
                  labelText:
                      ResponsiveHelper.isDesktop(context)
                          ? 'Segundo número / Exponente / Índice de raíz'
                          : 'Segundo número',
                  labelStyle: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      14,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.looks_two),
                  helperText: 'Para √, deja vacío para raíz cuadrada',
                  helperStyle: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      12,
                    ),
                  ),
                  contentPadding: ResponsiveHelper.getResponsivePadding(
                    context,
                  ),
                ),
              ),

              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 15),
              ),

              // Teclado de calculadora compacto
              Container(
                padding: ResponsiveHelper.getResponsivePadding(context),
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
                    ResponsiveHelper.isDesktop(context)
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCalculatorButton('^', Colors.blue[700]!),
                            _buildCalculatorButton('√', Colors.blue[700]!),
                            _buildCalculatorButton('÷', Colors.orange[600]!),
                            _buildCalculatorButton('×', Colors.orange[600]!),
                            _buildCalculatorButton('−', Colors.orange[600]!),
                            _buildCalculatorButton('+', Colors.orange[600]!),
                          ],
                        )
                        : Column(
                          children: [
                            Row(
                              children: [
                                _buildCalculatorButton('^', Colors.blue[700]!),
                                _buildCalculatorButton('√', Colors.blue[700]!),
                                _buildCalculatorButton(
                                  '÷',
                                  Colors.orange[600]!,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                4,
                              ),
                            ),
                            Row(
                              children: [
                                _buildCalculatorButton(
                                  '×',
                                  Colors.orange[600]!,
                                ),
                                _buildCalculatorButton(
                                  '−',
                                  Colors.orange[600]!,
                                ),
                                _buildCalculatorButton(
                                  '+',
                                  Colors.orange[600]!,
                                ),
                              ],
                            ),
                          ],
                        ),
                  ],
                ),
              ),

              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 15),
              ),

              // Mostrar resultado
              if (operacion.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: ResponsiveHelper.getResponsivePadding(context),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '📊 Resultado de la Operación',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            18,
                          ),
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          15,
                        ),
                      ),
                      Container(
                        padding: ResponsiveHelper.getResponsivePadding(context),
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
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              16,
                            ),
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (!detalleOperacion.contains('Error')) ...[
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            10,
                          ),
                        ),
                        Text(
                          '= ${resultado.toStringAsFixed(4)}',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              28,
                            ),
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            10,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(
                            ResponsiveHelper.getResponsiveSpacing(context, 10),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[300]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error,
                                color: Colors.red[600],
                                size: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  20,
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  8,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  resultado == double.infinity
                                      ? 'INDEFINIDO (∞)'
                                      : 'ERROR',
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.getResponsiveFontSize(
                                          context,
                                          20,
                                        ),
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

              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 15),
              ),

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
                      padding: ResponsiveHelper.getResponsivePadding(context),
                      textStyle: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          16,
                        ),
                      ),
                    ),
                    child: const Text('🗑️ Limpiar'),
                  ),
                ],
              ),

              // Espaciado final para evitar overflow
              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 20),
              ),
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
}
