import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/models/mfa_account.dart';
import '../../data/repositories/account_repository.dart';
import '../../domain/enums/sort_type.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoadAccounts extends AuthEvent {}

class AddAccount extends AuthEvent {
  final MfaAccount account;

  const AddAccount(this.account);

  @override
  List<Object?> get props => [account];
}

class SelectAccount extends AuthEvent {
  final MfaAccount? account;

  const SelectAccount(this.account);

  @override
  List<Object?> get props => [account];
}

class DeleteAccount extends AuthEvent {
  final MfaAccount account;

  const DeleteAccount(this.account);

  @override
  List<Object?> get props => [account];
}

class SortAccounts extends AuthEvent {
  final SortType sortType;
  const SortAccounts(this.sortType);

  @override
  List<Object?> get props => [sortType];
}

class FilterAccounts extends AuthEvent {
  final String query;
  const FilterAccounts(this.query);

  @override
  List<Object?> get props => [query];
}

class ReorderAccounts extends AuthEvent {
  final List<MfaAccount> accounts;
  const ReorderAccounts(this.accounts);

  @override
  List<Object?> get props => [accounts];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final List<MfaAccount> accounts;
  final MfaAccount? selectedAccount;

  const AuthLoaded(this.accounts, {this.selectedAccount});

  @override
  List<Object?> get props => [accounts, selectedAccount];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AccountRepository _repository;

  AuthBloc(this._repository) : super(AuthInitial()) {
    on<LoadAccounts>(_onLoadAccounts);
    on<AddAccount>(_onAddAccount);
    on<SelectAccount>(_onSelectAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<SortAccounts>(_onSortAccounts);
    on<FilterAccounts>(_onFilterAccounts);
    on<ReorderAccounts>(_onReorderAccounts);
  }

  Future<void> _onLoadAccounts(
      LoadAccounts event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final accounts = await _repository.loadAccounts();
      emit(AuthLoaded(accounts));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAddAccount(AddAccount event, Emitter<AuthState> emit) async {
    if (state is AuthLoaded) {
      final currentState = state as AuthLoaded;
      final updatedAccounts = [...currentState.accounts, event.account];
      await _repository.saveAccounts(updatedAccounts);
      emit(AuthLoaded(updatedAccounts));
    }
  }

  void _onSelectAccount(SelectAccount event, Emitter<AuthState> emit) {
    if (state is AuthLoaded) {
      final currentState = state as AuthLoaded;
      emit(AuthLoaded(currentState.accounts, selectedAccount: event.account));
    }
  }

  Future<void> _onDeleteAccount(
      DeleteAccount event, Emitter<AuthState> emit) async {
    if (state is AuthLoaded) {
      final currentState = state as AuthLoaded;
      final updatedAccounts = currentState.accounts
          .where((account) => account.id != event.account.id)
          .toList();

      await _repository.saveAccounts(updatedAccounts);

      // Wenn das gelöschte Konto das ausgewählte war, Auswahl aufheben
      final selectedAccount = currentState.selectedAccount;
      if (selectedAccount?.id == event.account.id) {
        emit(AuthLoaded(updatedAccounts));
      } else {
        emit(AuthLoaded(updatedAccounts, selectedAccount: selectedAccount));
      }
    }
  }

  void _onSortAccounts(SortAccounts event, Emitter<AuthState> emit) {
    if (state is AuthLoaded) {
      final currentState = state as AuthLoaded;
      var sortedAccounts = List<MfaAccount>.from(currentState.accounts);

      switch (event.sortType) {
        case SortType.nameAsc:
          sortedAccounts.sort((a, b) => a.issuer.compareTo(b.issuer));
          break;
        case SortType.nameDesc:
          sortedAccounts.sort((a, b) => b.issuer.compareTo(a.issuer));
          break;
        // ... weitere Sortieroptionen
      }

      emit(AuthLoaded(sortedAccounts,
          selectedAccount: currentState.selectedAccount));
    }
  }

  void _onFilterAccounts(FilterAccounts event, Emitter<AuthState> emit) {
    if (state is AuthLoaded) {
      final currentState = state as AuthLoaded;
      final filteredAccounts = currentState.accounts
          .where((account) =>
              account.issuer.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(AuthLoaded(filteredAccounts,
          selectedAccount: currentState.selectedAccount));
    }
  }

  void _onReorderAccounts(
      ReorderAccounts event, Emitter<AuthState> emit) async {
    await _repository.saveAccounts(event.accounts);
    emit(AuthLoaded(event.accounts));
  }
}
