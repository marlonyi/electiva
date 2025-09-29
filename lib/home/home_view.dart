import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final responsivePadding = ResponsiveHelper.getResponsivePadding(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: responsivePadding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(isDesktop ? 24 : 20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: isDesktop ? 15 : 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: ResponsiveHelper.getResponsiveFontSize(context, 30),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: ResponsiveHelper.getResponsiveFontSize(context, 16),
                ),
              ],
            ),
            SizedBox(
              height: ResponsiveHelper.getResponsiveSpacing(context, 15),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 8)),
            Text(
              description,
              style: TextStyle(
                color: Colors.white70,
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsivePadding = ResponsiveHelper.getResponsivePadding(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header principal responsivo
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                responsivePadding.left,
                ResponsiveHelper.isMobile(context) ? 60 : 40,
                responsivePadding.right,
                responsivePadding.bottom,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo[400]!, Colors.purple[400]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Logo y título principal
                  Container(
                    padding: responsivePadding,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.isDesktop(context) ? 24 : 20,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.school,
                          color: Colors.white,
                          size: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            60,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            15,
                          ),
                        ),
                        Text(
                          '¡Bienvenido a Electiva!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              28,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            10,
                          ),
                        ),
                        Text(
                          'Tu aplicación educativa completa',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              16,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Contenido principal responsivo
            Container(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.getMaxContentWidth(context),
              ),
              child: Padding(
                padding: responsivePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Descripción de la app
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.indigo),
                              SizedBox(width: 10),
                              Text(
                                'Acerca de esta App',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Esta aplicación ha sido desarrollada como parte del curso de Electiva, '
                            'integrando múltiples funcionalidades educativas y prácticas para demostrar '
                            'las capacidades de Flutter en el desarrollo multiplataforma.',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.4,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Título de características
                    const Text(
                      '🚀 Explora las Funcionalidades',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Grid de características responsivo
                    GridView.count(
                      crossAxisCount:
                          ResponsiveHelper.isMobile(context) ? 1 : 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        15,
                      ),
                      crossAxisSpacing: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        15,
                      ),
                      childAspectRatio: ResponsiveHelper.getCardAspectRatio(
                        context,
                      ),
                      children: [
                        _buildFeatureCard(
                          context,
                          title: '🧮 Calculadora Científica',
                          description:
                              'Operaciones matemáticas avanzadas: suma, resta, multiplicación, división con cociente y residuo, potenciación y radicación.',
                          icon: Icons.calculate,
                          color: Colors.orange,
                          onTap: () {
                            // La navegación se maneja desde el main con el índice
                            final scaffoldState = Scaffold.of(context);
                            if (scaffoldState.hasDrawer) {
                              Navigator.pop(context);
                            }
                            // Simular tap en el item de calculadora del drawer
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: '🌤️ Información del Clima',
                          description:
                              'Consulta datos meteorológicos en tiempo real: temperatura, humedad, velocidad del viento, sensación térmica y más.',
                          icon: Icons.wb_sunny,
                          color: Colors.blue,
                          onTap: () {
                            // La navegación se maneja desde el main con el índice
                            final scaffoldState = Scaffold.of(context);
                            if (scaffoldState.hasDrawer) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Información técnica
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal[100]!, Colors.teal[50]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.teal[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.code, color: Colors.teal[700]),
                              const SizedBox(width: 10),
                              Text(
                                'Tecnologías Implementadas',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          _buildTechItem('✓ Flutter & Dart'),
                          _buildTechItem('✓ Material Design'),
                          _buildTechItem('✓ Navegación con Drawer'),
                          _buildTechItem('✓ Manejo de Estado (StatefulWidget)'),
                          _buildTechItem('✓ TextEditingController'),
                          _buildTechItem('✓ Consumo de APIs REST'),
                          _buildTechItem('✓ Validaciones y Manejo de Errores'),
                          _buildTechItem('✓ Arquitectura Modular'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Footer
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.flutter_dash,
                            color: Colors.blue,
                            size: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Desarrollado con Flutter',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            'Proyecto Electiva 2025',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.teal[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
