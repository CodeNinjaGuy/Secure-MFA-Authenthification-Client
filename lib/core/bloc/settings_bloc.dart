import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mfa/core/services/tts_service.dart';

// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ToggleThemeMode extends SettingsEvent {}

class ChangeLanguage extends SettingsEvent {
  final String languageCode;

  const ChangeLanguage(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

// State
class SettingsState extends Equatable {
  final bool isDarkMode;
  final String languageCode;

  const SettingsState({
    required this.isDarkMode,
    required this.languageCode,
  });

  @override
  List<Object> get props => [isDarkMode, languageCode];

  SettingsState copyWith({
    bool? isDarkMode,
    String? languageCode,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences prefs;
  final TtsService _tts = TtsService();

  SettingsBloc(this.prefs)
      : super(SettingsState(
          isDarkMode: prefs.getBool('isDarkMode') ?? false,
          languageCode: prefs.getString('languageCode') ?? 'de',
        )) {
    on<ToggleThemeMode>((event, emit) async {
      final newIsDarkMode = !state.isDarkMode;
      await prefs.setBool('isDarkMode', newIsDarkMode);
      emit(state.copyWith(isDarkMode: newIsDarkMode));
    });

    on<ChangeLanguage>((event, emit) async {
      await prefs.setString('languageCode', event.languageCode);
      await _tts.setLanguage(event.languageCode);
      emit(state.copyWith(languageCode: event.languageCode));
    });
  }
}
