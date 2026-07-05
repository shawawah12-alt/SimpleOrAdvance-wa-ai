#!/data/data/com.termux/files/usr/bin/bash
# ====================================================================
# Script Instalasi WhatsApp AI Bot - Termux (Android)
# --------------------------------------------------------------------
# Script ini akan:
#   1. Memastikan nodejs dan git terpasang di Termux
#   2. Mengecek versi Node.js (minimal v20)
#   3. Menginstall dependencies npm (Baileys, axios, pino, @hapi/boom)
#   4. Menyiapkan file config.json dan history.json kosong
#   5. Menampilkan instruksi langkah selanjutnya
# ====================================================================

set -e

# Warna output (Termux mendukung ANSI)
G='\033[1;32m'
Y='\033[1;33m'
R='\033[1;31m'
C='\033[1;36m'
N='\033[0m'

print_line() {
    echo -e "${C}============================================${N}"
}

echo ""
print_line
echo -e "${G}  Instalasi WhatsApp AI Bot - Termux${N}"
print_line
echo ""

# -------------------------------------------------------------
# Step 1: Update package list
# -------------------------------------------------------------
echo -e "${Y}[1/5]${N} Memperbarui daftar package Termux..."
pkg update -y >/dev/null 2>&1 || {
    echo -e "${R}[X] Gagal menjalankan pkg update. Coba manual: pkg update${N}"
    exit 1
}
echo -e "${G}[OK]${N} Daftar package diperbarui."

# -------------------------------------------------------------
# Step 2: Install nodejs dan git
# -------------------------------------------------------------
echo -e "${Y}[2/5]${N} Mengecek dan menginstall nodejs serta git..."

if ! command -v node >/dev/null 2>&1; then
    pkg install -y nodejs >/dev/null 2>&1 || {
        echo -e "${R}[X] Gagal install nodejs. Coba manual: pkg install nodejs${N}"
        exit 1
    }
    echo -e "${G}[OK]${N} Node.js berhasil diinstall."
else
    echo -e "${G}[OK]${N} Node.js sudah terpasang."
fi

if ! command -v git >/dev/null 2>&1; then
    pkg install -y git >/dev/null 2>&1 || {
        echo -e "${Y}[!]${N} Git gagal diinstall. Tidak wajib, tapi disarankan."
    }
fi

# -------------------------------------------------------------
# Step 3: Cek versi Node.js
# -------------------------------------------------------------
echo -e "${Y}[3/5]${N} Mengecek versi Node.js..."

NODE_VERSION=$(node -v 2>/dev/null | sed 's/v//' | cut -d. -f1)
if [ -z "$NODE_VERSION" ]; then
    echo -e "${R}[X] Node.js tidak terdeteksi. Instalasi dibatalkan.${N}"
    exit 1
fi

if [ "$NODE_VERSION" -lt 20 ]; then
    echo -e "${R}[X] Versi Node.js terlalu lama (v${NODE_VERSION}). Minimum v20.${N}"
    echo -e "${Y}[!]${N} Coba update dengan: pkg upgrade nodejs"
    echo -e "${Y}[!]${N} Jika masih gagal, install Node.js LTS terbaru dari sumber lain."
    exit 1
fi

echo -e "${G}[OK]${N} Versi Node.js terpenuhi: $(node -v)"

# -------------------------------------------------------------
# Step 4: Install npm dependencies
# -------------------------------------------------------------
cd "$(dirname "$0")"

echo -e "${Y}[4/5]${N} Menginstall dependencies npm..."
echo -e "${C}      (Proses ini bisa memakan 1-3 menit, mohon tunggu)${N}"

npm install >/dev/null 2>&1 || {
    echo -e "${R}[X] npm install gagal. Menampilkan error detail:${N}"
    npm install
    exit 1
}
echo -e "${G}[OK]${N} Dependencies berhasil diinstall."

# -------------------------------------------------------------
# Step 5: Siapkan file konfigurasi awal
# -------------------------------------------------------------
echo -e "${Y}[5/5]${N} Menyiapkan file konfigurasi awal..."

if [ ! -f "config.json" ]; then
    echo '{"baseUrl":"","apiKey":"","model":""}' > config.json
    echo -e "${G}[OK]${N} File config.json dibuat (kosong)."
else
    echo -e "${G}[OK]${N} File config.json sudah ada, dilewati."
fi

if [ ! -f "history.json" ]; then
    echo '{}' > history.json
    echo -e "${G}[OK]${N} File history.json dibuat (kosong)."
else
    echo -e "${G}[OK]${N} File history.json sudah ada, dilewati."
fi

# -------------------------------------------------------------
# Selesai
# -------------------------------------------------------------
echo ""
print_line
echo -e "${G}  INSTALASI SELESAI${N}"
print_line
echo ""
echo -e "Langkah selanjutnya:"
echo ""
echo -e "  ${C}1.${N} Jalankan bot:"
echo -e "     ${G}node index.js${N}"
echo ""
echo -e "  ${C}2.${N} Masukkan nomor WhatsApp (format: 628xxx)"
echo ""
echo -e "  ${C}3.${N} Catat kode pairing 8 digit yang muncul"
echo ""
echo -e "  ${C}4.${N} Buka WhatsApp > Settings > Linked Devices >"
echo -e "     Link a Device > Link with phone number instead"
echo ""
echo -e "  ${C}5.${N} Masukkan kode pairing di WhatsApp"
echo ""
echo -e "  ${C}6.${N} Setelah bot online, kirim pesan ke akun WA kamu sendiri:"
echo -e "     ${G}/ai set${N}"
echo -e "     ${G}endpoint: https://api.openai.com/v1${N}"
echo -e "     ${G}apikey: sk-proj-xxxxxxx${N}"
echo -e "     ${G}model: gpt-4o-mini${N}"
echo ""
echo -e "Baca README.md untuk panduan lengkap dan troubleshooting."
echo ""
