import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mfa/core/constants/app_constants.dart';
import 'package:mfa/core/themes/app_theme.dart';
import 'package:mfa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mfa/features/auth/presentation/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mfa/features/auth/data/repositories/account_repository.dart';
import 'package:mfa/core/bloc/settings_bloc.dart';
import 'package:mfa/core/l10n/app_localizations.dart';
import 'package:mfa/core/services/tts_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final repository = AccountRepository(prefs);
  final settingsBloc = SettingsBloc(prefs);

  // Initialisiere TTS mit der gespeicherten Sprache
  final tts = TtsService();
  await tts.initialize();
  await tts.setLanguage(prefs.getString('languageCode') ?? 'de');

  runApp(MyApp(
    repository: repository,
    settingsBloc: settingsBloc,
  ));
}

class MyApp extends StatefulWidget {
  final AccountRepository repository;
  final SettingsBloc settingsBloc;

  const MyApp({
    super.key,
    required this.repository,
    required this.settingsBloc,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final TtsService _tts = TtsService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // TTS neu initialisieren wenn App wieder im Vordergrund
      _tts.initialize().then((_) {
        // Aktuelle Sprache setzen
        final currentLanguage = widget.settingsBloc.state.languageCode;
        _tts.setLanguage(currentLanguage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(widget.repository)..add(LoadAccounts()),
        ),
        BlocProvider.value(value: widget.settingsBloc),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settings) {
          return MaterialApp(
            title: AppConstants.appTitle,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            locale: Locale(settings.languageCode),
            supportedLocales: const [
              Locale('de'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
