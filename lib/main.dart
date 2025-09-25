import 'package:flutter/material.dart';

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
                '¿Te gusta la clase?',
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
  bool esperandoSegundoNumero = false;

  final TextEditingController _controllerNumero1 = TextEditingController();
  final TextEditingController _controllerNumero2 = TextEditingController();

  void calcular(String op) {
    if (_controllerNumero1.text.isEmpty || _controllerNumero2.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Por favor ingresa ambos números!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      numero1 = double.tryParse(_controllerNumero1.text) ?? 0;
      numero2 = double.tryParse(_controllerNumero2.text) ?? 0;
      operacion = op;

      if (op == '+') {
        resultado = numero1 + numero2;
      } else if (op == '-') {
        resultado = numero1 - numero2;
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
    });
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
        title: const Text('🧮 Calculadora Simple'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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

            const SizedBox(height: 30),

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

            // Campo para el segundo número
            TextField(
              controller: _controllerNumero2,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Segundo número',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.looks_two),
              ),
            ),

            const SizedBox(height: 30),

            // Botones de operaciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botón sumar
                ElevatedButton(
                  onPressed: () => calcular('+'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('+ Sumar', style: TextStyle(fontSize: 16)),
                ),

                // Botón restar
                ElevatedButton(
                  onPressed: () => calcular('-'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('- Restar', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Mostrar resultado
            if (operacion.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  children: [
                    Text(
                      'Operación: $numero1 $operacion $numero2',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Resultado: $resultado',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

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
          ],
        ),
      ),
    );
  }
}
