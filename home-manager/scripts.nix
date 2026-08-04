# Custom Shell Scripts
# This module defines global shell scripts directly in Nix, replacing things in ~/.local/bin
{ config, pkgs, ... }:

let
  secureUpdate = pkgs.writeShellScriptBin "secure-update" ''
    #!/bin/bash
    # Script cập nhật hệ thống an toàn - Heuristic Security Scanner
    # Natively managed by Nix Home Manager
    
    echo "--- [1/3] Đang quét Heuristic An ninh trên AUR Cache ---"
    
    # 1. Quét các IOC đã biết
    IOC_KNOWN=$(grep -rE "atomic-lockfile|js-digest|arch-audit-fix" ~/.cache/yay ~/.cache/paru 2>/dev/null)
    
    # 2. Quét hành vi: Downloader
    IOC_DOWNLOADER=$(grep -rE "(curl|wget).*\|.*(bash|sh|python|node|perl)" ~/.cache/yay ~/.cache/paru 2>/dev/null)
    
    # 3. Quét hành vi: Obfuscation
    IOC_OBFUSCATION=$(grep -rE "[a-zA-Z0-9+/]{100,}" ~/.cache/yay ~/.cache/paru 2>/dev/null | grep "PKGBUILD" | grep -vE "(sums|sha[0-9]*|b2|md5)" | grep -vE "['\"][a-f0-9]{64,}['\"]")
    
    # 4. Quét hành vi: Persistence
    IOC_PERSISTENCE=$(grep -rE "cp.*(/etc/systemd|/var/spool/cron|/etc/init.d)" ~/.cache/yay ~/.cache/paru 2>/dev/null)
    
    if [ -n "$IOC_KNOWN" ] || [ -n "$IOC_DOWNLOADER" ] || [ -n "$IOC_OBFUSCATION" ] || [ -n "$IOC_PERSISTENCE" ]; then
        echo "⚠️ CẢNH BÁO: Phát hiện dấu hiệu bất thường trong AUR Cache!"
        [ -n "$IOC_KNOWN" ] && echo "- Tìm thấy mã độc đã biết."
        [ -n "$IOC_DOWNLOADER" ] && echo "- Tìm thấy script tải file thực thi trực tiếp."
        [ -n "$IOC_OBFUSCATION" ] && echo "- Tìm thấy mã nguồn bị mã hóa (Obfuscation)."
        [ -n "$IOC_PERSISTENCE" ] && echo "- Tìm thấy nỗ lực cài đặt file hệ thống."
        exit 1
    fi
    
    echo "--- [2/3] Bắt đầu cập nhật hệ thống ---"
    yay -Syu
    
    echo "--- [3/3] Đang thực hiện dọn dẹp & fix lỗi ---"
    [ -x /usr/bin/flatpak ] && flatpak update -y
    [ -f "/home/hinne/fix-damx.sh" ] && /home/hinne/fix-damx.sh
    
    echo "Đang làm sạch cache để bảo mật..."
    rm -rf ~/.cache/paru/clone/*
    rm -rf ~/.cache/yay/*
    
    echo "✅ Hệ thống đã được cập nhật an toàn."
  '';
in
{
  home.packages = [
    secureUpdate
  ];
}
