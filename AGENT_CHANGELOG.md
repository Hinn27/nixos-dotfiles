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

### [2026-08-12 16:21] - CÀI ĐẶT NODEJS
- **File changed**: `home-manager/home.nix`
- **Mô tả**: Thêm gói `nodejs` vào `home.packages`.
- **Lý do**: Sếp chạy `kilocode` được cài bằng `pnpm` nhưng báo lỗi thiếu `node`. Nguyên nhân là máy sếp mới chỉ cài trình quản lý gói `pnpm` chứ chưa cài môi trường chạy lõi là `nodejs`.

### [2026-08-14 11:43] - SỬA LỖI PHÍM TẮT MỞ ZEN BROWSER
- **File changed**: `home-manager/home.nix`
- **Mô tả**: Đổi giá trị biến môi trường `BROWSER` từ `zen-browser` thành `zen`.
- **Lý do**: File cấu hình phím tắt của Niri dùng lệnh `$BROWSER` để mở web (phím Super+B). Lúc trước ta đặt `$BROWSER="zen-browser"`, nhưng tên file chạy thực tế của app lại là `zen`, dẫn tới việc bấm phím tắt bị lỗi không hiện gì.

### [2026-08-14 11:47] - CẤU HÌNH FASTFETCH CHUẨN L=9 (NIXOS-SMALL)
- **File changed**: `home-manager/fastfetch.nix`, `home-manager/zsh.nix`
- **Mô tả**: Thiết lập thẳng `logo.source = "nixos_small"` trong file cấu hình JSONC của Fastfetch. Đồng thời, lược bỏ bớt mục hiển thị CPU và GPU để tổng số dòng text vừa khít 9 dòng (bao gồm 2 dòng khung viền cong), tạo sự cân bằng hoàn hảo `l=9` với logo NixOS nhỏ. Trả lại lệnh `fastfetch` gốc gọn gàng trong `zsh.nix`.
- **Lý do**: Sếp yêu cầu copy 100% setup Fastfetch từ Reddit với logo nhỏ và thông tin vừa khít.

### [2026-08-14 12:08] - CẬP NHẬT CẤU HÌNH FASTFETCH ASCII-ART
- **File changed**: `home-manager/fastfetch.nix`, `home-manager/home.nix`
- **Mô tả**: Cập nhật file cấu hình fastfetch theo thiết kế "ascii-art" từ repo LierB/fastfetch. Cấu hình mới sử dụng các ngắt dòng (break), hiển thị `title`, dấu phân cách dạng dấu chấm (•), và màu sắc tùy chỉnh. Logo vẫn giữ nguyên bản `nixos_small` cho đồng bộ. Thêm `./fastfetch.nix` vào danh sách `imports` trong `home.nix` để kích hoạt file cấu hình.
- **Lý do**: Sếp gửi link GitHub yêu cầu copy 100% cấu hình ascii-art.jsonc về máy. Lỗi trước đó do chưa import file cấu hình vào lõi.

### [2026-08-14 12:20] - ĐIỀU CHỈNH KHOẢNG CÁCH CỬA SỔ NIRI
- **File changed**: `home-manager/niri/cfg/layout.kdl`
- **Mô tả**: Giảm khoảng cách (`gaps`) giữa các cửa sổ từ 6px xuống 3px trong phần `layout` của cấu hình Niri.
- **Lý do**: Sếp yêu cầu chỉnh gap của các cửa sổ về 3px để tối ưu không gian hiển thị màn hình.

### [2026-08-14 12:26] - XÓA KHOẢNG TRỐNG THỪA TRONG FASTFETCH
- **File changed**: `home-manager/fastfetch.nix`
- **Mô tả**: Xóa bỏ các dòng ngắt (`break`) thừa ở đầu và cuối danh sách modules, đồng thời bỏ `padding.top = 2` và giảm `padding.right = 4` của logo. Thiết kế này giúp logo và text ôm sát viền trên cùng và cân xứng 100%.
- **Lý do**: Sếp yêu cầu dọn dẹp các khoảng trống thừa thãi. Đã thử thêm 1 dòng trống ở mép trên theo yêu cầu nhưng sau đó sếp đổi ý muốn xóa hẳn để cho gọn.

