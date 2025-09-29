import 'package:flutter/material.dart';
import 'home/home_page.dart';
import 'calculator/calculator_page.dart';
import 'weather/weather_page.dart';
import 'utils/responsive_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Electiva Móvil - App Educativa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const MainNavigationPage(),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;

  final List<Widget> _pages = [
    const HomePage(),
    const CalculatorPage(),
    const WeatherPage(),
  ];

  final List<String> _titles = ['Inicio', 'Calculadora', 'Clima'];

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.calculate_rounded,
    Icons.wb_sunny_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // Animación suave para el cambio de página
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final maxWidth = ResponsiveHelper.getMaxContentWidth(context);

    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _titles[_currentIndex],
            key: ValueKey<String>(_titles[_currentIndex]),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 20),
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        automaticallyImplyLeading: !isDesktop,
      ),
      drawer: isDesktop ? null : _buildDrawer(),
      body:
          isDesktop
              ? Row(
                children: [
                  // Navegación lateral para desktop
                  Container(
                    width: 280,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border(
                        right: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: _buildDesktopNavigation(),
                  ),
                  // Contenido principal
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: _buildResponsiveBody(),
                    ),
                  ),
                ],
              )
              : _buildResponsiveBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: List.generate(_pages.length, (index) {
            return BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(_currentIndex == index ? 8.0 : 4.0),
                decoration: BoxDecoration(
                  color:
                      _currentIndex == index
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _icons[index],
                  size: _currentIndex == index ? 28 : 24,
                ),
              ),
              label: _titles[index],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Electiva Móvil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'App Educativa',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ...List.generate(_pages.length, (index) {
                      return _buildDrawerItem(
                        icon: _icons[index],
                        title: _titles[index],
                        subtitle: _getSubtitle(index),
                        isSelected: _currentIndex == index,
                        onTap: () {
                          Navigator.of(context).pop();
                          _onItemTapped(index);
                        },
                      );
                    }),
                    const Divider(height: 40),
                    ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: Colors.grey[600],
                      ),
                      title: const Text('Acerca de'),
                      subtitle: const Text('Versión 1.0.0'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _showAboutDialog();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color:
            isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey[700],
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[800],
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        onTap: onTap,
      ),
    );
  }

  String _getSubtitle(int index) {
    switch (index) {
      case 0:
        return 'Página principal';
      case 1:
        return 'Calculadora científica';
      case 2:
        return 'Información del clima';
      default:
        return '';
    }
  }

  void _showAboutDialog() {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.getResponsiveSpacing(context, 8),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: ResponsiveHelper.getResponsiveFontSize(context, 28),
                ),
              ),
              SizedBox(
                width: ResponsiveHelper.getResponsiveSpacing(context, 12),
              ),
              Expanded(
                child: Text(
                  'Acerca de la Aplicación',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      20,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: isDesktop ? 500 : double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información principal
                  Container(
                    padding: ResponsiveHelper.getResponsivePadding(context),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Electiva Móvil',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              18,
                            ),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          'Aplicación Educativa Responsiva',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              14,
                            ),
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            12,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                16,
                              ),
                              color: Colors.grey[600],
                            ),
                            SizedBox(
                              width: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                8,
                              ),
                            ),
                            Text(
                              'Versión 1.0.0',
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      14,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            8,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.code,
                              size: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                16,
                              ),
                              color: Colors.grey[600],
                            ),
                            SizedBox(
                              width: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                8,
                              ),
                            ),
                            Text(
                              'Desarrollado con Flutter',
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      14,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(context, 20),
                  ),

                  // Características
                  Container(
                    padding: ResponsiveHelper.getResponsivePadding(context),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
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
                            Text(
                              'Características Principales:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      16,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            12,
                          ),
                        ),
                        ...[
                              '🧮 Calculadora científica avanzada con funciones trigonométricas',
                              '🌤️ Información meteorológica en tiempo real con API',
                              '📱 Diseño responsivo para móvil, tablet y desktop',
                              '🎨 Interfaz moderna con Material Design 3',
                              '🚀 Navegación fluida y animaciones suaves',
                              '💡 Arquitectura modular y escalable',
                            ]
                            .map(
                              (feature) => Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      ResponsiveHelper.getResponsiveSpacing(
                                        context,
                                        4,
                                      ),
                                ),
                                child: Text(
                                  feature,
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.getResponsiveFontSize(
                                          context,
                                          14,
                                        ),
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(context, 20),
                  ),

                  // Información técnica
                  Container(
                    padding: ResponsiveHelper.getResponsivePadding(context),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.engineering,
                              color: Colors.blue[700],
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
                            Text(
                              'Detalles Técnicos:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      16,
                                    ),
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            12,
                          ),
                        ),
                        ...[
                              '🔧 Framework: Flutter (Dart)',
                              '📦 Arquitectura: Modular con responsive design',
                              '🌐 APIs: OpenWeatherMap para clima',
                              '🎯 Plataformas: Windows, Web, Android, iOS',
                              '📊 Estado: Gestión eficiente con StatefulWidget',
                              '🎨 UI: Material Design 3 con temas adaptativos',
                            ]
                            .map(
                              (tech) => Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      ResponsiveHelper.getResponsiveSpacing(
                                        context,
                                        4,
                                      ),
                                ),
                                child: Text(
                                  tech,
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.getResponsiveFontSize(
                                          context,
                                          14,
                                        ),
                                    height: 1.3,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(context, 16),
                  ),

                  // Footer
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          8,
                        ),
                        horizontal: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          16,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        '© 2025 Electiva Móvil - Proyecto Educativo',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            12,
                          ),
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close,
                size: ResponsiveHelper.getResponsiveFontSize(context, 18),
              ),
              label: Text(
                'Cerrar',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                ),
              ),
              style: TextButton.styleFrom(
                padding: ResponsiveHelper.getResponsivePadding(context),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResponsiveBody() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 - (_animationController.value * 0.03),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.getMaxContentWidth(context),
              ),
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: _pages,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopNavigation() {
    return Column(
      children: [
        // Header de la navegación
        Container(
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Electiva Móvil',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              20,
                            ),
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          'App Educativa',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              14,
                            ),
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
        // Lista de navegación
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final isSelected = _currentIndex == index;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _icons[index],
                      color: isSelected ? Colors.white : Colors.grey[700],
                      size: 20,
                    ),
                  ),
                  title: Text(
                    _titles[index],
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[800],
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        16,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    _getSubtitle(index),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        12,
                      ),
                    ),
                  ),
                  onTap: () => _onItemTapped(index),
                ),
              );
            },
          ),
        ),
        const Divider(),
        // Información adicional
        Container(
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: Colors.grey[600],
                  size: 20,
                ),
                title: Text(
                  'Acerca de',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      14,
                    ),
                  ),
                ),
                subtitle: Text(
                  'Versión 1.0.0',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      12,
                    ),
                  ),
                ),
                onTap: _showAboutDialog,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
