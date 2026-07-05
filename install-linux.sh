#!/usr/bin/env bash
# ====================================================================
# Script Instalasi WhatsApp AI Bot - Linux
# --------------------------------------------------------------------
# Mendukung: Debian, Ubuntu, Fedora, Arch, CentOS, RHEL
# Script ini akan:
#   1. Mendeteksi package manager (apt/dnf/pacman/yum)
#   2. Mengecek/install Node.js v20+ (v20 LTS atau v22 LTS)
#   3. Menginstall dependencies npm
#   4. Menyiapkan file config.json dan history.json kosong
#   5. Menampilkan instruksi langkah selanjutnya
# ====================================================================

set -e

# Warna output
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
echo -e "${G}  Instalasi WhatsApp AI Bot - Linux${N}"
print_line
echo ""

# Cek apakah dijalankan dengan sudo atau tidak
if [ "$(id -u)" = "0" ]; then
    echo -e "${Y}[!]${N} Script ini tidak perlu dijalankan sebagai root."
    echo -e "${Y}[!]${N} Hanya package manager yang butuh sudo (akan diminta otomatis)."
    echo ""
fi

# -------------------------------------------------------------
# Fungsi: deteksi package manager
# -------------------------------------------------------------
detect_pm() {
    if command -v apt-get >/dev/null 2>&1; then echo "apt"
    elif command -v dnf >/dev/null 2>&1; then echo "dnf"
    elif command -v pacman >/dev/null 2>&1; then echo "pacman"
    elif command -v yum >/dev/null 2>&1; then echo "yum"
    elif command -v zypper >/dev/null 2>&1; then echo "zypper"
    else echo "unknown"
    fi
}

PM=$(detect_pm)
echo -e "${Y}[Info]${N} Package manager terdeteksi: ${C}${PM}${N}"

if [ "$PM" = "unknown" ]; then
    echo -e "${R}[X]${N} Package manager tidak dikenali."
    echo -e "${Y}[!]${N} Install Node.js v20+ manual sesuai dokumentasi distro kamu,"
    echo -e "${Y}[!]${N} lalu jalankan: ${G}npm install${N}"
    exit 1
fi

# -------------------------------------------------------------
# Fungsi: install paket via package manager yang sesuai
# Parameter: nama_paket1 nama_paket2 ...
# -------------------------------------------------------------
install_pkg() {
    case "$PM" in
        apt)
            sudo apt-get install -y "$@" >/dev/null 2>&1
            ;;
        dnf)
            sudo dnf install -y "$@" >/dev/null 2>&1
            ;;
        pacman)
            sudo pacman -S --noconfirm --needed "$@" >/dev/null 2>&1
            ;;
        yum)
            sudo yum install -y "$@" >/dev/null 2>&1
            ;;
        zypper)
            sudo zypper install -y "$@" >/dev/null 2>&1
            ;;
    esac
}

# -------------------------------------------------------------
# Step 1: Cek dan install Node.js
# -------------------------------------------------------------
echo -e "${Y}[1/5]${N} Mengecek Node.js..."

NEED_INSTALL_NODE=false
if ! command -v node >/dev/null 2>&1; then
    NEED_INSTALL_NODE=true
else
    NODE_VERSION=$(node -v 2>/dev/null | sed 's/v//' | cut -d. -f1)
    if [ "$NODE_VERSION" -lt 20 ]; then
        echo -e "${Y}[!]${N} Versi Node.js terlalu lama (v${NODE_VERSION}). Akan di-upgrade ke v20."
        NEED_INSTALL_NODE=true
    fi
fi

if [ "$NEED_INSTALL_NODE" = "true" ]; then
    echo -e "${Y}[..]${N} Menginstall Node.js v20 LTS via NodeSource..."

    if [ "$PM" = "apt" ] || [ "$PM" = "yum" ]; then
        # Install curl dulu kalau belum ada
        if ! command -v curl >/dev/null 2>&1; then
            install_pkg curl
        fi
        # Setup NodeSource repository untuk v20
        if [ "$PM" = "apt" ]; then
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null 2>&1
            sudo apt-get install -y nodejs >/dev/null 2>&1 || {
                echo -e "${R}[X]${N} Gagal install Node.js dari NodeSource."
                echo -e "${Y}[!]${N} Coba manual: sudo apt install nodejs"
                exit 1
            }
        else
            # yum
            curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash - >/dev/null 2>&1
            sudo yum install -y nodejs >/dev/null 2>&1 || {
                echo -e "${R}[X]${N} Gagal install Node.js dari NodeSource."
                exit 1
            }
        fi
    elif [ "$PM" = "dnf" ]; then
        # Fedora biasanya sudah punya Node.js v20+ di repo default
        install_pkg nodejs npm
    elif [ "$PM" = "pacman" ]; then
        # Arch selalu punya Node.js versi terbaru
        install_pkg nodejs npm
    elif [ "$PM" = "zypper" ]; then
        install_pkg nodejs npm
    fi

    echo -e "${G}[OK]${N} Node.js berhasil diinstall: $(node -v)"
else
    echo -e "${G}[OK]${N} Node.js sudah terpasang: $(node -v)"
fi

# -------------------------------------------------------------
# Step 2: Cek git (opsional)
# -------------------------------------------------------------
echo -e "${Y}[2/5]${N} Mengecek git..."
if ! command -v git >/dev/null 2>&1; then
    install_pkg git && echo -e "${G}[OK]${N} Git diinstall." || echo -e "${Y}[!]${N} Git gagal diinstall (opsional)."
else
    echo -e "${G}[OK]${N} Git sudah terpasang."
fi

# -------------------------------------------------------------
# Step 3: Cek ulang versi Node.js (memastikan)
# -------------------------------------------------------------
echo -e "${Y}[3/5]${N} Verifikasi versi Node.js..."

NODE_VERSION=$(node -v 2>/dev/null | sed 's/v//' | cut -d. -f1)
if [ -z "$NODE_VERSION" ]; then
    echo -e "${R}[X]${N} Node.js masih belum terdeteksi setelah instalasi."
    exit 1
fi

if [ "$NODE_VERSION" -lt 20 ]; then
    echo -e "${R}[X]${N} Versi Node.js masih di bawah v20 (v${NODE_VERSION})."
    echo -e "${Y}[!]${N} Update manual via NodeSource: https://github.com/nodesource/distributions"
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
    echo -e "${R}[X]${N} npm install gagal. Menampilkan error detail:${N}"
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

# Set permission script
chmod +x install-linux.sh 2>/dev/null || true

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
echo -e "${Y}[Tip]${N} Untuk menjalankan bot di background (VPS), gunakan:"
echo -e "     ${G}nohup node index.js > bot.log 2>&1 &${N}"
echo -e "     atau pakai process manager seperti ${C}pm2${N}:"
echo -e "     ${G}sudo npm install -g pm2 && pm2 start index.js --name wa-ai-bot${N}"
echo ""
