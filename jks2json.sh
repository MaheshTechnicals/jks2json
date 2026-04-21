#!/bin/bash

# ==========================================
# Terminal Color Codes (Truecolor/ANSI)
# ==========================================
NC='\033[0m' # No Color
BOLD='\033[1m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'

# Gradient Colors for Header
G1='\033[38;2;255;0;128m'   # Pink/Magenta
G2='\033[38;2;200;50;255m'  # Purple
G3='\033[38;2;100;100;255m' # Blue
G4='\033[38;2;0;200;255m'   # Cyan
G5='\033[38;2;0;255;150m'   # Mint

# ==========================================
# Professional Header
# ==========================================
clear
echo -e "${G1}${BOLD}========================================================${NC}"
echo -e "${G2}${BOLD}                     ? jks2json ?                    ${NC}"
echo -e "${G3}${BOLD}                 By: Mahesh Technicals                 ${NC}"
echo -e "${G4}${BOLD}========================================================${NC}"
echo ""

# ==========================================
# File Discovery & Selection
# ==========================================
shopt -s nullglob
JKS_FILES=(*.jks)
shopt -u nullglob

if [ ${#JKS_FILES[@]} -eq 0 ]; then
    echo -e "${RED}? No .jks files found in the current directory.${NC}"
    echo -e "Please move your keystore files here and try again."
    exit 1
fi

echo -e "${G5}${BOLD}? Available Keystores:${NC}"
echo ""

for i in "${!JKS_FILES[@]}"; do
    echo -e "   ${CYAN}$((i+1)).${NC} ${YELLOW}${JKS_FILES[$i]}${NC}"
done

echo ""
read -p "$(echo -e ${G4}? Select a keystore number [1-${#JKS_FILES[@]}]: ${NC})" CHOICE

if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt "${#JKS_FILES[@]}" ]; then
    echo -e "${RED}? Invalid selection. Exiting.${NC}"
    exit 1
fi

SELECTED_JKS="${JKS_FILES[$((CHOICE-1))]}"

echo ""
echo -e "${GREEN}? Selected: ${BOLD}$SELECTED_JKS${NC}"
echo -e "${G1}${BOLD}--------------------------------------------------------${NC}"

# ==========================================
# Password Prompt & Verification
# ==========================================
read -s -p "$(echo -e ${YELLOW}? Enter Keystore Password: ${NC})" KEY_PASSWORD
echo ""

echo -e "${CYAN}? Verifying password & extracting data...${NC}"

if ! keytool -list -keystore "$SELECTED_JKS" -storepass "$KEY_PASSWORD" > /dev/null 2>&1; then
    echo -e "${RED}? Error: Incorrect password or corrupted keystore.${NC}"
    exit 1
fi

# ==========================================
# Data Extraction
# ==========================================
ALIAS=$(keytool -list -v -keystore "$SELECTED_JKS" -storepass "$KEY_PASSWORD" | grep "Alias name:" | awk '{print $3}' | tr -d '\r')
SHA1=$(keytool -list -v -keystore "$SELECTED_JKS" -storepass "$KEY_PASSWORD" | grep "SHA1:" | awk '{print $2}' | tr -d '\r')
SHA256=$(keytool -list -v -keystore "$SELECTED_JKS" -storepass "$KEY_PASSWORD" | grep "SHA256:" | awk '{print $2}' | tr -d '\r')
BASE64_STRING=$(base64 -w 0 "$SELECTED_JKS")

# ==========================================
# Folder Setup & JSON Generation
# ==========================================
mkdir -p json

BASENAME="${SELECTED_JKS%.*}"
OUTPUT_FILE="json/${BASENAME}.json"

cat <<EOF > "$OUTPUT_FILE"
{
  "keystore_file": "$SELECTED_JKS",
  "ALIAS": "$ALIAS",
  "KEYSTORE_PASSWORD": "$KEY_PASSWORD",
  "KEY_PASSWORD": "$KEY_PASSWORD",
  "FINGERPRINTS": {
    "SHA1": "$SHA1",
    "SHA256": "$SHA256"
  },
  "SIGNING_KEY_BASE64": "$BASE64_STRING"
}
EOF

# ==========================================
# Success Screen
# ==========================================
echo ""
echo -e "${G5}${BOLD}? SUCCESS! Data extracted securely.${NC}"
echo -e "${YELLOW}? Saved to: ${BOLD}${GREEN}$OUTPUT_FILE${NC}"
echo -e "${G1}${BOLD}========================================================${NC}"
echo ""