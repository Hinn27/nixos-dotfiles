### [2026-08-06 15:28] - FIX POLKIT AND ZSH SHELL
- **File changed**: nixos/configuration.nix
- **Mô tả**: Đã thêm group `networkmanager`, package `polkit_gnome`, cấu hình `systemd.user.services.polkit-gnome-authentication-agent-1`
- **Lý do**: Khắc phục lỗi thiếu GUI mật khẩu Wifi của Polkit, đưa shell từ bash trở về đúng với cấu hình Zsh được cấp phép sẵn trong file flake chính gốc thay vì nhầm /etc/nixos cũ.

### [2026-08-07 15:26] - CẤU HÌNH TERMINAL MẶC ĐỊNH
- **File changed**: `home-manager/home.nix`, `home-manager/kitty.nix`
- **Mô tả**: Thêm biến môi trường `TERMINAL = "kitty"` và bật `xdg.terminal-exec` trỏ về `kitty.desktop`.
- **Lý do**: Để các phần mềm GUI (như Noctalia) biết phải dùng terminal nào khi mở các ứng dụng CLI có `Terminal=true` (như Yazi, Nvim). Mặc định nếu không có, tính năng File Search của Noctalia sẽ báo lỗi hoặc không phản hồi.

### [2026-08-07 15:54] - THIẾT LẬP SPOTIFY ĐỘT BIẾN (SPICETIFY NATIVE)
- **File changed**: Không sửa file cấu hình NixOS.
- **Mô tả**: Copy Spotify từ Nix Store ra `~/.local/share/spotify-mutable` và tạo file desktop ghi đè. Cài Spicetify theme Comfy và Spicetify Marketplace thủ công.
- **Lý do**: Để vượt qua giới hạn Read-only của thư mục `/nix/store`, cho phép sếp sử dụng tính năng tải extension trực tiếp từ Marketplace bên trong Spotify và cho phép Noctalia đổi màu (Live Reload) tự động mà không cần build lại hệ thống.

### [2026-08-07 16:01] - MỞ KHÓA THƯ MỤC NOCTALIA
- **File changed**: `home-manager/noctalia.nix`
- **Mô tả**: Sửa cấu hình symlink thư mục Noctalia thành `recursive = true;`
- **Lý do**: Cho phép giao diện Settings của Noctalia có thể lưu được các thay đổi (chẳng hạn như bật nút Spicetify) thay vì bị lỗi do thư mục bị khóa Read-only bởi Home Manager.

### [2026-08-07 16:12] - GHI ĐÈ LAUNCHER ĐỂ FIX LỖI ỨNG DỤNG
- **File changed**: Không sửa file cấu hình NixOS.
- **Mô tả**: Tạo script `~/.local/bin/spotify` để ưu tiên khởi chạy bản Spotify đột biến. Ghi đè `yazi.desktop` và `nvim.desktop` trong `~/.local/share/applications` để thiết lập cứng lệnh chạy qua `kitty -e`.
### [2026-08-07 16:16] - FIX XDG_DATA_DIRS KHÔNG NHẬN LAUNCHER TỰ TẠO
- **File changed**: `home-manager/home.nix`
- **Mô tả**: Dùng module `xdg.desktopEntries` của Home Manager để khai báo đè các shortcut của Spotify, Yazi, Nvim thay vì ghi file tay vào `~/.local/share/applications`.
- **Lý do**: Môi trường NixOS của sếp không trỏ `XDG_DATA_DIRS` về thư mục `~/.local/share`, dẫn tới mọi file desktop tui tự tạo vừa nãy đều vô dụng (hệ thống không đọc được). Đưa cấu hình vào Home Manager để nó tự nhúng vào `~/.nix-profile/share/applications` (nơi hệ thống luôn ưu tiên đọc).

### [2026-08-07 16:28] - CÀI ĐẶT LRC_TTY VÀ PLAYERCTL
- **File changed**: `home-manager/home.nix`
- **Mô tả**: Thêm `playerctl` vào `home.packages`. Tự động tải mã nguồn và biên dịch `lrc_tty` bằng Zig rồi ném vào `~/.local/bin/lrc_tty`.
- **Lý do**: Sếp yêu cầu tải 2 gói này cho plugin LRC của Noctalia. Tuy nhiên, `lrc_tty` chưa hề có gói chính thức trên kho của NixOS (nixpkgs), nên tui phải dùng chiêu biên dịch thủ công từ mã nguồn gốc trên Github!

### [2026-08-07 17:04] - GỠ BỎ TOÀN BỘ SPOTIFY, SPICETIFY, LRC VÀ PLAYERCTL
- **File changed**: `home-manager/home.nix`
- **Mô tả**: Xóa `spotify`, `spicetify-cli`, và `playerctl` khỏi `home.packages`. Xóa cấu hình đè `xdg.desktopEntries.spotify`. Xóa sạch dữ liệu rác tại `~/.local/bin/spotify`, `~/.local/bin/lrc_tty`, `~/.local/share/spotify-mutable`, `~/.config/spicetify`, `~/.cache/spotify`, `~/.config/spotify`.
- **Lý do**: Sếp yêu cầu gỡ sạch sẽ toàn bộ các thành phần này khỏi hệ thống.

### [2026-08-07 17:15] - DỌN SẠCH TÀN DƯ SPOTIFY DESKTOP ENTRY
- **File changed**: Không sửa file NixOS
- **Mô tả**: Xóa thủ công file `/home/hinne/.local/share/applications/spotify.desktop`.
- **Lý do**: File này được tạo thủ công từ lúc đầu để ép cấu hình, bị bỏ sót trong đợt xóa trước khiến Launcher vẫn hiện icon Spotify.

### [2026-08-08 17:49] - BẬT BLUETOOTH & QUẢN LÝ PIN LAPTOP
- **File changed**: `nixos/configuration.nix`
- **Mô tả**: Bật `hardware.bluetooth.enable`, kích hoạt `Experimental = true` để báo pin thiết bị. Bật `services.upower.enable` để đọc phần trăm pin laptop và `services.power-profiles-daemon.enable` để điều chỉnh hiệu năng.
- **Lý do**: Sếp yêu cầu bật tính năng kết nối Bluetooth, xem dung lượng pin thiết bị và theo dõi pin laptop.

### [2026-08-10 13:26] - CÀI ĐẶT ZEN BROWSER
- **File changed**: `flake.nix`, `home-manager/home.nix`
- **Mô tả**: Thêm input `zen-browser` từ flake `github:youwen5/zen-browser-flake` vào `flake.nix`. Thêm gói `inputs.zen-browser.packages.\${pkgs.system}.default` vào `home.packages` trong `home.nix`.
- **Lý do**: Sếp yêu cầu cài đặt Zen Browser theo hướng dẫn từ NixOS Wiki.
