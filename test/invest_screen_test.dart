import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trabalho_final/invest.dart';

void main() {
  testWidgets('Tela de investimentos exibe botão voltar e retorna', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TelaInvestimentos(),
                    ),
                  );
                },
                child: const Text('Abrir investimentos'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir investimentos'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Voltar'), findsOneWidget);

    await tester.tap(find.byTooltip('Voltar'));
    await tester.pumpAndSettle();

    expect(find.text('Abrir investimentos'), findsOneWidget);
  });
}
