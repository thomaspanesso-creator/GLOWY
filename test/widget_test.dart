import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Asegúrate de que este import coincida exactamente con el nombre de tu proyecto
import 'package:flutter_application_4/main.dart';

void main() {
  // Configuración inicial requerida para pruebas que usan almacenamiento local simulado
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'GLOWY inicializa en la pantalla de Login cuando no hay sesión activa',
    (WidgetTester tester) async {
      // 1. Inicializamos la app simulando que NO hay sesión guardada (isLoggedIn: false)
      await tester.pumpWidget(const GlowyApp(isLoggedIn: false));

      // 2. Verificamos que se renderice el eslogan exclusivo de tu Login
      expect(find.text('MADE FOR NAIL LOVERS'), findsOneWidget);

      // 3. Verificamos que el botón con el texto de inicio de sesión esté en pantalla
      expect(find.text('INICIAR SESIÓN'), findsOneWidget);
    },
  );

  testWidgets('GLOWY va directo al Feed si la sesión ya estaba guardada', (
    WidgetTester tester,
  ) async {
    // 1. Inicializamos la app simulando que SÍ hay una sesión guardada activa (isLoggedIn: true)
    await tester.pumpWidget(const GlowyApp(isLoggedIn: true));

    // 2. Verificamos que cargue directamente el Feed principal de la comunidad
    expect(find.text('GLOWY'), findsOneWidget);
    expect(
      find.text('¡Bienvenida a la comunidad de Nail Art!'),
      findsOneWidget,
    );

    // 3. Verificamos que aparezca el botón de tus filtros avanzados (icono tune)
    expect(find.byIcon(Icons.tune), findsOneWidget);
  });
}
