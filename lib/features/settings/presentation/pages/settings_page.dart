import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfa/core/bloc/settings_bloc.dart';
import 'package:mfa/core/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionHeader(
                icon: Icons.palette_outlined,
                title: l10n.appearance,
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: Icon(
                    state.isDarkMode
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                  ),
                  title: Text(l10n.darkMode),
                  subtitle: Text(
                    state.isDarkMode ? l10n.enabled : l10n.disabled,
                    style: TextStyle(color: colorScheme.secondary),
                  ),
                  trailing: Switch(
                    value: state.isDarkMode,
                    onChanged: (_) {
                      context.read<SettingsBloc>().add(ToggleThemeMode());
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _SectionHeader(
                icon: Icons.language_outlined,
                title: l10n.language,
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Deutsch'),
                      value: 'de',
                      groupValue: state.languageCode,
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<SettingsBloc>()
                              .add(ChangeLanguage(value));
                        }
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('English'),
                      value: 'en',
                      groupValue: state.languageCode,
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<SettingsBloc>()
                              .add(ChangeLanguage(value));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
      ],
    );
  }
}
