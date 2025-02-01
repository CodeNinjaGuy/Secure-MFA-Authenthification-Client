import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/mfa_account.dart';
import '../../domain/services/backup_service.dart';

class AccountRepository {
  static const String _storageKey = 'mfa_accounts';
  final SharedPreferences _prefs;

  AccountRepository(this._prefs);

  Future<List<MfaAccount>> loadAccounts() async {
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString == null) {
      // Versuche Wiederherstellung aus Backup
      try {
        final accounts = await BackupService.restoreFromAutoBackup();
        await saveAccounts(accounts); // Speichere wiederhergestellte Konten
        return accounts;
      } catch (e) {
        return [];
      }
    }

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => MfaAccount.fromJson(json)).toList();
  }

  Future<void> saveAccounts(List<MfaAccount> accounts) async {
    final jsonList = accounts.map((account) => account.toJson()).toList();
    await _prefs.setString(_storageKey, json.encode(jsonList));

    // Automatisches Backup erstellen
    await BackupService.createAutoBackup(accounts);
  }
}
