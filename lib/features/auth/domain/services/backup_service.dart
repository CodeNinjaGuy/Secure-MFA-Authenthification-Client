import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/mfa_account.dart';

class BackupService {
  static const String _backupKey = 'mfa_backup';
  static const String _backupDateKey = 'mfa_backup_date';

  static String exportAccounts(List<MfaAccount> accounts) {
    final jsonList = accounts.map((acc) => acc.toJson()).toList();
    return base64Encode(utf8.encode(json.encode(jsonList)));
  }

  static List<MfaAccount> importAccounts(String backupString) {
    try {
      final jsonString = utf8.decode(base64Decode(backupString));
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => MfaAccount.fromJson(json)).toList();
    } catch (e) {
      throw const FormatException('Ungültiges Backup-Format');
    }
  }

  // Neues automatisches Backup
  static Future<void> createAutoBackup(List<MfaAccount> accounts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final backupString = exportAccounts(accounts);

      await prefs.setString(_backupKey, backupString);
      await prefs.setString(_backupDateKey, DateTime.now().toIso8601String());
    } catch (e) {
      // Fehler beim Backup
    }
  }

  // Backup wiederherstellen
  static Future<List<MfaAccount>> restoreFromAutoBackup() async {
    final prefs = await SharedPreferences.getInstance();
    final backupString = prefs.getString(_backupKey);

    if (backupString == null) {
      throw const FormatException('Kein Backup vorhanden');
    }

    return importAccounts(backupString);
  }

  // Backup-Datum abrufen
  static Future<DateTime?> getLastBackupDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_backupDateKey);

    if (dateString == null) return null;

    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}
