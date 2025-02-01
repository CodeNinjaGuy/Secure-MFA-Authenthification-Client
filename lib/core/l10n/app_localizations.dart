import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Secure MFA Authenticator',
      'settings': 'Settings',
      'appearance': 'Appearance',
      'darkMode': 'Dark Mode',
      'enabled': 'Enabled',
      'disabled': 'Disabled',
      'language': 'Language',
      'noAccounts': 'No MFA Accounts',
      'addAccount': 'Add Account',
      'scanQrCode': 'Scan QR Code',
      'manualEntry': 'Manual Entry',
      'searchAccounts': 'Search accounts...',
      'noAccountsFound': 'No accounts found',
      'tryDifferentSearch': 'Try a different search term',
      'selectAccount': 'Select an account',
      'error': 'Error loading accounts',
      'howItWorks': 'How TOTP Works',
      'backup': 'Backup & Restore',
      'createBackup': 'Create Backup',
      'restoreBackup': 'Restore Backup',
      'backupCreated': 'Backup created',
      'backupRestored': 'Backup restored',
      'backupError': 'Backup error',
      'invalidBackup': 'Invalid backup format',
      'copyCode': 'Copy Code',
      'codeCopied': 'Code copied',
      'speak': 'Speak Code',
      'delete': 'Delete',
      'edit': 'Edit',
      'cancel': 'Cancel',
      'save': 'Save',
      'provider': 'Provider',
      'accountName': 'Account Name/Email',
      'accountNameHint': 'e.g. john@example.com',
      'secretKey': 'Secret Key',
      'secretKeyHint': 'The secret key',
      'advancedSettings': 'Advanced Settings',
      'codeLength': 'Code Length',
      'digits': 'digits',
      'period': 'Period',
      'seconds': 'seconds',
      'algorithm': 'Algorithm',
      'pleaseEnterProvider': 'Please enter a provider',
      'pleaseEnterAccount': 'Please enter an account name',
      'pleaseEnterSecret': 'Please enter the secret key',
      'invalidSecretKey': 'Invalid secret key (Base32 format required)',
      'tapToAddAccount': 'Tap + to add an account',
      'version': 'Version',
      'search': 'Search',
      'clear': 'Clear',
      'secondsRemaining': 'seconds remaining',
      'authenticatorCode': 'Authenticator Code',
      'pleaseConfirmDelete': 'Do you really want to delete the account',
      'updateInterval': 'Update Interval',
      'details': 'Details',
      'info': 'Info',
      'deleteAccount': 'Delete Account',
      'emptyAccountsTitle': 'No MFA Accounts',
      'emptyAccountsMessage': 'Tap + to add an account',
      'addAccountTitle': 'Add Account',
      'accountExists': 'This account already exists',
      'menu': 'Menu',
      'about': 'About',
    },
    'de': {
      'appTitle': 'Secure MFA Authenticator',
      'settings': 'Einstellungen',
      'appearance': 'Erscheinungsbild',
      'darkMode': 'Dunkles Design',
      'enabled': 'Aktiviert',
      'disabled': 'Deaktiviert',
      'language': 'Sprache',
      'noAccounts': 'Keine MFA-Konten vorhanden',
      'addAccount': 'Konto hinzufügen',
      'scanQrCode': 'QR-Code scannen',
      'manualEntry': 'Manuelle Eingabe',
      'searchAccounts': 'Konten durchsuchen...',
      'noAccountsFound': 'Keine Konten gefunden',
      'tryDifferentSearch': 'Versuchen Sie es mit einem anderen Suchbegriff',
      'selectAccount': 'Wählen Sie ein Konto aus',
      'error': 'Fehler beim Laden der Konten',
      'howItWorks': 'Wie TOTP funktioniert',
      'backup': 'Backup & Wiederherstellung',
      'createBackup': 'Backup erstellen',
      'restoreBackup': 'Backup wiederherstellen',
      'backupCreated': 'Backup wurde erstellt',
      'backupRestored': 'Backup wurde wiederhergestellt',
      'backupError': 'Fehler beim Backup',
      'invalidBackup': 'Ungültiges Backup-Format',
      'copyCode': 'Code kopieren',
      'codeCopied': 'Code kopiert',
      'speak': 'Code vorlesen',
      'delete': 'Löschen',
      'edit': 'Bearbeiten',
      'cancel': 'Abbrechen',
      'save': 'Speichern',
      'provider': 'Dienstanbieter',
      'accountName': 'Kontoname/E-Mail',
      'accountNameHint': 'z.B. john@example.com',
      'secretKey': 'Secret Key',
      'secretKeyHint': 'Der geheime Schlüssel',
      'advancedSettings': 'Erweiterte Einstellungen',
      'codeLength': 'Code-Länge',
      'digits': 'Stellen',
      'period': 'Intervall',
      'seconds': 'Sekunden',
      'algorithm': 'Algorithmus',
      'pleaseEnterProvider': 'Bitte geben Sie einen Dienstanbieter ein',
      'pleaseEnterAccount': 'Bitte geben Sie einen Kontonamen ein',
      'pleaseEnterSecret': 'Bitte geben Sie den Secret Key ein',
      'invalidSecretKey': 'Ungültiger Secret Key (Base32-Format erforderlich)',
      'tapToAddAccount': 'Tippen Sie auf +, um ein Konto hinzuzufügen',
      'version': 'Version',
      'search': 'Suchen',
      'clear': 'Löschen',
      'secondsRemaining': 'Sekunden verbleibend',
      'authenticatorCode': 'Authentifizierungscode',
      'pleaseConfirmDelete': 'Möchten Sie das Konto wirklich löschen',
      'updateInterval': 'Aktualisierungsintervall',
      'details': 'Details',
      'info': 'Info',
      'deleteAccount': 'Konto löschen',
      'emptyAccountsTitle': 'Keine MFA-Konten vorhanden',
      'emptyAccountsMessage': 'Tippen Sie auf +, um ein Konto hinzuzufügen',
      'addAccountTitle': 'Konto hinzufügen',
      'accountExists': 'Dieses Konto existiert bereits',
      'menu': 'Menü',
      'about': 'Über die App',
    },
  };

  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get appearance =>
      _localizedValues[locale.languageCode]!['appearance']!;
  String get darkMode => _localizedValues[locale.languageCode]!['darkMode']!;
  String get enabled => _localizedValues[locale.languageCode]!['enabled']!;
  String get disabled => _localizedValues[locale.languageCode]!['disabled']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get noAccounts =>
      _localizedValues[locale.languageCode]!['noAccounts']!;
  String get searchAccounts =>
      _localizedValues[locale.languageCode]!['searchAccounts']!;
  String get noAccountsFound =>
      _localizedValues[locale.languageCode]!['noAccountsFound']!;
  String get tryDifferentSearch =>
      _localizedValues[locale.languageCode]!['tryDifferentSearch']!;
  String get selectAccount =>
      _localizedValues[locale.languageCode]!['selectAccount']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get howItWorks =>
      _localizedValues[locale.languageCode]!['howItWorks']!;
  String get backup => _localizedValues[locale.languageCode]!['backup']!;
  String get createBackup =>
      _localizedValues[locale.languageCode]!['createBackup']!;
  String get restoreBackup =>
      _localizedValues[locale.languageCode]!['restoreBackup']!;
  String get backupCreated =>
      _localizedValues[locale.languageCode]!['backupCreated']!;
  String get backupRestored =>
      _localizedValues[locale.languageCode]!['backupRestored']!;
  String get backupError =>
      _localizedValues[locale.languageCode]!['backupError']!;
  String get invalidBackup =>
      _localizedValues[locale.languageCode]!['invalidBackup']!;
  String get copyCode => _localizedValues[locale.languageCode]!['copyCode']!;
  String get codeCopied =>
      _localizedValues[locale.languageCode]!['codeCopied']!;
  String get speak => _localizedValues[locale.languageCode]!['speak']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get provider => _localizedValues[locale.languageCode]!['provider']!;
  String get accountName =>
      _localizedValues[locale.languageCode]!['accountName']!;
  String get accountNameHint =>
      _localizedValues[locale.languageCode]!['accountNameHint']!;
  String get secretKey => _localizedValues[locale.languageCode]!['secretKey']!;
  String get secretKeyHint =>
      _localizedValues[locale.languageCode]!['secretKeyHint']!;
  String get advancedSettings =>
      _localizedValues[locale.languageCode]!['advancedSettings']!;
  String get codeLength =>
      _localizedValues[locale.languageCode]!['codeLength']!;
  String get digits => _localizedValues[locale.languageCode]!['digits']!;
  String get period => _localizedValues[locale.languageCode]!['period']!;
  String get seconds => _localizedValues[locale.languageCode]!['seconds']!;
  String get algorithm => _localizedValues[locale.languageCode]!['algorithm']!;
  String get pleaseEnterProvider =>
      _localizedValues[locale.languageCode]!['pleaseEnterProvider']!;
  String get pleaseEnterAccount =>
      _localizedValues[locale.languageCode]!['pleaseEnterAccount']!;
  String get pleaseEnterSecret =>
      _localizedValues[locale.languageCode]!['pleaseEnterSecret']!;
  String get invalidSecretKey =>
      _localizedValues[locale.languageCode]!['invalidSecretKey']!;
  String get tapToAddAccount =>
      _localizedValues[locale.languageCode]!['tapToAddAccount']!;
  String get version => _localizedValues[locale.languageCode]!['version']!;
  String get search => _localizedValues[locale.languageCode]!['search']!;
  String get clear => _localizedValues[locale.languageCode]!['clear']!;
  String get secondsRemaining =>
      _localizedValues[locale.languageCode]!['secondsRemaining']!;
  String get authenticatorCode =>
      _localizedValues[locale.languageCode]!['authenticatorCode']!;
  String get pleaseConfirmDelete =>
      _localizedValues[locale.languageCode]!['pleaseConfirmDelete']!;
  String get updateInterval =>
      _localizedValues[locale.languageCode]!['updateInterval']!;
  String get details => _localizedValues[locale.languageCode]!['details']!;
  String get info => _localizedValues[locale.languageCode]!['info']!;
  String get deleteAccount =>
      _localizedValues[locale.languageCode]!['deleteAccount']!;
  String get emptyAccountsTitle =>
      _localizedValues[locale.languageCode]!['emptyAccountsTitle']!;
  String get emptyAccountsMessage =>
      _localizedValues[locale.languageCode]!['emptyAccountsMessage']!;
  String get addAccountTitle =>
      _localizedValues[locale.languageCode]!['addAccountTitle']!;
  String get accountExists =>
      _localizedValues[locale.languageCode]!['accountExists']!;
  String get menu => _localizedValues[locale.languageCode]!['menu']!;
  String get about => _localizedValues[locale.languageCode]!['about']!;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
