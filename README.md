[![Node.js CI](https://github.com/shawawah12-alt/Wa-ai-bot/actions/workflows/node.js.yml/badge.svg)](https://github.com/shawawah12-alt/Wa-ai-bot/actions/workflows/node.js.yml)

# WA AI Bot

Bot WhatsApp berbasis AI yang memanfaatkan API berformat OpenAI-compatible untuk menjawab pertanyaan, menganalisis gambar, dan mengingat konteks percakapan. Dibangun di atas library [Baileys](https://github.com/WhiskeySockets/Baileys) dengan metode **pairing code**, sehingga pengguna tidak perlu memindai QR code dari layar terminal. Cukup masukkan nomor WhatsApp, dapatkan kode pairing, lalu masukkan kode tersebut di aplikasi WhatsApp.

Bot ini cocok dipakai sebagai asisten pribadi di WhatsApp, jawaban cepat untuk pertanyaan sehari-hari, atau sebagai wrapper multi-provider AI (OpenAI, Groq, OpenRouter, Gemini OpenAI-compatible, dan sejenisnya) selama endpoint mengikuti format `https://.../v1/chat/completions`.

Proyek ini sepenuhnya open source di bawah lisensi MIT. Kamu bebas memakai, memodifikasi, dan mendistribusikan ulang sesuai kebutuhan.

---

## Daftar Isi

- [Fitur Utama](#fitur-utama)
- [Prasyarat Sistem](#prasyarat-sistem)
- [Cara Instalasi](#cara-instalasi)
  - [Mode 1: Termux (Android)](#mode-1-termux-android)
  - [Mode 2: Linux (Debian/Ubuntu/Fedora/Arch)](#mode-2-linux-debianubuntufedoraarch)
- [Setup Bot di WhatsApp](#setup-bot-di-whatsapp)
- [Cara Penggunaan](#cara-penggunaan)
- [Struktur Proyek](#struktur-proyek)
- [Penjelasan Konfigurasi](#penjelasan-konfigurasi)
- [Troubleshooting](#troubleshooting)
- [Cara Kontribusi](#cara-kontribusi)
- [Lisensi](#lisensi)
- [Kredit](#kredit)

---

## Fitur Utama

Bot ini dirancang ringan namun cukup lengkap untuk kebutuhan asisten AI harian di WhatsApp. Berikut fitur-fitur yang tersedia secara default:

- **Pairing Code Authentication**: Tidak perlu QR code. Cukup masukkan nomor WhatsApp aktif, bot akan memberikan kode 8 digit yang dimasukkan lewat menu "Tautkan dengan nomor" di aplikasi WhatsApp.
- **Multi-Provider AI**: Mendukung semua provider yang kompatibel dengan format API OpenAI (OpenAI, Groq, OpenRouter, Together AI, Gemini OpenAI-compatible, lokal Ollama, dan lainnya). Tinggal masukkan endpoint, API key, dan nama model.
- **Mode Thinking**: Tersedia dua mode jawaban. Mode normal untuk jawaban singkat-padat-jelas, dan mode `(thinking)` untuk jawaban komprehensif, analitis, dan terstruktur. Mode ini berguna saat kamu butuh penjelasan mendalam untuk topik kompleks.
- **Dukungan Gambar (Vision)**: Kirim gambar dengan caption `/ai <pertanyaan tentang gambar>` dan bot akan menganalisis gambar tersebut. Cocok untuk membaca teks dari screenshot, menjelaskan isi foto, atau mengenali objek.
- **Riwayat Percakapan**: Bot mengingat hingga 10 pesan terakhir per chat (baik personal maupun grup) sehingga konteks tidak hilang saat melakukan follow-up question. Riwayat disimpan di file `history.json` agar tetap ada walau bot di-restart.
- **Typing Indicator**: Saat AI sedang memproses jawaban, bot akan menampilkan status "mengetik..." di WhatsApp pengirim, sehingga pengguna tahu bot sedang bekerja dan tidak mengira bot hang atau error.
- **Auto-Reconnect**: Jika koneksi ke server WhatsApp terputus (kecuali karena logout), bot akan otomatis mencoba reconnect dalam 3 detik tanpa perlu intervensi manual.
- **Konfigurasi via WhatsApp Itu Sendiri**: Tidak perlu edit file manual. Setup endpoint, API key, dan model cukup dilakukan lewat command `/ai set` langsung dari chat WhatsApp.

---

## Prasyarat Sistem

Sebelum menginstal bot, pastikan perangkat kamu memenuhi syarat berikut. Jika salah satu belum terpenuhi, script instalasi akan mencoba memenuhinya secara otomatis.

- **Node.js versi 20 atau lebih baru** (disarankan v20 LTS). Baileys versi terbaru menggunakan fitur ES2022+ yang tidak tersedia di Node.js versi lama.
- **npm** (biasanya ikut terpasang bersama Node.js).
- **Git** (opsional, hanya untuk clone repo).
- **Koneksi internet stabil** saat proses instalasi dan saat bot berjalan.
- **Akun WhatsApp aktif** di HP, karena bot akan ditautkan ke akun tersebut sebagai perangkat tambahan.
- **API key dari provider AI** yang dipilih (OpenAI, Groq, OpenRouter, atau lainnya). Tanpa ini bot bisa jalan tapi tidak akan bisa membalas pertanyaan AI.

> Catatan: Bot ini menggunakan akun WhatsApp kamu sendiri sebagai "perangkat tambahan". WhatsApp mengizinkan hingga 4 perangkat tambahan per akun. Jangan lupa untuk tetap menjaga akun WhatsApp agar tidak dipakai untuk spam, karena WhatsApp bisa membatasi akun yang melanggar Terms of Service.

---

## Cara Instalasi

Pilih mode instalasi sesuai perangkat kamu. Kedua script instalasi pada dasarnya melakukan hal yang sama: cek/install Node.js, install npm dependencies, dan menyiapkan file konfigurasi awal. Yang berbeda hanya cara install Node.js di tiap platform.

### Mode 1: Termux (Android)

Cocok untuk kamu yang ingin menjalankan bot langsung dari HP Android tanpa PC. Pastikan aplikasi Termux sudah terpasang (unduh dari F-Droid atau GitHub rilis Termux, jangan dari Play Store karena versinya sudah lama).

```bash
# 1. Update package Termux
pkg update -y && pkg upgrade -y

# 2. Install git dan nodejs
pkg install git nodejs -y

# 3. clone
git clone https://github.com/shawawah12-alt/wa-ai-bot.git
cd wa-ai-bot

# 4. Jalankan script instalasi
bash install-termux.sh

# 5. Jalankan bot
node index.js
```

Script `install-termux.sh` akan melakukan hal berikut secara otomatis:

1. Memastikan `nodejs` dan `git` sudah terpasang. Jika belum, akan diinstall via `pkg`.
2. Mengecek versi Node.js. Jika di bawah v18, instalasi dihentikan dengan pesan error yang jelas.
3. Menjalankan `npm install` untuk menginstall dependencies (Baileys, axios, pino, @hapi/boom).
4. Membuat file `config.json` dan `history.json` kosong jika belum ada.
5. Menampilkan instruksi langkah selanjutnya.

Alternatif tanpa clone (manual copy file): unduh repo sebagai ZIP, ekstrak di Termux, lalu jalankan `bash install-termux.sh` dari dalam folder hasil ekstrak.

### Mode 2: Linux (Debian/Ubuntu/Fedora/Arch)

Cocok untuk kamu yang menjalankan bot di VPS, PC Linux, WSL, atau Raspberry Pi. Script akan mendeteksi distro dan package manager yang dipakai secara otomatis.

```bash
# 1. Clone repo (ganti URL dengan URL repo GitHub kamu)
git clone https://github.com/shawawah12-alt/wa-ai-bot.git
cd wa-ai-bot

# 2. Beri permission execute dan jalankan script instalasi
chmod +x install-linux.sh
./install-linux.sh

# 3. Jalankan bot
node index.js
```

Script `install-linux.sh` akan melakukan hal berikut secara otomatis:

1. Mendeteksi package manager: `apt` (Debian/Ubuntu), `dnf` (Fedora), `pacman` (Arch), atau `yum` (CentOS/RHEL lama).
2. Mengecek apakah Node.js sudah terpasang. Jika belum, akan diinstall via NodeSource (untuk apt/yum) atau package manager bawaan distro (untuk dnf/pacman).
3. Memastikan versi Node.js minimal v18. Disarankan v20 LTS untuk kompatibilitas maksimal dengan Baileys.
4. Menjalankan `npm install` untuk menginstall semua dependencies.
5. Membuat file `config.json` dan `history.json` kosong jika belum ada.

> Untuk distro selain yang disebutkan di atas (Alpine, NixOS, dan lain-lain), kamu perlu install Node.js v18+ manual sesuai dokumentasi distro tersebut, lalu jalankan `npm install` di dalam folder proyek.

---

## Setup Bot di WhatsApp

Setelah instalasi selesai dan bot pertama kali dijalankan dengan `node index.js`, ikuti langkah berikut untuk menautkan bot ke akun WhatsApp kamu:

1. **Di terminal akan muncul prompt**: `Masukkan nomor (628xxx):`. Masukkan nomor WhatsApp kamu dalam format internasional tanpa tanda `+`. Contoh: `6281234567890` untuk nomor Indonesia.
2. **Tunggu 3 detik**, bot akan meminta kode pairing ke server WhatsApp.
3. **Kode pairing 8 digit akan muncul di terminal** dalam kotak pembatas. Catat kode tersebut.
4. **Buka aplikasi WhatsApp** di HP kamu.
5. Masuk ke menu: **Settings > Linked Devices > Link a Device**.
6. Pilih opsi **"Link with phone number instead"** (Tautkan dengan nomor).
7. **Masukkan kode pairing** 8 digit yang muncul di terminal.
8. Jika berhasil, terminal akan menampilkan pesan `PAIRING SUKSES. Bot siap jalan.` dan bot langsung aktif menerima pesan.

Selanjutnya, kamu perlu mengatur provider AI yang akan dipakai. Kirim pesan ke akun WhatsApp kamu sendiri (atau chat ke nomor bot dari nomor lain) dengan format berikut:

```
/ai set
endpoint: https://api.openai.com/v1
apikey: sk-proj-xxxxxxxxxxxxxxxxxxxx
model: gpt-4o-mini
```

Ganti nilai `endpoint`, `apikey`, dan `model` sesuai provider yang kamu pakai. Berikut beberapa contoh konfigurasi untuk provider populer:

**OpenAI:**
```
endpoint: https://api.openai.com/v1
apikey: sk-proj-xxxxxx
model: gpt-4o-mini
```

**Groq (gratis, cepat):**
```
endpoint: https://api.groq.com/openai/v1
apikey: gsk_xxxxxx
model: llama-3.3-70b-versatile
```

**OpenRouter (multi-provider):**
```
endpoint: https://openrouter.ai/api/v1
apikey: sk-or-v1-xxxxxx
model: anthropic/claude-5-sonnet
```

**Ollama lokal (tanpa API key):**
```
endpoint: http://localhost:11434/v1
apikey: ollama
model: llama3.2
```

Setelah setup berhasil, bot akan membalas dengan konfirmasi `Setup Berhasil Diperbarui!` dan siap menerima pertanyaan.

---

## Cara Penggunaan

Semua perintah diawali dengan `/ai`. Berikut daftar perintah yang tersedia:

| Perintah | Fungsi |
|---|---|
| `/ai` | Menampilkan bantuan dan status bot saat ini. |
| `/ai set\nendpoint: ...\napikey: ...\nmodel: ...` | Mengatur atau mengganti provider AI. |
| `/ai <pertanyaan>` | Bertanya ke AI dengan mode normal (jawaban singkat). |
| `/ai (thinking) <pertanyaan>` | Bertanya ke AI dengan mode analitis (jawaban mendalam). |
| `/ai clear` | Menghapus riwayat percakapan untuk chat saat ini. |

**Contoh pemakaian sehari-hari:**

- Tanya cepat: `/ai jam berapa sekarang di Tokyo?`
- Mode thinking: `/ai (thinking) jelaskan perbedaan TCP dan UDP beserta contoh penggunaannya`
- Kirim gambar: lampirkan gambar + caption `/ai apa yang ada di gambar ini?`
- Reset konteks: `/ai clear` lalu mulai topik baru

Bot akan menampilkan status "mengetik..." selama AI memproses jawaban. Tergantung provider dan panjang jawaban, waktu respons berkisar antara 2-15 detik. Jika lebih dari 3 menit tidak ada balasan, kemungkinan terjadi error API dan akan ditampilkan sebagai pesan error di chat.

---

## Struktur Proyek

```
wa-ai-bot/
├── index.js              # Source code utama bot
├── package.json          # Daftar dependencies dan metadata proyek
├── install-termux.sh     # Script instalasi untuk Termux (Android)
├── install-linux.sh      # Script instalasi untuk Linux
├── config.example.json   # Contoh format file konfigurasi
├── .gitignore            # Daftar file yang diabaikan oleh git
├── LICENSE               # Lisensi proyek (MIT)
└── README.md             # Dokumentasi ini

File yang dibuat otomatis saat dijalankan:
├── auth/                 # Folder state autentikasi WhatsApp (jangan di-commit)
├── config.json           # Konfigurasi provider AI (jangan di-commit)
└── history.json          # Riwayat percakapan per chat (jangan di-commit)
```

---

## Penjelasan Konfigurasi

File `config.json` otomatis dibuat saat pertama kali setup lewat command `/ai set`. Strukturnya sebagai berikut:

```json
{
  "baseUrl": "https://api.openai.com/v1",
  "apiKey": "sk-proj-xxxxxxxxxxxx",
  "model": "gpt-4o-mini"
}
```

- **baseUrl**: Base URL endpoint provider AI. Harus mengarah ke root endpoint (misal `https://api.openai.com/v1`), tanpa trailing slash. Bot akan otomatis menambahkan path `/chat/completions`.
- **apiKey**: API key dari provider. Untuk provider lokal seperti Ollama, isi dengan string apa pun (misal `ollama`).
- **model**: Nama model yang tersedia di provider. Cek dokumentasi provider untuk daftar model yang didukung.

File ini sebaiknya **tidak pernah di-commit ke GitHub** karena berisi API key rahasia. Sudah ditambahkan ke `.gitignore` secara default.

---

## Troubleshooting

**Bot tidak merespon setelah pairing berhasil**
Pastikan kamu sudah menjalankan command `/ai set` dengan format yang benar. Bot hanya akan merespon pesan yang diawali dengan `/ai`. Jika belum setup, ketik `/ai` untuk melihat panduan.

**Error: `X Error API: ...`**
Artinya ada masalah dengan provider AI kamu. Periksa kembali: (1) API key valid dan belum expired, (2) endpoint benar, (3) model yang dipilih tersedia di provider, (4) saldo/kuota API masih cukup.

**Error: `Connection closed. Reason: 515` atau kode lain**
Koneksi ke server WhatsApp terputus sementara. Bot akan otomatis reconnect dalam 3 detik. Jika tetap tidak reconnect, matikan bot (Ctrl+C), tunggu 1 menit, lalu jalankan ulang `node index.js`.

**Bot logout sendiri / tidak bisa reconnect**
Jika terminal menampilkan pesan `Logout. Hapus folder auth`, hapus folder `auth` lalu jalankan ulang bot untuk melakukan pairing ulang:

```bash
rm -rf auth
node index.js
```

**Gagal download gambar / vision tidak jalan**
Pastikan kamu mengirim gambar sebagai **lampiran dengan caption**, bukan sebagai pesan berbeda. Caption harus diawali `/ai`. Jika masih gagal, kemungkinan provider AI yang dipilih tidak mendukung fitur vision (contoh: beberapa model di Groq belum mendukung gambar).

**`npm install` gagal di Termux**
Coba jalankan `pkg upgrade nodejs` lalu `npm install` ulang. Jika masih gagal, hapus folder `node_modules` dan `package-lock.json`, lalu install ulang dari awal:

```bash
rm -rf node_modules package-lock.json
npm install
```

**Migrasi ke nomor WhatsApp lain**
Hentikan bot, hapus folder `auth`, lalu jalankan ulang. Bot akan meminta nomor baru:

```bash
rm -rf auth
node index.js
```

---

## Cara Kontribusi

Kontribusi sangat diterima. Beberapa hal yang bisa kamu bantu:

- Melaporkan bug lewat tab Issues dengan deskripsi langkah reproduksi yang jelas.
- Mengajukan fitur baru (misal dukungan voice note, dukungan PDF, multi-model routing, dll).
- Membantu memperbaiki dokumentasi atau menerjemahkan ke bahasa lain.
- Membuat pull request untuk perbaikan kode.

Untuk pull request, pastikan kode mengikuti style yang sudah ada (2 space indent, single quote string, no semicolon di akhir baris yang tidak perlu), dan jelaskan secara ringkas apa yang diubah beserta alasannya.

---

## Lisensi

Proyek ini dilisensikan di bawah **MIT License**. Kamu bebas menggunakan, memodifikasi, mendistribusikan, dan mengkomersialkan proyek ini selama menyertakan atribusi lisensi asli. Lihat file [LICENSE](LICENSE) untuk teks lengkapnya.

---

## Kredit

Proyek ini dibangun di atas kerja keras beberapa pihak berikut:

- **Zhaw (Shadiq)** sebagai pembuat script awal bot. Instagram: `mas_ukkantext`, TikTok: `@ravmoise/test`.
- **[Baileys by WhiskeySockets](https://github.com/WhiskeySockets/Baileys)** untuk library komunikasi WhatsApp WebSocket.
- **[Axios](https://axios-http.com/)** untuk HTTP client.
- **[Pino](https://github.com/pinojs/pino)** untuk logging.
- Seluruh provider AI (OpenAI, Groq, OpenRouter, dan lainnya) yang menyediakan API kompatibel dengan format OpenAI.

Jika kamu memodifikasi dan merilis ulang proyek ini, mohon tetap mencantumkan kredit ke pembuat asli.
