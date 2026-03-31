#!/bin/bash

# =========================================
# Arch Linux + KDE Plasma Health Check CLI
# =========================================

# Colors for output
RED="\033[1;31m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
RESET="\033[0m"

echo -e "${CYAN}=== Arch Linux System Health Check ===${RESET}"

# -----------------------------
# 1. Updates & Orphaned Packages
# -----------------------------
echo -e "\n${BLUE}--- Updates & Orphans ---${RESET}"
sudo pacman -Syu --noconfirm
orphans=$(pacman -Qdtq)
if [[ -n $orphans ]]; then
    echo -e "${YELLOW}Orphaned packages found:${RESET} $orphans"
else
    echo -e "${GREEN}No orphaned packages.${RESET}"
fi

# -----------------------------
# 2. Disk Usage
# -----------------------------
echo -e "\n${BLUE}--- Disk Usage ---${RESET}"
df -h | awk '{printf "%-25s %6s %6s %6s %4s %s\n", $1, $2, $3, $4, $5, $6}' | column -t

# -----------------------------
# 3. Failing Services
# -----------------------------
echo -e "\n${BLUE}--- Failing Services ---${RESET}"
failures=$(systemctl --failed --no-legend)
if [[ -n $failures ]]; then
    echo -e "${RED}$failures${RESET}"
else
    echo -e "${GREEN}No failing services.${RESET}"
fi

# -----------------------------
# 4. Recent Critical Errors
# -----------------------------
echo -e "\n${BLUE}--- Recent Critical Errors (journalctl) ---${RESET}"
journalctl -p 3 -xb --no-pager | tail -20 || echo -e "${GREEN}No recent critical errors.${RESET}"

# -----------------------------
# 5. GPU / OpenGL / Vulkan / OpenCL / ROCm
# -----------------------------
echo -e "\n${BLUE}--- GPU / OpenGL / Vulkan / OpenCL / ROCm ---${RESET}"

# OpenGL
if command -v glxinfo &>/dev/null; then
    echo -e "${CYAN}OpenGL:${RESET}"
    glxinfo | grep "OpenGL renderer"
else
    echo -e "${YELLOW}glxinfo not installed.${RESET}"
fi

# Vulkan
if command -v vulkaninfo &>/dev/null; then
    echo -e "${CYAN}Vulkan:${RESET}"
    vulkaninfo | grep "deviceName" | head -n 1
else
    echo -e "${YELLOW}vulkaninfo not installed.${RESET}"
fi

# OpenCL
if command -v clinfo &>/dev/null; then
    echo -e "${CYAN}OpenCL:${RESET}"
    clinfo | grep "Device Name" | head -n 1
else
    echo -e "${YELLOW}clinfo not installed.${RESET}"
fi

# ROCm
if [[ -d /opt/rocm ]]; then
    echo -e "${CYAN}ROCm:${RESET} Installed"
else
    echo -e "${CYAN}ROCm:${RESET} Missing"
fi

# Key packages
echo -e "\n${BLUE}--- Key Packages ---${RESET}"
pacman -Q mesa vulkan-radeon rocm-opencl-runtime rocm-hip-runtime ocl-icd ffmpeg libxcrypt-compat 2>/dev/null || echo -e "${YELLOW}Some packages missing.${RESET}"

# -----------------------------
# 6. KDE Plasma Info
# -----------------------------
echo -e "\n${BLUE}--- KDE Plasma Info ---${RESET}"
if command -v plasmashell &>/dev/null; then
    plasmashell --version
else
    echo -e "${YELLOW}Plasma not installed or plasmashell not found.${RESET}"
fi

# -----------------------------
# 7. Suggest Fixes for Common Issues
# -----------------------------
echo -e "\n${BLUE}--- Suggestions ---${RESET}"
if [[ -n $orphans ]]; then
    echo -e "${YELLOW}Consider removing orphaned packages with: sudo pacman -Rns $orphans${RESET}"
fi

journal_errors=$(journalctl -p 3 -xb --no-pager | tail -20)
if [[ $journal_errors == *cosmic-greeter* ]]; then
    echo -e "${YELLOW}Cosmic greeter errors detected. If unused, consider removing: sudo pacman -Rns cosmic-greeter greetd greetd-agreety${RESET}"
fi

echo -e "\n${GREEN}=== Health Check Complete ===${RESET}"
