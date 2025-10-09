import 'dart:math' as math;

/// Clase que contiene toda la lógica de cálculo de la calculadora.
/// Separada de la UI para facilitar las pruebas unitarias.
class CalculatorLogic {
  /// Resultado de la última operación
  final double resultado;

  /// Descripción detallada de la operación realizada
  final String detalleOperacion;

  /// Indica si hubo algún error en la operación
  final bool tieneError;

  CalculatorLogic({
    required this.resultado,
    required this.detalleOperacion,
    this.tieneError = false,
  });

  /// Realiza una operación matemática entre dos números
  static CalculatorLogic calcular(
    double numero1,
    double numero2,
    String operacion,
  ) {
    switch (operacion) {
      case '+':
        return _sumar(numero1, numero2);
      case '−':
      case '-':
        return _restar(numero1, numero2);
      case '×':
      case '*':
        return _multiplicar(numero1, numero2);
      case '÷':
      case '/':
        return _dividir(numero1, numero2);
      case '^':
        return _potencia(numero1, numero2);
      case '√':
        return _raiz(numero1, numero2);
      default:
        return CalculatorLogic(
          resultado: 0,
          detalleOperacion: 'Error: Operación no válida',
          tieneError: true,
        );
    }
  }

  /// Suma dos números
  static CalculatorLogic _sumar(double a, double b) {
    final resultado = a + b;
    return CalculatorLogic(
      resultado: resultado,
      detalleOperacion: '$a + $b = $resultado',
    );
  }

  /// Resta dos números
  static CalculatorLogic _restar(double a, double b) {
    final resultado = a - b;
    return CalculatorLogic(
      resultado: resultado,
      detalleOperacion: '$a − $b = $resultado',
    );
  }

  /// Multiplica dos números
  static CalculatorLogic _multiplicar(double a, double b) {
    final resultado = a * b;
    return CalculatorLogic(
      resultado: resultado,
      detalleOperacion: '$a × $b = $resultado',
    );
  }

  /// Divide dos números con manejo especial de división por cero
  static CalculatorLogic _dividir(double dividendo, double divisor) {
    // Caso 1: División por cero exacto
    if (divisor == 0) {
      return CalculatorLogic(
        resultado: double.infinity,
        detalleOperacion: 'Error: División por cero no definida',
        tieneError: true,
      );
    }

    // Caso 2: División por número muy pequeño
    if (divisor.abs() < 0.0000001) {
      return CalculatorLogic(
        resultado: double.infinity,
        detalleOperacion: 'Error: División por número demasiado pequeño',
        tieneError: true,
      );
    }

    // Caso 3: División normal
    final cociente = dividendo / divisor;
    final residuo = dividendo % divisor;

    String detalle = '$dividendo ÷ $divisor = ${cociente.toStringAsFixed(4)}';

    // Agregar detalles adicionales solo si hay residuo significativo
    if (residuo.abs() > 0.0001) {
      detalle += '\nCociente: ${cociente.toStringAsFixed(4)}';
      detalle += '\nResiduo: ${residuo.toStringAsFixed(4)}';
    }

    // Advertencia para resultados muy grandes
    if (cociente.abs() > 1e10) {
      detalle += '\n⚠️ Resultado muy grande';
    }

    return CalculatorLogic(resultado: cociente, detalleOperacion: detalle);
  }

  /// Calcula la potencia: numero1^numero2
  static CalculatorLogic _potencia(double base, double exponente) {
    final resultado = math.pow(base, exponente).toDouble();
    return CalculatorLogic(
      resultado: resultado,
      detalleOperacion: '$base^$exponente = $resultado',
    );
  }

  /// Calcula la raíz n-ésima de un número
  /// Si numero2 es 0 o no se proporciona, calcula raíz cuadrada (índice = 2)
  static CalculatorLogic _raiz(double numero, double indice) {
    // Por defecto, raíz cuadrada
    final indiceReal = indice == 0 ? 2.0 : indice;

    // Validación: número negativo con raíz par
    if (numero < 0 && indiceReal % 2 == 0) {
      return CalculatorLogic(
        resultado: 0,
        detalleOperacion:
            'Error: Raíz inválida (número negativo con índice par)',
        tieneError: true,
      );
    }

    // Validación: índice no positivo
    if (indiceReal <= 0) {
      return CalculatorLogic(
        resultado: 0,
        detalleOperacion: 'Error: Raíz inválida (índice no positivo)',
        tieneError: true,
      );
    }

    final resultado = math.pow(numero, 1 / indiceReal).toDouble();
    return CalculatorLogic(
      resultado: resultado,
      detalleOperacion:
          '${indiceReal.toInt()}√$numero = ${resultado.toStringAsFixed(4)}',
    );
  }

  /// Valida si un string es un número válido
  static bool esNumeroValido(String texto) {
    if (texto.trim().isEmpty) return false;
    return double.tryParse(texto.trim()) != null;
  }

  /// Valida la entrada antes de calcular
  static String? validarEntrada(
    String numero1,
    String numero2,
    String operacion,
  ) {
    // Para raíz cuadrada, solo validar el primer número
    if (operacion == '√') {
      if (!esNumeroValido(numero1)) {
        return 'Por favor ingresa un número válido para la raíz.';
      }
      return null; // válido
    }

    // Para otras operaciones, validar ambos números
    if (!esNumeroValido(numero1) || !esNumeroValido(numero2)) {
      return 'Por favor ingresa ambos números válidos.';
    }

    return null; // válido
  }
}
