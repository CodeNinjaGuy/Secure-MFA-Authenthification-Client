// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mfa/main.dart';
import 'package:mfa/features/auth/data/repositories/account_repository.dart';
import 'package:mfa/core/bloc/settings_bloc.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    final repository = AccountRepository(prefs);
    final settingsBloc = SettingsBloc(prefs);

    await tester.pumpWidget(MyApp(
      repository: repository,
      settingsBloc: settingsBloc,
    ));

    expect(find.text('Keine MFA-Konten vorhanden'), findsOneWidget);
  });
}
