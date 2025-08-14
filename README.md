# Aplikasi To-Do List (Proyek Akhir Mobile Development)

Selamat datang di repository Proyek Akhir Mobile Development! Ini adalah aplikasi To-Do List fungsional yang dibangun menggunakan Flutter. Aplikasi ini dirancang untuk membantu pengguna mengelola tugas harian mereka secara efisien dengan antarmuka yang bersih, modern, dan interaktif.

## 🌟 Fitur Utama

Aplikasi ini mencakup berbagai fitur yang dibagi menjadi tiga tingkatan, dari dasar hingga lanjutan, untuk menunjukkan pemahaman komprehensif tentang pengembangan aplikasi mobile dengan Flutter.

### Tingkat 1: Fitur Dasar (Essential)
-   ✅ **Manajemen Tugas (CRUD):** Tambah, lihat, edit, dan hapus tugas dengan mudah.
-   ✅ **Tandai Selesai:** Tugas yang sudah selesai akan secara visual dibedakan (berwarna abu-abu) dan otomatis diurutkan ke bagian bawah daftar.
-   ✅ **Penyimpanan Lokal:** Semua data tugas dan pengguna disimpan secara persisten di perangkat menggunakan `shared_preferences`, sehingga data tidak hilang saat aplikasi ditutup.
-   ✅ **Pencarian Real-time:** Cari tugas secara instan berdasarkan judul atau catatan.
-   ✅ **State Management Profesional:** Menggunakan `provider` untuk mengelola state aplikasi secara efisien dan reaktif.
-   ✅ **UI/UX Modern:** Antarmuka yang dirancang dengan indah, terinspirasi dari desain Figma, dengan dukungan penuh untuk **Mode Gelap & Terang**.

### Tingkat 2: Fitur Pengguna (Intermediate)
-   ✅ **Autentikasi Pengguna:** Sistem registrasi dan login untuk memisahkan data antar pengguna (disimulasikan secara lokal).
-   ✅ **Manajemen Sesi:** Fitur "auto-login" untuk menjaga pengguna tetap masuk setelah menutup aplikasi.
-   ✅ **Halaman Profil Kaya Fitur:**
    -   Menampilkan informasi pengguna (nama, email, bio, tanggal bergabung).
    -   **Edit Profil:** Pengguna dapat mengubah nama dan bio mereka.
    -   **Statistik Tugas:** Menampilkan jumlah total, selesai, dan tugas yang tertunda.
    -   **Pengaturan Tema:** Pengguna dapat memilih tema aplikasi (Terang, Gelap, atau Sistem) yang preferensinya disimpan per akun.

### Tingkat 3: Fitur Lanjutan (Advanced)
-   ✅ **Countdown Timer Real-time:**
    -   Untuk tugas yang memiliki waktu mulai, kartu tugas akan menampilkan hitungan mundur yang dinamis ("2 jam lagi", "15 menit lagi").
    -   Timer ini diperbarui setiap detik, memberikan nuansa "hidup" dan informatif pada antarmuka pengguna.

## 📸 Screenshot Aplikasi

| Halaman Utama (Light) | Halaman Utama (Dark) | Halaman Profil |
| :-------------------: | :------------------: | :------------: |
| ![Halaman Utama Light](https://github.com/user-attachments/assets/a3374a6e-73f9-4240-8c85-2edb589540c3) | ![Halaman Utama Dark](https://github.com/user-attachments/assets/e1ff90fa-14d5-4f75-9b9a-0ef2610b198e) | ![Halaman Profil](https://github.com/user-attachments/assets/b0fcfc64-9929-4e3c-bc95-961cd266e42d) |

| Halaman Tambah Tugas | Halaman Login | Halaman Register |
| :------------------: | :-----------: | :--------------: |
| ![Halaman Tambah Tugas](https://github.com/user-attachments/assets/ee799d44-c43e-49f8-b54b-2e43a9b34b37) | ![Halaman Login](https://github.com/user-attachments/assets/2e0be3e7-87a9-4eda-bbc2-d8a9a5d8b8bf) | ![Halaman Register](https://github.com/user-attachments/assets/cc41dce0-da9f-4038-b2ac-b5745d3eaba7) |

| Kartu Tugas dengan Countdown |
| :---------------------------: |
| ![Countdown Timer](https://github.com/user-attachments/assets/58ffb3d5-33db-49d4-ad55-64b1be8ec206) |


## 🛠️ Teknologi & Stack

-   **Framework:** Flutter 3.x
-   **Bahasa Pemrograman:** Dart
-   **Arsitektur & State Management:** Provider
-   **Penyimpanan Lokal:** `shared_preferences`
-   **Paket Utama:**
    -   `provider`: Untuk state management.
    -   `shared_preferences`: Untuk persistensi data.
    -   `uuid`: Untuk generate ID unik.
    -   `google_fonts`: Untuk tipografi yang lebih baik.
    -   `intl`: Untuk format tanggal dan waktu.

## 🚀 Cara Menjalankan Proyek

Untuk menjalankan proyek ini di lingkungan lokal Anda, ikuti langkah-langkah berikut:

1.  **Clone Repository**
    ```bash
    git clone https://github.com/bestoism/flutter_todo_app.git
    ```
    <!-- URL sudah disesuaikan dengan yang Anda gunakan sebelumnya -->

2.  **Masuk ke Direktori Proyek**
    ```bash
    cd flutter_todo_app
    ```

3.  **Install Dependencies**
    Pastikan Anda sudah menginstal Flutter SDK. Jalankan perintah berikut untuk mengunduh semua paket yang dibutuhkan.
    ```bash
    flutter pub get
    ```

4.  **Jalankan Aplikasi**
    Hubungkan perangkat (emulator atau perangkat fisik) dan jalankan aplikasi.
    ```bash
    flutter run
    ```

Proyek ini telah diuji dan berjalan dengan baik pada platform Android dan Web (dengan fungsionalitas UI penuh).

---

Dibuat dengan ❤️ menggunakan Flutter.
