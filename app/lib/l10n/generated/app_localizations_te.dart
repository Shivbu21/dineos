// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppStringsTe extends AppStrings {
  AppStringsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'dineos';

  @override
  String get commonCancel => 'రద్దు చేయి';

  @override
  String get commonDelete => 'తొలగించు';

  @override
  String get commonRemove => 'తీసివేయి';

  @override
  String get commonClose => 'మూసివేయి';

  @override
  String get commonDone => 'అయింది';

  @override
  String get commonSave => 'మార్పులను సేవ్ చేయి';

  @override
  String get commonAdd => 'జోడించు';

  @override
  String get commonName => 'పేరు';

  @override
  String get commonAddress => 'చిరునామా';

  @override
  String get commonPort => 'పోర్ట్';

  @override
  String get commonPrice => 'ధర';

  @override
  String get commonTotal => 'మొత్తం';

  @override
  String get commonSubtotal => 'సబ్‌టోటల్';

  @override
  String get commonNote => 'గమనిక';

  @override
  String get commonReason => 'కారణం';

  @override
  String get commonAmount => 'మొత్తం';

  @override
  String get commonReference => 'రిఫరెన్స్';

  @override
  String get commonDescription => 'వివరణ';

  @override
  String get commonCategory => 'వర్గం';

  @override
  String get commonPhoto => 'ఫోటో';

  @override
  String get commonOptions => 'ఎంపికలు';

  @override
  String get commonTags => 'ట్యాగ్‌లు';

  @override
  String get commonTryAgain => 'మళ్లీ ప్రయత్నించు';

  @override
  String get commonCouldNotLoad => 'లోడ్ చేయలేకపోయింది';

  @override
  String get commonTest => 'పరీక్ష';

  @override
  String get commonEarlier => 'ముందు';

  @override
  String get commonLater => 'తర్వాత';

  @override
  String get commonAll => 'అన్నీ';

  @override
  String get commonOn => 'ఆన్';

  @override
  String get commonOff => 'ఆఫ్';

  @override
  String get signInTitle => 'సైన్ ఇన్';

  @override
  String get signInUsername => 'యూజర్‌నేమ్';

  @override
  String get signInPin => 'పిన్';

  @override
  String get signInUseDifferentServer => 'వేరే సర్వర్‌ను వాడు';

  @override
  String get connectTitle => 'మీ సర్వర్‌కు కనెక్ట్ చేయండి';

  @override
  String get connectAction => 'కనెక్ట్';

  @override
  String get connectOnThisNetwork => 'ఈ నెట్‌వర్క్‌లో';

  @override
  String get connectSubtitle => 'రెస్టారెంట్ నిర్వహణ';

  @override
  String get connectSubtitleLong =>
      'మీ రెస్టారెంట్‌ను నడిపే కంప్యూటర్ వైపు ఈ పరికరాన్ని చూపండి.';

  @override
  String get connectFooter => 'ఎప్పటికీ ఉచితం. మీ డేటా మీ మెషీన్‌లోనే ఉంటుంది.';

  @override
  String get connectServerHelper =>
      'సర్వర్‌ను ఈ కంప్యూటర్‌లోనే నడుపుతున్నారా? అలాగే ఉంచండి.';

  @override
  String get connectRunOnThisComputer =>
      'రెస్టారెంట్‌ను ఈ కంప్యూటర్‌లోనే నడుపు';

  @override
  String get connectRunOnThisComputerHint =>
      'అన్నీ ఇక్కడే సెటప్ అవుతాయి. టాబ్లెట్లు, కిచెన్ స్క్రీన్ ఈ మెషీన్‌కు కనెక్ట్ అవుతాయి.';

  @override
  String get connectScanCode => 'కోడ్‌ను స్కాన్ చేయి';

  @override
  String get connectServerAddress => 'సర్వర్ చిరునామా';

  @override
  String get connectOr => 'లేదా';

  @override
  String get connectScanPointAtCode => 'కోడ్ వైపు చూపించు';

  @override
  String get connectScanTypeInstead => 'బదులుగా టైప్ చేయి';

  @override
  String get setupTitle => 'మీ రెస్టారెంట్‌ను సెటప్ చేయండి';

  @override
  String get kdsOnThePass => 'పాస్‌లో';

  @override
  String get kdsNothingOnThePass => 'పాస్‌లో ఏమీ లేదు';

  @override
  String kdsCouldNotUpdate(String error) {
    return 'అప్‌డేట్ చేయలేకపోయింది: $error';
  }

  @override
  String get navPos => 'కౌంటర్';

  @override
  String get navKds => 'వంటగది';

  @override
  String get navManager => 'మేనేజర్';

  @override
  String get navSignOut => 'సైన్ అవుట్';

  @override
  String get navSwitchShell => 'స్క్రీన్ మార్చు';

  @override
  String get floorTitle => 'ఫ్లోర్';

  @override
  String get floorHint =>
      'బిల్ తెరవడానికి లేదా తీసుకోవడానికి టేబుల్‌ను నొక్కండి.';

  @override
  String get floorNoTables => 'టేబుళ్లు సెటప్ చేయలేదు';

  @override
  String get floorTakeaway => 'టేకవే';

  @override
  String get floorOpenBill => 'బిల్ తెరువు';

  @override
  String get floorHowManyGuests => 'ఎంతమంది అతిథులు?';

  @override
  String floorSeatTable(String label) {
    return '$label వద్ద కూర్చోబెట్టు';
  }

  @override
  String floorCouldNotOpen(String error) {
    return 'టేబుల్ తెరవలేకపోయింది: $error';
  }

  @override
  String floorCouldNotStart(String error) {
    return 'ఆర్డర్ ప్రారంభించలేకపోయింది: $error';
  }

  @override
  String get floorInUse => 'వాడుకలో';

  @override
  String get orderBackToFloor => 'ఫ్లోర్‌కు తిరిగి';

  @override
  String get orderNothingHere => 'ఇక్కడ ఏమీ లేదు';

  @override
  String get orderMenuEmpty => 'మెనూ ఖాళీగా ఉంది';

  @override
  String get orderBillGone => 'ఈ బిల్ పోయింది';

  @override
  String orderCouldNotAdd(String error) {
    return 'దాన్ని జోడించలేకపోయింది: $error';
  }

  @override
  String get orderSoldOut => '86';

  @override
  String get orderAddToBill => 'బిల్లులో జోడించు';

  @override
  String get orderNoteForKitchen => 'వంటగదికి గమనిక';

  @override
  String orderUpTo(int count) {
    return '$count వరకు';
  }

  @override
  String moveBillTitle(String number) {
    return 'బిల్ #$number తరలించు';
  }

  @override
  String get moveBillNowhere => 'దాన్ని తరలించడానికి వేరే చోటు లేదు.';

  @override
  String get moveBillWhereTo => 'ఎక్కడికి తరలించాలి?';

  @override
  String get discountTitle => 'డిస్కౌంట్';

  @override
  String get discountAmountOff => 'మొత్తంలో తగ్గింపు';

  @override
  String get discountNewSubtotal => 'కొత్త సబ్‌టోటల్';

  @override
  String get discountReasonHint => 'దీని నుండే సర్వీస్, పన్ను లెక్కిస్తారు.';

  @override
  String get discountClear => 'క్లియర్ చేయి';

  @override
  String get paymentTitle => 'వారు ఎలా చెల్లిస్తున్నారు?';

  @override
  String get paymentCashReceived => 'నగదు అందింది';

  @override
  String get paymentChangeDue => 'తిరిగి ఇవ్వాల్సిన';

  @override
  String get paymentPaid => 'చెల్లించబడింది';

  @override
  String paymentTake(String amount) {
    return '$amount తీసుకో';
  }

  @override
  String get paymentTakenSoFar => 'ఇప్పటివరకు తీసుకున్నది';

  @override
  String get paymentRemovePayment => 'ఈ చెల్లింపును తొలగించు';

  @override
  String get paymentReceipt => 'రసీదు';

  @override
  String get receiptTitle => 'రసీదు';

  @override
  String receiptPrintTo(String printer) {
    return '$printer‌లో ప్రింట్ చేయి';
  }

  @override
  String get shiftCloseTitle => 'మీ షిఫ్ట్‌ను ముగించు';

  @override
  String get shiftCashInDrawer => 'డ్రాయర్‌లో నగదు';

  @override
  String get shiftCashTaken => 'తీసుకున్న నగదు';

  @override
  String get shiftCounted => 'లెక్కించినది';

  @override
  String get shiftOpeningFloat => 'ప్రారంభ మొత్తం';

  @override
  String get shiftShouldBeInDrawer => 'డ్రాయర్‌లో ఉండాల్సింది';

  @override
  String get shiftHereIsWhat => 'లెక్క ఇదిగో.';

  @override
  String get shiftClosed => 'షిఫ్ట్ ముగిసింది';

  @override
  String get summaryTakings => 'ఆదాయం';

  @override
  String get summaryHowItAddsUp => 'మొత్తం ఎలా వచ్చింది';

  @override
  String get summaryHowItWasPaid => 'ఎలా చెల్లించబడింది';

  @override
  String get summaryTheDrawer => 'డ్రాయర్';

  @override
  String get summaryCancelled => 'రద్దు';

  @override
  String get menuItemsTitle => 'ఐటమ్‌లు';

  @override
  String get menuItemsSubtitle => 'మీరు అమ్మేవన్నీ, వాటి ధరతో.';

  @override
  String get menuItemsNew => 'కొత్త ఐటమ్';

  @override
  String get menuItemsNone => 'ఇంకా ఐటమ్‌లు లేవు';

  @override
  String get menuItemsNoMatch => 'సరిపోలేదు';

  @override
  String get menuItemsAddFirst => 'మీ మొదటి ఐటమ్‌ను జోడించండి';

  @override
  String get menuItemsAddCategoryFirst => 'ముందు వర్గాన్ని జోడించండి';

  @override
  String get menuCategoriesTitle => 'వర్గాలు';

  @override
  String get menuCategoriesSubtitle => 'మీ మెనూ భాగాలు. కౌంటర్‌లోనూ ఇదే క్రమం.';

  @override
  String get menuCategoriesNew => 'కొత్త వర్గం';

  @override
  String get menuCategoriesNone => 'ఇంకా వర్గాలు లేవు';

  @override
  String get menuCategoriesAddFirst => 'మీ మొదటి వర్గాన్ని జోడించండి';

  @override
  String get menuCategoriesHidden => 'దాచబడింది';

  @override
  String get menuCategoriesTileColour => 'టైల్ రంగు';

  @override
  String get menuCategoriesTileColourHint =>
      'సిబ్బంది త్వరగా కనుగొనేందుకు కౌంటర్‌లో చూపుతుంది.';

  @override
  String get menuCategoriesVisible => 'కౌంటర్‌లో కనిపిస్తుంది';

  @override
  String get menuCategoriesStation => 'దీన్ని చేసేది';

  @override
  String get menuCategoriesStationHint =>
      'ఈ విభాగం ఆర్డర్లు ఆ స్టేషన్‌లో ప్రింట్ అవుతాయి.';

  @override
  String get menuItemOnTheMenu => 'మెనూలో ఉంది';

  @override
  String get menuItemInStock => 'స్టాక్‌లో';

  @override
  String get menuItemCode => 'ఐటమ్ కోడ్';

  @override
  String get menuItemPrepTime => 'తయారీ సమయం';

  @override
  String get modifiersTitle => 'మాడిఫైయర్లు';

  @override
  String get modifiersSubtitle =>
      'ఐటమ్‌లకు జోడించే ఎంపికలు. ఒక్కసారి తయారుచేసి ఎక్కడైనా వాడండి.';

  @override
  String get modifiersNewGroup => 'కొత్త గ్రూప్';

  @override
  String get modifiersNone => 'ఇంకా మాడిఫైయర్ గ్రూపులు లేవు';

  @override
  String get modifiersCreateFirst => 'మీ మొదటి గ్రూప్‌ను తయారుచేయండి';

  @override
  String get modifiersAddOption => 'ఎంపికను జోడించు';

  @override
  String get modifiersNoOptions => 'ఇంకా ఎంపికలు లేవు.';

  @override
  String get modifiersAllowMoreThanOne => 'ఒకటి కంటే ఎక్కువ అనుమతించు';

  @override
  String get modifiersMustBeAnswered => 'సమాధానం తప్పనిసరి';

  @override
  String get modifiersMaxSelectable => 'ఎంచుకోగల గరిష్ఠం';

  @override
  String get modifiersPriceChange => 'ధర మార్పు';

  @override
  String get modifiersOffered => 'అందుబాటులో';

  @override
  String get tablesTitle => 'టేబుళ్లు';

  @override
  String get tablesSubtitle =>
      'మీ ఫ్లోర్. గదిలో భాగాలుంటే జోన్లుగా విభజించండి.';

  @override
  String get tablesNew => 'కొత్త టేబుల్';

  @override
  String get tablesNone => 'ఇంకా టేబుళ్లు లేవు';

  @override
  String get tablesAddFirst => 'మీ మొదటి టేబుల్‌ను జోడించండి';

  @override
  String get tablesNameOrNumber => 'పేరు లేదా సంఖ్య';

  @override
  String get tablesSeats => 'సీట్లు';

  @override
  String get tablesZone => 'జోన్';

  @override
  String get tablesInUse => 'వాడుకలో ఉంది';

  @override
  String get tablesCodes => 'టేబుల్ కోడ్‌లు';

  @override
  String get tablesCodesNone => 'ఇంకా టేబుళ్లు వాడుకలో లేవు.';

  @override
  String tablesDeleteConfirm(String label) {
    return '$label తొలగించాలా?';
  }

  @override
  String get staffTitle => 'సిబ్బంది';

  @override
  String get staffSubtitle => 'ఎవరు సైన్ ఇన్ చేయవచ్చు, వారికి ఏమి అనుమతి.';

  @override
  String get staffAddSomeone => 'ఒకరిని జోడించు';

  @override
  String get staffNobodyYet => 'ఇంకా ఎవరూ లేరు';

  @override
  String get staffCanSignIn => 'సైన్ ఇన్ చేయవచ్చు';

  @override
  String get staffWhatTheyCanDo => 'వారు ఏమి చేయగలరు';

  @override
  String get staffYou => 'మీరు';

  @override
  String get staffCannotDisableSelf => 'మీ ఖాతాను మీరే ఆపలేరు.';

  @override
  String get staffGiveNewPin => 'వారికి కొత్త పిన్ ఇవ్వు';

  @override
  String staffNewPinFor(String name) {
    return '$name కోసం కొత్త పిన్';
  }

  @override
  String get staffSetPin => 'పిన్ సెట్ చేయి';

  @override
  String staffRemoveConfirm(String name) {
    return '$name తొలగించాలా?';
  }

  @override
  String get reportsTitle => 'రిపోర్టులు';

  @override
  String get reportsSubtitle => 'ప్రతి రోజు లెక్క.';

  @override
  String get reportsWhatSold => 'ఏమి అమ్ముడైంది';

  @override
  String get reportsWhoServedIt => 'ఎవరు సర్వ్ చేశారు';

  @override
  String get reportsByHour => 'గంట వారీగా';

  @override
  String get reportsExportCsv => 'CSV ఎగుమతి';

  @override
  String get reportsSaved => 'రిపోర్టు సేవ్ అయింది.';

  @override
  String reportsCouldNotSave(String error) {
    return 'సేవ్ చేయలేకపోయింది: $error';
  }

  @override
  String get activityTitle => 'కార్యకలాపం';

  @override
  String get activitySubtitle => 'డిస్కౌంట్లు, రద్దులు — ప్రతిదానితో పేరు.';

  @override
  String get activityMoneyLeavingOnly => 'బయటకు వెళ్లే డబ్బు మాత్రమే';

  @override
  String get settingsTitle => 'సెట్టింగ్‌లు';

  @override
  String get settingsRestaurant => 'రెస్టారెంట్';

  @override
  String get settingsRestaurantHint =>
      'మీ రెస్టారెంట్ తనను ఎలా చూపుతుంది, ఏమి ఛార్జ్ చేస్తుంది.';

  @override
  String get settingsCharges => 'ఛార్జీలు';

  @override
  String get settingsCurrency => 'కరెన్సీ';

  @override
  String get settingsTaxRate => 'పన్ను రేటు';

  @override
  String get settingsTaxIncluded => 'మెనూ ధరల్లో పన్ను కలిసి ఉంది';

  @override
  String get settingsServiceCharge => 'సర్వీస్ ఛార్జ్';

  @override
  String get settingsPrinters => 'ప్రింటర్లు';

  @override
  String get settingsReceipts => 'రసీదులు';

  @override
  String get settingsHeader => 'హెడర్';

  @override
  String get settingsFooter => 'ఫుటర్';

  @override
  String get settingsServer => 'సర్వర్';

  @override
  String get settingsThisDevice => 'ఈ పరికరం';

  @override
  String get settingsAddTablet => 'టాబ్లెట్ జోడించు';

  @override
  String get settingsSignOut => 'సైన్ అవుట్';

  @override
  String get settingsDisconnect => 'డిస్‌కనెక్ట్ చేయి';

  @override
  String get settingsDisconnectConfirm => 'ఈ పరికరాన్ని డిస్‌కనెక్ట్ చేయాలా?';

  @override
  String get printerNew => 'ప్రింటర్ జోడించు';

  @override
  String get printerPaperWidth => 'కాగితం వెడల్పు';

  @override
  String get printerWhatItPrints => 'అది ఏమి ప్రింట్ చేస్తుంది';

  @override
  String get printerInUse => 'వాడుకలో';

  @override
  String printerRemoveConfirm(String name) {
    return '$name తొలగించాలా?';
  }

  @override
  String get guestScanTitle => 'ఆర్డర్ కోసం స్కాన్ చేయి';

  @override
  String get guestMenuTitle => 'మెనూ';

  @override
  String get signInErrorNoUsername => 'మీ యూజర్‌నేమ్ ఇవ్వండి.';

  @override
  String get signInErrorShortPin => 'మీ పిన్ కనీసం 4 అంకెలు.';

  @override
  String ticketSendCourseOnly(String course) {
    return '$course మాత్రమే పంపు';
  }

  @override
  String get ticketBackToFloor => 'ఫ్లోర్‌కు తిరిగి';

  @override
  String ticketCouldNotSend(String error) {
    return 'పంపలేకపోయింది: $error';
  }

  @override
  String ticketCouldNotCancel(String error) {
    return 'రద్దు చేయలేకపోయింది: $error';
  }

  @override
  String get ticketEmptyBill => 'ఈ బిల్లులో ఇంకా ఏమీ లేదు';

  @override
  String get ticketVoided => 'రద్దు చేయబడింది';

  @override
  String get ticketSavedNotSent => 'ఇక్కడ సేవ్ అయింది — ఇంకా పంపలేదు';

  @override
  String get ticketQuantity => 'పరిమాణం';

  @override
  String get ticketCourse => 'కోర్సు';

  @override
  String get ticketRetry => 'మళ్లీ ప్రయత్నం';

  @override
  String get kdsStatusQueued => 'క్యూలో';

  @override
  String get kdsStatusPreparing => 'తయారవుతోంది';

  @override
  String get kdsStatusReady => 'సిద్ధం';

  @override
  String get outletTitle => 'అవుట్‌లెట్';

  @override
  String get outletSwitch => 'అవుట్‌లెట్ మార్చు';

  @override
  String get outletAll => 'అన్ని అవుట్‌లెట్లు';

  @override
  String get settingsLanguage => 'భాష';

  @override
  String get settingsLanguageHint => 'ఈ పరికరం భాష';

  @override
  String get floorNoTablesHint =>
      'మేనేజర్ ఫ్లోర్ → టేబుళ్లలో టేబుళ్లను జోడించవచ్చు. అప్పటివరకు మీరు టేకవే ఆర్డర్లు తీసుకోవచ్చు.';

  @override
  String get splitOwnBill => 'లేదా ఎవరికైనా వారి సొంత బిల్ ఇవ్వండి';

  @override
  String get splitSeparateTax =>
      'ప్రతి బిల్లుపై సర్వీస్, పన్ను విడివిడిగా లెక్కిస్తారు.';

  @override
  String get splitEvenTitle => 'అందరూ తమ వాటా చెల్లించండి';

  @override
  String get splitEvenHint =>
      'ఒక బిల్, సమానంగా విభజించు. ప్రతి వాటాను ప్రత్యేక చెల్లింపుగా తీసుకోండి.';

  @override
  String get kdsEmptyHint => 'కౌంటర్ పంపగానే టిక్కెట్లు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get settingsLanguageSystem => 'పరికర భాష';

  @override
  String get invTitle => 'స్టాక్';

  @override
  String get invSubtitle =>
      'చేతిలో ఉన్న స్టాక్, దాని విలువ, మళ్లీ ఏమి తెప్పించాలి.';

  @override
  String get invNewItem => 'కొత్త వస్తువు';

  @override
  String get invStockValue => 'స్టాక్ విలువ';

  @override
  String get invLowStock => 'తక్కువ స్టాక్';

  @override
  String invLastRestock(String date) {
    return 'చివరి కొనుగోలు $date';
  }

  @override
  String get invNeedsReview => 'సమీక్ష అవసరం';

  @override
  String get invLow => 'తక్కువ';

  @override
  String get invBalance => 'నిల్వ';

  @override
  String get invThreshold => 'మళ్లీ తెప్పించే స్థాయి';

  @override
  String get invUnit => 'యూనిట్';

  @override
  String invCostPerUnit(String unit) {
    return '$unitకు ధర';
  }

  @override
  String get invActive => 'చురుకుగా';

  @override
  String get invPurchase => 'కొనుగోలు';

  @override
  String get invWastage => 'వృథా';

  @override
  String get invAdjust => 'సర్దుబాటు';

  @override
  String get invQuantity => 'పరిమాణం';

  @override
  String get invNote => 'గమనిక';

  @override
  String get invEmpty => 'ఇంకా స్టాక్ వస్తువులు లేవు';

  @override
  String get invEmptyHint => 'పిండి, పాలు, చికెన్ జోడించండి — వంటగదిలో ఉండేది.';

  @override
  String get invRecipe => 'వంటకం';

  @override
  String get invRecipeHint =>
      'ప్రతి సర్వింగ్‌కు ఏమి అవసరమో. వడ్డించగానే ఆటోమేటిక్‌గా తగ్గుతుంది.';

  @override
  String get invAddIngredient => 'పదార్థం జోడించండి';

  @override
  String get invQtyPerServing => 'సర్వింగ్‌కు';

  @override
  String get invSaveItemFirst =>
      'ముందు వస్తువును సేవ్ చేయండి, తర్వాత వంటకం జోడించండి.';

  @override
  String get invPurchaseTitle => 'కొనుగోలు నమోదు చేయండి';

  @override
  String get invWastageTitle => 'వృథాను నమోదు చేయండి';

  @override
  String get invAdjustTitle => 'స్టాక్ సర్దుబాటు చేయండి';

  @override
  String get invAdjustHint => 'ఆడిట్ చేసిన సవరణలు — ఉదా. లెక్క తేడా.';

  @override
  String get invPickIngredient => 'పదార్థం ఎంచుకోండి';

  @override
  String get invEdit => 'సవరించు';
}
