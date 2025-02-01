import 'package:equatable/equatable.dart';

class MfaAccount extends Equatable {
  final String id;
  final String issuer;
  final String accountName;
  final String secret;
  final int digits;
  final int period;
  final String algorithm;

  const MfaAccount({
    required this.id,
    required this.issuer,
    required this.accountName,
    required this.secret,
    this.digits = 6,
    this.period = 30,
    this.algorithm = 'SHA1',
  });

  factory MfaAccount.fromJson(Map<String, dynamic> json) {
    return MfaAccount(
      id: json['id'] as String,
      issuer: json['issuer'] as String,
      accountName: json['accountName'] as String,
      secret: json['secret'] as String,
      digits: json['digits'] as int? ?? 6,
      period: json['period'] as int? ?? 30,
      algorithm: json['algorithm'] as String? ?? 'SHA1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issuer': issuer,
      'accountName': accountName,
      'secret': secret,
      'digits': digits,
      'period': period,
      'algorithm': algorithm,
    };
  }

  @override
  List<Object?> get props =>
      [id, issuer, accountName, secret, digits, period, algorithm];
}
