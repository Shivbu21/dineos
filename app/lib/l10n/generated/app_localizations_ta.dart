// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppStringsTa extends AppStrings {
  AppStringsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'dineos';

  @override
  String get commonCancel => 'ரத்து செய்';

  @override
  String get commonDelete => 'நீக்கு';

  @override
  String get commonRemove => 'அகற்று';

  @override
  String get commonClose => 'மூடு';

  @override
  String get commonDone => 'முடிந்தது';

  @override
  String get commonSave => 'மாற்றங்களைச் சேமி';

  @override
  String get commonAdd => 'சேர்';

  @override
  String get commonName => 'பெயர்';

  @override
  String get commonAddress => 'முகவரி';

  @override
  String get commonPort => 'போர்ட்';

  @override
  String get commonPrice => 'விலை';

  @override
  String get commonTotal => 'மொத்தம்';

  @override
  String get commonSubtotal => 'துணை மொத்தம்';

  @override
  String get commonNote => 'குறிப்பு';

  @override
  String get commonReason => 'காரணம்';

  @override
  String get commonAmount => 'தொகை';

  @override
  String get commonReference => 'குறிப்பு எண்';

  @override
  String get commonDescription => 'விளக்கம்';

  @override
  String get commonCategory => 'பிரிவு';

  @override
  String get commonPhoto => 'புகைப்படம்';

  @override
  String get commonOptions => 'விருப்பங்கள்';

  @override
  String get commonTags => 'குறிச்சொற்கள்';

  @override
  String get commonTryAgain => 'மீண்டும் முயற்சி';

  @override
  String get commonCouldNotLoad => 'ஏற்ற முடியவில்லை';

  @override
  String get commonTest => 'சோதனை';

  @override
  String get commonEarlier => 'முன்னர்';

  @override
  String get commonLater => 'பின்னர்';

  @override
  String get commonAll => 'அனைத்தும்';

  @override
  String get commonOn => 'ஆன்';

  @override
  String get commonOff => 'ஆஃப்';

  @override
  String get signInTitle => 'உள்நுழை';

  @override
  String get signInUsername => 'பயனர்பெயர்';

  @override
  String get signInPin => 'பின்';

  @override
  String get signInUseDifferentServer => 'வேறு சேவையகத்தைப் பயன்படுத்து';

  @override
  String get connectTitle => 'உங்கள் சேவையகத்துடன் இணையுங்கள்';

  @override
  String get connectAction => 'இணை';

  @override
  String get connectOnThisNetwork => 'இந்த வலையமைப்பில்';

  @override
  String get connectSubtitle => 'உணவக மேலாண்மை';

  @override
  String get connectSubtitleLong =>
      'உங்கள் உணவகத்தை இயக்கும் கணினியை நோக்கி இந்தச் சாதனத்தைக் காட்டுங்கள்.';

  @override
  String get connectFooter =>
      'என்றும் இலவசம். உங்கள் தரவு உங்கள் கணினியிலேயே இருக்கும்.';

  @override
  String get connectServerHelper =>
      'சேவையகத்தை இந்தக் கணினியில் இயக்குகிறீர்களா? அப்படியே விடுங்கள்.';

  @override
  String get connectRunOnThisComputer => 'உணவகத்தை இந்தக் கணினியில் இயக்கு';

  @override
  String get connectRunOnThisComputerHint =>
      'அனைத்தும் இங்கேயே அமையும். டேப்லெட்டுகளும் சமையலறைத் திரையும் இந்தக் கணினியுடன் இணையும்.';

  @override
  String get connectScanCode => 'குறியீட்டை ஸ்கேன் செய்';

  @override
  String get connectServerAddress => 'சேவையக முகவரி';

  @override
  String get connectOr => 'அல்லது';

  @override
  String get connectScanPointAtCode => 'குறியீட்டை நோக்கிக் காட்டு';

  @override
  String get connectScanTypeInstead => 'பதிலாகத் தட்டச்சு செய்';

  @override
  String get setupTitle => 'உங்கள் உணவகத்தை அமையுங்கள்';

  @override
  String get kdsOnThePass => 'பாஸில்';

  @override
  String get kdsNothingOnThePass => 'பாஸில் எதுவும் இல்லை';

  @override
  String kdsCouldNotUpdate(String error) {
    return 'புதுப்பிக்க முடியவில்லை: $error';
  }

  @override
  String get navPos => 'கல்லா';

  @override
  String get navKds => 'சமையலறை';

  @override
  String get navManager => 'மேலாளர்';

  @override
  String get navSignOut => 'வெளியேறு';

  @override
  String get navSwitchShell => 'திரையை மாற்று';

  @override
  String get floorTitle => 'தளம்';

  @override
  String get floorHint => 'பில்லைத் திறக்க அல்லது எடுக்க மேசையைத் தட்டவும்.';

  @override
  String get floorNoTables => 'மேசைகள் அமைக்கப்படவில்லை';

  @override
  String get floorTakeaway => 'எடுத்துச் செல்';

  @override
  String get floorOpenBill => 'பில்லைத் திற';

  @override
  String get floorHowManyGuests => 'எத்தனை விருந்தினர்?';

  @override
  String floorSeatTable(String label) {
    return '$label-இல் அமர்த்து';
  }

  @override
  String floorCouldNotOpen(String error) {
    return 'மேசையைத் திறக்க முடியவில்லை: $error';
  }

  @override
  String floorCouldNotStart(String error) {
    return 'ஆர்டரைத் தொடங்க முடியவில்லை: $error';
  }

  @override
  String get floorInUse => 'பயனில்';

  @override
  String get orderBackToFloor => 'தளத்திற்குத் திரும்பு';

  @override
  String get orderNothingHere => 'இங்கே எதுவும் இல்லை';

  @override
  String get orderMenuEmpty => 'மெனு காலி';

  @override
  String get orderBillGone => 'இந்த பில் போய்விட்டது';

  @override
  String orderCouldNotAdd(String error) {
    return 'அதைச் சேர்க்க முடியவில்லை: $error';
  }

  @override
  String get orderSoldOut => '86';

  @override
  String get orderAddToBill => 'பில்லில் சேர்';

  @override
  String get orderNoteForKitchen => 'சமையலறைக்குக் குறிப்பு';

  @override
  String orderUpTo(int count) {
    return '$count வரை';
  }

  @override
  String moveBillTitle(String number) {
    return 'பில் #$number-ஐ நகர்த்து';
  }

  @override
  String get moveBillNowhere => 'அதை நகர்த்த வேறு இடமில்லை.';

  @override
  String get moveBillWhereTo => 'எங்கே நகர்த்துவது?';

  @override
  String get discountTitle => 'தள்ளுபடி';

  @override
  String get discountAmountOff => 'தொகையில் தள்ளுபடி';

  @override
  String get discountNewSubtotal => 'புதிய துணை மொத்தம்';

  @override
  String get discountReasonHint =>
      'இதிலிருந்துதான் சேவைக் கட்டணமும் வரியும் கணக்கிடப்படும்.';

  @override
  String get discountClear => 'அழி';

  @override
  String get paymentTitle => 'அவர்கள் எப்படிச் செலுத்துகிறார்கள்?';

  @override
  String get paymentCashReceived => 'ரொக்கம் பெறப்பட்டது';

  @override
  String get paymentChangeDue => 'மீதித் தொகை';

  @override
  String get paymentPaid => 'செலுத்தப்பட்டது';

  @override
  String paymentTake(String amount) {
    return '$amount வாங்கு';
  }

  @override
  String get paymentTakenSoFar => 'இதுவரை வாங்கியது';

  @override
  String get paymentRemovePayment => 'இந்தக் கட்டணத்தை நீக்கு';

  @override
  String get paymentReceipt => 'ரசீது';

  @override
  String get receiptTitle => 'ரசீது';

  @override
  String receiptPrintTo(String printer) {
    return '$printer-இல் அச்சிடு';
  }

  @override
  String get shiftCloseTitle => 'உங்கள் ஷிப்டை முடி';

  @override
  String get shiftCashInDrawer => 'டிராயரில் ரொக்கம்';

  @override
  String get shiftCashTaken => 'வாங்கிய ரொக்கம்';

  @override
  String get shiftCounted => 'எண்ணியது';

  @override
  String get shiftOpeningFloat => 'தொடக்கத் தொகை';

  @override
  String get shiftShouldBeInDrawer => 'டிராயரில் இருக்க வேண்டியது';

  @override
  String get shiftHereIsWhat => 'கணக்கு இதோ.';

  @override
  String get shiftClosed => 'ஷிப்ட் முடிந்தது';

  @override
  String get summaryTakings => 'வருமானம்';

  @override
  String get summaryHowItAddsUp => 'கூட்டுத்தொகை எப்படி';

  @override
  String get summaryHowItWasPaid => 'எப்படிச் செலுத்தப்பட்டது';

  @override
  String get summaryTheDrawer => 'டிராயர்';

  @override
  String get summaryCancelled => 'ரத்து';

  @override
  String get menuItemsTitle => 'உருப்படிகள்';

  @override
  String get menuItemsSubtitle =>
      'நீங்கள் விற்பனை செய்வது அனைத்தும், அதன் விலையுடன்.';

  @override
  String get menuItemsNew => 'புதிய உருப்படி';

  @override
  String get menuItemsNone => 'இன்னும் உருப்படிகள் இல்லை';

  @override
  String get menuItemsNoMatch => 'பொருந்துவது எதுவும் இல்லை';

  @override
  String get menuItemsAddFirst => 'உங்கள் முதல் உருப்படியைச் சேர்';

  @override
  String get menuItemsAddCategoryFirst => 'முதலில் பிரிவைச் சேர்';

  @override
  String get menuCategoriesTitle => 'பிரிவுகள்';

  @override
  String get menuCategoriesSubtitle =>
      'உங்கள் மெனுவின் பகுதிகள். கல்லாவிலும் இதே வரிசை.';

  @override
  String get menuCategoriesNew => 'புதிய பிரிவு';

  @override
  String get menuCategoriesNone => 'இன்னும் பிரிவுகள் இல்லை';

  @override
  String get menuCategoriesAddFirst => 'உங்கள் முதல் பிரிவைச் சேர்';

  @override
  String get menuCategoriesHidden => 'மறைக்கப்பட்டது';

  @override
  String get menuCategoriesTileColour => 'ஓட்டின் நிறம்';

  @override
  String get menuCategoriesTileColourHint =>
      'பணியாளர்கள் விரைவில் கண்டுபிடிக்க கல்லாவில் காட்டப்படும்.';

  @override
  String get menuCategoriesVisible => 'கல்லாவில் தெரியும்';

  @override
  String get menuCategoriesStation => 'இதைச் செய்பவர்';

  @override
  String get menuCategoriesStationHint =>
      'இந்தப் பிரிவின் ஆர்டர்கள் அந்த நிலையத்தில் அச்சாகும்.';

  @override
  String get menuItemOnTheMenu => 'மெனுவில் உள்ளது';

  @override
  String get menuItemInStock => 'இருப்பில்';

  @override
  String get menuItemCode => 'உருப்படி குறியீடு';

  @override
  String get menuItemPrepTime => 'தயாரிப்பு நேரம்';

  @override
  String get modifiersTitle => 'மாற்றிகள்';

  @override
  String get modifiersSubtitle =>
      'உருப்படிகளுடன் இணைக்கக்கூடிய தேர்வுகள். ஒருமுறை உருவாக்கி எங்கும் பயன்படுத்துங்கள்.';

  @override
  String get modifiersNewGroup => 'புதிய குழு';

  @override
  String get modifiersNone => 'இன்னும் மாற்றிக் குழுக்கள் இல்லை';

  @override
  String get modifiersCreateFirst => 'உங்கள் முதல் குழுவை உருவாக்கு';

  @override
  String get modifiersAddOption => 'விருப்பத்தைச் சேர்';

  @override
  String get modifiersNoOptions => 'இன்னும் விருப்பங்கள் இல்லை.';

  @override
  String get modifiersAllowMoreThanOne => 'ஒன்றுக்கு மேற்பட்டதை அனுமதி';

  @override
  String get modifiersMustBeAnswered => 'பதில் கட்டாயம்';

  @override
  String get modifiersMaxSelectable => 'தேர்ந்தெடுக்கக்கூடிய அதிகபட்சம்';

  @override
  String get modifiersPriceChange => 'விலை மாற்றம்';

  @override
  String get modifiersOffered => 'வழங்கப்படுகிறது';

  @override
  String get tablesTitle => 'மேசைகள்';

  @override
  String get tablesSubtitle =>
      'உங்கள் தளம். அறையில் பகுதிகள் இருந்தால் மண்டலங்களாகப் பிரியுங்கள்.';

  @override
  String get tablesNew => 'புதிய மேசை';

  @override
  String get tablesNone => 'இன்னும் மேசைகள் இல்லை';

  @override
  String get tablesAddFirst => 'உங்கள் முதல் மேசையைச் சேர்';

  @override
  String get tablesNameOrNumber => 'பெயர் அல்லது எண்';

  @override
  String get tablesSeats => 'இருக்கைகள்';

  @override
  String get tablesZone => 'மண்டலம்';

  @override
  String get tablesInUse => 'பயனில் உள்ளது';

  @override
  String get tablesCodes => 'மேசைக் குறியீடுகள்';

  @override
  String get tablesCodesNone => 'இன்னும் மேசைகள் பயனில் இல்லை.';

  @override
  String tablesDeleteConfirm(String label) {
    return '$label-ஐ நீக்கவா?';
  }

  @override
  String get staffTitle => 'பணியாளர்கள்';

  @override
  String get staffSubtitle => 'யார் உள்நுழையலாம், அவர்களுக்கு என்ன அனுமதி.';

  @override
  String get staffAddSomeone => 'ஒருவரைச் சேர்';

  @override
  String get staffNobodyYet => 'இன்னும் யாரும் இல்லை';

  @override
  String get staffCanSignIn => 'உள்நுழையலாம்';

  @override
  String get staffWhatTheyCanDo => 'அவர்கள் என்ன செய்யலாம்';

  @override
  String get staffYou => 'நீங்கள்';

  @override
  String get staffCannotDisableSelf => 'உங்கள் கணக்கை நீங்களே அணைக்க முடியாது.';

  @override
  String get staffGiveNewPin => 'அவர்களுக்குப் புதிய பின் கொடு';

  @override
  String staffNewPinFor(String name) {
    return '$name-க்குப் புதிய பின்';
  }

  @override
  String get staffSetPin => 'பின் அமை';

  @override
  String staffRemoveConfirm(String name) {
    return '$name-ஐ நீக்கவா?';
  }

  @override
  String get reportsTitle => 'அறிக்கைகள்';

  @override
  String get reportsSubtitle => 'ஒவ்வொரு நாளின் கணக்கு.';

  @override
  String get reportsWhatSold => 'என்ன விற்றது';

  @override
  String get reportsWhoServedIt => 'யார் பரிமாறினார்';

  @override
  String get reportsByHour => 'மணிநேர வாரியாக';

  @override
  String get reportsExportCsv => 'CSV ஏற்றுமதி';

  @override
  String get reportsSaved => 'அறிக்கை சேமிக்கப்பட்டது.';

  @override
  String reportsCouldNotSave(String error) {
    return 'சேமிக்க முடியவில்லை: $error';
  }

  @override
  String get activityTitle => 'செயல்பாடு';

  @override
  String get activitySubtitle =>
      'தள்ளுபடி, ரத்து மற்றும் நீக்கங்கள் — ஒவ்வொன்றுடனும் பெயர்.';

  @override
  String get activityMoneyLeavingOnly => 'வெளியேறும் பணம் மட்டும்';

  @override
  String get settingsTitle => 'அமைப்புகள்';

  @override
  String get settingsRestaurant => 'உணவகம்';

  @override
  String get settingsRestaurantHint =>
      'உங்கள் உணவகம் தன்னை எப்படி அடையாளப்படுத்துகிறது, என்ன கட்டணம்.';

  @override
  String get settingsCharges => 'கட்டணங்கள்';

  @override
  String get settingsCurrency => 'நாணயம்';

  @override
  String get settingsTaxRate => 'வரி விகிதம்';

  @override
  String get settingsTaxIncluded => 'மெனு விலையில் வரி அடங்கும்';

  @override
  String get settingsServiceCharge => 'சேவைக் கட்டணம்';

  @override
  String get settingsPrinters => 'அச்சுப்பொறிகள்';

  @override
  String get settingsReceipts => 'ரசீதுகள்';

  @override
  String get settingsHeader => 'தலைப்பு';

  @override
  String get settingsFooter => 'அடிக்குறிப்பு';

  @override
  String get settingsServer => 'சேவையகம்';

  @override
  String get settingsThisDevice => 'இந்தச் சாதனம்';

  @override
  String get settingsAddTablet => 'டேப்லெட்டைச் சேர்';

  @override
  String get settingsSignOut => 'வெளியேறு';

  @override
  String get settingsDisconnect => 'துண்டி';

  @override
  String get settingsDisconnectConfirm => 'இந்தச் சாதனத்தைத் துண்டிக்கவா?';

  @override
  String get printerNew => 'அச்சுப்பொறி சேர்';

  @override
  String get printerPaperWidth => 'காகித அகலம்';

  @override
  String get printerWhatItPrints => 'அது எதை அச்சிடும்';

  @override
  String get printerInUse => 'பயனில்';

  @override
  String printerRemoveConfirm(String name) {
    return '$name-ஐ நீக்கவா?';
  }

  @override
  String get guestScanTitle => 'ஆர்டருக்கு ஸ்கேன் செய்';

  @override
  String get guestMenuTitle => 'மெனு';

  @override
  String get signInErrorNoUsername => 'உங்கள் பயனர்பெயரை உள்ளிடுங்கள்.';

  @override
  String get signInErrorShortPin => 'உங்கள் பின் குறைந்தது 4 இலக்கங்கள்.';

  @override
  String ticketSendCourseOnly(String course) {
    return '$course மட்டும் அனுப்பு';
  }

  @override
  String get ticketBackToFloor => 'தளத்திற்குத் திரும்பு';

  @override
  String ticketCouldNotSend(String error) {
    return 'அனுப்ப முடியவில்லை: $error';
  }

  @override
  String ticketCouldNotCancel(String error) {
    return 'ரத்து செய்ய முடியவில்லை: $error';
  }

  @override
  String get ticketEmptyBill => 'இந்த பில்லில் இன்னும் எதுவும் இல்லை';

  @override
  String get ticketVoided => 'ரத்து செய்யப்பட்டது';

  @override
  String get ticketSavedNotSent =>
      'இங்கே சேமிக்கப்பட்டது — இன்னும் அனுப்பவில்லை';

  @override
  String get ticketQuantity => 'அளவு';

  @override
  String get ticketCourse => 'உணவு வரிசை';

  @override
  String get ticketRetry => 'மீண்டும் முயற்சி';

  @override
  String get kdsStatusQueued => 'வரிசையில்';

  @override
  String get kdsStatusPreparing => 'தயாராகிறது';

  @override
  String get kdsStatusReady => 'தயார்';

  @override
  String get outletTitle => 'கிளை';

  @override
  String get outletSwitch => 'கிளையை மாற்று';

  @override
  String get outletAll => 'அனைத்துக் கிளைகள்';

  @override
  String get settingsLanguage => 'மொழி';

  @override
  String get settingsLanguageHint => 'இந்தச் சாதனத்தின் மொழி';

  @override
  String get floorNoTablesHint =>
      'மேலாளர் தளம் → மேசைகளில் மேசைகளைச் சேர்க்கலாம். அதுவரை நீங்கள் எடுத்துச் செல் ஆர்டர்களை எடுக்கலாம்.';

  @override
  String get splitOwnBill => 'அல்லது ஒருவருக்குத் தனி பில் கொடுங்கள்';

  @override
  String get splitSeparateTax =>
      'ஒவ்வொரு பில்லிலும் சேவைக் கட்டணமும் வரியும் தனித்தனியே கணக்கிடப்படும்.';

  @override
  String get splitEvenTitle => 'அனைவரும் தங்கள் பங்கைச் செலுத்துங்கள்';

  @override
  String get splitEvenHint =>
      'ஒரு பில், சமமாகப் பிரி. ஒவ்வொரு பங்கையும் தனிக் கட்டணமாக வாங்குங்கள்.';

  @override
  String get kdsEmptyHint => 'கல்லா அனுப்பியதும் டிக்கெட்டுகள் இங்கே தோன்றும்.';

  @override
  String get settingsLanguageSystem => 'சாதன மொழி';

  @override
  String get invTitle => 'சரக்கு';

  @override
  String get invSubtitle =>
      'கையிருப்பு, அதன் மதிப்பு, எதை மீண்டும் வாங்க வேண்டும்.';

  @override
  String get invNewItem => 'புதிய பொருள்';

  @override
  String get invStockValue => 'சரக்கு மதிப்பு';

  @override
  String get invLowStock => 'குறைந்த சரக்கு';

  @override
  String invLastRestock(String date) {
    return 'கடைசி கொள்முதல் $date';
  }

  @override
  String get invNeedsReview => 'மதிப்பாய்வு தேவை';

  @override
  String get invLow => 'குறைவு';

  @override
  String get invBalance => 'இருப்பு';

  @override
  String get invThreshold => 'மீண்டும் வாங்கும் நிலை';

  @override
  String get invUnit => 'அலகு';

  @override
  String invCostPerUnit(String unit) {
    return '$unit ஒன்றுக்கான விலை';
  }

  @override
  String get invActive => 'செயலில்';

  @override
  String get invPurchase => 'கொள்முதல்';

  @override
  String get invWastage => 'வீண்';

  @override
  String get invAdjust => 'சரிசெய்';

  @override
  String get invQuantity => 'அளவு';

  @override
  String get invNote => 'குறிப்பு';

  @override
  String get invEmpty => 'இன்னும் சரக்கு பொருட்கள் இல்லை';

  @override
  String get invEmptyHint =>
      'மாவு, பால், கோழி சேர்க்கவும் — சமையலறையில் இருப்பதை.';

  @override
  String get invRecipe => 'செய்முறை';

  @override
  String get invRecipeHint =>
      'ஒவ்வொரு பரிமாறலுக்கும் தேவையானவை. பரிமாறும்போது தானாகக் கழியும்.';

  @override
  String get invAddIngredient => 'பொருள் சேர்க்கவும்';

  @override
  String get invQtyPerServing => 'ஒரு பரிமாறலுக்கு';

  @override
  String get invSaveItemFirst =>
      'முதலில் பொருளைச் சேமிக்கவும், பிறகு செய்முறையைச் சேர்க்கவும்.';

  @override
  String get invPurchaseTitle => 'கொள்முதலைப் பதிவு செய்க';

  @override
  String get invWastageTitle => 'வீணாவதைப் பதிவு செய்க';

  @override
  String get invAdjustTitle => 'சரக்கைச் சரிசெய்க';

  @override
  String get invAdjustHint =>
      'தணிக்கை செய்யப்பட்ட திருத்தங்கள் — எ.கா. எண்ணிக்கை வேறுபாடு.';

  @override
  String get invPickIngredient => 'பொருளைத் தேர்ந்தெடுக்கவும்';

  @override
  String get invEdit => 'திருத்து';
}
