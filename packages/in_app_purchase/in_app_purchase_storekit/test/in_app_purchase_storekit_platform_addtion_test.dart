// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

import 'fakes/fake_storekit_platform.dart';
import 'sk2_test_api.g.dart';
import 'test_api.g.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final FakeStoreKitPlatform fakeStoreKitPlatform = FakeStoreKitPlatform();
  final FakeStoreKit2Platform fakeStoreKit2Platform = FakeStoreKit2Platform();

  setUpAll(() {
    TestInAppPurchaseApi.setUp(fakeStoreKitPlatform);
    TestInAppPurchase2Api.setUp(fakeStoreKit2Platform);
  });

  setUp(() {
    fakeStoreKit2Platform.reset();
  });

  group('present code redemption sheet', () {
    test('null', () async {
      expect(
          InAppPurchaseStoreKitPlatformAddition().presentCodeRedemptionSheet(),
          completes);
    });
  });

  group('refresh receipt data', () {
    test('should refresh receipt data', () async {
      final PurchaseVerificationData? receiptData =
          await InAppPurchaseStoreKitPlatformAddition()
              .refreshPurchaseVerificationData();
      expect(receiptData, isNotNull);
      expect(receiptData!.source, kIAPSource);
      expect(receiptData.localVerificationData, 'refreshed receipt data');
      expect(receiptData.serverVerificationData, 'refreshed receipt data');
    });
  });

  group('showManageSubscriptions', () {
    test('should complete without error', () async {
      expect(
          InAppPurchaseStoreKitPlatformAddition().showManageSubscriptions(),
          completes);
    });
  });
}
