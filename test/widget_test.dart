import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart'; // Asegúrate que este nombre coincida con el del proyecto

void main() {
  testWidgets('Se muestran los botones de canales en la página principal', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('ESPN Premium'), findsOneWidget);
    expect(find.text('Win Sports+'), findsOneWidget);
    expect(find.text('TNT Argentina'), findsOneWidget);
    expect(find.text('Gol Perú'), findsOneWidget);
  });
}
