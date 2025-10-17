import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _cardsController;
  late AnimationController _floatingController;
  late Animation<double> _heroAnimation;
  late Animation<double> _cardsAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _cardsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _heroAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.elasticOut),
    );
    _cardsAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardsController, curve: Curves.easeOutCubic),
    );
    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // Iniciar animaciones
    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _cardsController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _cardsController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Widget _buildFloatingElement(
    IconData icon,
    Color color,
    double size, {
    double delay = 0,
  }) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * (0.5 + delay)),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: size),
          ),
        );
      },
    );
  }

  Widget _buildGlassmorphismCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    double delay = 0,
  }) {
    return AnimatedBuilder(
      animation: _cardsAnimation,
      builder: (context, child) {
        final slideOffset = (1 - _cardsAnimation.value) * 100;
        final opacity = _cardsAnimation.value.clamp(0.0, 1.0);

        return Transform.translate(
          offset: Offset(0, slideOffset * (1 + delay)),
          child: Opacity(
            opacity: opacity,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.2),
                      color.withOpacity(0.1),
                      Colors.white.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: color.withOpacity(0.3), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      spreadRadius: -2,
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: color.withOpacity(0.4)),
                      ),
                      child: Icon(icon, color: color, size: 32),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        color: color.withOpacity(0.8),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Explorar',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: color, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final responsivePadding = ResponsiveHelper.getResponsivePadding(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6366F1), // Indigo moderno
              Color(0xFF8B5CF6), // Purple moderno
              Color(0xFF06B6D4), // Cyan moderno
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section con animaciones
              Container(
                height: isDesktop ? 500 : 400,
                padding: EdgeInsets.symmetric(
                  horizontal: responsivePadding.left,
                ),
                child: Stack(
                  children: [
                    // Elementos flotantes de fondo
                    Positioned(
                      top: 60,
                      left: 40,
                      child: _buildFloatingElement(
                        Icons.calculate,
                        Colors.orange,
                        24,
                      ),
                    ),
                    Positioned(
                      top: 120,
                      right: 60,
                      child: _buildFloatingElement(
                        Icons.wb_sunny,
                        Colors.yellow,
                        28,
                        delay: 0.5,
                      ),
                    ),
                    Positioned(
                      bottom: 100,
                      left: 80,
                      child: _buildFloatingElement(
                        Icons.cloud,
                        Colors.white,
                        20,
                        delay: 1.0,
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      right: 40,
                      child: _buildFloatingElement(
                        Icons.school,
                        Colors.blue,
                        26,
                        delay: 0.3,
                      ),
                    ),

                    // Contenido principal del hero
                    AnimatedBuilder(
                      animation: _heroAnimation,
                      builder: (context, child) {
                        final scale = 0.8 + (_heroAnimation.value * 0.2);
                        final opacity = _heroAnimation.value.clamp(0.0, 1.0);

                        return Center(
                          child: Transform.scale(
                            scale: scale,
                            child: Opacity(
                              opacity: opacity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Logo con efecto glow
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.2),
                                          Colors.white.withOpacity(0.1),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.2),
                                          spreadRadius: 10,
                                          blurRadius: 30,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.rocket_launch,
                                      color: Colors.white,
                                      size: 80,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Electiva Digital',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Aprende, calcula y descubre el clima\ncon tecnología de vanguardia',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 18,
                                      height: 1.4,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 32),
                                  // Indicador de scroll
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Sección de características
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsivePadding.left,
                  vertical: 60,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    // Título de sección
                    Text(
                      '🚀 Funcionalidades Interactivas',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Descubre herramientas poderosas diseñadas para tu aprendizaje',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),

                    // Grid de características
                    GridView.count(
                      crossAxisCount: isDesktop ? 2 : 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 30,
                      childAspectRatio: isDesktop ? 1.2 : 0.8,
                      children: [
                        _buildGlassmorphismCard(
                          title: '🧮 Calculadora Avanzada',
                          description:
                              'Operaciones matemáticas complejas con interfaz intuitiva. Potenciación, radicación, funciones trigonométricas y más.',
                          icon: Icons.calculate,
                          color: Colors.orange,
                          onTap: () {},
                          delay: 0,
                        ),
                        _buildGlassmorphismCard(
                          title: '🌤️ Clima en Tiempo Real',
                          description:
                              'Información meteorológica actualizada con pronósticos precisos. Temperatura, humedad, viento y nubosidad.',
                          icon: Icons.wb_sunny,
                          color: Colors.blue,
                          onTap: () {},
                          delay: 0.2,
                        ),
                      ],
                    ),

                    const SizedBox(height: 60),

                    // Sección de estadísticas
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo.withOpacity(0.1),
                            Colors.purple.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.indigo.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '📊 Estadísticas del Sistema',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem('Operaciones', '∞', Colors.orange),
                              _buildStatItem('Ciudades', '50K+', Colors.blue),
                              _buildStatItem(
                                'Usuarios',
                                'Activo',
                                Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Footer moderno
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.code, color: Colors.indigo, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                'Desarrollado con Flutter',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Proyecto Electiva 2025 • Tecnología de Vanguardia',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
