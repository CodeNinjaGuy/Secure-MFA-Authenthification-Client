import 'dart:async';
import 'package:crypto/crypto.dart';
import 'dart:typed_data';
import 'package:base32/base32.dart';

class TotpService {
  static String generateTotp(String secret, {int period = 30}) {
    try {
      final cleanSecret =
          secret.replaceAll(RegExp(r'[^A-Za-z2-7]'), '').toUpperCase();
      final paddedSecret = addBase32Padding(cleanSecret);

      final timeStamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final counter = timeStamp ~/ period;

      // Konvertiere Counter zu 8-Byte Array
      final counterBytes = _int64ToBytes(counter);

      // Decodiere Base32-Secret
      final keyBytes = base32.decode(paddedSecret);

      // Berechne HMAC-SHA1
      final hmac = Hmac(sha1, keyBytes);
      final hash = hmac.convert(counterBytes);

      // Extrahiere 4 Bytes für den Code
      final offset = hash.bytes[hash.bytes.length - 1] & 0xf;
      final binary = ((hash.bytes[offset] & 0x7f) << 24) |
          ((hash.bytes[offset + 1] & 0xff) << 16) |
          ((hash.bytes[offset + 2] & 0xff) << 8) |
          (hash.bytes[offset + 3] & 0xff);

      // Generiere 6-stelligen Code
      return (binary % 1000000).toString().padLeft(6, '0');
    } catch (e) {
      rethrow;
    }
  }

  static Uint8List _int64ToBytes(int value) {
    final buffer = Uint8List(8);
    for (var i = 7; i >= 0; i--) {
      buffer[i] = value & 0xff;
      value = value >> 8;
    }
    return buffer;
  }

  static String addBase32Padding(String input) {
    final missingPadding = (8 - (input.length % 8)) % 8;
    return input + ('=' * missingPadding);
  }

  static int getRemainingSeconds({int period = 30}) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return period - (now % period);
  }

  static Stream<String> getTotpStream(String secret, {int period = 30}) {
    final controller = StreamController<String>();
    Timer? periodicTimer;
    int? lastTimestamp;

    void generateAndEmit() {
      try {
        final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final currentInterval = currentTimestamp ~/ period;

        if (lastTimestamp == null ||
            currentInterval > (lastTimestamp! ~/ period)) {
          lastTimestamp = currentTimestamp;
          final code = generateTotp(secret, period: period);
          controller.add(code);
        }
      } catch (e) {
        controller.addError(e);
      }
    }

    // Initialen Code sofort senden
    generateAndEmit();

    // Starte den periodischen Timer
    periodicTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        generateAndEmit();
      },
    );

    controller.onCancel = () {
      periodicTimer?.cancel();
      controller.close();
    };

    return controller.stream;
  }
}
