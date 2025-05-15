#!/data/data/com.termux/files/usr/bin/bash

# Colors & Styles
GREEN="\e[92m"
RED="\e[91m"
YELLOW="\e[93m"
BLUE="\e[94m"
CYAN="\e[96m"
MAGENTA="\e[95m"
BOLD="\e[1m"
UNDERLINE="\e[4m"
RESET="\e[0m"

# Directories & paths
BIN="$PREFIX/bin/nethunter"
NETHUNTERDIR="$PREFIX/var/lib/proot-distro/installed-rootfs/nethunter"
DEBIANDIR="$PREFIX/var/lib/proot-distro/installed-rootfs/debian"
DEBIANBAK="$PREFIX/var/lib/proot-distro/installed-rootfs/debian.bak"

# Banner with colors & style
banner() {
  clear
  echo -e "${MAGENTA}${BOLD}"
  echo "╔════════════════════════════════════════╗"
  echo "║      NETHUNTER INSTALLER by Sunil      ║"
  echo "╚════════════════════════════════════════╝"
  echo -e "${RESET}"
}

# Loading spinner animation (for long tasks)
spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# Check Internet Connection with spinner
check_internet() {
  echo -ne "${YELLOW}[*] Checking internet connection...${RESET} "
  ping -c 1 google.com &>/dev/null &
  spinner $!
  if [ $? -ne 0 ]; then
    echo -e "\r${RED}[✗] No internet connection. Please check your connection and try again.${RESET}"
    exit 1
  else
    echo -e "\r${GREEN}[✓] Internet connection detected.${RESET}"
  fi
}

# Check & install proot-distro if missing
check_proot() {
  echo -ne "${YELLOW}[*] Verifying proot-distro installation...${RESET} "
  if ! command -v proot-distro >/dev/null; then
    echo -e "\r${RED}[!] proot-distro not found, installing now...${RESET}"
    pkg install proot-distro -y || { echo -e "${RED}[✗] Failed to install proot-distro. Exiting.${RESET}"; exit 1; }
  else
    echo -e "\r${GREEN}[✓] proot-distro is already installed.${RESET}"
  fi
}

# Backup existing Debian and install fresh Debian as Nethunter
setup_kali() {
  if [[ -d $DEBIANDIR ]]; then
    echo -e "${YELLOW}[i] Backing up existing Debian installation...${RESET}"
    mv "$DEBIANDIR" "$DEBIANBAK"
  fi

  echo -e "${YELLOW}[*] Installing fresh Debian...${RESET}"
  proot-distro install debian || { echo -e "${RED}[✗] Failed to install Debian. Exiting.${RESET}"; exit 1; }

  echo -e "${YELLOW}[*] Renaming Debian distro to Nethunter...${RESET}"
  proot-distro rename debian nethunter || { echo -e "${RED}[✗] Rename failed. Exiting.${RESET}"; exit 1; }

  # Restore backup if existed
  if [[ -d $DEBIANBAK ]]; then
    echo -e "${YELLOW}[i] Restoring original Debian backup...${RESET}"
    mv "$DEBIANBAK" "$DEBIANDIR"
  fi
}

# Configure Nethunter environment in root's .bashrc
configure_kali() {
  echo -e "${YELLOW}[*] Configuring Nethunter environment...${RESET}"

  # Create .bashrc script inside the distro
  cat > "$NETHUNTERDIR/root/.bashrc" <<- EOF
#!/bin/bash
echo -e "${CYAN}Updating system and setting up Kali repositories...${RESET}"
apt update -y
apt install gnupg sudo curl neofetch -y

echo 'deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware' > /etc/apt/sources.list
curl -sSL https://archive.kali.org/archive-key.asc | apt-key add -

mv /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d

apt update -y && apt dist-upgrade -y

# Create user kali with sudo privileges
useradd -m -s /bin/bash kali
echo 'kali:kali' | chpasswd
echo 'kali ALL=(ALL:ALL) ALL' > /etc/sudoers.d/kali
chmod 440 /etc/sudoers.d/kali

# Download custom .bashrc for kali user
curl -LO https://raw.githubusercontent.com/Anon4You/kalilinux/main/assets/.bashrc
cp .bashrc /home/kali/
chown kali:kali /home/kali/.bashrc

echo -e "${GREEN}Setup complete! You can now login as 'kali' user.${RESET}"
sleep 2
exit
EOF

  # Login once to apply configuration (this step blocks so keep it last)
  proot-distro login nethunter
}

# Create launcher script for easy access
create_launcher() {
  echo -e "${YELLOW}[*] Creating launcher command '${BOLD}nethunter${RESET}${YELLOW}'...${RESET}"

  cat > "$BIN" <<- EOF
#!/data/data/com.termux/files/usr/bin/bash
if [[ \$1 == "-r" ]]; then
  echo -e "${MAGENTA}Launching Nethunter as root...${RESET}"
  proot-distro login nethunter --shared-tmp
else
  echo -e "${MAGENTA}Launching Nethunter as kali user...${RESET}"
  proot-distro login --user kali nethunter --shared-tmp
fi
EOF

  chmod +x "$BIN"
}

# Final success message
success_msg() {
  echo -e "\n${GREEN}${BOLD}[✓] Nethunter-CLI installed successfully!${RESET}\n"
  echo -e "${BLUE}[*] Type '${YELLOW}nethunter${BLUE}' to launch as kali user."
  echo -e "[*] Type '${YELLOW}nethunter -r${BLUE}' to launch as root."
  echo -e "${RED}${BOLD}[!] Default password for user 'kali' is: 'kali'${RESET}\n"
  echo -e "${CYAN}Follow me on GitHub: https://github.com/prince4You${RESET}\n"
}

# MAIN SCRIPT EXECUTION
banner
check_internet
check_proot
setup_kali
configure_kali
create_launcher
success_msg
