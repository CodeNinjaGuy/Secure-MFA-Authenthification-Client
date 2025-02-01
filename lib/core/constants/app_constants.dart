class AppConstants {
  static const String appTitle = 'Secure MFA Authenticator';
  static const String addAccountTitle = 'Konto hinzufügen';
  static const String scanQrTitle = 'QR-Code scannen';
  static const String aboutTitle = 'Über die App';

  // About Screen Texte
  static const String developer = 'Martin Bundschuh';
  static const String appVersion = '1.0.0';
  static const String appDescription = '''
Eine moderne Multi-Faktor-Authentifizierungs-App für erhöhte Sicherheit.

Funktionen:
• Generierung von TOTP-Codes (Time-based One-Time Passwords)
• Unterstützung für QR-Code-Scanning
• Manuelle Eingabe von Authentifizierungsschlüsseln
• Automatische Code-Aktualisierung
• Dunkelmodus-Unterstützung
• Sicheres lokales Speichern der Zugangsdaten
• Material 3 Design

Unterstützte Sicherheitsstandards:
• TOTP (RFC 6238)
• HMAC-SHA1 Verschlüsselung
• Base32-Kodierung für Secrets
• 6- und 8-stellige Codes
• 30- und 60-Sekunden Intervalle
• Kompatibel mit Google Authenticator
''';

  // Technische Spezifikationen
  static const String securityDetails = '''
Implementierte Standards:
• Time-Based One-Time Password (TOTP) - RFC 6238
• HMAC-Based One-Time Password (HOTP) - RFC 4226
• Secure Hash Algorithm 1 (SHA-1)
• Base32 Encoding - RFC 4648

Sicherheitsmerkmale:
• Verschlüsselte lokale Speicherung
• Keine Cloud-Synchronisation
• Keine Netzwerkkommunikation erforderlich
• Offline-fähig
''';

  static const String howItWorksTitle = 'Wie funktioniert TOTP?';

  static const String totpExplanation = '''
Time-based One-Time Password (TOTP) ist ein sicherer Algorithmus zur Generierung temporärer Codes:

1. Zeitbasierte Generierung
• Der aktuelle Zeitstempel wird in 30-Sekunden-Intervalle unterteilt
• Dies garantiert, dass Server und App den gleichen Code generieren

2. Geheimer Schlüssel
• Ein einzigartiger Base32-kodierter Schlüssel wird bei der Einrichtung geteilt
• Dieser bleibt geheim und wird nur lokal gespeichert

3. Code-Generierung
• Zeit + Geheimer Schlüssel → HMAC-SHA1 → 6-stelliger Code
• Der Code ist nur für 30 Sekunden gültig
• Jeder Code kann nur einmal verwendet werden

4. Synchronisation
• Die Codes basieren auf der UTC-Zeit
• Keine Internetverbindung erforderlich
• Server und App müssen nur grob zeitsynchronisiert sein
''';

  static const String totpTechnicalDetails = '''
Technische Implementierung:
1. Zeit → Unix-Timestamp ÷ 30 = Counter
2. Counter + Secret → HMAC-SHA1
3. HMAC-Output → Dynamische Trunkierung
4. Modulo 1.000.000 → 6-stelliger Code
''';

  static const String backupTitle = 'Backup & Wiederherstellung';
  static const String createBackupButton = 'Backup erstellen';
  static const String restoreBackupButton = 'Backup wiederherstellen';
  static const String backupCreatedMessage = 'Backup wurde erstellt';
  static const String backupRestoredMessage = 'Backup wurde wiederhergestellt';
  static const String backupErrorMessage = 'Fehler beim Backup';
  static const String invalidBackupMessage = 'Ungültiges Backup-Format';
}
