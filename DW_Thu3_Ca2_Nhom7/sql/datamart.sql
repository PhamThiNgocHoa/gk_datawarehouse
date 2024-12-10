-- Tạo lại database datamart (nếu chưa tồn tại)
CREATE DATABASE IF NOT EXISTS datamart;
USE datamart;

-- Bảng tổng hợp doanh số và thông tin giá theo ngày
CREATE TABLE IF NOT EXISTS sales_summary (
    id INT PRIMARY KEY,
    sku VARCHAR(50),
    name VARCHAR(255),
    total_sales DECIMAL(15, 2), -- Tổng doanh số (giá sau khi giảm)
    avg_price DECIMAL(10, 2), -- Giá trung bình
    avg_discount DECIMAL(5, 2), -- Mức giảm giá trung bình
    date_key DATE
);

-- Bảng hiệu suất của thương hiệu theo tháng
CREATE TABLE IF NOT EXISTS brand_performance (
    record_id INT AUTO_INCREMENT PRIMARY KEY, -- Tự động tăng để đảm bảo mỗi bản ghi là duy nhất
    brand_id INT,
    brand_name VARCHAR(255),
    total_sales DECIMAL(15, 2),
    avg_rating NUMERIC,
    avg_discount DECIMAL(5, 2),
    month_key DATE -- Dùng month_key để liên kết với date_dim
);

-- Bảng tổng hợp doanh số theo danh mục sản phẩm
CREATE TABLE IF NOT EXISTS category_sales_summary (
    category_ids VARCHAR(255) PRIMARY KEY,
    total_sales DECIMAL(15, 2), -- Tổng doanh số
    avg_price DECIMAL(10, 2), -- Giá trung bình
    date_key DATE -- Dùng date_key để liên kết với date_dim
);

TRUNCATE TABLE brand_performance;
TRUNCATE TABLE category_sales_summary;
TRUNCATE TABLE sales_summary;
