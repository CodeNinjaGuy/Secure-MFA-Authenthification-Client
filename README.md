# Secure MFA Authenticator

Eine moderne und sichere Multi-Faktor-Authentifizierungs-App für iOS und Android, entwickelt mit Flutter.

## Features

### Sicherheit & Privatsphäre
- **100% Offline**: Keine Internetverbindung erforderlich
- **Keine Cloud**: Alle Daten bleiben auf dem Gerät
- **Verschlüsselte Speicherung**: Sichere lokale Datenhaltung
- **Automatische Backups**: Zusätzliche Sicherheit durch lokale Backups
- **Keine Berechtigungen**: Nur Kamera (für QR) und Audio (für TTS) erforderlich

### Authentifizierung
- **TOTP-Standard**: RFC 6238 konform
- **Volle Kompatibilität**: Funktioniert mit allen gängigen 2FA-Diensten
- **QR-Code Scanner**: Schnelles Hinzufügen neuer Konten
- **Manuelle Eingabe**: Alternative zum QR-Code
- **Verschiedene Zeitintervalle**: 30 oder 60 Sekunden
- **Flexible Codes**: 6 oder 8 Stellen

### Benutzerfreundlichkeit
- **Material 3 Design**: Moderne und intuitive Oberfläche
- **Dark Mode**: Automatisch oder manuell
- **Mehrsprachig**: Deutsch und Englisch
- **Barrierefreiheit**: Vorlesen der Codes (TTS)
- **Adaptives Layout**: Optimiert für alle Bildschirmgrößen
- **Backup & Export**: Einfache Datensicherung

## Technische Details

### Implementierte Standards
- Time-Based One-Time Password (TOTP) - RFC 6238
- HMAC-SHA1 Verschlüsselung
- Base32-Kodierung (RFC 4648)

### Systemanforderungen
- iOS 15.5 oder neuer
- Android 5.0 (API 21) oder neuer

## Installation

Die App ist verfügbar über:
- App Store (iOS)
- Google Play Store (Android)

## Datenschutz

- **Keine Werbung**
- **Keine Analytics**
- **Keine Tracker**
- **Keine Benutzerprofile**
- **Keine Netzwerkkommunikation**

## Entwicklung

Das Projekt verwendet:
- Flutter & Dart
- BLoC Pattern für State Management
- Clean Architecture
- Material 3 Design System

## Lizenz

Copyright © 2024 Martin Bundschuh

Diese Software ist unter der MIT-Lizenz veröffentlicht.

## Support

Bei Fragen oder Problemen:
- GitHub Issues
- E-Mail: [martin@bundschuh.me]

## Changelog

### Version 1.0.0 (2024)
- Erste öffentliche Version
- Grundlegende TOTP-Funktionalität
- QR-Code Scanner
- Mehrsprachigkeit (DE/EN)
- Dark Mode
- Backup-System
