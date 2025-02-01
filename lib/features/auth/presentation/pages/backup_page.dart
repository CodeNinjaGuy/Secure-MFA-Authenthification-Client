import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfa/core/constants/app_constants.dart';
import '../../domain/services/backup_service.dart';
import '../bloc/auth_bloc.dart';
import '../../domain/models/mfa_account.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.backupTitle),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.backup,
                        size: 48,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Backup erstellen',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sichern Sie Ihre MFA-Konten in der Zwischenablage',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => _createBackup(context, state.accounts),
                        icon: const Icon(Icons.save),
                        label: const Text(AppConstants.createBackupButton),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.restore,
                        size: 48,
                        color: colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Backup wiederherstellen',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Stellen Sie Ihre gesicherten MFA-Konten aus der Zwischenablage wieder her',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                            ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () => _restoreBackup(context),
                        icon: const Icon(Icons.upload),
                        label: const Text(AppConstants.restoreBackupButton),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FutureBuilder<DateTime?>(
                  future: BackupService.getLastBackupDate(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    final lastBackup = snapshot.data;
                    if (lastBackup == null) return const SizedBox.shrink();

                    return Text(
                      'Letztes automatisches Backup: ${_formatDate(lastBackup)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.secondary,
                          ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _createBackup(
      BuildContext context, List<MfaAccount> accounts) async {
    try {
      final backupString = BackupService.exportAccounts(accounts);
      await Clipboard.setData(ClipboardData(text: backupString));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppConstants.backupCreatedMessage),
            behavior: SnackBarBehavior.floating,
            width: 280,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppConstants.backupErrorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _restoreBackup(BuildContext context) async {
    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboard?.text == null) return;

    try {
      final accounts = BackupService.importAccounts(clipboard!.text!);
      if (context.mounted) {
        context.read<AuthBloc>().add(ReorderAccounts(accounts));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppConstants.backupRestoredMessage),
            behavior: SnackBarBehavior.floating,
            width: 280,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppConstants.invalidBackupMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
