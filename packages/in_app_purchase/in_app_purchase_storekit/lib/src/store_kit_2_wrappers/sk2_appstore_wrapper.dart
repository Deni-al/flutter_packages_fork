// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../in_app_purchase_apis.dart';

/// Wrapper for StoreKit2's AppStore
/// (https://developer.apple.com/documentation/storekit/appstore)
final class AppStore {
  /// Dart wrapper for StoreKit2's canMakePayments()
  /// Returns a bool that indicates whether the person can make purchases.
  /// https://developer.apple.com/documentation/storekit/appstore/3822277-canmakepayments
  Future<bool> canMakePayments() {
    return hostApi2.canMakePayments();
  }

  /// Dart wrapper for StoreKit2's sync()
  /// Synchronizes your app’s transaction information and subscription status with information from the App Store.
  /// Will initiate an authentication pop up.
  /// https://developer.apple.com/documentation/storekit/appstore/sync()
  Future<void> sync() {
    return hostApi2.sync();
  }

  /// Presents a sheet that enables users to redeem subscription offer codes.
  Future<void> presentOfferCodeRedeemSheet() {
    return hostApi2.presentOfferCodeRedeemSheet();
  }

  /// Dart wrapper for StoreKit2's showManageSubscriptions(in:)
  /// Presents the App Store sheet that lets users manage their subscriptions.
  /// https://developer.apple.com/documentation/storekit/appstore/showmanagesubscriptions(in:)
  Future<void> showManageSubscriptions() {
    return hostApi2.showManageSubscriptions();
  }

  /// Returns verified renewal-info JSON for the product's subscription group.
  ///
  /// Match `originalTransactionId` to the customer's transaction before use.
  /// `renewalPrice` is in milliunits of `currency`; optional fields may be absent.
  /// Returns an empty list when the group has no subscription status.
  /// Throws a platform exception when fetching or verification fails.
  Future<List<String>> subscriptionRenewalInfo(String productId) {
    return hostApi2.subscriptionRenewalInfo(productId);
  }

  /// Checks if the specified subscription will auto-renew at the end of the current billing period.
  Future<bool> willAutoRenew(String productId) {
    return hostApi2.willAutoRenew(productId);
  }
}
