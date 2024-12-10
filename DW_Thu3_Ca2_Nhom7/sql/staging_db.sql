CREATE DATABASE IF NOT EXISTS staging_db;
USE staging_db;
CREATE TABLE IF NOT EXISTS product_daily (
    id INT,
    sku VARCHAR(50),
    name VARCHAR(255),
    seller_id INT,
    seller_name VARCHAR(255),
    brand_id INT,
    brand_name VARCHAR(255),
    price DECIMAL(10, 2),
    original_price DECIMAL(10, 2),
    discount DECIMAL(5, 2),
    discount_rate INT,
		rating_average NUMERIC,
    category_ids VARCHAR(1000),
    origin VARCHAR(50),
    date TIMESTAMP,
    status VARCHAR(50) DEFAULT NULL -- Thêm cột status để lưu trạng thái
);


DROP PROCEDURE UpdateProductDaily


CALL staging_db.UpdateProductDaily();


TRUNCATE TABLE product_daily;
