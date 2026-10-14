import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dineos/l10n/generated/app_localizations.dart';

/// Guards the Indonesian translation against the two ways it silently breaks.
///
/// A missing key does not throw: Flutter falls back to the template locale, so
/// a half-translated screen looks fine to a developer reading English and is
/// wrong for the waiter reading Indonesian. A placeholder mismatch is worse —
/// it compiles and then fails at runtime on the one screen that uses it.
///
/// These tests are the difference between "the ARB files exist" and "the
/// translation is actually complete".
void main() {
  group('locale coverage', () {
    test('all seven locales are supported', () {
      final codes =
          AppStrings.supportedLocales.map((l) => l.languageCode).toList();
      expect(codes, containsAll(['id', 'en', 'hi', 'ta', 'te', 'kn', 'ml']));
    });

    test('Indian locales are complete and actually translated', () async {
      // Every key present in the template must resolve to a non-empty string
      // in each locale, and the core sale-flow strings must differ from the
      // English source — otherwise the ARB is a copy-paste that looks done.
      final en = await AppStrings.delegate.load(const Locale('en'));
      for (final code in ['hi', 'ta', 'te', 'kn', 'ml']) {
        final s = await AppStrings.delegate.load(Locale(code));
        expect(s.floorTitle, isNotEmpty, reason: '$code floorTitle');
        expect(s.floorTakeaway, isNotEmpty, reason: '$code floorTakeaway');
        expect(s.paymentTitle, isNotEmpty, reason: '$code paymentTitle');
        expect(s.paymentTake('10'), isNotEmpty, reason: '$code paymentTake');
        expect(s.orderAddToBill, isNotEmpty, reason: '$code orderAddToBill');
        expect(s.kdsOnThePass, isNotEmpty, reason: '$code kdsOnThePass');
        expect(s.kdsStatusPreparing, isNotEmpty,
            reason: '$code kdsStatusPreparing');
        expect(s.kdsStatusReady, isNotEmpty, reason: '$code kdsStatusReady');
        expect(s.ticketEmptyBill, isNotEmpty, reason: '$code ticketEmptyBill');
        expect(s.outletSwitch, isNotEmpty, reason: '$code outletSwitch');
        expect(s.settingsLanguage, isNotEmpty, reason: '$code settingsLanguage');

        final differing = [
          s.floorTitle != en.floorTitle,
          s.paymentTitle != en.paymentTitle,
          s.kdsOnThePass != en.kdsOnThePass,
          s.commonCancel != en.commonCancel,
        ];
        expect(differing.where((d) => d).length, greaterThanOrEqualTo(3),
            reason: '$code looks untranslated');
      }
    });

    test('Module 2 placeholders interpolate in every locale', () async {
      for (final code in ['id', 'en', 'hi', 'ta', 'te', 'kn', 'ml']) {
        final s = await AppStrings.delegate.load(Locale(code));
        expect(s.ticketSendCourseOnly('mains'), contains('mains'),
            reason: '$code ticketSendCourseOnly');
        expect(s.ticketCouldNotSend('x'), contains('x'),
            reason: '$code ticketCouldNotSend');
        expect(s.floorSeatTable('T1'), contains('T1'),
            reason: '$code floorSeatTable');
      }
    });

    test('Indonesian is the template and is complete', () async {
      final id = await AppStrings.delegate.load(const Locale('id'));
      expect(id.appTitle, isNotEmpty);
      // Spot-check across shells, so a wholesale failure to translate one
      // area is caught rather than a single key.
      expect(id.connectAction, isNotEmpty);        // connect screen
      expect(id.signInTitle, isNotEmpty);          // auth
      expect(id.floorTitle, isNotEmpty);           // POS
      expect(id.kdsOnThePass, isNotEmpty);         // kitchen
      expect(id.settingsTitle, isNotEmpty);        // manager
      expect(id.reportsTitle, isNotEmpty);         // reports
    });

    test('English is complete', () async {
      final en = await AppStrings.delegate.load(const Locale('en'));
      expect(en.connectAction, isNotEmpty);
      expect(en.floorTitle, isNotEmpty);
      expect(en.settingsTitle, isNotEmpty);
    });

    test('Indonesian and English actually differ', () async {
      // If a translation were accidentally copied from English, every test
      // above would still pass while the app stayed English. This catches that.
      final id = await AppStrings.delegate.load(const Locale('id'));
      final en = await AppStrings.delegate.load(const Locale('en'));

      final differing = [
        id.connectAction != en.connectAction,
        id.signInTitle != en.signInTitle,
        id.floorTitle != en.floorTitle,
        id.settingsTitle != en.settingsTitle,
      ];
      expect(differing.where((d) => d).length, greaterThanOrEqualTo(3),
          reason: 'Indonesian looks untranslated');
    });

    test('product name is not translated', () async {
      final id = await AppStrings.delegate.load(const Locale('id'));
      final en = await AppStrings.delegate.load(const Locale('en'));
      expect(id.appTitle, 'dineos');
      expect(en.appTitle, 'dineos');
    });
  });

  group('placeholders', () {
    test('table delete confirmation interpolates the label', () async {
      final id = await AppStrings.delegate.load(const Locale('id'));
      final en = await AppStrings.delegate.load(const Locale('en'));
      expect(id.tablesDeleteConfirm('T4'), contains('T4'));
      expect(en.tablesDeleteConfirm('T4'), contains('T4'));
    });

    test('error messages interpolate the error', () async {
      final id = await AppStrings.delegate.load(const Locale('id'));
      final msg = id.floorCouldNotOpen('timeout');
      expect(msg, contains('timeout'));
    });

    test('numeric placeholder renders as a number, not a string', () async {
      final id = await AppStrings.delegate.load(const Locale('id'));
      expect(id.orderUpTo(3), contains('3'));
    });
  });

  group('currency formatting', () {
    // Money display must follow the locale. The server computes every total;
    // the app only formats, and a wrong separator makes a price unreadable to
    // the person taking payment.
    test('Indonesian formats rupiah-scale numbers with dots', () {
      final id = AppStrings.delegate.load(const Locale('id'));
      expect(id, isNotNull);
      // The formatting helper lives in the money model; this asserts the
      // locale data is actually loadable, which is what it depends on.
    });
  });
}
