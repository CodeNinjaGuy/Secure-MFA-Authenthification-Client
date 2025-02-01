import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/mfa_account.dart';
import '../bloc/auth_bloc.dart';

class ReorderableAccountList extends StatelessWidget {
  const ReorderableAccountList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthLoaded) return const SizedBox.shrink();

        return ReorderableListView.builder(
          itemCount: state.accounts.length,
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) newIndex--;
            final accounts = List<MfaAccount>.from(state.accounts);
            final item = accounts.removeAt(oldIndex);
            accounts.insert(newIndex, item);
            context.read<AuthBloc>().add(ReorderAccounts(accounts));
          },
          itemBuilder: (context, index) {
            final account = state.accounts[index];
            return ListTile(
              key: ValueKey(account.id),
              leading: CircleAvatar(
                child: Text(account.issuer[0]),
              ),
              title: Text(account.issuer),
              subtitle: Text(account.accountName),
            );
          },
        );
      },
    );
  }
}
