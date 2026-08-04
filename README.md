# NixOS & Home Manager Configuration

Kho lưu trữ này chứa toàn bộ cấu hình khai báo (declarative) cho cả hệ điều hành NixOS và môi trường người dùng (Home Manager). 

Hệ thống được chia làm hai phần chính:
- **NixOS (`nixosConfigurations.arch`)**: Quản lý kernel, driver, bootloader và các dịch vụ cấp hệ thống.
- **Home Manager (`homeConfigurations."hinne@arch"`)**: Quản lý dotfiles, terminal (Zsh, Kitty, Starship), CLI tools và phần mềm người dùng.

---

## 1. Chuẩn bị trước khi cài đặt lại máy

**ĐIỀU KIỆN BẮT BUỘC:** Bạn phải sao lưu khóa giải mã (SOPS Age Key) ra một thiết bị lưu trữ ngoài (USB) hoặc trình quản lý mật khẩu.
- Đường dẫn file cần lưu: `~/.config/sops/age/keys.txt`

Nếu mất file này, bạn sẽ vĩnh viễn không thể giải mã được khóa SSH và các dữ liệu bí mật khác lưu trong repo này.

---

## 2. Hướng dẫn cài đặt cho máy NixOS mới

Sau khi hoàn tất cài đặt NixOS bằng đĩa USB (qua giao diện Calamares) và boot vào hệ điều hành mới, hãy thực hiện lần lượt các bước sau:

### Bước 2.1: Phục hồi SOPS Key
Tạo thư mục và chép file `keys.txt` từ USB lưu trữ của bạn vào đúng vị trí cũ:
```bash
mkdir -p ~/.config/sops/age
# Chép file keys.txt vào thư mục trên
# Phân quyền bảo mật chặt chẽ cho file key:
chmod 600 ~/.config/sops/age/keys.txt
```

### Bước 2.2: Tải mã nguồn cấu hình
Sử dụng môi trường tạm thời của Nix để gọi Git và tải repo về:
```bash
nix-shell -p git
git clone https://github.com/Hinn27/nixos-dotfiles.git ~/nix-config
cd ~/nix-config
```

### Bước 2.3: Kích hoạt phần hệ thống (OS)
*Lưu ý: Nếu bạn cài trên một phần cứng khác hoàn toàn, hãy tạo lại file hardware-configuration trước.*
```bash
# (Tuỳ chọn) Tạo file hardware-configuration.nix cho máy mới:
# sudo nixos-generate-config --show-hardware-config > nixos/hardware-configuration.nix

# Áp dụng cấu hình NixOS:
sudo nixos-rebuild switch --flake .#arch
```

### Bước 2.4: Kích hoạt phần người dùng (Home Manager)
Bước này sẽ thiết lập toàn bộ môi trường lập trình, giao diện terminal và tự động giải mã cấu hình SSH cho bạn.
```bash
nix run home-manager/master -- switch --flake .#hinne@arch
```
Sau khi lệnh chạy xong, hãy khởi động lại máy hoặc đăng nhập lại để các cấu hình có hiệu lực toàn diện.

---

## 3. Hướng dẫn quản lý Secrets

Mọi file bí mật (như SSH private key) được lưu trong thư mục `secrets/` đều đã được mã hóa bằng thuật toán Age thông qua công cụ `sops-nix`. 

Để chỉnh sửa hoặc thêm bí mật mới, bạn không được mở file yaml bằng text editor thông thường, mà phải dùng lệnh sau (yêu cầu máy đang có file keys.txt):
```bash
cd ~/nix-config
nix shell nixpkgs#sops -c sops secrets/secrets.yaml
```
Sops sẽ tự động giải mã file vào một vùng nhớ tạm, mở lên cho bạn chỉnh sửa, và tự động mã hóa lại khi bạn lưu file.
