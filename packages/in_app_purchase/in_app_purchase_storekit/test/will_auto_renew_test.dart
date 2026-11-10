// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/src/in_app_purchase_apis.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';

import 'fakes/fake_storekit_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fake = FakeStoreKit2Platform();

  setUp(() async {
    fake.reset();
    fake.validProducts['123'] = SK2Product(
      id: '123',
      displayName: 'Subscription',
      displayPrice: r'$1.00',
      description: 'Subscription',
      price: 1,
      type: SK2ProductType.autoRenewable,
      priceLocale: SK2PriceLocale(currencyCode: 'USD', currencySymbol: r'$'),
    );
    setInAppPurchaseHostApis(api: FakeStoreKitPlatform(), api2: fake);
    await InAppPurchaseStoreKitPlatform.enableStoreKit2();
  });

  test('AppStore preserves the enabled and disabled renewal preference', () async {
    fake.autoRenewProducts['123'] = true;
    expect(await AppStore().willAutoRenew('123'), isTrue);
    fake.autoRenewProducts['123'] = false;
    expect(await AppStore().willAutoRenew('123'), isFalse);
  });

  test('platform exposes the renewal preference', () async {
    fake.autoRenewProducts['123'] = true;
    expect(await InAppPurchaseStoreKitPlatform().willAutoRenew('123'), isTrue);
  });

  test('unknown product preserves the native error code', () async {
    await expectLater(
      AppStore().willAutoRenew('missing'),
      throwsA(
        isA<PlatformException>().having(
          (error) => error.code,
          'code',
          'storekit2_failed_to_fetch_product',
        ),
      ),
    );
  });

  test('non-subscription preserves the native error code', () async {
    await expectLater(
      AppStore().willAutoRenew('456'),
      throwsA(
        isA<PlatformException>().having(
          (error) => error.code,
          'code',
          'storekit2_not_subscription',
        ),
      ),
    );
  });

  test('StoreKit 1 rejects renewal checks', () async {
    await InAppPurchaseStoreKitPlatform.enableStoreKit1();
    try {
      await expectLater(
        InAppPurchaseStoreKitPlatform().willAutoRenew('123'),
        throwsA(
          isA<PlatformException>().having((error) => error.code, 'code', 'storekit2_not_enabled'),
        ),
      );
    } finally {
      await InAppPurchaseStoreKitPlatform.enableStoreKit2();
    }
  });
}
