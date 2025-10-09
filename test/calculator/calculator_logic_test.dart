import 'package:flutter_test/flutter_test.dart';
import 'package:electiva/calculator/calculator_logic.dart';

void main() {
  group('CalculatorLogic - Operaciones Básicas', () {
    test('suma dos números positivos correctamente', () {
      // Arrange
      const numero1 = 5.0;
      const numero2 = 3.0;

      // Act
      final resultado = CalculatorLogic.calcular(numero1, numero2, '+');

      // Assert
      expect(resultado.resultado, 8.0);
      expect(resultado.detalleOperacion, '5.0 + 3.0 = 8.0');
      expect(resultado.tieneError, false);
    });

    test('suma números negativos correctamente', () {
      // Arrange
      const numero1 = -10.0;
      const numero2 = -5.0;

      // Act
      final resultado = CalculatorLogic.calcular(numero1, numero2, '+');

      // Assert
      expect(resultado.resultado, -15.0);
      expect(resultado.detalleOperacion, '-10.0 + -5.0 = -15.0');
    });

    test('suma con decimales correctamente', () {
      // Arrange
      const numero1 = 3.5;
      const numero2 = 2.25;

      // Act
      final resultado = CalculatorLogic.calcular(numero1, numero2, '+');

      // Assert
      expect(resultado.resultado, 5.75);
    });

    test('resta dos números correctamente', () {
      // Arrange
      const numero1 = 10.0;
      const numero2 = 3.0;

      // Act
      final resultado = CalculatorLogic.calcular(numero1, numero2, '−');

      // Assert
      expect(resultado.resultado, 7.0);
      expect(resultado.detalleOperacion, '10.0 − 3.0 = 7.0');
      expect(resultado.tieneError, false);
    });

    test('resta usando símbolo alternativo "-"', () {
      // Arrange
      const numero1 = 8.0;
      const numero2 = 5.0;

      // Act
      final resultado = CalculatorLogic.calcular(numero1, numero2, '-');

      // Assert
      expect(resultado.resultado, 3.0);
      expect(resultado.detalleOperacion, '8.0 − 5.0 = 3.0');
    });

    test('resta que da resultado negativo', () {
      // Arrange
      const numero1 = 3.0;
      const numero2 = 8.0;

      // Act
      final resultado = CalculatorLogic.calcular(numero1, numero2, '−');

      // Assert
      expect(resultado.resultado, -5.0);
    });

    test('multiplica dos números positivos', () {
      // Arrange
      const numero1 = 4.0;
      const numero2 = 5.0;

      // Act
      final resultado = CalculatorLogic.calcular(numero1, numero2, '×');

      // Assert
      expect(resultado.resultado, 20.0);
      expect(resultado.detalleOperacion, '4.0 × 5.0 = 20.0');
      expect(resultado.tieneError, false);
    });

    test('multiplica usando símbolo alternativo "*"', () {
      // Arrange
      const numero1 = 3.0;
      const numero2 = 6.0;

      // Act
      final resultado = CalculatorLogic.calcular(numero1, numero2, '*');

      // Assert
      expect(resultado.resultado, 18.0);
    });

    test('multiplica por cero da cero', () {
      // Arrange
      const numero1 = 100.0;
      const numero2 = 0.0;

      // Act
      final resultado = CalculatorLogic.calcular(numero1, numero2, '×');

      // Assert
      expect(resultado.resultado, 0.0);
    });

    test('multiplica números negativos', () {
      // Arrange
      const numero1 = -4.0;
      const numero2 = -3.0;

      // Act
      final resultado = CalculatorLogic.calcular(numero1, numero2, '×');

      // Assert
      expect(resultado.resultado, 12.0);
    });
  });

  group('CalculatorLogic - División', () {
    test('divide dos números correctamente', () {
      // Arrange
      const dividendo = 10.0;
      const divisor = 2.0;

      // Act
      final resultado = CalculatorLogic.calcular(dividendo, divisor, '÷');

      // Assert
      expect(resultado.resultado, 5.0);
      expect(resultado.detalleOperacion.contains('10.0 ÷ 2.0 = 5.0000'), true);
      expect(resultado.tieneError, false);
    });

    test('divide usando símbolo alternativo "/"', () {
      // Arrange
      const dividendo = 15.0;
      const divisor = 3.0;

      // Act
      final resultado = CalculatorLogic.calcular(dividendo, divisor, '/');

      // Assert
      expect(resultado.resultado, 5.0);
    });

    test('división por cero retorna error', () {
      // Arrange
      const dividendo = 10.0;
      const divisor = 0.0;

      // Act
      final resultado = CalculatorLogic.calcular(dividendo, divisor, '÷');

      // Assert
      expect(resultado.resultado, double.infinity);
      expect(
        resultado.detalleOperacion,
        'Error: División por cero no definida',
      );
      expect(resultado.tieneError, true);
    });

    test('división por número muy pequeño retorna error', () {
      // Arrange
      const dividendo = 10.0;
      const divisor = 0.00000001; // Menor a 0.0000001

      // Act
      final resultado = CalculatorLogic.calcular(dividendo, divisor, '÷');

      // Assert
      expect(resultado.resultado, double.infinity);
      expect(
        resultado.detalleOperacion,
        'Error: División por número demasiado pequeño',
      );
      expect(resultado.tieneError, true);
    });

    test('división con residuo muestra detalles', () {
      // Arrange
      const dividendo = 10.0;
      const divisor = 3.0;

      // Act
      final resultado = CalculatorLogic.calcular(dividendo, divisor, '÷');

      // Assert
      expect(resultado.detalleOperacion.contains('Cociente:'), true);
      expect(resultado.detalleOperacion.contains('Residuo:'), true);
    });

    test('división exacta no muestra residuo', () {
      // Arrange
      const dividendo = 10.0;
      const divisor = 2.0;

      // Act
      final resultado = CalculatorLogic.calcular(dividendo, divisor, '÷');

      // Assert
      expect(resultado.detalleOperacion.contains('Residuo:'), false);
    });

    test('división que genera número muy grande muestra advertencia', () {
      // Arrange
      const dividendo = 1e15; // Número muy grande
      const divisor = 0.1;

      // Act
      final resultado = CalculatorLogic.calcular(dividendo, divisor, '÷');

      // Assert
      expect(
        resultado.detalleOperacion.contains('⚠️ Resultado muy grande'),
        true,
      );
    });
  });

  group('CalculatorLogic - Potencias', () {
    test('calcula potencia positiva correctamente', () {
      // Arrange
      const base = 2.0;
      const exponente = 3.0;

      // Act
      final resultado = CalculatorLogic.calcular(base, exponente, '^');

      // Assert
      expect(resultado.resultado, 8.0);
      expect(resultado.detalleOperacion, '2.0^3.0 = 8.0');
      expect(resultado.tieneError, false);
    });

    test('calcula potencia con exponente cero', () {
      // Arrange
      const base = 5.0;
      const exponente = 0.0;

      // Act
      final resultado = CalculatorLogic.calcular(base, exponente, '^');

      // Assert
      expect(resultado.resultado, 1.0);
    });

    test('calcula potencia con exponente negativo', () {
      // Arrange
      const base = 2.0;
      const exponente = -2.0;

      // Act
      final resultado = CalculatorLogic.calcular(base, exponente, '^');

      // Assert
      expect(resultado.resultado, 0.25); // 2^-2 = 1/4 = 0.25
    });

    test('calcula potencia con base negativa y exponente par', () {
      // Arrange
      const base = -3.0;
      const exponente = 2.0;

      // Act
      final resultado = CalculatorLogic.calcular(base, exponente, '^');

      // Assert
      expect(resultado.resultado, 9.0);
    });

    test('calcula potencia con decimales', () {
      // Arrange
      const base = 4.0;
      const exponente = 0.5; // Raíz cuadrada

      // Act
      final resultado = CalculatorLogic.calcular(base, exponente, '^');

      // Assert
      expect(resultado.resultado, 2.0);
    });
  });

  group('CalculatorLogic - Raíces', () {
    test('calcula raíz cuadrada correctamente', () {
      // Arrange
      const numero = 9.0;
      const indice = 2.0;

      // Act
      final resultado = CalculatorLogic.calcular(numero, indice, '√');

      // Assert
      expect(resultado.resultado, 3.0);
      expect(resultado.detalleOperacion.contains('2√9.0 = 3.0000'), true);
      expect(resultado.tieneError, false);
    });

    test('calcula raíz cuadrada cuando índice es 0 (default)', () {
      // Arrange
      const numero = 16.0;
      const indice = 0.0; // Debe usar 2 por defecto

      // Act
      final resultado = CalculatorLogic.calcular(numero, indice, '√');

      // Assert
      expect(resultado.resultado, 4.0);
      expect(resultado.detalleOperacion.contains('2√'), true);
    });

    test('calcula raíz cúbica correctamente', () {
      // Arrange
      const numero = 27.0;
      const indice = 3.0;

      // Act
      final resultado = CalculatorLogic.calcular(numero, indice, '√');

      // Assert
      expect(resultado.resultado, closeTo(3.0, 0.0001));
      expect(resultado.detalleOperacion.contains('3√27.0'), true);
    });

    test('raíz de número negativo con índice par retorna error', () {
      // Arrange
      const numero = -9.0;
      const indice = 2.0;

      // Act
      final resultado = CalculatorLogic.calcular(numero, indice, '√');

      // Assert
      expect(resultado.resultado, 0.0);
      expect(resultado.detalleOperacion.contains('Error: Raíz inválida'), true);
      expect(resultado.tieneError, true);
    });

    test('raíz con índice negativo retorna error', () {
      // Arrange
      const numero = 9.0;
      const indice = -2.0;

      // Act
      final resultado = CalculatorLogic.calcular(numero, indice, '√');

      // Assert
      expect(resultado.resultado, 0.0);
      expect(resultado.detalleOperacion.contains('índice no positivo'), true);
      expect(resultado.tieneError, true);
    });

    test('raíz de cero es cero', () {
      // Arrange
      const numero = 0.0;
      const indice = 2.0;

      // Act
      final resultado = CalculatorLogic.calcular(numero, indice, '√');

      // Assert
      expect(resultado.resultado, 0.0);
      expect(resultado.tieneError, false);
    });
  });

  group('CalculatorLogic - Validaciones', () {
    test('valida número positivo correctamente', () {
      // Act & Assert
      expect(CalculatorLogic.esNumeroValido('123'), true);
    });

    test('valida número decimal correctamente', () {
      // Act & Assert
      expect(CalculatorLogic.esNumeroValido('3.14'), true);
    });

    test('valida número negativo correctamente', () {
      // Act & Assert
      expect(CalculatorLogic.esNumeroValido('-42'), true);
    });

    test('rechaza string vacío', () {
      // Act & Assert
      expect(CalculatorLogic.esNumeroValido(''), false);
    });

    test('rechaza string con solo espacios', () {
      // Act & Assert
      expect(CalculatorLogic.esNumeroValido('   '), false);
    });

    test('rechaza texto no numérico', () {
      // Act & Assert
      expect(CalculatorLogic.esNumeroValido('abc'), false);
    });

    test('rechaza número con formato inválido', () {
      // Act & Assert
      expect(CalculatorLogic.esNumeroValido('3.14.15'), false);
    });

    test('validar entrada para operación normal - válida', () {
      // Act
      final error = CalculatorLogic.validarEntrada('5', '3', '+');

      // Assert
      expect(error, null);
    });

    test('validar entrada para operación normal - número1 inválido', () {
      // Act
      final error = CalculatorLogic.validarEntrada('abc', '3', '+');

      // Assert
      expect(error, 'Por favor ingresa ambos números válidos.');
    });

    test('validar entrada para operación normal - número2 inválido', () {
      // Act
      final error = CalculatorLogic.validarEntrada('5', '', '+');

      // Assert
      expect(error, 'Por favor ingresa ambos números válidos.');
    });

    test('validar entrada para raíz - válida', () {
      // Act
      final error = CalculatorLogic.validarEntrada('9', '2', '√');

      // Assert
      expect(error, null);
    });

    test('validar entrada para raíz - número inválido', () {
      // Act
      final error = CalculatorLogic.validarEntrada('', '2', '√');

      // Assert
      expect(error, 'Por favor ingresa un número válido para la raíz.');
    });
  });

  group('CalculatorLogic - Operaciones Inválidas', () {
    test('operación no válida retorna error', () {
      // Arrange
      const numero1 = 5.0;
      const numero2 = 3.0;
      const operacionInvalida = '%';

      // Act
      final resultado = CalculatorLogic.calcular(
        numero1,
        numero2,
        operacionInvalida,
      );

      // Assert
      expect(resultado.resultado, 0.0);
      expect(resultado.detalleOperacion, 'Error: Operación no válida');
      expect(resultado.tieneError, true);
    });
  });

  group('CalculatorLogic - Casos Edge', () {
    test('suma de números muy grandes', () {
      // Arrange
      const numero1 = 1e308;
      const numero2 = 1e308;

      // Act
      final resultado = CalculatorLogic.calcular(numero1, numero2, '+');

      // Assert
      expect(resultado.resultado, double.infinity);
    });

    test('multiplicación de números muy pequeños', () {
      // Arrange
      const numero1 = 1e-100;
      const numero2 = 1e-100;

      // Act
      final resultado = CalculatorLogic.calcular(numero1, numero2, '×');

      // Assert
      expect(resultado.resultado, closeTo(0, 1e-200));
    });

    test('potencia que genera overflow', () {
      // Arrange
      const base = 10.0;
      const exponente = 1000.0;

      // Act
      final resultado = CalculatorLogic.calcular(base, exponente, '^');

      // Assert
      expect(resultado.resultado, double.infinity);
    });

    test('raíz de 1 es siempre 1', () {
      // Arrange
      const numero = 1.0;
      const indice = 5.0;

      // Act
      final resultado = CalculatorLogic.calcular(numero, indice, '√');

      // Assert
      expect(resultado.resultado, closeTo(1.0, 0.0001));
    });
  });
}
