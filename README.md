# GoodbyeDPI - Phiên bản Tối ưu cho Mạng Việt Nam

Phần mềm vượt tường lửa DPI (Deep Packet Inspection) của các nhà mạng Việt Nam (Viettel, VNPT, FPT, MobiFone, CMC). Giúp truy cập các dịch vụ bị chặn như **Steam, Discord, Medium, Reddit, BBC, Torrent...** mà không cần sử dụng VPN, không làm giảm tốc độ mạng và không làm tăng độ trễ (ping).

Dựa trên dự án gốc [GoodbyeDPI](https://github.com/ValdikSS/GoodbyeDPI) của ValdikSS, được tinh chỉnh cấu hình, tối ưu bộ lọc blacklist và vá các lỗi mã nguồn chuyên biệt cho hạ tầng mạng tại Việt Nam.

---

## 1. Điểm Khác Biệt So Với Bản Gốc

* **Cấu hình tối ưu cho ISP Việt Nam**: Nhà mạng Việt Nam chặn ở 2 tầng (DNS Hijacking và SNI Inspection). Cấu hình sử dụng `-p -r -s -f 2 -e 2 --reverse-frag --max-payload 1200 -q`, tránh sử dụng gói tin giả (Fake Request / wrong-chksum) vốn dễ bị một số router GPON nhà mạng chặn drop nhầm.
* **Chặn QUIC/HTTP3 (`-q`)**: Ngăn trình duyệt kết nối qua giao thức UDP 443 chưa được phân mảnh, tự động ép về TCP HTTPS để vượt chặn triệt để.
* **Danh sách Blacklist chọn lọc (`vietnam-blacklist.txt`)**: Chỉ can thiệp vào các trang bị chặn tại Việt Nam. Toàn bộ lưu lượng khác (App ngân hàng, Momo, Zalo, game trong nước, Youtube, Facebook...) đi thẳng 100%, không bị ảnh hưởng.
* **Tự động yêu cầu quyền Administrator**: Tất cả script `.cmd` đều tích hợp cơ chế tự động mở hộp thoại UAC xin quyền Admin nếu người dùng quên click "Run as administrator".
* **Công cụ đổi DNS nhanh (`dns_quick_switch.cmd`)**: Hỗ trợ chuyển đổi nhanh sang Cloudflare (1.1.1.1), Google (8.8.8.8) hoặc khôi phục DHCP mặc định chỉ với 1 phím bấm.
* **Cập nhật Blacklist 1-click (`update_blacklist.cmd`)**: Tự động tải danh sách tên miền mới nhất từ repository và khởi động lại dịch vụ ngầm nếu đang chạy.
* **Vá lỗi và cải tiến mã nguồn C**:
  * Tự động xử lý lỗi WinDivert Error 1058 (`touch_windivert`): Tự động đánh thức và truy vấn trạng thái WinDivert trong Windows Service Control Manager, chống lỗi dịch vụ bị khoá/vô hiệu hoá.
  * Hỗ trợ độ trễ giữa các mảnh phân mảnh (`--frag-delay <ms>`): Chống lại các hệ thống DPI có bộ đệm ghép luồng (reassembly buffer).
  * Sửa lỗi chế độ `--frag-by-sni` khi dùng độc lập.
  * Sửa lỗi tràn bộ nhớ đệm (out-of-bounds array access) trong bộ nạp gói tin giả `fakepackets.c`.
  * Sửa lỗi đọc tràn 1 byte (buffer over-read) khi kiểm tra độ dài SNI trong `goodbyedpi.c`.
  * Khắc phục lỗi tham số `--ip-id` bị vô hiệu hoá từ lần gọi thứ hai trở đi.
  * Xử lý cảnh báo chuyển nhánh switch-case thiếu `break` trong `service.c`.
  * Bổ sung cơ chế chuyển đổi chữ hoa/thường (case-insensitive) cho danh sách tên miền.

---

## 2. Hướng Dẫn Sử Dụng Nhanh

Tải bản phát hành mới nhất từ mục **Releases**, giải nén ra thư mục bất kỳ trên máy (ổ C, D, E...):

### Cách 1: Cài đặt chạy ngầm vĩnh viễn (Khuyên dùng)
1. Chạy file **`service_install_vietnam.cmd`**.
2. Phần mềm sẽ được đăng ký thành Windows Service, tự động chạy ngầm mỗi khi bật máy.
3. Không tốn tài nguyên (chiếm dưới 4MB RAM, CPU xấp xỉ 0%), không xuất hiện cửa sổ dòng lệnh.
4. Khi không muốn dùng nữa, chỉ cần chạy file **`service_remove.cmd`**.

### Cách 2: Chạy tạm thời khi cần
1. Chạy file **`1_vietnam_optimized.cmd`**.
2. Giữ nguyên cửa sổ CMD trong suốt quá trình sử dụng. Khi đóng cửa sổ, phần mềm sẽ dừng lại.

### Cách 3: Bỏ chặn toàn bộ lưu lượng (Không dùng Blacklist)
* Chạy **`2_vietnam_all_traffic.cmd`** (hoặc **`service_install_vietnam_all.cmd`** nếu muốn cài service).
* Chế độ này sẽ áp dụng kỹ thuật phân mảnh cho tất cả các kết nối HTTPS ra ngoài Internet.

---

## 3. Lưu Ý Bắt Buộc (Tránh Bị Chặn Tầng DNS)

Các nhà mạng tại Việt Nam thường áp dụng chặn ở tầng phân giải tên miền (DNS) trước khi gói tin đến tầng DPI. Để đảm bảo hiệu quả 100%, bạn cần bật tính năng **DNS bảo mật (DoH - DNS over HTTPS)** trên trình duyệt:

* **Google Chrome / Cốc Cốc / Microsoft Edge / Brave**:
  * Vào `Cài đặt` -> `Quyền riêng tư và bảo mật` -> `Bảo mật`.
  * Bật mục `Sử dụng hệ thống tên miền (DNS) bảo mật`.
  * Chọn nhà cung cấp: **Cloudflare (1.1.1.1)** hoặc **Google (Public DNS)**.
* **Mozilla Firefox**:
  * Vào `Cài đặt` -> `Cài đặt mạng` (dưới cùng) -> Chọn `Cài đặt...`.
  * Bật `Bật DNS qua HTTPS` -> Chọn chế độ `Bảo vệ tối đa` -> Chọn nhà cung cấp `Cloudflare`.

Nếu muốn đổi DNS toàn hệ thống cho các ứng dụng không phải trình duyệt (như Steam Client, Discord Desktop), hãy sử dụng file **`dns_quick_switch.cmd`** và chọn phím `[1]`.

---

## 4. Danh Sách Tên Miền Blacklist

File **`vietnam-blacklist.txt`** chứa danh sách các website bị chặn phổ biến tại Việt Nam.

GoodbyeDPI hỗ trợ tự động khớp mọi tên miền con (subdomain). Ví dụ:
* Khai báo `steampowered.com` sẽ tự động bao gồm cả `store.steampowered.com`, `login.steampowered.com`, `checkout.steampowered.com`...
* Khai báo `steamcommunity.com` sẽ tự động bao gồm cả `cdn.steamcommunity.com`, `api.steamcommunity.com`...
Do đó không cần phải liệt kê thủ công từng subdomain vào file.

### Cách cập nhật hoặc thêm tên miền mới:
* **Tự động**: Chạy file `update_blacklist.cmd` để đồng bộ danh sách mới nhất từ GitHub.
* **Thủ công**: Mở file `vietnam-blacklist.txt` bằng Notepad, thêm tên miền bạn muốn (mỗi dòng 1 tên miền) rồi lưu lại. Nếu đang chạy service, hãy chạy lại `service_install_vietnam.cmd` để dịch vụ nạp cấu hình mới.

---

## 5. Tự Biên Dịch Từ Mã Nguồn (Build From Source)

Yêu cầu môi trường Linux (Ubuntu/Debian) hoặc WSL có cài đặt MinGW-w64:

```bash
# Cài đặt trình biên dịch MinGW
sudo apt-get update
sudo apt-get install -y gcc-mingw-w64 make unzip wget

# Tải thư viện WinDivert
wget https://reqrypt.org/download/WinDivert-2.2.0-D.zip
unzip WinDivert-2.2.0-D.zip

# Biên dịch bản 64-bit (x86_64)
cd src
make clean
make CPREFIX=x86_64-w64-mingw32- BIT64=1 WINDIVERTHEADERS=../WinDivert-2.2.0-D/include WINDIVERTLIBS=../WinDivert-2.2.0-D/x64 -j4

# Biên dịch bản 32-bit (i686)
make clean
make CPREFIX=i686-w64-mingw32- WINDIVERTHEADERS=../WinDivert-2.2.0-D/include WINDIVERTLIBS=../WinDivert-2.2.0-D/x86 -j4
```

Repository này cũng đã tích hợp sẵn workflow **GitHub Actions** (`.github/workflows/build.yml`), tự động biên dịch và đóng gói bộ cài hoàn chỉnh mỗi khi có commit mới.

---

## 6. Xử Lý Sự Cố Thường Gặp

* **Lỗi không khởi động được service**: Đảm bảo thư mục chứa GoodbyeDPI không nằm trong đường dẫn có chứa ký tự đặc biệt hoặc quyền hạn bị giới hạn. Nên đặt ở ổ đĩa thông thường như `C:\GoodbyeDPI` hoặc `D:\GoodbyeDPI`.
* **Trùng lặp driver WinDivert**: Nếu trước đó bạn từng sử dụng Zapret, ByeDPI hoặc phiên bản GoodbyeDPI khác, hãy chạy file `service_remove.cmd` để dọn dẹp sạch các service và driver cũ trước khi cài lại.
* **Xung đột phần mềm mạng**: Tính năng `Advanced Stream Detect` trên các card mạng Killer Network (Intel/Qualcomm) có thể xung đột với WinDivert. Hãy tắt tính năng này trong Killer Control Center nếu gặp tình trạng mất mạng.

---

## 7. Giấy Phép & Ghi Nhận Bản Quyền

* Dự án dựa trên mã nguồn gốc [GoodbyeDPI](https://github.com/ValdikSS/GoodbyeDPI) của tác giả **ValdikSS** (phát hành theo giấy phép Apache License 2.0).
* Sử dụng thư viện điều hướng gói tin [WinDivert](https://github.com/basil00/Divert) của tác giả **basil00** (giấy phép GNU LGPLv3).
