-- ==========================================================
-- CSDL RESTMAN (Hỗ trợ cả MySQL và SQLite)
-- ==========================================================

-- 1. Bảng tblUser0
CREATE TABLE IF NOT EXISTS tblUser0 (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50)
);

-- 2. Bảng tblCustomer0 (Kế thừa User0)
CREATE TABLE IF NOT EXISTS tblCustomer0 (
    tblUser0id INTEGER PRIMARY KEY,
    FOREIGN KEY (tblUser0id) REFERENCES tblUser0(id) ON DELETE CASCADE
);

-- 3. Bảng tblStaff0 (Kế thừa User0)
CREATE TABLE IF NOT EXISTS tblStaff0 (
    tblUser0id INTEGER PRIMARY KEY,
    position VARCHAR(100) NOT NULL,
    FOREIGN KEY (tblUser0id) REFERENCES tblUser0(id) ON DELETE CASCADE
);

-- 4. Bảng tblManager0 (Kế thừa Staff0)
CREATE TABLE IF NOT EXISTS tblManager0 (
    tblStaff0id INTEGER PRIMARY KEY,
    FOREIGN KEY (tblStaff0id) REFERENCES tblStaff0(tblUser0id) ON DELETE CASCADE
);

-- 5. Bảng tblCategory0
CREATE TABLE IF NOT EXISTS tblCategory0 (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL
);

-- 6. Bảng tblDish0
CREATE TABLE IF NOT EXISTS tblDish0 (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL,
    image VARCHAR(255),
    price REAL NOT NULL,
    description TEXT,
    tblCategory0id INTEGER,
    FOREIGN KEY (tblCategory0id) REFERENCES tblCategory0(id) ON DELETE SET NULL
);

-- 7. Bảng tblCombo0
CREATE TABLE IF NOT EXISTS tblCombo0 (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL,
    image VARCHAR(255),
    price REAL NOT NULL,
    description TEXT
);

-- 8. Bảng tblComboDetail0
CREATE TABLE IF NOT EXISTS tblComboDetail0 (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    quantity INTEGER NOT NULL,
    tblCombo0id INTEGER NOT NULL,
    tblDish0id INTEGER NOT NULL,
    FOREIGN KEY (tblCombo0id) REFERENCES tblCombo0(id) ON DELETE CASCADE,
    FOREIGN KEY (tblDish0id) REFERENCES tblDish0(id) ON DELETE CASCADE
);

-- ==========================================================
-- DỮ LIỆU MẪU (THẬT, TIẾNG VIỆT CÓ DẤU)
-- ==========================================================

-- Xóa dữ liệu cũ nếu có
DELETE FROM tblComboDetail0;
DELETE FROM tblCombo0;
DELETE FROM tblDish0;
DELETE FROM tblCategory0;
DELETE FROM tblManager0;
DELETE FROM tblStaff0;
DELETE FROM tblCustomer0;
DELETE FROM tblUser0;

-- Thêm User
INSERT INTO tblUser0 (id, username, password, name, email, phone) VALUES
(1, 'customer1', '123456', 'Nguyễn Văn Khách', 'khach1@gmail.com', '0901234567'),
(2, 'customer2', '123456', 'Trần Thị Thu Trang', 'trangttt@gmail.com', '0912345678'),
(3, 'manager1', '123456', 'Lê Quản Lý', 'quanly1@restman.vn', '0988776655'),
(4, 'staff1', '123456', 'Phạm Nhân Viên', 'nhanvien1@restman.vn', '0977665544');

-- Thêm Customer
INSERT INTO tblCustomer0 (tblUser0id) VALUES
(1),
(2);

-- Thêm Staff
INSERT INTO tblStaff0 (tblUser0id, position) VALUES
(3, 'Quản lý nhà hàng'),
(4, 'Nhân viên phục vụ');

-- Thêm Manager
INSERT INTO tblManager0 (tblStaff0id) VALUES
(3);

-- Thêm Category
INSERT INTO tblCategory0 (id, name) VALUES
(1, 'Khai vị'),
(2, 'Món chính'),
(3, 'Tráng miệng'),
(4, 'Đồ uống');

-- Thêm Dish
INSERT INTO tblDish0 (id, name, image, price, description, tblCategory0id) VALUES
(1, 'Gỏi cuốn tôm thịt', 'goi_cuon.jpg', 45000, 'Gỏi cuốn tươi ngon kèm nước chấm tương đen bùi ngậy', 1),
(2, 'Súp hải sản nấm hương', 'sup_hai_san.jpg', 55000, 'Súp nóng hổi với tôm, mực tươi ngọt và nấm thơm', 1),
(3, 'Bò bít tết sốt tiêu đen', 'bo_bit_tet.jpg', 180000, 'Bò Úc nhập khẩu nướng than hoa mềm mọng sốt tiêu đen', 2),
(4, 'Cá hồi áp chảo sốt bơ chanh', 'ca_hoi.jpg', 195000, 'Cá hồi Nauy áp chảo giòn da kèm măng tây tươi', 2),
(5, 'Cơm chiên hải sản Hoàng Kim', 'com_chien.jpg', 90000, 'Cơm chiên hạt tơi vàng ruộm với tôm, mực và trứng muối', 2),
(6, 'Chè khúc bạch thanh mát', 'che_khuc_bach.jpg', 35000, 'Chè khúc bạch sữa béo ngậy kèm nhãn lồng và hạnh nhân lát', 3),
(7, 'Panna Cotta dâu tây', 'panna_cotta.jpg', 40000, 'Panna cotta mềm mịn quyện lớp mứt sốt dâu tây tươi', 3),
(8, 'Trà đào cam sả', 'tra_dao.jpg', 35000, 'Trà đen thanh mát kết hợp lát đào giòn và hương sả nồng nàn', 4),
(9, 'Nước ép cam nguyên chất', 'nuoc_cam.jpg', 40000, 'Cam sành mọng nước ép nguyên chất tươi mới', 4);

-- Thêm Combo
INSERT INTO tblCombo0 (id, name, image, price, description) VALUES
(1, 'Combo Hẹn Hò Lãng Mạn', 'combo_hen_ho.jpg', 390000, 'Thích hợp cho cặp đôi 2 người gồm bò bít tết, tráng miệng và trà đào'),
(2, 'Combo Gia Đình Ấm Cúng', 'combo_gia_dinh.jpg', 550000, 'Dành cho gia đình 3-4 người gồm khai vị gỏi cuốn, cá hồi, cơm chiên và nước ép');

-- Thêm ComboDetail
INSERT INTO tblComboDetail0 (id, quantity, tblCombo0id, tblDish0id) VALUES
(1, 1, 1, 3),
(2, 2, 1, 7),
(3, 2, 1, 8),
(4, 2, 2, 1),
(5, 1, 2, 4),
(6, 1, 2, 5),
(7, 3, 2, 9);
