# NixOS & Home Manager Configuration

Hệ thống được chia làm hai phần chính:

- **NixOS (`nixosConfigurations.nixos`)**: Quản lý kernel, driver, bootloader và các dịch vụ cấp hệ thống.
- **Home Manager (`homeConfigurations."hinne@nixos"`)**: Quản lý dotfiles, terminal (Zsh, Kitty, Starship), CLI tools và phần mềm người dùng.

## 📂 Cấu trúc thư mục

```text
~/nix-config/
    ├── ❄️ flake.nix               # khai báo toàn bộ hệ thống (Khai báo input/output)
    ├── 🔒 flake.lock              # phiên bản của các thư viện
    ├── ⚙️ .sops.yaml              # mã hoá bí mật với sops-nix
    │
    ├── 💻 nixos/                  # QUẢN LÝ HỆ THỐNG CẤP ROOT
    │   ├── configuration.nix      # Cài đặt bootloader, kernel, driver, user, font và các service hệ thống (âm thanh, mạng...)
    │   └── hardware-configuration.nix # File tự gen bởi NixOS chứa thông tin về ổ cứng, CPU, phân vùng
    │
    ├── 👤 home-manager/           # QUẢN LÝ PHẦN MỀM & SETTING CỦA USER
    │   ├── home.nix               # danh sách phần mềm cài cho user và thiết lập các biến môi trường
    │   ├── tools.nix              # khai báo các công cụ bổ trợ
    │   ├── scripts.nix            # custom script bash cá nhân
    │   │
    │   ├── ⌨️ fcitx5.nix          # Cấu hình Lotus
    │   ├── 🐙 git.nix             # Cấu hình tài khoản và alias của Git
    │   ├── 🐚 zsh.nix             # Cấu hình Shell (Zsh)
    │   ├── 🚀 starship.nix        # Cấu hình giao diện Prompt
    │   ├── 🖥️ kitty.nix           # Cấu hình Terminal Kitty
    │   │
    │   ├── 🪟 niri/               # cấu hình của Window Manager Niri (bind, layout, rules)
    │   ├── 🌙 noctalia/           # cấu hình thanh Bar/Shell Noctalia
    │   ├── 📝 nvim/               # cấu hình trình Neovim
    │   └── 🎬 mpv/                # cấu hình MPV
    │
    └── 🗝️ secrets/                # CHỨA CÁC THÔNG TIN BẢO MẬT ĐƯỢC MÃ HOÁ
        └── secrets.yaml           # Mã hoá các thứ như mật khẩu, SSH key...
```

---

## 1. Hướng dẫn cài đặt cho máy NixOS mới

### Bước 1.1: Phục hồi SOPS Key

Tạo thư mục và chép file `keys.txt` từ USB lưu trữ của bạn vào đúng vị trí cũ:

```bash
mkdir -p ~/.config/sops/age
# Chép file keys.txt vào thư mục trên
# Phân quyền bảo mật chặt chẽ cho file key:
chmod 600 ~/.config/sops/age/keys.txt
```

### Bước 1.2: Tải mã nguồn cấu hình

Sử dụng môi trường tạm thời của Nix để gọi Git và tải repo về:

```bash
nix-shell -p git
git clone https://github.com/Hinn27/nixos-dotfiles.git ~/nix-config
cd ~/nix-config
```

### Bước 1.3: Kích hoạt phần hệ thống (OS)

_Lưu ý: Nếu bạn cài trên một phần cứng khác hoàn toàn, hãy tạo lại file hardware-configuration trước._

```bash
# (Tuỳ chọn) Tạo file hardware-configuration.nix cho máy mới:
# sudo nixos-generate-config --show-hardware-config > nixos/hardware-configuration.nix

# Áp dụng cấu hình NixOS:
sudo nixos-rebuild switch --flake .#nixos
```

### Bước 1.4: Kích hoạt phần người dùng (Home Manager)

Bước này sẽ thiết lập toàn bộ môi trường lập trình, giao diện terminal và tự động giải mã cấu hình SSH.

```bash
nix run home-manager/master -- switch --flake .#hinne@nixos
```

Sau khi lệnh chạy xong, hãy khởi động lại máy hoặc đăng nhập lại để các cấu hình có hiệu lực toàn diện.

---

## 2. Hướng dẫn quản lý Secrets

Mọi file bí mật (như SSH private key) được lưu trong thư mục `secrets/` đều đã được mã hóa bằng thuật toán Age thông qua công cụ `sops-nix`.

Để chỉnh sửa hoặc thêm bí mật mới, không được mở file yaml bằng text editor thông thường, mà phải dùng lệnh sau (yêu cầu máy đang có file keys.txt):

```bash
cd ~/nix-config
nix shell nixpkgs#sops -c sops secrets/secrets.yaml
```

Sops sẽ tự động giải mã file vào một vùng nhớ tạm, mở lên cho bạn chỉnh sửa, và tự động mã hóa lại khi bạn lưu file.
