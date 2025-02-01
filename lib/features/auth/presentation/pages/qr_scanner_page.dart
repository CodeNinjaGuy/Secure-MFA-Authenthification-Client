import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfa/core/constants/app_constants.dart';
import '../bloc/auth_bloc.dart';
import '../../domain/models/mfa_account.dart';
import 'package:uuid/uuid.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.scanQrTitle),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (_isProcessing) return; // Verhindere mehrfache Verarbeitung

          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              _isProcessing = true; // Setze Flag
              _handleScannedCode(context, code);
              break;
            }
          }
        },
      ),
    );
  }

  void _handleScannedCode(BuildContext context, String code) {
    try {
      final uri = Uri.parse(code);
      if (uri.scheme != 'otpauth' || uri.host != 'totp') {
        throw const FormatException('Ungültiger QR-Code');
      }

      final segments = uri.pathSegments;
      if (segments.isEmpty) {
        throw const FormatException('Fehlende Kontoinformationen');
      }

      final accountInfo = segments.last;
      final parts = accountInfo.split(':');
      final issuer = parts.length > 1
          ? parts[0]
          : uri.queryParameters['issuer'] ?? 'Unbekannt';
      final accountName = parts.length > 1 ? parts[1] : parts[0];
      final secret = uri.queryParameters['secret'];

      if (secret == null) {
        throw const FormatException('Kein Secret gefunden');
      }

      // Prüfe, ob das Konto bereits existiert
      if (context.read<AuthBloc>().state is AuthLoaded) {
        final state = context.read<AuthBloc>().state as AuthLoaded;
        final exists = state.accounts.any((a) =>
            a.issuer == issuer &&
            a.accountName == accountName &&
            a.secret == secret);

        if (exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dieses Konto existiert bereits'),
              backgroundColor: Colors.orange,
            ),
          );
          Navigator.of(context).pop();
          return;
        }
      }

      final account = MfaAccount(
        id: const Uuid().v4(),
        issuer: issuer,
        accountName: accountName,
        secret: secret,
        digits: int.tryParse(uri.queryParameters['digits'] ?? '') ?? 6,
        period: int.tryParse(uri.queryParameters['period'] ?? '') ?? 30,
        algorithm: uri.queryParameters['algorithm'] ?? 'SHA1',
      );

      context.read<AuthBloc>().add(AddAccount(account));
      Navigator.of(context).pop();
    } catch (e) {
      _isProcessing = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Scannen: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
