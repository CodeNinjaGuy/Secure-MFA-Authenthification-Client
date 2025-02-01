import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfa/core/constants/app_constants.dart';
import '../../domain/models/mfa_account.dart';
import '../bloc/auth_bloc.dart';
import './qr_scanner_page.dart';
import './manual_entry_page.dart';
import '../widgets/detail_view.dart';
import './about_page.dart';
import '../widgets/search_bar.dart';
import 'package:mfa/features/settings/presentation/pages/settings_page.dart';
import 'package:mfa/core/l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final showFab = state is AuthLoaded && state.selectedAccount == null;

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppConstants.appTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AboutPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: AdaptiveLayout(
            body: Column(
              children: [
                AccountSearchBar(
                  controller: _searchController,
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query.toLowerCase();
                    });
                  },
                  onClear: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                ),
                Expanded(
                  child: _buildAccountList(state),
                ),
              ],
            ),
          ),
          floatingActionButton: showFab
              ? FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => const AddAccountSheet(),
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  Widget _buildAccountList(AuthState state) {
    if (state is AuthLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AuthLoaded) {
      final filteredAccounts = state.accounts.where((account) {
        final searchLower = _searchQuery.toLowerCase();
        return account.issuer.toLowerCase().contains(searchLower) ||
            account.accountName.toLowerCase().contains(searchLower);
      }).toList();

      if (filteredAccounts.isEmpty) {
        if (_searchQuery.isNotEmpty) {
          return _buildNoSearchResults();
        }
        return const EmptyAccountsView();
      }

      return AccountListView(accounts: filteredAccounts);
    }

    return const SizedBox.shrink();
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Keine Konten gefunden',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Versuchen Sie es mit einem anderen Suchbegriff',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class AdaptiveLayout extends StatelessWidget {
  final Widget body;

  const AdaptiveLayout({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Tablet/Desktop Layout
          return Row(
            children: [
              SizedBox(
                width: 320,
                child: body,
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoaded && state.selectedAccount != null) {
                      return DetailView(account: state.selectedAccount!);
                    }
                    return const Center(
                      child: Text('Wählen Sie ein Konto aus'),
                    );
                  },
                ),
              ),
            ],
          );
        }
        // Mobile Layout
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoaded && state.selectedAccount != null) {
              return DetailView(account: state.selectedAccount!);
            }
            return body;
          },
        );
      },
    );
  }
}

class EmptyAccountsView extends StatelessWidget {
  const EmptyAccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.security,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.emptyAccountsTitle,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.emptyAccountsMessage,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class AccountListView extends StatelessWidget {
  final List<MfaAccount> accounts;

  const AccountListView({
    super.key,
    required this.accounts,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthLoaded) return const SizedBox.shrink();

        return ListView.builder(
          itemCount: state.accounts.length,
          itemBuilder: (context, index) {
            final account = state.accounts[index];
            final isSelected = account == state.selectedAccount;

            return ListTile(
              leading: CircleAvatar(
                child: Text(account.issuer[0]),
              ),
              title: Text(account.issuer),
              subtitle: Text(account.accountName),
              trailing: isSelected ? const Icon(Icons.check) : null,
              selected: isSelected,
              onTap: () {
                context.read<AuthBloc>().add(SelectAccount(account));
              },
            );
          },
        );
      },
    );
  }
}

class AddAccountSheet extends StatelessWidget {
  const AddAccountSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Konto hinzufügen',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const QrScannerPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('QR-Code scannen'),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ManualEntryPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Manuell eingeben'),
              ),
            ],
          ),
        );
      },
    );
  }
}
