import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/mfa_account.dart';
import '../../domain/services/totp_service.dart';
import '../bloc/auth_bloc.dart';
import '../pages/how_it_works_page.dart';
import 'package:mfa/core/services/tts_service.dart';
import 'package:mfa/core/l10n/app_localizations.dart';

class DetailView extends StatefulWidget {
  final MfaAccount account;

  const DetailView({
    super.key,
    required this.account,
  });

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  final TtsService _tts = TtsService();

  @override
  void initState() {
    super.initState();
    _tts.initialize();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final isMobile = MediaQuery.of(context).size.width <= 600;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surface,
            colorScheme.surface.withAlpha(242),
          ],
        ),
      ),
      child: Column(
        children: [
          if (isMobile) // Zurück-Button nur auf mobilen Geräten
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      context.read<AuthBloc>().add(const SelectAccount(null));
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header mit Animation
                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Hero(
                          tag: 'avatar-${widget.account.id}',
                          child: Material(
                            elevation: 8,
                            shadowColor: colorScheme.primary.withAlpha(77),
                            borderRadius: BorderRadius.circular(40),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: colorScheme.primaryContainer,
                              child: Text(
                                widget.account.issuer[0],
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.account.issuer,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.account.accountName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: colorScheme.secondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  // TOTP Code mit Animation
                  StreamBuilder<String>(
                    stream: TotpService.getTotpStream(
                      widget.account.secret,
                      period: widget.account.period,
                    ),
                    builder: (context, snapshot) {
                      final code = snapshot.data ??
                          TotpService.generateTotp(
                            widget.account.secret,
                            period: widget.account.period,
                          );
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.2),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          key: ValueKey(code),
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 24,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.shadow.withAlpha(26),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      code.substring(0, 3),
                                      style: TextStyle(
                                        fontSize: 56,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 8,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      width: 2,
                                      height: 40,
                                      color: colorScheme.primary.withAlpha(77),
                                    ),
                                    Text(
                                      code.substring(3),
                                      style: TextStyle(
                                        fontSize: 56,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 8,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TotpProgressIndicator(
                                period: widget.account.period),
                          ],
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  // Action Buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ActionButton(
                          icon: Icons.copy,
                          label: l10n.copyCode,
                          onPressed: () {
                            final code = TotpService.generateTotp(
                              widget.account.secret,
                              period: widget.account.period,
                            );
                            Clipboard.setData(ClipboardData(text: code));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.codeCopied),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                width: 200,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        _ActionButton(
                          icon: Icons.volume_up,
                          label: l10n.speak,
                          onPressed: _tts.isInitialized
                              ? () {
                                  final code = TotpService.generateTotp(
                                    widget.account.secret,
                                    period: widget.account.period,
                                  );
                                  final formattedCode =
                                      '${code.substring(0, 3)} ${code.substring(3)}';
                                  _tts.speak(formattedCode);
                                }
                              : null,
                        ),
                        _ActionButton(
                          icon: Icons.info_outline,
                          label: l10n.details,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  AccountDetailsDialog(account: widget.account),
                            );
                          },
                        ),
                        _ActionButton(
                          icon: Icons.help_outline,
                          label: l10n.info,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const HowItWorksPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Verbesserte Progress Indicator Animation
class TotpProgressIndicator extends StatelessWidget {
  final int period;

  const TotpProgressIndicator({
    super.key,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<int>(
      stream: Stream.periodic(
        const Duration(seconds: 1),
        (_) => TotpService.getRemainingSeconds(period: period),
      ),
      initialData: TotpService.getRemainingSeconds(period: period),
      builder: (context, snapshot) {
        final remaining = snapshot.data ?? 0;
        final progress = remaining / period;
        final isLow = remaining <= 5;
        final colorScheme = Theme.of(context).colorScheme;

        return Column(
          children: [
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 300),
              tween: Tween<double>(begin: 0, end: progress),
              builder: (context, double value, _) {
                return Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withAlpha(77),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: isLow ? colorScheme.error : colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: (isLow
                                    ? colorScheme.error
                                    : colorScheme.primary)
                                .withAlpha(102),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isLow ? colorScheme.error : colorScheme.onSurface,
                fontWeight: isLow ? FontWeight.bold : FontWeight.normal,
              ),
              child: Text(
                '$remaining ${l10n.secondsRemaining}',
              ),
            ),
          ],
        );
      },
    );
  }
}

class AccountDetailsDialog extends StatelessWidget {
  final MfaAccount account;

  const AccountDetailsDialog({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(40),
              blurRadius: 24,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      account.issuer[0],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.issuer,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                        ),
                        Text(
                          account.accountName,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onPrimaryContainer
                                        .withAlpha(180),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailTile(
                    icon: Icons.timer,
                    label: l10n.period,
                    value: '${account.period} ${l10n.seconds}',
                  ),
                  const SizedBox(height: 16),
                  _DetailTile(
                    icon: Icons.pin,
                    label: l10n.codeLength,
                    value: '${account.digits} ${l10n.digits}',
                  ),
                  const SizedBox(height: 16),
                  _DetailTile(
                    icon: Icons.security,
                    label: l10n.algorithm,
                    value: account.algorithm,
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Delete Button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(l10n.delete),
                            content: Text(
                              '${l10n.pleaseConfirmDelete} "${account.issuer}"?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(l10n.cancel),
                              ),
                              FilledButton.icon(
                                onPressed: () {
                                  context
                                      .read<AuthBloc>()
                                      .add(DeleteAccount(account));
                                  Navigator.of(context)
                                      .pop(); // Schließe Bestätigungsdialog
                                  Navigator.of(context)
                                      .pop(); // Schließe Details-Dialog
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: colorScheme.error,
                                  foregroundColor: colorScheme.onError,
                                ),
                                icon: const Icon(Icons.delete_forever),
                                label: Text(l10n.delete),
                              ),
                            ],
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        padding: const EdgeInsets.all(16),
                      ),
                      icon: const Icon(Icons.delete_outline),
                      label: Text(l10n.deleteAccount),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: colorScheme.onSecondaryContainer,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
