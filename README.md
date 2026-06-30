# Lock App Pattern

Project Flutter untuk starter aplikasi pengunci aplikasi tambahan dengan metode pattern lock.

Android package name / application ID:

```text
com.deploydulupulangnanti.lockapp
```

Kebijakan privasi tersedia di [PRIVACY_POLICY.md](PRIVACY_POLICY.md). Untuk GitHub Pages, gunakan halaman [docs/privacy-policy.html](docs/privacy-policy.html).

Project ini dibuat menggunakan Flutter dari FVM:

```powershell
C:\Users\userkamu\fvm\versions\3.41.2
```

## Fitur

- Membuat pola kunci minimal 4 titik.
- Konfirmasi pola saat pertama kali dibuat.
- Membuka aplikasi dengan pola yang sudah dibuat.
- Menampilkan jumlah percobaan pola yang salah.
- Dashboard daftar aplikasi tambahan yang bisa ditandai terkunci.
- Reset pola dari dashboard setelah berhasil masuk.

## Catatan Penting

Versi ini adalah fondasi UI dan logic pattern lock di Flutter/Dart. Untuk benar-benar mengunci aplikasi Android lain, pengembangan berikutnya perlu menambahkan fitur native Android seperti izin usage access, deteksi aplikasi aktif, overlay, dan service background.

Penyimpanan pola pada versi ini masih aktif selama sesi aplikasi berjalan. Jika ingin pola tersimpan permanen, bisa ditambahkan dependency seperti `shared_preferences`. Pada Windows, plugin Flutter biasanya membutuhkan Developer Mode karena memakai symlink.

## Struktur Project

```text
lib/
  main.dart          # UI, pattern input, logic lock, dan dashboard aplikasi
test/
  widget_test.dart   # Smoke test layar awal pattern lock
android/             # Target Android
ios/                 # Target iOS
web/                 # Target Web
windows/             # Target Windows
```

## Menjalankan Project

Masuk ke folder project:

```powershell
cd D:\GITHUB\lock_app_pattern
```

Ambil dependency:

```powershell
C:\Users\userkamu\fvm\versions\3.41.2\bin\flutter.bat pub get
```

Jalankan aplikasi:

```powershell
C:\Users\userkamu\fvm\versions\3.41.2\bin\flutter.bat run
```

## Pemeriksaan

Analisis kode:

```powershell
C:\Users\userkamu\fvm\versions\3.41.2\bin\flutter.bat analyze
```

Jalankan test:

```powershell
C:\Users\userkamu\fvm\versions\3.41.2\bin\flutter.bat test
```

Build APK debug:

```powershell
C:\Users\userkamu\fvm\versions\3.41.2\bin\flutter.bat build apk --debug
```

Jika build APK pertama kali terasa lama, biasanya Gradle sedang mengunduh atau menyiapkan cache Android.
