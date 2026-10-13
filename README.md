# CheckPlanner

Aplikasi mobile to-do list untuk mengelola tugas harian semua kalangan.
Ini adalah **versi awal (tampilan/UI)** dari proposal tugas akhir.

## Fitur pada versi awal

- Layar selamat datang, Login (email, kata sandi, lupa kata sandi, Google), dan Registrasi (nama, email, kata sandi, kalangan, syarat & ketentuan). Login/registrasi masih tampilan saja, belum terhubung Firebase Authentication
- Beranda: progres harian, filter (Semua, Hari Ini, Mendatang, Selesai), daftar tugas
- Tambah, edit, hapus (dengan dialog konfirmasi), dan tandai tugas selesai
- Prioritas (rendah/sedang/tinggi) dan kategori
- Kalender bulanan dengan penanda tanggal yang memiliki tugas
- Statistik (grafik batang & distribusi kategori)
- Profil dengan mode tampilan gelap

Data masih disimpan sementara di memori (`lib/data/task_store.dart`) dan akan
diganti dengan SQLite + Firebase pada tahap implementasi berikutnya.

## Struktur folder

```
lib/
  main.dart
  theme/        tema warna (hijau toska #35766D + oranye)
  models/       model Task, Priority
  data/         TaskStore (data sementara)
  utils/        format tanggal bahasa Indonesia
  screens/      welcome, login, registrasi, home shell, daftar tugas, form tugas, kalender, statistik, profil
  widgets/      komponen yang dipakai ulang (TaskTile)
test/
```

## Menjalankan

Folder `android/` dan `ios/` dibuat otomatis oleh Flutter, jalankan sekali:

```bash
flutter create . --project-name checkplanner --org com.checkplanner
flutter pub get
flutter run
```

Menjalankan test:

```bash
flutter test
```

## Widget Flutter yang dipakai

`MaterialApp`, `Scaffold`, `NavigationBar`, `IndexedStack`, `ListView`, `GridView`,
`Card`, `Checkbox`, `ChoiceChip`, `Form` / `TextFormField`, `showDatePicker`,
`showTimePicker`, `AlertDialog`, `LinearProgressIndicator`, `SwitchListTile`,
`ListenableBuilder`, `ValueListenableBuilder`.
