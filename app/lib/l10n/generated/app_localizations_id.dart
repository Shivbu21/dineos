// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppStringsId extends AppStrings {
  AppStringsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'dineos';

  @override
  String get commonCancel => 'Batal';

  @override
  String get commonDelete => 'Hapus';

  @override
  String get commonRemove => 'Singkirkan';

  @override
  String get commonClose => 'Tutup';

  @override
  String get commonDone => 'Selesai';

  @override
  String get commonSave => 'Simpan perubahan';

  @override
  String get commonAdd => 'Tambah';

  @override
  String get commonName => 'Nama';

  @override
  String get commonAddress => 'Alamat';

  @override
  String get commonPort => 'Port';

  @override
  String get commonPrice => 'Harga';

  @override
  String get commonTotal => 'Total';

  @override
  String get commonSubtotal => 'Subtotal';

  @override
  String get commonNote => 'Catatan';

  @override
  String get commonReason => 'Alasan';

  @override
  String get commonAmount => 'Jumlah';

  @override
  String get commonReference => 'Referensi';

  @override
  String get commonDescription => 'Deskripsi';

  @override
  String get commonCategory => 'Kategori';

  @override
  String get commonPhoto => 'Foto';

  @override
  String get commonOptions => 'Pilihan';

  @override
  String get commonTags => 'Label';

  @override
  String get commonTryAgain => 'Coba lagi';

  @override
  String get commonCouldNotLoad => 'Tidak bisa memuat ini';

  @override
  String get commonTest => 'Uji';

  @override
  String get commonEarlier => 'Lebih awal';

  @override
  String get commonLater => 'Lebih baru';

  @override
  String get commonAll => 'Semua';

  @override
  String get commonOn => 'Aktif';

  @override
  String get commonOff => 'Mati';

  @override
  String get signInTitle => 'Masuk';

  @override
  String get signInUsername => 'Nama pengguna';

  @override
  String get signInPin => 'PIN';

  @override
  String get signInUseDifferentServer => 'Ganti server';

  @override
  String get connectTitle => 'Sambungkan ke server Anda';

  @override
  String get connectAction => 'Sambungkan';

  @override
  String get connectOnThisNetwork => 'Di jaringan ini';

  @override
  String get connectSubtitle => 'Manajemen restoran';

  @override
  String get connectSubtitleLong =>
      'Arahkan perangkat ini ke komputer yang menjalankan restoran Anda.';

  @override
  String get connectFooter =>
      'Gratis selamanya. Data Anda tetap di mesin Anda sendiri.';

  @override
  String get connectServerHelper =>
      'Menjalankan server di komputer ini? Biarkan seperti ini.';

  @override
  String get connectRunOnThisComputer => 'Jalankan restoran di komputer ini';

  @override
  String get connectRunOnThisComputerHint =>
      'Semua diatur di sini. Tablet dan layar dapur menyusul lewat wi-fi Anda.';

  @override
  String get connectScanCode => 'Pindai kode';

  @override
  String get connectServerAddress => 'Alamat server';

  @override
  String get connectOr => 'atau';

  @override
  String get connectScanPointAtCode => 'Arahkan ke kode';

  @override
  String get connectScanTypeInstead => 'Ketik manual';

  @override
  String get setupTitle => 'Siapkan restoran Anda';

  @override
  String get kdsOnThePass => 'Di pass';

  @override
  String get kdsNothingOnThePass => 'Pass kosong';

  @override
  String kdsCouldNotUpdate(String error) {
    return 'Tidak bisa memperbarui: $error';
  }

  @override
  String get navPos => 'Kasir';

  @override
  String get navKds => 'Dapur';

  @override
  String get navManager => 'Manajer';

  @override
  String get navSignOut => 'Keluar';

  @override
  String get navSwitchShell => 'Ganti tampilan';

  @override
  String get floorTitle => 'Lantai';

  @override
  String get floorHint => 'Ketuk meja untuk membuka atau melanjutkan bonnya.';

  @override
  String get floorNoTables => 'Belum ada meja';

  @override
  String get floorTakeaway => 'Bawa pulang';

  @override
  String get floorOpenBill => 'Bon terbuka';

  @override
  String get floorHowManyGuests => 'Berapa tamu?';

  @override
  String floorSeatTable(String label) {
    return 'Dudukkan $label';
  }

  @override
  String floorCouldNotOpen(String error) {
    return 'Tidak bisa membuka meja: $error';
  }

  @override
  String floorCouldNotStart(String error) {
    return 'Tidak bisa memulai pesanan: $error';
  }

  @override
  String get floorInUse => 'Terpakai';

  @override
  String get orderBackToFloor => 'Kembali ke lantai';

  @override
  String get orderNothingHere => 'Belum ada isi';

  @override
  String get orderMenuEmpty => 'Menu masih kosong';

  @override
  String get orderBillGone => 'Bon ini sudah tidak ada';

  @override
  String orderCouldNotAdd(String error) {
    return 'Tidak bisa menambah: $error';
  }

  @override
  String get orderSoldOut => 'Habis';

  @override
  String get orderAddToBill => 'Tambahkan ke bon';

  @override
  String get orderNoteForKitchen => 'Catatan untuk dapur';

  @override
  String orderUpTo(int count) {
    return 'maksimal $count';
  }

  @override
  String moveBillTitle(String number) {
    return 'Pindahkan bon #$number';
  }

  @override
  String get moveBillNowhere => 'Tidak ada tujuan lain.';

  @override
  String get moveBillWhereTo => 'Ke mana?';

  @override
  String get discountTitle => 'Diskon';

  @override
  String get discountAmountOff => 'Potongan jumlah';

  @override
  String get discountNewSubtotal => 'Subtotal baru';

  @override
  String get discountReasonHint => 'Layanan dan pajak dihitung dari angka ini.';

  @override
  String get discountClear => 'Hapus';

  @override
  String get paymentTitle => 'Bagaimana mereka membayar?';

  @override
  String get paymentCashReceived => 'Uang diterima';

  @override
  String get paymentChangeDue => 'Kembalian';

  @override
  String get paymentPaid => 'Sudah dibayar';

  @override
  String paymentTake(String amount) {
    return 'Terima $amount';
  }

  @override
  String get paymentTakenSoFar => 'Sudah diterima';

  @override
  String get paymentRemovePayment => 'Hapus pembayaran ini';

  @override
  String get paymentReceipt => 'Struk';

  @override
  String get receiptTitle => 'Struk';

  @override
  String receiptPrintTo(String printer) {
    return 'Cetak ke $printer';
  }

  @override
  String get shiftCloseTitle => 'Tutup shift Anda';

  @override
  String get shiftCashInDrawer => 'Uang di laci';

  @override
  String get shiftCashTaken => 'Uang masuk';

  @override
  String get shiftCounted => 'Hasil hitung';

  @override
  String get shiftOpeningFloat => 'Modal awal';

  @override
  String get shiftShouldBeInDrawer => 'Seharusnya ada di laci';

  @override
  String get shiftHereIsWhat => 'Berikut hasilnya.';

  @override
  String get shiftClosed => 'Shift ditutup';

  @override
  String get summaryTakings => 'Pendapatan';

  @override
  String get summaryHowItAddsUp => 'Rincian';

  @override
  String get summaryHowItWasPaid => 'Cara pembayaran';

  @override
  String get summaryTheDrawer => 'Laci';

  @override
  String get summaryCancelled => 'Dibatalkan';

  @override
  String get menuItemsTitle => 'Menu';

  @override
  String get menuItemsSubtitle => 'Semua yang Anda jual, dan harganya.';

  @override
  String get menuItemsNew => 'Menu baru';

  @override
  String get menuItemsNone => 'Belum ada menu';

  @override
  String get menuItemsNoMatch => 'Tidak ada yang cocok';

  @override
  String get menuItemsAddFirst => 'Tambahkan menu pertama';

  @override
  String get menuItemsAddCategoryFirst => 'Tambahkan kategori dulu';

  @override
  String get menuCategoriesTitle => 'Kategori';

  @override
  String get menuCategoriesSubtitle =>
      'Bagian-bagian menu Anda. Urutannya mengikuti urutan di kasir.';

  @override
  String get menuCategoriesNew => 'Kategori baru';

  @override
  String get menuCategoriesNone => 'Belum ada kategori';

  @override
  String get menuCategoriesAddFirst => 'Tambahkan kategori pertama';

  @override
  String get menuCategoriesHidden => 'Disembunyikan';

  @override
  String get menuCategoriesTileColour => 'Warna kartu';

  @override
  String get menuCategoriesTileColourHint =>
      'Ditampilkan di kasir supaya staf cepat menemukan bagian ini.';

  @override
  String get menuCategoriesVisible => 'Tampil di kasir';

  @override
  String get menuCategoriesStation => 'Siapa yang membuat';

  @override
  String get menuCategoriesStationHint =>
      'Bon dari bagian ini dicetak di stasiun tersebut.';

  @override
  String get menuItemOnTheMenu => 'Ada di menu';

  @override
  String get menuItemInStock => 'Stok tersedia';

  @override
  String get menuItemCode => 'Kode menu';

  @override
  String get menuItemPrepTime => 'Waktu siap';

  @override
  String get modifiersTitle => 'Pilihan tambahan';

  @override
  String get modifiersSubtitle =>
      'Pilihan yang bisa ditempel ke menu. Tentukan sekali, pakai berulang.';

  @override
  String get modifiersNewGroup => 'Grup baru';

  @override
  String get modifiersNone => 'Belum ada grup pilihan';

  @override
  String get modifiersCreateFirst => 'Buat grup pertama';

  @override
  String get modifiersAddOption => 'Tambah pilihan';

  @override
  String get modifiersNoOptions => 'Belum ada pilihan.';

  @override
  String get modifiersAllowMoreThanOne => 'Boleh pilih lebih dari satu';

  @override
  String get modifiersMustBeAnswered => 'Wajib dijawab';

  @override
  String get modifiersMaxSelectable => 'Maksimal yang bisa dipilih';

  @override
  String get modifiersPriceChange => 'Perubahan harga';

  @override
  String get modifiersOffered => 'Ditawarkan';

  @override
  String get tablesTitle => 'Meja';

  @override
  String get tablesSubtitle =>
      'Denah Anda. Kelompokkan per zona kalau ruangannya bersekat.';

  @override
  String get tablesNew => 'Meja baru';

  @override
  String get tablesNone => 'Belum ada meja';

  @override
  String get tablesAddFirst => 'Tambahkan meja pertama';

  @override
  String get tablesNameOrNumber => 'Nama atau nomor';

  @override
  String get tablesSeats => 'Kursi';

  @override
  String get tablesZone => 'Zona';

  @override
  String get tablesInUse => 'Terpakai';

  @override
  String get tablesCodes => 'Kode meja';

  @override
  String get tablesCodesNone => 'Belum ada meja yang dipakai.';

  @override
  String tablesDeleteConfirm(String label) {
    return 'Hapus $label?';
  }

  @override
  String get staffTitle => 'Staf';

  @override
  String get staffSubtitle =>
      'Siapa yang bisa masuk, dan apa yang boleh mereka lakukan.';

  @override
  String get staffAddSomeone => 'Tambah orang';

  @override
  String get staffNobodyYet => 'Belum ada siapa-siapa';

  @override
  String get staffCanSignIn => 'Bisa masuk';

  @override
  String get staffWhatTheyCanDo => 'Hak akses';

  @override
  String get staffYou => 'Anda';

  @override
  String get staffCannotDisableSelf =>
      'Anda tidak bisa menonaktifkan akun sendiri.';

  @override
  String get staffGiveNewPin => 'Beri PIN baru';

  @override
  String staffNewPinFor(String name) {
    return 'PIN baru untuk $name';
  }

  @override
  String get staffSetPin => 'Simpan PIN';

  @override
  String staffRemoveConfirm(String name) {
    return 'Keluarkan $name?';
  }

  @override
  String get reportsTitle => 'Laporan';

  @override
  String get reportsSubtitle => 'Hasil penjualan tiap hari.';

  @override
  String get reportsWhatSold => 'Yang terjual';

  @override
  String get reportsWhoServedIt => 'Yang melayani';

  @override
  String get reportsByHour => 'PER JAM';

  @override
  String get reportsExportCsv => 'Ekspor CSV';

  @override
  String get reportsSaved => 'Laporan tersimpan.';

  @override
  String reportsCouldNotSave(String error) {
    return 'Tidak bisa menyimpan: $error';
  }

  @override
  String get activityTitle => 'Aktivitas';

  @override
  String get activitySubtitle =>
      'Diskon, pembatalan, dan void — lengkap dengan namanya.';

  @override
  String get activityMoneyLeavingOnly => 'Hanya uang keluar';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsRestaurant => 'Restoran';

  @override
  String get settingsRestaurantHint =>
      'Identitas restoran Anda dan biaya yang dikenakan.';

  @override
  String get settingsCharges => 'Biaya';

  @override
  String get settingsCurrency => 'Mata uang';

  @override
  String get settingsTaxRate => 'Tarif pajak';

  @override
  String get settingsTaxIncluded => 'Harga menu sudah termasuk pajak';

  @override
  String get settingsServiceCharge => 'Biaya layanan';

  @override
  String get settingsPrinters => 'Printer';

  @override
  String get settingsReceipts => 'Struk';

  @override
  String get settingsHeader => 'Kepala';

  @override
  String get settingsFooter => 'Kaki';

  @override
  String get settingsServer => 'Server';

  @override
  String get settingsThisDevice => 'Perangkat ini';

  @override
  String get settingsAddTablet => 'Tambah tablet';

  @override
  String get settingsSignOut => 'Keluar';

  @override
  String get settingsDisconnect => 'Putuskan';

  @override
  String get settingsDisconnectConfirm => 'Putuskan perangkat ini?';

  @override
  String get printerNew => 'Tambah printer';

  @override
  String get printerPaperWidth => 'Lebar kertas';

  @override
  String get printerWhatItPrints => 'Fungsi cetak';

  @override
  String get printerInUse => 'Terpakai';

  @override
  String printerRemoveConfirm(String name) {
    return 'Hapus $name?';
  }

  @override
  String get guestScanTitle => 'Pindai untuk memesan';

  @override
  String get guestMenuTitle => 'Menu';

  @override
  String get signInErrorNoUsername => 'Masukkan nama pengguna Anda.';

  @override
  String get signInErrorShortPin => 'PIN Anda minimal 4 angka.';

  @override
  String ticketSendCourseOnly(String course) {
    return 'Kirim $course saja';
  }

  @override
  String get ticketBackToFloor => 'Kembali ke lantai';

  @override
  String ticketCouldNotSend(String error) {
    return 'Tidak bisa mengirim: $error';
  }

  @override
  String ticketCouldNotCancel(String error) {
    return 'Tidak bisa membatalkan: $error';
  }

  @override
  String get ticketEmptyBill => 'Belum ada di bon ini';

  @override
  String get ticketVoided => 'Dibatalkan';

  @override
  String get ticketSavedNotSent => 'Tersimpan di sini — belum dikirim';

  @override
  String get ticketQuantity => 'Jumlah';

  @override
  String get ticketCourse => 'Tahap hidangan';

  @override
  String get ticketRetry => 'Coba lagi';

  @override
  String get kdsStatusQueued => 'Antre';

  @override
  String get kdsStatusPreparing => 'Dimasak';

  @override
  String get kdsStatusReady => 'Siap';

  @override
  String get outletTitle => 'Outlet';

  @override
  String get outletSwitch => 'Ganti outlet';

  @override
  String get outletAll => 'Semua outlet';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsLanguageHint => 'Bahasa untuk perangkat ini';

  @override
  String get floorNoTablesHint =>
      'Manajer bisa menambah meja di Lantai → Meja. Sementara itu Anda tetap bisa menerima pesanan bawa pulang.';

  @override
  String get splitOwnBill => 'Atau beri seseorang bonnya sendiri';

  @override
  String get splitSeparateTax =>
      'Layanan dan pajak dihitung pada masing-masing bon.';

  @override
  String get splitEvenTitle => 'Semua membayar bagian';

  @override
  String get splitEvenHint =>
      'Satu bon, dibagi rata. Ambil tiap bagian sebagai pembayaran sendiri.';

  @override
  String get kdsEmptyHint => 'Tiket muncul di sini begitu kasir mengirimnya.';

  @override
  String get settingsLanguageSystem => 'Bahasa perangkat';

  @override
  String get invTitle => 'Inventaris';

  @override
  String get invSubtitle =>
      'Stok yang ada, nilainya, dan apa yang harus dipesan.';

  @override
  String get invNewItem => 'Item baru';

  @override
  String get invStockValue => 'Nilai stok';

  @override
  String get invLowStock => 'Stok menipis';

  @override
  String invLastRestock(String date) {
    return 'Restok terakhir $date';
  }

  @override
  String get invNeedsReview => 'Perlu ditinjau';

  @override
  String get invLow => 'Menipis';

  @override
  String get invBalance => 'Saldo';

  @override
  String get invThreshold => 'Batas minimum';

  @override
  String get invUnit => 'Satuan';

  @override
  String invCostPerUnit(String unit) {
    return 'Harga per $unit';
  }

  @override
  String get invActive => 'Aktif';

  @override
  String get invPurchase => 'Pembelian';

  @override
  String get invWastage => 'Terbuang';

  @override
  String get invAdjust => 'Penyesuaian';

  @override
  String get invQuantity => 'Jumlah';

  @override
  String get invNote => 'Catatan';

  @override
  String get invEmpty => 'Belum ada item stok';

  @override
  String get invEmptyHint =>
      'Tambahkan tepung, susu, ayam — apa pun yang disimpan dapur.';

  @override
  String get invRecipe => 'Resep';

  @override
  String get invRecipeHint =>
      'Bahan yang dipakai tiap porsi. Otomatis dikurangi saat disajikan.';

  @override
  String get invAddIngredient => 'Tambah bahan';

  @override
  String get invQtyPerServing => 'Per porsi';

  @override
  String get invSaveItemFirst => 'Simpan item dulu, lalu tambahkan resepnya.';

  @override
  String get invPurchaseTitle => 'Catat pembelian';

  @override
  String get invWastageTitle => 'Catat bahan terbuang';

  @override
  String get invAdjustTitle => 'Sesuaikan stok';

  @override
  String get invAdjustHint => 'Koreksi tercatat — mis. selisih hitung ulang.';

  @override
  String get invPickIngredient => 'Pilih bahan';

  @override
  String get invEdit => 'Ubah';
}
