// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppStringsHi extends AppStrings {
  AppStringsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'dineos';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonDelete => 'हटाएं';

  @override
  String get commonRemove => 'निकालें';

  @override
  String get commonClose => 'बंद करें';

  @override
  String get commonDone => 'हो गया';

  @override
  String get commonSave => 'बदलाव सहेजें';

  @override
  String get commonAdd => 'जोड़ें';

  @override
  String get commonName => 'नाम';

  @override
  String get commonAddress => 'पता';

  @override
  String get commonPort => 'पोर्ट';

  @override
  String get commonPrice => 'कीमत';

  @override
  String get commonTotal => 'कुल';

  @override
  String get commonSubtotal => 'उप-कुल';

  @override
  String get commonNote => 'नोट';

  @override
  String get commonReason => 'कारण';

  @override
  String get commonAmount => 'राशि';

  @override
  String get commonReference => 'संदर्भ';

  @override
  String get commonDescription => 'विवरण';

  @override
  String get commonCategory => 'श्रेणी';

  @override
  String get commonPhoto => 'फोटो';

  @override
  String get commonOptions => 'विकल्प';

  @override
  String get commonTags => 'टैग';

  @override
  String get commonTryAgain => 'पुनः प्रयास करें';

  @override
  String get commonCouldNotLoad => 'लोड नहीं हो सका';

  @override
  String get commonTest => 'टेस्ट';

  @override
  String get commonEarlier => 'पहले';

  @override
  String get commonLater => 'बाद में';

  @override
  String get commonAll => 'सभी';

  @override
  String get commonOn => 'चालू';

  @override
  String get commonOff => 'बंद';

  @override
  String get signInTitle => 'साइन इन';

  @override
  String get signInUsername => 'यूज़रनेम';

  @override
  String get signInPin => 'पिन';

  @override
  String get signInUseDifferentServer => 'दूसरा सर्वर इस्तेमाल करें';

  @override
  String get connectTitle => 'अपने सर्वर से जुड़ें';

  @override
  String get connectAction => 'जुड़ें';

  @override
  String get connectOnThisNetwork => 'इस नेटवर्क पर';

  @override
  String get connectSubtitle => 'रेस्तरां प्रबंधन';

  @override
  String get connectSubtitleLong =>
      'इस डिवाइस को अपना रेस्तरां चलाने वाले कंप्यूटर की ओर इंगित करें।';

  @override
  String get connectFooter =>
      'हमेशा मुफ़्त। आपका डेटा आपकी अपनी मशीन पर रहता है।';

  @override
  String get connectServerHelper =>
      'सर्वर इसी कंप्यूटर पर चला रहे हैं? इसे ऐसे ही रहने दें।';

  @override
  String get connectRunOnThisComputer => 'रेस्तरां इसी कंप्यूटर पर चलाएं';

  @override
  String get connectRunOnThisComputerHint =>
      'सब कुछ यहीं सेट हो जाएगा। टैबलेट और किचन स्क्रीन फिर इस मशीन से जुड़ेंगे।';

  @override
  String get connectScanCode => 'कोड स्कैन करें';

  @override
  String get connectServerAddress => 'सर्वर का पता';

  @override
  String get connectOr => 'या';

  @override
  String get connectScanPointAtCode => 'कोड की ओर इंगित करें';

  @override
  String get connectScanTypeInstead => 'बजाय टाइप करें';

  @override
  String get setupTitle => 'अपना रेस्तरां सेट करें';

  @override
  String get kdsOnThePass => 'काउंटर पर';

  @override
  String get kdsNothingOnThePass => 'काउंटर पर कुछ नहीं';

  @override
  String kdsCouldNotUpdate(String error) {
    return 'अपडेट नहीं हो सका: $error';
  }

  @override
  String get navPos => 'काउंटर';

  @override
  String get navKds => 'रसोई';

  @override
  String get navManager => 'प्रबंधक';

  @override
  String get navSignOut => 'साइन आउट';

  @override
  String get navSwitchShell => 'स्क्रीन बदलें';

  @override
  String get floorTitle => 'फ्लोर';

  @override
  String get floorHint => 'बिल खोलने या उठाने के लिए टेबल पर टैप करें।';

  @override
  String get floorNoTables => 'कोई टेबल सेट नहीं';

  @override
  String get floorTakeaway => 'टेकअवे';

  @override
  String get floorOpenBill => 'बिल खोलें';

  @override
  String get floorHowManyGuests => 'कितने मेहमान?';

  @override
  String floorSeatTable(String label) {
    return '$label पर बैठाएं';
  }

  @override
  String floorCouldNotOpen(String error) {
    return 'टेबल नहीं खुल सकी: $error';
  }

  @override
  String floorCouldNotStart(String error) {
    return 'ऑर्डर शुरू नहीं हो सका: $error';
  }

  @override
  String get floorInUse => 'व्यस्त';

  @override
  String get orderBackToFloor => 'फ्लोर पर वापस';

  @override
  String get orderNothingHere => 'यहाँ कुछ नहीं';

  @override
  String get orderMenuEmpty => 'मेनू खाली है';

  @override
  String get orderBillGone => 'यह बिल चला गया';

  @override
  String orderCouldNotAdd(String error) {
    return 'वह जोड़ा नहीं जा सका: $error';
  }

  @override
  String get orderSoldOut => '86';

  @override
  String get orderAddToBill => 'बिल में जोड़ें';

  @override
  String get orderNoteForKitchen => 'रसोई के लिए नोट';

  @override
  String orderUpTo(int count) {
    return '$count तक';
  }

  @override
  String moveBillTitle(String number) {
    return 'बिल #$number ले जाएं';
  }

  @override
  String get moveBillNowhere => 'इसे ले जाने के लिए और कोई जगह नहीं।';

  @override
  String get moveBillWhereTo => 'कहाँ ले जाएं?';

  @override
  String get discountTitle => 'छूट';

  @override
  String get discountAmountOff => 'राशि में छूट';

  @override
  String get discountNewSubtotal => 'नया उप-कुल';

  @override
  String get discountReasonHint => 'इसी से सेवा और कर निकाला जाता है।';

  @override
  String get discountClear => 'साफ़ करें';

  @override
  String get paymentTitle => 'वे कैसे भुगतान कर रहे हैं?';

  @override
  String get paymentCashReceived => 'नकद मिला';

  @override
  String get paymentChangeDue => 'वापसी';

  @override
  String get paymentPaid => 'भुगतान हो गया';

  @override
  String paymentTake(String amount) {
    return '$amount लें';
  }

  @override
  String get paymentTakenSoFar => 'अब तक लिया';

  @override
  String get paymentRemovePayment => 'यह भुगतान हटाएं';

  @override
  String get paymentReceipt => 'रसीद';

  @override
  String get receiptTitle => 'रसीद';

  @override
  String receiptPrintTo(String printer) {
    return '$printer पर प्रिंट करें';
  }

  @override
  String get shiftCloseTitle => 'अपनी शिफ्ट बंद करें';

  @override
  String get shiftCashInDrawer => 'दराज़ में नकद';

  @override
  String get shiftCashTaken => 'ली गई नकद';

  @override
  String get shiftCounted => 'गिना हुआ';

  @override
  String get shiftOpeningFloat => 'शुरुआती रकम';

  @override
  String get shiftShouldBeInDrawer => 'दराज़ में होनी चाहिए';

  @override
  String get shiftHereIsWhat => 'यह रहा हिसाब।';

  @override
  String get shiftClosed => 'शिफ्ट बंद';

  @override
  String get summaryTakings => 'कमाई';

  @override
  String get summaryHowItAddsUp => 'जोड़ कैसा बना';

  @override
  String get summaryHowItWasPaid => 'भुगतान कैसे हुआ';

  @override
  String get summaryTheDrawer => 'दराज़';

  @override
  String get summaryCancelled => 'रद्द';

  @override
  String get menuItemsTitle => 'आइटम';

  @override
  String get menuItemsSubtitle => 'जो कुछ आप बेचते हैं, और उसकी कीमत।';

  @override
  String get menuItemsNew => 'नया आइटम';

  @override
  String get menuItemsNone => 'अभी कोई आइटम नहीं';

  @override
  String get menuItemsNoMatch => 'कुछ मेल नहीं खाता';

  @override
  String get menuItemsAddFirst => 'अपना पहला आइटम जोड़ें';

  @override
  String get menuItemsAddCategoryFirst => 'पहले श्रेणी जोड़ें';

  @override
  String get menuCategoriesTitle => 'श्रेणियाँ';

  @override
  String get menuCategoriesSubtitle =>
      'आपके मेनू के भाग। काउंटर पर भी यही क्रम रहेगा।';

  @override
  String get menuCategoriesNew => 'नई श्रेणी';

  @override
  String get menuCategoriesNone => 'अभी कोई श्रेणी नहीं';

  @override
  String get menuCategoriesAddFirst => 'अपनी पहली श्रेणी जोड़ें';

  @override
  String get menuCategoriesHidden => 'छिपा हुआ';

  @override
  String get menuCategoriesTileColour => 'टाइल का रंग';

  @override
  String get menuCategoriesTileColourHint =>
      'काउंटर पर दिखता है ताकि स्टाफ जल्दी ढूंढ सके।';

  @override
  String get menuCategoriesVisible => 'काउंटर पर दिखे';

  @override
  String get menuCategoriesStation => 'इसे कौन बनाता है';

  @override
  String get menuCategoriesStationHint =>
      'इस भाग के ऑर्डर उसी स्टेशन पर प्रिंट होंगे।';

  @override
  String get menuItemOnTheMenu => 'मेनू पर है';

  @override
  String get menuItemInStock => 'स्टॉक में';

  @override
  String get menuItemCode => 'आइटम कोड';

  @override
  String get menuItemPrepTime => 'तैयारी का समय';

  @override
  String get modifiersTitle => 'मॉडिफायर';

  @override
  String get modifiersSubtitle =>
      'आइटमों से जोड़े जा सकने वाले विकल्प। एक बार बनाएं, हर जगह इस्तेमाल करें।';

  @override
  String get modifiersNewGroup => 'नया समूह';

  @override
  String get modifiersNone => 'अभी कोई मॉडिफायर समूह नहीं';

  @override
  String get modifiersCreateFirst => 'अपना पहला समूह बनाएं';

  @override
  String get modifiersAddOption => 'विकल्प जोड़ें';

  @override
  String get modifiersNoOptions => 'अभी कोई विकल्प नहीं।';

  @override
  String get modifiersAllowMoreThanOne => 'एक से ज़्यादा चुनने दें';

  @override
  String get modifiersMustBeAnswered => 'जवाब ज़रूरी है';

  @override
  String get modifiersMaxSelectable => 'अधिकतम चुने जा सकने वाले';

  @override
  String get modifiersPriceChange => 'कीमत में बदलाव';

  @override
  String get modifiersOffered => 'उपलब्ध';

  @override
  String get tablesTitle => 'टेबल';

  @override
  String get tablesSubtitle =>
      'आपका फ्लोर। कमरे में हिस्से हों तो ज़ोन में बाँटें।';

  @override
  String get tablesNew => 'नई टेबल';

  @override
  String get tablesNone => 'अभी कोई टेबल नहीं';

  @override
  String get tablesAddFirst => 'अपनी पहली टेबल जोड़ें';

  @override
  String get tablesNameOrNumber => 'नाम या नंबर';

  @override
  String get tablesSeats => 'सीटें';

  @override
  String get tablesZone => 'ज़ोन';

  @override
  String get tablesInUse => 'इस्तेमाल में';

  @override
  String get tablesCodes => 'टेबल कोड';

  @override
  String get tablesCodesNone => 'अभी कोई टेबल इस्तेमाल में नहीं।';

  @override
  String tablesDeleteConfirm(String label) {
    return '$label हटाएं?';
  }

  @override
  String get staffTitle => 'स्टाफ';

  @override
  String get staffSubtitle =>
      'कौन साइन इन कर सकता है, और उसे क्या करने की अनुमति है।';

  @override
  String get staffAddSomeone => 'किसी को जोड़ें';

  @override
  String get staffNobodyYet => 'अभी कोई नहीं';

  @override
  String get staffCanSignIn => 'साइन इन कर सकता है';

  @override
  String get staffWhatTheyCanDo => 'वे क्या कर सकते हैं';

  @override
  String get staffYou => 'आप';

  @override
  String get staffCannotDisableSelf => 'आप अपना खाता बंद नहीं कर सकते।';

  @override
  String get staffGiveNewPin => 'उन्हें नया पिन दें';

  @override
  String staffNewPinFor(String name) {
    return '$name के लिए नया पिन';
  }

  @override
  String get staffSetPin => 'पिन सेट करें';

  @override
  String staffRemoveConfirm(String name) {
    return '$name हटाएं?';
  }

  @override
  String get reportsTitle => 'रिपोर्ट';

  @override
  String get reportsSubtitle => 'हर दिन का हिसाब।';

  @override
  String get reportsWhatSold => 'क्या बिका';

  @override
  String get reportsWhoServedIt => 'किसने परोसा';

  @override
  String get reportsByHour => 'प्रति घंटा';

  @override
  String get reportsExportCsv => 'CSV निर्यात करें';

  @override
  String get reportsSaved => 'रिपोर्ट सहेजी गई।';

  @override
  String reportsCouldNotSave(String error) {
    return 'सहेजा नहीं जा सका: $error';
  }

  @override
  String get activityTitle => 'गतिविधि';

  @override
  String get activitySubtitle => 'छूट, रद्द और निरस्त — हर एक के साथ नाम।';

  @override
  String get activityMoneyLeavingOnly => 'केवल जाने वाला पैसा';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsRestaurant => 'रेस्तरां';

  @override
  String get settingsRestaurantHint =>
      'आपका रेस्तरां खुद को कैसे बताता है और क्या शुल्क लेता है।';

  @override
  String get settingsCharges => 'शुल्क';

  @override
  String get settingsCurrency => 'मुद्रा';

  @override
  String get settingsTaxRate => 'कर की दर';

  @override
  String get settingsTaxIncluded => 'मेनू की कीमतों में कर शामिल';

  @override
  String get settingsServiceCharge => 'सेवा शुल्क';

  @override
  String get settingsPrinters => 'प्रिंटर';

  @override
  String get settingsReceipts => 'रसीदें';

  @override
  String get settingsHeader => 'हेडर';

  @override
  String get settingsFooter => 'फुटर';

  @override
  String get settingsServer => 'सर्वर';

  @override
  String get settingsThisDevice => 'यह डिवाइस';

  @override
  String get settingsAddTablet => 'टैबलेट जोड़ें';

  @override
  String get settingsSignOut => 'साइन आउट';

  @override
  String get settingsDisconnect => 'डिस्कनेक्ट करें';

  @override
  String get settingsDisconnectConfirm => 'इस डिवाइस को डिस्कनेक्ट करें?';

  @override
  String get printerNew => 'प्रिंटर जोड़ें';

  @override
  String get printerPaperWidth => 'कागज़ की चौड़ाई';

  @override
  String get printerWhatItPrints => 'यह क्या प्रिंट करता है';

  @override
  String get printerInUse => 'इस्तेमाल में';

  @override
  String printerRemoveConfirm(String name) {
    return '$name हटाएं?';
  }

  @override
  String get guestScanTitle => 'ऑर्डर के लिए स्कैन करें';

  @override
  String get guestMenuTitle => 'मेनू';

  @override
  String get signInErrorNoUsername => 'अपना यूज़रनेम डालें।';

  @override
  String get signInErrorShortPin => 'आपका पिन कम से कम 4 अंकों का है।';

  @override
  String ticketSendCourseOnly(String course) {
    return 'केवल $course भेजें';
  }

  @override
  String get ticketBackToFloor => 'फ्लोर पर वापस';

  @override
  String ticketCouldNotSend(String error) {
    return 'भेजा नहीं जा सका: $error';
  }

  @override
  String ticketCouldNotCancel(String error) {
    return 'रद्द नहीं हो सका: $error';
  }

  @override
  String get ticketEmptyBill => 'इस बिल में अभी कुछ नहीं';

  @override
  String get ticketVoided => 'रद्द किया गया';

  @override
  String get ticketSavedNotSent => 'यहाँ सहेजा गया — अभी भेजा नहीं';

  @override
  String get ticketQuantity => 'मात्रा';

  @override
  String get ticketCourse => 'कोर्स';

  @override
  String get ticketRetry => 'पुनः प्रयास';

  @override
  String get kdsStatusQueued => 'कतार में';

  @override
  String get kdsStatusPreparing => 'बन रहा है';

  @override
  String get kdsStatusReady => 'तैयार';

  @override
  String get outletTitle => 'आउटलेट';

  @override
  String get outletSwitch => 'आउटलेट बदलें';

  @override
  String get outletAll => 'सभी आउटलेट';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsLanguageHint => 'इस डिवाइस की भाषा';

  @override
  String get floorNoTablesHint =>
      'प्रबंधक फ्लोर → टेबल में टेबल जोड़ सकता है। तब तक आप टेकअवे ऑर्डर ले सकते हैं।';

  @override
  String get splitOwnBill => 'या किसी को अपना अलग बिल दें';

  @override
  String get splitSeparateTax => 'हर बिल पर सेवा और कर अलग-अलग निकाला जाता है।';

  @override
  String get splitEvenTitle => 'सब अपना हिस्सा दें';

  @override
  String get splitEvenHint =>
      'एक बिल, बराबर बाँटा। हर हिस्से को अलग भुगतान लें।';

  @override
  String get kdsEmptyHint => 'काउंटर भेजते ही टिकट यहाँ दिखते हैं।';

  @override
  String get settingsLanguageSystem => 'डिवाइस की भाषा';

  @override
  String get invTitle => 'इन्वेंटरी';

  @override
  String get invSubtitle => 'मौजूदा स्टॉक, उसकी कीमत, और क्या मंगवाना है।';

  @override
  String get invNewItem => 'नया आइटम';

  @override
  String get invStockValue => 'स्टॉक मूल्य';

  @override
  String get invLowStock => 'कम स्टॉक';

  @override
  String invLastRestock(String date) {
    return 'अंतिम खरीद $date';
  }

  @override
  String get invNeedsReview => 'समीक्षा आवश्यक';

  @override
  String get invLow => 'कम';

  @override
  String get invBalance => 'शेष';

  @override
  String get invThreshold => 'इस स्तर पर मंगवाएं';

  @override
  String get invUnit => 'इकाई';

  @override
  String invCostPerUnit(String unit) {
    return '$unit प्रति लागत';
  }

  @override
  String get invActive => 'सक्रिय';

  @override
  String get invPurchase => 'खरीद';

  @override
  String get invWastage => 'बर्बादी';

  @override
  String get invAdjust => 'समायोजन';

  @override
  String get invQuantity => 'मात्रा';

  @override
  String get invNote => 'नोट';

  @override
  String get invEmpty => 'अभी कोई स्टॉक आइटम नहीं';

  @override
  String get invEmptyHint =>
      'आटा, दूध, चिकन जोड़ें — रसोई में जो भी रखा जाता है।';

  @override
  String get invRecipe => 'रेसिपी';

  @override
  String get invRecipeHint =>
      'प्रत्येक सर्विंग में क्या लगता है। परोसते ही अपने आप कटेगा।';

  @override
  String get invAddIngredient => 'सामग्री जोड़ें';

  @override
  String get invQtyPerServing => 'प्रति सर्विंग';

  @override
  String get invSaveItemFirst => 'पहले आइटम सहेजें, फिर रेसिपी जोड़ें।';

  @override
  String get invPurchaseTitle => 'खरीद दर्ज करें';

  @override
  String get invWastageTitle => 'बर्बादी दर्ज करें';

  @override
  String get invAdjustTitle => 'स्टॉक समायोजित करें';

  @override
  String get invAdjustHint => 'लेखापरीक्षित सुधार — जैसे गिनती में अंतर।';

  @override
  String get invPickIngredient => 'सामग्री चुनें';

  @override
  String get invEdit => 'संपादित करें';
}
