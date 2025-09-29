import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Breakpoints para diferentes tamaños de pantalla
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;
  static const double desktopMaxWidth = 1440;

  // Métodos para detectar tipo de dispositivo
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMaxWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileMaxWidth &&
      MediaQuery.of(context).size.width < tabletMaxWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMaxWidth;

  // Método para obtener el número de columnas según el tamaño
  static int getColumns(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4; // Desktop
  }

  // Método para obtener padding responsive
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(32);
    }
  }

  // Método para obtener el máximo ancho de contenido
  static double getMaxContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (isDesktop(context)) {
      return screenWidth > desktopMaxWidth ? desktopMaxWidth : screenWidth;
    }
    return screenWidth;
  }

  // Método para obtener tamaño de fuente responsive
  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    if (isMobile(context)) {
      return baseFontSize * 0.9;
    } else if (isTablet(context)) {
      return baseFontSize * 1.1;
    } else {
      return baseFontSize * 1.2;
    }
  }

  // Método para obtener espaciado responsive
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    if (isMobile(context)) {
      return baseSpacing * 0.8;
    } else if (isTablet(context)) {
      return baseSpacing * 1.2;
    } else {
      return baseSpacing * 1.5;
    }
  }

  // Método para determinar si usar Drawer o BottomNavigationBar
  static bool shouldUseDrawerOnly(BuildContext context) {
    return isDesktop(context);
  }

  // Método para determinar orientación
  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  // Método para obtener aspect ratio responsive
  static double getCardAspectRatio(BuildContext context) {
    if (isMobile(context)) {
      return isLandscape(context) ? 1.8 : 1.2;
    } else if (isTablet(context)) {
      return 1.4;
    } else {
      return 1.6;
    }
  }
}
