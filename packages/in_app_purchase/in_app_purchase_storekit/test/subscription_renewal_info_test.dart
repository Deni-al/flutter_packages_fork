// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = BasicMessageChannel<Object?>(
    'dev.flutter.pigeon.in_app_purchase_storekit.InAppPurchase2API.subscriptionRenewalInfo',
    StandardMessageCodec(),
  );
  final TestDefaultBinaryMessenger messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  tearDown(() => messenger.setMockDecodedMessageHandler<Object?>(channel, null));

  test('returns verified renewal JSON through the generated channel', () async {
    messenger.setMockDecodedMessageHandler<Object?>(channel, (Object? message) async {
      expect(message, <Object?>['annual']);
      return <Object?>[
        <String>[
          '{"originalTransactionId":"123","productId":"annual","autoRenewStatus":1,"renewalPrice":149000,"currency":"USD","offerType":5,"offerIdentifier":"retention"}',
        ],
      ];
    });
    final List<String> info = await AppStore().subscriptionRenewalInfo('annual');
    expect(jsonDecode(info.single), containsPair('offerType', 5));
    expect(jsonDecode(info.single), containsPair('renewalPrice', 149000));
  });

  test('returns no records when there is no subscription status', () async {
    messenger.setMockDecodedMessageHandler<Object?>(channel, (_) async => <Object?>[<String>[]]);
    expect(await AppStore().subscriptionRenewalInfo('annual'), isEmpty);
  });

  test('propagates native verification failures', () async {
    messenger.setMockDecodedMessageHandler<Object?>(
      channel,
      (_) async => <Object?>['storekit2_failed_to_fetch_renewal_info', 'Verification failed', null],
    );
    await expectLater(
      AppStore().subscriptionRenewalInfo('annual'),
      throwsA(
        isA<PlatformException>().having(
          (error) => error.code,
          'code',
          'storekit2_failed_to_fetch_renewal_info',
        ),
      ),
    );
  });
}