### [2026-08-15 00:27] - CẬP NHẬT PHÍM TẮT KITTY & SỔ TAY
- **File changed**: `home-manager/kitty.nix`, `/home/hinne/Documents/Note-Obsidian/Notes/Phím tắt Niri và Yazi.md`
- **Mô tả**: Thay thế phím tắt chia pane Kitty thành `Ctrl + Shift + Enter` (chia ngang) và `Ctrl + Shift + O` (chia dọc). Viết lại nội dung file ghi chú Obsidian, chắt lọc các phím tắt cốt lõi của Neovim và Kitty theo yêu cầu, đồng thời khôi phục lại bảng phím tắt của Yazi xuống cuối file.
- **Lý do**: Sếp yêu cầu tinh gọn lại file ghi chú, đồng bộ cấu hình Kitty theo bộ phím tắt mới, và sau đó yêu cầu giữ lại phần hướng dẫn của Yazi.

### [2026-08-15 00:31] - BẬT RENDER MARKDOWN ĐẸP CHO YAZI
- **File changed**: `home-manager/home.nix`
- **Mô tả**: Bổ sung gói `rich-cli` và `glow` vào danh sách Yazi Dependencies.
- **Lý do**: Yazi đã được cài sẵn plugin `rich-preview` để xem Markdown/JSON/CSV, nhưng trước đó do hệ thống thiếu thư viện `rich-cli` nên nó bị giáng cấp xuống thành text trần. Cài thêm gói này để plugin hoạt động hết công suất.

### [2026-08-15 00:32] - GỠ BỎ PHÍM TẮT V THỪA TRONG YAZI
- **File changed**: `~/.config/yazi/keymap.toml`, `/home/hinne/Documents/Note-Obsidian/Notes/Phím tắt Niri và Yazi.md`
- **Mô tả**: Xóa bỏ phím tắt `v` (mở video bằng mpv) khỏi cấu hình Yazi và xóa dòng hướng dẫn tương ứng trong sổ tay Obsidian.
- **Lý do**: Phím `v` mặc định của Yazi là dùng để kích hoạt chế độ chọn file (Visual Mode). Việc gán phím `v` để mở video bị đè lên tính năng gốc, trong khi ấn Enter thì Yazi cũng tự động mở bằng mpv rồi nên phím tắt này là hoàn toàn vô dụng và gây lỗi.

### [2026-08-15 00:36] - TỐI ƯU HÓA HIỆU NĂNG CUỘN YAZI (GLOW)
- **File changed**: `~/.config/yazi/yazi.toml`, `~/.config/yazi/plugins/glow.yazi`
- **Mô tả**: Clone plugin `glow.yazi` từ github và đổi cấu hình preview file Markdown (MD) từ `rich-preview` sang `glow`.
- **Lý do**: Lệnh `rich` khởi động bằng Python quá chậm (tốn hàng trăm ms), dẫn đến việc mỗi khi giữ phím cuộn nhanh qua một danh sách file thì CPU bị nghẽn do liên tục gọi Python, tạo cảm giác giật lag. `glow` được viết bằng Go, khởi động tức thì, giúp Yazi render Markdown siêu tốc mà không làm giảm frame rate.

### [2026-08-15 00:40] - GỠ BỎ GLOW, QUAY VỀ RICH-CLI
- **File changed**: `home-manager/home.nix`, `~/.config/yazi/yazi.toml`, `~/.config/yazi/plugins/glow.yazi`
- **Mô tả**: Gỡ sạch gói `glow` và plugin `glow.yazi`, cấu hình lại `yazi.toml` để trỏ Markdown về lại `rich-preview` như cũ.
- **Lý do**: Sếp phản hồi rằng dùng glow không hề mượt hơn tí nào, có thể lag do bản thân giao thức dựng hình ảnh hoặc render của Terminal chứ không phải do tốc độ khởi động của Python. Sếp quyết định trung thành với `rich-cli` vì nó xem được cả JSON/CSV đồng bộ.

### [2026-08-16 20:28] - SỬA LỖI CHUỘT KHÔNG QUA ĐƯỢC MÀN HÌNH LAPTOP
- **File changed**: `home-manager/niri/cfg/display.kdl`
- **Mô tả**: Sửa lại tọa độ `x` của màn hình laptop (`eDP-1`) từ `-1920` thành `-1745`.
- **Lý do**: Màn hình laptop được sếp cài scale 1.1, nên chiều ngang thực tế (logical width) bị thu hẹp còn 1745px. Việc đặt tọa độ ở -1920 tạo ra một "vùng chết" (dead zone) rộng 175px giữa 2 màn hình, khiến con trỏ chuột bị kẹt lại không sang được. Đã dời tọa độ về -1745 để hai mép màn hình dính sát vào nhau.

