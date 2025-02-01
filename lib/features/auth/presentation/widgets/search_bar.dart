import 'package:flutter/material.dart';
import 'package:mfa/core/l10n/app_localizations.dart';

class AccountSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onClear;

  const AccountSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SearchBar(
        controller: controller,
        hintText: l10n.searchAccounts,
        leading: Icon(
          Icons.search,
          color: colorScheme.onSurfaceVariant,
          semanticLabel: l10n.search,
        ),
        trailing: [
          if (controller.text.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear,
                semanticLabel: l10n.clear,
              ),
              onPressed: () {
                controller.clear();
                onClear();
              },
            ),
        ],
        onChanged: onChanged,
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
    );
  }
}
