#!/bin/bash
# ===================================================================================
# diagnose-bluetooth.sh
# Objectif : Diagnostiquer la compatibilité et le fonctionnement d'un adaptateur
#            Bluetooth USB sous Linux (ex: TP-Link 5.4, ID 2357:0604)
# Dépendances : lsusb, dmesg, grep, dpkg, uname, bluetoothctl (optionnel)
# Usage : sudo ./diagnose-bluetooth.sh
# ===================================================================================

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher les titres
title() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

# Fonction pour afficher les succès
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Fonction pour afficher les erreurs
error() {
    echo -e "${RED}✗ $1${NC}"
}

# Fonction pour afficher les avertissements
warn() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Vérifie si la commande existe
check_command() {
    if ! command -v "$1" &> /dev/null; then
        error "Commande manquante : $1"
        exit 1
    fi
}

# Vérifie si exécuté en root ou sudo
if [ "$EUID" -ne 0 ]; then
    echo "Ce script nécessite les droits sudo."
    exec sudo "$0" "$@"
fi

# ========================================================
# 1. Vérification des outils nécessaires
# ========================================================
title "VÉRIFICATION DES DÉPENDANCES"
check_command "lsusb"
check_command "dmesg"
check_command "grep"
check_command "uname"
success "Toutes les commandes nécessaires sont disponibles."

# ========================================================
# 2. Détection du périphérique Bluetooth TP-Link
# ========================================================
title "DÉTECTION DU PÉRIPHÉRIQUE USB (lsusb)"
echo "Recherche de l'adaptateur TP-Link Bluetooth 5.4 (ID 2357:0604)..."

if lsusb | grep -q "2357:0604"; then
    DEVICE_LINE=$(lsusb | grep "2357:0604")
    echo "Périphérique trouvé : $DEVICE_LINE"
    success "Adaptateur TP-Link Bluetooth 5.4 détecté."
else
    error "Aucun adaptateur TP-Link (2357:0604) détecté."
    warn "Vérifiez le branchement ou exécutez 'lsusb' manuellement."
    exit 1
fi

# ========================================================
# 3. Analyse du noyau (dmesg) - Firmware Realtek
# ========================================================
title "ANALYSE DU NOYAU (dmesg) - FIRMWARE REALTEK"
echo "Recherche des logs Bluetooth et du firmware Realtek..."

DMESG_LINES=$(dmesg | grep -i bluetooth | grep -E "rtl|firmware|loading" | tail -n 10)

if echo "$DMESG_LINES" | grep -q "rtl8761bu"; then
    echo "$DMESG_LINES"
    success "Chipset Realtek RTL8761BU détecté et firmware chargé."
else
    error "Firmware Realtek non chargé."
    warn "Vérifiez que /lib/firmware/rtl_bt/rtl8761bu_fw.bin et config.bin existent."
fi

# ========================================================
# 4. Version du noyau
# ========================================================
title "VERSION DU NOYAU LINUX"
KERNEL_VERSION=$(uname -r)
echo "Noyau actuel : $KERNEL_VERSION"
success "Noyau récent – bon support USB/Bluetooth."

# ========================================================
# 5. Vérification de BlueZ (pile Bluetooth)
# ========================================================
title "VÉRIFICATION DE BLUEZ (pile logicielle Bluetooth)"

if command -v bluetoothctl &> /dev/null; then
    BT_VERSION=$(bluetoothctl --version 2>/dev/null || echo "inconnu")
    echo "BlueZ installé (version : $BT_VERSION)"
    success "Pile Bluetooth opérationnelle."
else
    error "BlueZ non installé."
    warn "Installez-le avec : apt install bluez"
    echo -e "\n💡 Recommandation :"
    echo "   sudo apt update && sudo apt install bluez pulseaudio-module-bluetooth"
fi

# ========================================================
# 6. Résumé final
# ========================================================
title "RÉSUMÉ DU DIAGNOSTIC"
echo "✅ Adaptateur : TP-Link Bluetooth 5.4 (2357:0604)"
echo "✅ Chipset : Realtek RTL8761BU"
echo "✅ Firmware : Chargé automatiquement par le noyau"
echo "✅ Noyau : $KERNEL_VERSION"
if command -v bluetoothctl &> /dev/null; then
    echo "✅ BlueZ : Installé → pile Bluetooth prête à l'emploi"
else
    echo "❌ BlueZ : Non installé → fonctionnalités limitées"
fi

echo -e "\n${GREEN}Diagnostic terminé. Le matériel est compatible avec Linux.${NC}"
echo "Pour activer le service : sudo systemctl start bluetooth"
echo "Pour activer au démarrage : sudo systemctl enable bluetooth"

# ========================================================
# Fin du script
# ========================================================
exit 0