### [2026-08-17 12:35] - TỐI ƯU HÓA GAMING & CÀI ĐẶT POLYMC
### [2026-08-17 12:37] - CHỮA CHÁY LỖI THIẾU GÓI POLYMC
- **File changed**: `nixos/configuration.nix`
- **Mô tả**: Thay thế gói `polymc` (đã bị xóa khỏi nixpkgs) bằng `hmcl` (Hello Minecraft! Launcher).
- **Lý do**: Kho ứng dụng Nixpkgs đã gỡ bỏ hoàn toàn PolyMC do các lùm xùm nội bộ của dự án này. Để chơi được Minecraft crack (Offline mode), đã chuyển sang sử dụng HMCL - một launcher mã nguồn mở rất xịn sò, hỗ trợ tải mod từ CurseForge/Modrinth trực tiếp mà vẫn cho phép tạo tài khoản Offline.

### [2026-08-17 12:46] - SỬA LỖI LAG CHUỘT TRÊN GIAO DIỆN HMCL
- **File changed**: `~/.local/share/applications/hmcl.desktop` (Tạo mới file override)
- **Mô tả**: Ghi đè biểu tượng khởi động (shortcut) của HMCL để chèn thêm các biến môi trường `_JAVA_OPTIONS="-Dprism.order=sw"` và `GDK_BACKEND=x11`.
- **Lý do**: HMCL sử dụng bộ khung giao diện JavaFX. Khi chạy trên môi trường Wayland kết hợp với card đồ họa Nvidia Optimus, tính năng tăng tốc phần cứng (Hardware Acceleration) của JavaFX bị lỗi nhịp Vsync, gây ra hiện tượng chuột di chuyển bị khựng/lag. Chèn lệnh ép JavaFX chuyển sang dựng hình bằng CPU (Software Rendering) và ép chạy qua X11 để xử lý triệt để tình trạng này (chỉ áp dụng cho giao diện của Launcher, không ảnh hưởng đến FPS khi vào trong game Minecraft).

### [2026-08-17 14:04] - QUAY XE VỀ LẠI POLYMC BẰNG FLAKE CHÍNH THỨC
- **File changed**: `flake.nix`, `nixos/configuration.nix`
- **Mô tả**: Khai báo nguồn `github:PolyMC/PolyMC` vào `flake.nix` và cài đặt gói `inputs.polymc.packages.${pkgs.system}.polymc` vào hệ thống thay cho HMCL.
- **Lý do**: Sếp muốn dùng PolyMC gốc cho quen tay, mà kho Nixpkgs lại không có. Nên tui đã kéo thẳng bản cài đặt mới nhất từ mã nguồn Github chính thức của PolyMC về để sếp dùng thoải mái.

### [2026-08-17 16:14] - CÀI ĐẶT MÔI TRƯỜNG DOCKER, DATAGRIP VÀ QUICKEMU
- **File changed**: `nixos/configuration.nix`
- **Mô tả**: Bật tính năng `virtualisation.docker.enable`, thêm user vào nhóm `docker` và `kvm`. Cài đặt thêm các gói `jetbrains.datagrip` và `quickemu`.
- **Lý do**: Chuẩn bị môi trường để chạy MS SQL Server (qua Docker), công cụ quản lý cơ sở dữ liệu (DataGrip) và công cụ tạo máy ảo siêu tốc (Quickemu) để cài Windows 10 phục vụ việc chạy SSMS cho thầy giáo kiểm tra.

### [2026-08-17 17:13] - GỠ BỎ AZURE DATA STUDIO VÌ LỖI NIXPKGS
- **File changed**: `nixos/configuration.nix`
- **Mô tả**: Bỏ gói `azure-data-studio` ra khỏi danh sách cài đặt.
- **Lý do**: Lệnh cài đặt bị lỗi `undefined variable` do gói phần mềm này không còn tồn tại trên kho Nixpkgs hiện tại của hệ thống. Chuyển hướng sếp về dùng Máy ảo Windows hoặc DataGrip.

