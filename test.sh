#!/usr/bin/env bash

# Path Setup
BIN="$PREFIX/bin/nethunter"
NETHUNTERDIR="$PREFIX/var/lib/proot-distro/installed-rootfs/nethunter"
DEBIANDIR="$PREFIX/var/lib/proot-distro/installed-rootfs/debian"
DEBIANBAK="$PREFIX/var/lib/proot-distro/installed-rootfs/debian.bak"

echo "[*] Setting up NetHunter in Termux..."

# Backup existing Debian and install fresh one as nethunter
if [[ -d $DEBIANDIR ]]; then
    echo "[*] Backing up existing Debian..."
    mv $DEBIANDIR $DEBIANBAK
fi

echo "[*] Installing fresh Debian base..."
proot-distro install debian
echo "[*] Renaming Debian to NetHunter..."
proot-distro rename debian nethunter

if [[ -d $DEBIANBAK ]]; then
    echo "[*] Restoring original Debian..."
    mv $DEBIANBAK $DEBIANDIR
fi

# Configure NetHunter's environment
echo "[*] Setting up NetHunter environment..."

cat > "$NETHUNTERDIR/root/.bashrc" <<- 'EOF'
#!/bin/bash
apt-get update -y
apt-get install -y gnupg sudo curl

# Add Kali repo
echo 'deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware' > /etc/apt/sources.list

# Import Kali archive key
curl -fsSL https://archive.kali.org/archive-key.asc | apt-key add -
mkdir -p /etc/apt/trusted.gpg.d
if [ -f /etc/apt/trusted.gpg ]; then
    cp /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/
fi

# Upgrade system
apt-get update -y && apt-get dist-upgrade -y

# Add kali user
useradd -m -s /bin/bash kali
echo 'kali:kali' | chpasswd
echo 'kali  ALL=(ALL:ALL) ALL' >> /etc/sudoers.d/kali
chmod 0440 /etc/sudoers.d/kali

# Setup user bashrc
curl -sSL https://raw.githubusercontent.com/prince4you/Kali-Linux/main/.bashrc -o /home/kali/.bashrc
chown kali:kali /home/kali/.bashrc

sleep 1
exit
EOF

# Run the bashrc setup
proot-distro login nethunter --shared-tmp

# Create CLI launcher
echo "[*] Creating 'nethunter' CLI launcher..."
cat > "$BIN" <<- EOF
#!/usr/bin/env bash
if [[ \$1 == "-r" ]]; then
    proot-distro login nethunter --shared-tmp
else
    proot-distro login --user kali nethunter --shared-tmp
fi
EOF

chmod +x "$BIN"

echo
echo "[*] NetHunter-CLI installed successfully!"
echo "[*] Type 'nethunter' to launch as user 'kali'"
echo "[*] Type 'nethunter -r' to launch as root"
echo "[*] Default password for sudo is: kali"
