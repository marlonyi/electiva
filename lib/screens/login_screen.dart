import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../auth/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorMessage;
  bool _showPassword = false;

  // Controladores de animación avanzados
  late AnimationController _backgroundController;
  late AnimationController _formController;
  late AnimationController _particlesController;
  late AnimationController _glowController;
  late AnimationController _textController;

  late Animation<double> _backgroundAnimation;
  late Animation<double> _formAnimation;
  late Animation<double> _particlesAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _textAnimation;

  // Lista de partículas para efectos visuales
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    // Inicializar controladores de animación
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    _formController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _particlesController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Configurar animaciones
    _backgroundAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );

    _formAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _formController, curve: Curves.elasticOut),
    );

    _particlesAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _particlesController, curve: Curves.linear),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.elasticOut),
    );

    // Generar partículas iniciales usando el tamaño real de la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      _generateParticlesForSize(size.width, size.height);
    });

    // Iniciar animaciones
    _formController.forward();
    _textController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _formController.dispose();
    _particlesController.dispose();
    _glowController.dispose();
    _textController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _generateParticlesForSize(double width, double height) {
    if (_particles.isNotEmpty) return; // Solo generar una vez
    _particles.clear();
    final random = math.Random();
    for (int i = 0; i < 30; i++) {
      final px = random.nextDouble() * width;
      final py = random.nextDouble() * height;
      final vx = (random.nextDouble() - 0.5) * 1.2; // velocidad reducida
      final vy = (random.nextDouble() - 0.5) * 1.2;
      _particles.add(
        Particle(
          position: Offset(px.clamp(0.0, width), py.clamp(0.0, height)),
          velocity: Offset(vx, vy),
          size: (random.nextDouble() * 3 + 1).clamp(1.0, 4.0),
          opacity: (random.nextDouble() * 0.6 + 0.3).clamp(0.0, 1.0),
          color: Color.fromRGBO(
            (random.nextInt(50) + 200).clamp(0, 255),
            (random.nextInt(50) + 200).clamp(0, 255),
            255,
            1,
          ),
        ),
      );
    }
    setState(() {});
  }

  Future<void> _handleEmailAuth() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor completa todos los campos';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isLogin) {
        await _authService.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        await _authService.createUserWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e.toString());
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signInWithGoogle();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e.toString());
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'Usuario no encontrado. Verifica tu email.';
    } else if (error.contains('wrong-password')) {
      return 'Contraseña incorrecta.';
    } else if (error.contains('email-already-in-use')) {
      return 'Este email ya está registrado.';
    } else if (error.contains('weak-password')) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    } else if (error.contains('invalid-email')) {
      return 'Email inválido.';
    }
    return 'Error: $error';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _backgroundAnimation,
          _formAnimation,
          _particlesAnimation,
          _glowAnimation,
          _textAnimation,
        ]),
        builder: (context, child) {
          return SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(
                      const Color(0xFF667EEA),
                      const Color(0xFF764BA2),
                      (math.sin(_backgroundAnimation.value) * 0.5 + 0.5).clamp(
                        0.0,
                        1.0,
                      ),
                    )!,
                    Color.lerp(
                      const Color(0xFFF093FB),
                      const Color(0xFFF5576C),
                      (math.cos(_backgroundAnimation.value) * 0.5 + 0.5).clamp(
                        0.0,
                        1.0,
                      ),
                    )!,
                    Color.lerp(
                      const Color(0xFF4FACFE),
                      const Color(0xFF00F2FE),
                      (math.sin(_backgroundAnimation.value + math.pi) * 0.5 +
                              0.5)
                          .clamp(0.0, 1.0),
                    )!,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: ClipRect(
                child: Stack(
                  children: [
                    // Partículas animadas
                    ..._buildParticles(),

                    // Efectos de fondo dinámicos
                    _buildBackgroundEffects(),

                    // Contenido principal (scrollable y centrado cuando hay espacio)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final viewportHeight = constraints.maxHeight;
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: viewportHeight,
                            ),
                            child: Center(
                              child: Transform.scale(
                                scale: _formAnimation.value.clamp(0.0, 1.0),
                                child: Opacity(
                                  opacity: _formAnimation.value.clamp(0.0, 1.0),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 400,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 15,
                                          sigmaY: 15,
                                        ), // Reducido de 20 a 15
                                        child: Container(
                                          padding: const EdgeInsets.all(30),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.12,
                                            ), // Mejor opacidad
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.25,
                                              ), // Mejor opacidad
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.08,
                                                ), // Mejor opacidad
                                                blurRadius: 20,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Logo y título con animación
                                              _buildAnimatedHeader(),

                                              const SizedBox(height: 30),

                                              // Formulario con efectos modernos
                                              _buildModernForm(),

                                              // Mensaje de error con animación
                                              if (_errorMessage != null)
                                                _buildErrorMessage(),

                                              const SizedBox(height: 25),

                                              // Botones principales
                                              _buildActionButtons(),

                                              const SizedBox(height: 20),

                                              // Separador elegante
                                              _buildDivider(),

                                              const SizedBox(height: 20),

                                              // Botón de Google
                                              _buildGoogleButton(),

                                              // Enlaces adicionales
                                              _buildAdditionalLinks(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildParticles() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return _particles.map((particle) {
      // Calcular movimiento suave con límites seguros
      final time = _particlesAnimation.value;
      final speed = 30.0; // Velocidad constante

      double x = particle.position.dx + particle.velocity.dx * time * speed;
      double y = particle.position.dy + particle.velocity.dy * time * speed;

      // Wrap-around con límites seguros
      x = x % screenWidth;
      y = y % screenHeight;

      // Asegurar coordenadas positivas
      if (x < 0) x += screenWidth;
      if (y < 0) y += screenHeight;

      return Positioned(
        left: x.clamp(0.0, screenWidth - particle.size),
        top: y.clamp(0.0, screenHeight - particle.size),
        child: Container(
          width: particle.size,
          height: particle.size,
          decoration: BoxDecoration(
            color: particle.color.withValues(
              alpha: (particle.opacity * _glowAnimation.value).clamp(0.0, 1.0),
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: particle.color.withValues(alpha: 0.15),
                blurRadius: particle.size * 0.8,
                spreadRadius: particle.size * 0.1,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildBackgroundEffects() {
    return Positioned.fill(
      child: CustomPaint(
        painter: BackgroundPainter(
          animation: _backgroundAnimation.value,
          glowIntensity: _glowAnimation.value,
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return Transform.translate(
      offset: Offset(0, (1 - _textAnimation.value) * -50),
      child: Opacity(
        opacity: _textAnimation.value.clamp(0.0, 1.0),
        child: Column(
          children: [
            // Logo con glow effect optimizado
            const SizedBox(height: 20),
            // Ícono moderno alusivo como elemento principal
            Builder(
              builder: (context) {
                final w = MediaQuery.of(context).size.width;
                final iconSize = math.min(w * 0.14, 56.0);
                final containerPadding = math.min(24.0, w * 0.06);
                return Container(
                  padding: EdgeInsets.all(containerPadding),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 25,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.calculate_rounded,
                    color: Colors.white.withOpacity(0.95),
                    size: iconSize,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernForm() {
    return Column(
      children: [
        // Campo de email
        _buildModernTextField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),

        // Campo de contraseña
        _buildModernTextField(
          controller: _passwordController,
          label: 'Contraseña',
          icon: Icons.lock_outline,
          obscureText: !_showPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white.withOpacity(0.7),
            ),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Reducido blur
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18), // Mejor opacidad
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.22), // Mejor opacidad
                width: 1,
              ),
            ),
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  icon,
                  color: Colors.white.withOpacity(0.7),
                  size: 22,
                ),
                suffixIcon: suffixIcon,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.withOpacity(0.8),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Botón principal
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.9),
                Colors.white.withOpacity(0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleEmailAuth,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child:
                _isLoading
                    ? SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.withOpacity(0.8),
                        ),
                      ),
                    )
                    : Text(
                      _isLogin ? 'INICIAR SESIÓN' : 'REGISTRARSE',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
          ),
        ),

        const SizedBox(height: 15),

        // Botón toggle
        TextButton(
          onPressed: () => setState(() => _isLogin = !_isLogin),
          child: Text(
            _isLogin
                ? '¿No tienes cuenta? Regístrate'
                : '¿Ya tienes cuenta? Inicia sesión',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'O',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white.withOpacity(0.15),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _handleGoogleSignIn,
        icon: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              'G',
              style: TextStyle(
                color: Colors.blue.shade600,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        label: Text(
          'Continuar con Google',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalLinks() {
    if (!_isLogin) {
      return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: TextButton(
          onPressed: () async {
            if (_emailController.text.isEmpty) {
              setState(() {
                _errorMessage =
                    'Ingresa tu email para restablecer la contraseña';
              });
              return;
            }

            try {
              await _authService.sendPasswordResetEmail(
                _emailController.text.trim(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Email de restablecimiento enviado'),
                  backgroundColor: Colors.green.withOpacity(0.8),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $e'),
                  backgroundColor: Colors.red.withOpacity(0.8),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          child: Text(
            '¿Olvidaste tu contraseña?',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white.withOpacity(0.4),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

// Clase para partículas
class Particle {
  final Offset position;
  final Offset velocity;
  final double size;
  final double opacity;
  final Color color;

  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.opacity,
    required this.color,
  });
}

// Pintor personalizado para efectos de fondo
class BackgroundPainter extends CustomPainter {
  final double animation;
  final double glowIntensity;

  BackgroundPainter({required this.animation, required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.fill
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            (15 * glowIntensity).clamp(5.0, 25.0),
          ); // Limitado blur

    // Círculos de luz animados con límites seguros
    for (int i = 0; i < 3; i++) {
      final angle = animation + i * math.pi / 3;
      final x = (size.width * (0.3 + 0.3 * math.sin(angle))).clamp(
        50.0,
        size.width - 50.0,
      );
      final y = (size.height * (0.3 + 0.3 * math.cos(angle))).clamp(
        50.0,
        size.height - 50.0,
      );
      final radius = (80 + 40 * math.sin(animation * 2 + i)).clamp(40.0, 150.0);

      paint.color = Color.fromRGBO(
        255,
        255,
        255,
        (0.08 * glowIntensity).clamp(0.0, 0.3), // Limitada opacidad máxima
      );

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.glowIntensity != glowIntensity;
  }
}
