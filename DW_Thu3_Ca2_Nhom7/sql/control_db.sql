-- 1. Kết nối Control Database
CREATE DATABASE IF NOT EXISTS control_db;
USE control_db;

-- 2. Tạo bảng file_config
CREATE TABLE IF NOT EXISTS file_config (
    file_id INT AUTO_INCREMENT PRIMARY KEY,
    file_name VARCHAR(255) NOT NULL,
    file_path_temp VARCHAR(500) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_type VARCHAR(50) NOT NULL,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    source VARCHAR(255),
    username VARCHAR(50),
    password VARCHAR(50)
);
ALTER TABLE file_config
ADD COLUMN err_to_mail VARCHAR(50);

-- 3. Tạo bảng logs
CREATE TABLE IF NOT EXISTS logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    file_id INT,
    process_step VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL,
    log_message TEXT,
    log_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    log_dateupdate DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (file_id) REFERENCES file_config(file_id)
);

ALTER TABLE temp_product_daily MODIFY COLUMN discount DECIMAL(10, 2);
ALTER TABLE temp_product_daily ADD PRIMARY KEY (id);

-- 4. Tạo bảng tạm temp_product_daily
CREATE TABLE IF NOT EXISTS temp_product_daily (
    id INT ,
    sku VARCHAR(50),
   `name` VARCHAR(255),
    url_key VARCHAR(255),
    url_path VARCHAR(255),
    availability VARCHAR(50),
    seller_id INT,
    seller_name VARCHAR(255),
    brand_id INT,
    brand_name VARCHAR(255),
    price DECIMAL(10, 2),
    original_price DECIMAL(10, 2),
    badges_new VARCHAR(255),
    badges_v3 VARCHAR(255),
    discount DECIMAL(10, 2),
    discount_rate INT,
    rating_average DECIMAL(3, 2),
    review_count INT,
    category_ids VARCHAR(1000),
    primary_category_path VARCHAR(255),
    primary_category_name VARCHAR(255),
    thumbnail_url VARCHAR(255),
    thumbnail_width INT,
    thumbnail_height INT,
    productset_id INT,
    seller_product_id INT,
    seller_product_sku VARCHAR(50),
    master_product_sku VARCHAR(50),
    shippable BOOLEAN,
    isGiftAvailable BOOLEAN,
    fastest_delivery_time INT,
    order_route VARCHAR(50),
    is_tikinow_delivery BOOLEAN,
    is_nextday_delivery BOOLEAN,
    is_from_official_store BOOLEAN,
    is_authentic BOOLEAN,
    tiki_verified BOOLEAN,
    tiki_hero BOOLEAN,
    origin VARCHAR(50),
    freeship_campaign VARCHAR(255),
    impression_info TEXT,
    is_high_price_penalty BOOLEAN,
    is_top_brand BOOLEAN,
    temp_date TIMESTAMP,
    status VARCHAR(50) DEFAULT NULL -- Thêm cột status để lưu trạng thái
);


CREATE TABLE IF NOT EXISTS temp_date_dim (
    date_id INT,
    date_key DATE, -- Đảm bảo date_key là duy nhất
    day_of_week INT,
    week_of_month INT,
    day_name VARCHAR(10),
    month_key  VARCHAR(15),
    `year` INT(10),
    `year_month` VARCHAR(10),
    day_of_year INT(11),
    week_of_year INT(11),
    iso_week INT(11),
    iso_week_year VARCHAR(10),
    previous_sunday DATE,
    next_monday DATE,
    quarter_year VARCHAR(10),
    is_weekend BOOLEAN,
    holiday_type VARCHAR(20)
);

DROP  TABLE IF EXISTS temp_date_dim;



DESCRIBE temp_product_daily;

-- 5. Thêm thông tin file vào bảng file_config
INSERT INTO file_config (file_name, file_path_temp, file_path, file_type, created_date, source, username, password)
VALUES ('lovisong_DD_MM_YYYY', 'D:\\Study\\HK1_Nam4\\DW\\temp', 'C:\\Users\\user\\Documents\\Navicat\\MySQL\\Servers\\DW\\staging_db', '', NOW(), 'https://tiki.vn/lo-vi-song/c2022', 'root', '');

-- 6. Lấy file_id của file vừa thêm vào
SET @file_id = LAST_INSERT_ID();

-- 7. Chèn log vào bảng logs
INSERT INTO logs (file_id, process_step, status, log_message)
VALUES (@file_id, 'Save', 'Success', 'Dữ liệu đã được tải vào file temp_product_daily');


TRUNCATE TABLE temp_product_daily;