### [2026-08-17 17:41] - GỠ BỎ TOÀN BỘ JETBRAINS IDES, CHUYỂN SANG TOOLBOX
- **File changed**: `home-manager/home.nix`, `nixos/configuration.nix`
- **Mô tả**: Gỡ bỏ các gói `jetbrains.idea`, `jetbrains.webstorm`, và `jetbrains.datagrip`. Chỉ giữ lại duy nhất `jetbrains-toolbox`.
- **Lý do**: Các IDE cài qua Nix bị khóa cứng, không thể Update và khó kích hoạt bản quyền Edu. Việc chuyển qua cài đặt từ bên trong giao diện JetBrains Toolbox sẽ giải quyết triệt để mọi vấn đề: Tự động cập nhật dễ dàng, quản lý bản quyền tập trung, không sinh ra nhiều shortcut trùng lặp rác máy.

### [2026-08-17 23:43] - THÊM ALIAS QUICKWIN10
- **File changed**: `home-manager/zsh.nix`
- **Mô tả**: Thêm lệnh tắt `quickwin10` vào danh sách alias của Zsh.
- **Lý do**: Sếp muốn gõ `quickwin10` thay vì phải gõ dài dòng `quickemu --vm ~/windows-10/windows-10.conf` mỗi lần muốn mở máy ảo.

### [2026-08-24 15:08] - TỐI ƯU DAMX VÀ THÊM ALIAS ĐIỀU KHIỂN
- **File changed**: `nixos/damx.nix`, `home-manager/zsh.nix`
- **Mô tả**: Xóa bỏ giao diện DAMX (GUI) và tiến trình chạy ngầm (Daemon), chỉ giữ lại kernel module `linuwu-sense`. Thêm các alias Zsh để điều khiển quạt (`fan-auto`, `fan-max`, `fan-med`) và bật/tắt giới hạn sạc pin (`bat-limit-on`, `bat-limit-off`).
- **Lý do**: Khắc phục tình trạng DAMX GUI giật lag và tốn tài nguyên hệ thống, chuyển sang điều khiển nhẹ nhàng bằng dòng lệnh.

### [2026-08-24 15:00] - CÀI ĐẶT VÀ CẤU HÌNH SWAY 
- **File changed**: `nixos/configuration.nix`, `home-manager/zsh.nix`, `home-manager/sway.nix`, `home-manager/sway/config`, `home-manager/home.nix`
- **Mô tả**: Bật tính năng cài đặt Sway trong NixOS, cấu hình file `zsh.nix` để tự động chọn Niri ở tty1 và Sway ở tty2. Tạo cấu hình phím tắt cho Sway ánh xạ 1-1 với phím tắt từ Niri (Kitty, Noctalia, Yazi, thao tác cửa sổ...) thông qua thư mục `home-manager/sway`.
- **Lý do**: Sếp muốn dùng thử Sway nhưng vẫn muốn giữ lại Niri phòng hờ để có thể dễ dàng quay lại bất cứ lúc nào, đồng thời muốn toàn bộ phím tắt quen thuộc từ Niri được mang qua Sway để dùng thử cho thuận tiện.

### [2026-08-24 15:10] - THÊM JETBRAINS TOOLBOX VÀO AUTOSTART
- **File changed**: `home-manager/niri/cfg/autostart.kdl`, `home-manager/sway/config`
- **Mô tả**: Sửa cấu hình tự động khởi chạy của cả Niri và Sway để chạy `jetbrains-toolbox` kèm cờ `--minimize` (chạy ngầm). Đồng thời bổ sung `noctalia` vào autostart của Sway để đồng bộ thanh công cụ.
- **Lý do**: Sếp yêu cầu bật tự khởi động cho Jetbrains Toolbox. Việc thêm `--minimize` giúp Toolbox tự động thu nhỏ xuống khay hệ thống, không làm phiền người dùng lúc khởi động.

### [2026-08-24 15:22] - XÓA ALIAS CŨ TỪ CACHYOS
- **File changed**: `home-manager/zsh.nix`
- **Mô tả**: Xóa các alias `mirror` và `update` vì đây là cấu hình cũ từ Arch/CachyOS không còn tác dụng trên NixOS.
- **Lý do**: Sếp yêu cầu dọn dẹp để tự gõ lệnh chuẩn của NixOS (`nh os switch` / `nh home switch`).
