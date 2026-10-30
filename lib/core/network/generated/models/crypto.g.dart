// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Crypto _$CryptoFromJson(Map<String, dynamic> json) => Crypto(
  coin: json['coin'] as String?,
  wallet: json['wallet'] as String?,
  network: json['network'] as String?,
);

Map<String, dynamic> _$CryptoToJson(Crypto instance) => <String, dynamic>{
  'coin': instance.coin,
  'wallet': instance.wallet,
  'network': instance.network,
};
