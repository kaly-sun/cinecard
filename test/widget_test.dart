// Testes automatizados do CineCard.
// Rode com:  flutter test
//
// Observação: em testes o Flutter NÃO acessa a internet, então todo
// Image.network falha de propósito. Isso é ótimo para nós: prova que o
// errorBuilder funciona (aparece "Pôster indisponível" em vez de erro).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cinecard/main.dart';

void main() {
  testWidgets('Catálogo mostra o título e os cards', (tester) async {
    await tester.pumpWidget(const CineCardApp());
    await tester.pumpAndSettle();

    expect(find.text('CineCard'), findsOneWidget);
    expect(find.text('Cidade de Deus'), findsOneWidget);
    // Cada card tem um CircleAvatar (foto local do diretor).
    expect(find.byType(CircleAvatar), findsWidgets);
    // Cada pôster está dentro de um ClipRRect (cantos arredondados).
    expect(find.byType(ClipRRect), findsWidgets);
  });

  testWidgets('errorBuilder mostra "Pôster indisponível" quando falha',
      (tester) async {
    await tester.pumpWidget(const CineCardApp());
    await tester.pumpAndSettle();

    // Sem internet no teste, todos os pôsteres caem no errorBuilder.
    expect(find.text('Pôster indisponível'), findsWidgets);
    expect(find.byIcon(Icons.movie), findsWidgets);
  });

  testWidgets('Detalhe troca o BoxFit com os botões e mostra o ativo',
      (tester) async {
    await tester.pumpWidget(const CineCardApp());
    await tester.pumpAndSettle();

    // Toca no primeiro card para abrir o detalhe.
    await tester.tap(find.text('Cidade de Deus'));
    await tester.pumpAndSettle();

    expect(find.text('BoxFit ativo: contain'), findsOneWidget);

    await tester.tap(find.text('Fill'));
    await tester.pumpAndSettle();
    expect(find.text('BoxFit ativo: fill'), findsOneWidget);

    await tester.tap(find.text('Cover'));
    await tester.pumpAndSettle();
    expect(find.text('BoxFit ativo: cover'), findsOneWidget);

    // Confere que existe um Image com fit == BoxFit.cover (o pôster grande).
    final imagens = tester.widgetList<Image>(find.byType(Image));
    expect(imagens.any((img) => img.fit == BoxFit.cover), isTrue);
  });
}
