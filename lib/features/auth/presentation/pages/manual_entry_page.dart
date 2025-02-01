import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:base32/base32.dart';
import '../../domain/models/mfa_account.dart';
import '../bloc/auth_bloc.dart';
import '../../domain/services/totp_service.dart';

class ManualEntryPage extends StatefulWidget {
  const ManualEntryPage({super.key});

  @override
  State<ManualEntryPage> createState() => _ManualEntryPageState();
}

class _ManualEntryPageState extends State<ManualEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _issuerController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _secretController = TextEditingController();
  int _digits = 6;
  int _period = 30;

  @override
  void dispose() {
    _issuerController.dispose();
    _accountNameController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final account = MfaAccount(
        id: const Uuid().v4(),
        issuer: _issuerController.text,
        accountName: _accountNameController.text,
        secret: _secretController.text.replaceAll(' ', ''),
        digits: _digits,
        period: _period,
      );

      context.read<AuthBloc>().add(AddAccount(account));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konto manuell hinzufügen'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _issuerController,
                decoration: const InputDecoration(
                  labelText: 'Dienstanbieter',
                  hintText: 'z.B. Google, GitHub, etc.',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Bitte geben Sie einen Dienstanbieter ein';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _accountNameController,
                decoration: const InputDecoration(
                  labelText: 'Kontoname/E-Mail',
                  hintText: 'z.B. john@example.com',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Bitte geben Sie einen Kontonamen ein';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _secretController,
                decoration: const InputDecoration(
                  labelText: 'Secret Key',
                  hintText: 'Der geheime Schlüssel',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Bitte geben Sie den Secret Key ein';
                  }
                  // Validiere Base32-Format
                  try {
                    final cleanSecret = value!
                        .replaceAll(RegExp(r'[^A-Za-z2-7]'), '')
                        .toUpperCase();
                    final paddedSecret =
                        TotpService.addBase32Padding(cleanSecret);
                    base32.decode(paddedSecret);
                    return null;
                  } catch (_) {
                    return 'Ungültiger Secret Key (Base32-Format erforderlich)';
                  }
                },
              ),
              const SizedBox(height: 24),
              const Text('Erweiterte Einstellungen:'),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _digits,
                decoration: const InputDecoration(
                  labelText: 'Code-Länge',
                ),
                items: const [
                  DropdownMenuItem(value: 6, child: Text('6 Stellen')),
                  DropdownMenuItem(value: 8, child: Text('8 Stellen')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _digits = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _period,
                decoration: const InputDecoration(
                  labelText: 'Aktualisierungsintervall',
                ),
                items: const [
                  DropdownMenuItem(value: 30, child: Text('30 Sekunden')),
                  DropdownMenuItem(value: 60, child: Text('60 Sekunden')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _period = value);
                  }
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Konto hinzufügen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
