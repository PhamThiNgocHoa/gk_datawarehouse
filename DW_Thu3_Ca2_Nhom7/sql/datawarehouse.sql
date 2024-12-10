-- Tạo lại database datawarehouse (nếu chưa tồn tại)
CREATE DATABASE IF NOT EXISTS datawarehouse;
USE datawarehouse;

-- Bảng lưu thông tin sản phẩm cơ bản
CREATE TABLE IF NOT EXISTS product_info (
    id INT PRIMARY KEY,
    sku VARCHAR(50),
    name VARCHAR(255),
    brand_id INT,
    category_ids VARCHAR(255),
    origin VARCHAR(50),
    status VARCHAR(50)
);

-- Bảng lưu thông tin người bán
CREATE TABLE IF NOT EXISTS seller_info (
    seller_id INT PRIMARY KEY,
    seller_name VARCHAR(255)
);

-- Bảng lưu thông tin thương hiệu
CREATE TABLE IF NOT EXISTS brand_info (
    brand_id INT,
    brand_name VARCHAR(255),
    PRIMARY KEY (brand_id, brand_name)
);

-- Bảng lưu lịch sử giá và khuyến mãi của sản phẩm, có liên kết với date_dim
CREATE TABLE IF NOT EXISTS product_price_history (
    id INT,
    price DECIMAL(10, 2),
    original_price DECIMAL(10, 2),
    discount DECIMAL(5, 2),
    discount_rate INT,
    date_key DATE, -- Vẫn liên kết với date_dim
    FOREIGN KEY (id) REFERENCES product_info(id)
);

-- Bảng lưu thông tin đánh giá của sản phẩm, có liên kết với date_dim
CREATE TABLE IF NOT EXISTS product_rating (
    id INT,
    rating_average NUMERIC,
    date_key DATE, -- Vẫn liên kết với date_dim
    FOREIGN KEY (id) REFERENCES product_info(id)
    )

CREATE TABLE IF NOT EXISTS date_dim (
    date_id INT PRIMARY KEY,
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


TRUNCATE TABLE date_dim;

TRUNCATE TABLE brand_info;
TRUNCATE TABLE product_price_history;
TRUNCATE TABLE product_rating;
TRUNCATE TABLE seller_info;

TRUNCATE TABLE product_info;
-- Vô hiệu hóa ràng buộc khóa ngoại
SET foreign_key_checks = 0;

-- Thực hiện truncate bảng
TRUNCATE TABLE datawarehouse.product_info;

-- Bật lại ràng buộc khóa ngoại
SET foreign_key_checks = 1;

