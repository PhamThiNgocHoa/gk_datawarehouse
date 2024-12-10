
SELECT * FROM staging_db.product_daily;
TRUNCATE TABLE staging_db.product_daily;
SHOW VARIABLES LIKE 'secure_file_priv';
-- 9. Đọc file CSV

-- LOAD DATA FROM CSV TO VÀO BẢNG TẠM
LOAD DATA INFILE 'D:/Study/HK1_Nam4/DW/temp/lovisong_10_11_2024.csv'
INTO TABLE control_db.temp_product_daily
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id, sku, name,url_key,url_path,availability,seller_id,seller_name,brand_id,brand_name,price,original_price,badges_new,badges_v3,discount,discount_rate,rating_average,review_count,category_ids,primary_category_path,primary_category_name,thumbnail_url, thumbnail_width, thumbnail_height, productset_id,seller_product_id,seller_product_sku,master_product_sku,shippable,isGiftAvailable,fastest_delivery_time,order_route,is_tikinow_delivery,is_nextday_delivery,is_from_official_store,is_authentic,tiki_verified, tiki_hero,origin,freeship_campaign,impression_info,is_high_price_penalty,is_top_brand
);
UPDATE control_db.temp_product_daily
SET status = '1'
WHERE id IN (
    SELECT id FROM (
        SELECT id FROM control_db.temp_product_daily
        GROUP BY id
        HAVING COUNT(*) > 1
    ) AS duplicate_ids
);


-- 10. Lưu dữ liệu
-- CHUYỂN DỮ LIỆU TỪ BẢNG TẠM VÀO BẢNG CHÍNH
INSERT INTO staging_db.Product_daily (   
    id,
    sku,
    name,
    seller_id,
    seller_name,
    brand_id,
    brand_name,
    price,
    original_price,
    discount,
		rating_average,
    discount_rate,
    category_ids,
    origin,
		`status`,
    `date`
)
SELECT 
   id,
    sku,
    name,
    seller_id,
    seller_name,
    brand_id,
    brand_name,
    price,
    original_price,
    discount,
		rating_average,
    discount_rate,
    category_ids,
    origin,
		`status`,
    temp_date AS `date`
FROM 
    control_db.temp_product_daily;
		



-- 11. Cập nhật trạng thái trong logs "Success Extracting"
-- Lấy file_id từ bảng file_config
SET @file_id = (SELECT file_id FROM control_db.file_config WHERE file_name = 'lovisong_10_11_2024');
SET @file_id = LAST_INSERT_ID();
-- Chèn log vào bảng logs
INSERT INTO control_db.logs (file_id, process_step, status, log_message)
VALUES (@file_id, 'Extract', 'Success Extracting', 'Dữ liệu đã được tải vào bảng staging_db.product_daily');


LOAD DATA INFILE 'D:/Study/HK1_Nam4/DW/Date_Dim/date_dim.csv'
INTO TABLE datawarehouse.date_dim
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 2 ROWS
(date_id, date_key, day_of_week, week_of_month, day_name, month_key,
        `year`, `year_month`, day_of_year, week_of_year, iso_week, iso_week_year,
        previous_sunday, next_monday, quarter_year, is_weekend, holiday_type);
        

INSERT INTO datawarehouse.product_info (id, sku, name, brand_id, category_ids, origin, `status`)
SELECT DISTINCT id, sku, name, brand_id, category_ids, origin, `status`
FROM staging_db.product_daily;

INSERT INTO datawarehouse.seller_info (seller_id, seller_name)
SELECT seller_id, MAX(seller_name)
FROM staging_db.product_daily
GROUP BY seller_id;

INSERT INTO datawarehouse.brand_info (brand_id, brand_name)
SELECT DISTINCT brand_id, brand_name
FROM staging_db.product_daily;

INSERT INTO datawarehouse.product_price_history (id, price, original_price, discount, discount_rate, date_key)
SELECT
    pd.id,
    pd.price,
    pd.original_price,
    pd.discount,
    pd.discount_rate,
    DATE(pd.date) -- Chuyển `TIMESTAMP` sang `DATE` để khớp với `date_key`
FROM
    staging_db.product_daily pd
JOIN
    datawarehouse.date_dim dd ON DATE(pd.date) = dd.date_key;


INSERT INTO datawarehouse.product_rating (id, rating_average, date_key)
SELECT
    pd.id,
    pd.rating_average,
    DATE(pd.date) -- Chuyển `TIMESTAMP` sang `DATE` để khớp với `date_key`
FROM
    staging_db.product_daily pd
JOIN
    datawarehouse.date_dim dd ON DATE(pd.date) = dd.date_key;


INSERT INTO control_db.logs (file_id, process_step, status, log_message)
VALUES (@file_id, 'Extract', 'Success Extracting', 'Dữ liệu đã được tải vào các bảng trong datawarehouse');


INSERT INTO datamart.sales_summary (id, sku, name, total_sales, avg_price, avg_discount, date_key)
SELECT
    pph.id,
    pi.sku,
    pi.name,
    SUM(pph.price * (1 - pph.discount_rate / 100)) AS total_sales, -- Tổng doanh số sau khi giảm
    AVG(pph.price) AS avg_price, -- Giá trung bình
    AVG(pph.discount_rate) AS avg_discount, -- Mức giảm giá trung bình
    pph.date_key
FROM
    datawarehouse.product_price_history pph
JOIN
    datawarehouse.product_info pi ON pph.id = pi.id
GROUP BY
    pph.id, pi.sku, pi.name, pph.date_key;


INSERT INTO datamart.brand_performance (brand_id, brand_name, total_sales, avg_rating, avg_discount, month_key)
SELECT
    pi.brand_id,
    bi.brand_name,
    SUM(pph.price * (1 - pph.discount_rate / 100)) AS total_sales,
    AVG(pr.rating_average) AS avg_rating,
    AVG(pph.discount_rate) AS avg_discount,
    DATE_FORMAT(pph.date_key, '%Y-%m-01') AS month_key -- Sử dụng ngày đầu tiên của tháng làm `month_key`
FROM
    datawarehouse.product_price_history pph
JOIN
    datawarehouse.product_info pi ON pph.id = pi.id
JOIN
    datawarehouse.brand_info bi ON pi.brand_id = bi.brand_id
LEFT JOIN
    datawarehouse.product_rating pr ON pph.id = pr.id AND pph.date_key = pr.date_key
GROUP BY
    pi.brand_id, bi.brand_name, month_key;


INSERT INTO datamart.category_sales_summary (category_ids, total_sales, avg_price, date_key)
SELECT
    pi.category_ids AS category_ids, -- Sử dụng đúng tên cột
    SUM(pph.price * (1 - pph.discount_rate / 100)) AS total_sales, -- Tính tổng doanh số sau khi giảm
    AVG(pph.price) AS avg_price, -- Tính giá trung bình
    pph.date_key
FROM
    datawarehouse.product_price_history pph
JOIN
    datawarehouse.product_info pi ON pph.id = pi.id
GROUP BY
    pi.category_ids, pph.date_key;




DELIMITER $$

CREATE PROCEDURE UpdateDuplicateStatus()
BEGIN
    UPDATE control_db.temp_product_daily
    SET status = '1'
    WHERE id IN (
        SELECT id FROM (
            SELECT id FROM control_db.temp_product_daily
            GROUP BY id
            HAVING COUNT(*) > 1
        ) AS duplicate_ids
    );
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE InsertProductDaily()
BEGIN
    INSERT INTO staging_db.Product_daily (
        id,
        sku,
        name,
        seller_id,
        seller_name,
        brand_id,
        brand_name,
        price,
        original_price,
        discount,
        rating_average,
        discount_rate,
        category_ids,
        origin,
        `status`,
        `date`
    )
    SELECT 
        id,
        sku,
        name,
        seller_id,
        seller_name,
        brand_id,
        brand_name,
        price,
        original_price,
        discount,
        rating_average,
        discount_rate,
        category_ids,
        origin,
        `status`,
        temp_date AS `date`
    FROM 
        control_db.temp_product_daily;
END$$

DELIMITER ;




DROP PROCEDURE IF EXISTS InsertDateDimData;

DELIMITER $$

CREATE PROCEDURE InsertDateDimData()
BEGIN
    -- Chèn dữ liệu từ bảng tạm vào bảng chính, chuyển đổi định dạng ngày
    INSERT INTO datawarehouse.date_dim (
        date_id, date_key, day_of_week, week_of_month, day_name, month_key,
        `year`, `year_month`, day_of_year, week_of_year, iso_week, iso_week_year,
        previous_sunday, next_monday, quarter_year, is_weekend, holiday_type
    )
    SELECT 
        date_id,
        STR_TO_DATE(date_key, '%d/%m/%Y'), -- Chuyển đổi định dạng ngày
        day_of_week,
        week_of_month,
        day_name,
        month_key,
        `year`,
        `year_month`,
        day_of_year,
        week_of_year,
        iso_week,
        iso_week_year,
        STR_TO_DATE(previous_sunday, '%d/%m/%Y'), -- Chuyển đổi định dạng ngày
        STR_TO_DATE(next_monday, '%d/%m/%Y'),    -- Chuyển đổi định dạng ngày
        quarter_year,
        is_weekend,
        holiday_type
    FROM temp_date_dim;

    -- Tùy chọn: Xóa bảng tạm nếu không cần nữa
    DROP TABLE IF EXISTS temp_date_dim;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE UpdateProductDaily()
BEGIN
    -- Xem dữ liệu trước khi cập nhật
    SELECT `status`, origin
    FROM staging_db.product_daily
    WHERE TRIM(`status`) = '' OR TRIM(origin) = '';

    -- Cập nhật dữ liệu
    UPDATE staging_db.product_daily
    SET 
        `status` = COALESCE(NULLIF(RTRIM(LTRIM(`status`)), ''), "N/A"),
        origin = COALESCE(NULLIF(RTRIM(LTRIM(origin)), ''), "N/A");
END$$

DELIMITER ;

DROP PROCEDURE insertProductInfo
-- load to datawahouse
DELIMITER $$

CREATE PROCEDURE insertProductInfo()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;

    -- Chèn dữ liệu mới, bỏ qua bản ghi trùng
    INSERT IGNORE INTO datawarehouse.product_info (id, sku, name, brand_id, category_ids, origin, `status`)
    SELECT DISTINCT id, sku, name, brand_id, category_ids, origin, `status`
    FROM staging_db.product_daily;

    SET FOREIGN_KEY_CHECKS = 1;
END $$

DELIMITER ;


DROP PROCEDURE insertSellerInfo
DELIMITER $$

CREATE PROCEDURE insertSellerInfo()
BEGIN
    REPLACE INTO datawarehouse.seller_info (seller_id, seller_name)
    SELECT seller_id, MAX(seller_name)
    FROM staging_db.product_daily
    GROUP BY seller_id;
END $$

DELIMITER ;

DROP PROCEDURE insertBrandInfo
DELIMITER $$

CREATE PROCEDURE insertBrandInfo()
BEGIN
    REPLACE INTO datawarehouse.brand_info (brand_id, brand_name)
    SELECT DISTINCT brand_id, brand_name
    FROM staging_db.product_daily;
END $$

DELIMITER ;

DROP PROCEDURE insertProductRating
DELIMITER $$

CREATE PROCEDURE insertProductPriceHistory()
BEGIN
    REPLACE INTO datawarehouse.product_price_history (id, price, original_price, discount, discount_rate, date_key)
    SELECT
        pd.id,
        pd.price,
        pd.original_price,
        pd.discount,
        pd.discount_rate,
        DATE(pd.date) -- Chuyển `TIMESTAMP` sang `DATE` để khớp với `date_key`
    FROM
        staging_db.product_daily pd
    JOIN
        datawarehouse.date_dim dd ON DATE(pd.date) = dd.date_key;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE insertProductRating()
BEGIN
    REPLACE INTO datawarehouse.product_rating (id, rating_average, date_key)
    SELECT
        pd.id,
        pd.rating_average,
        DATE(pd.date) -- Chuyển `TIMESTAMP` sang `DATE` để khớp với `date_key`
    FROM
        staging_db.product_daily pd
    JOIN
        datawarehouse.date_dim dd ON DATE(pd.date) = dd.date_key;
END $$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE insertSalesSummary()
BEGIN
    REPLACE INTO datamart.sales_summary (id, sku, name, total_sales, avg_price, avg_discount, date_key)
SELECT
    pph.id,
    pi.sku,
    pi.name,
    SUM(pph.price * (1 - pph.discount_rate / 100)) AS total_sales, -- Tổng doanh số sau khi giảm
    AVG(pph.price) AS avg_price, -- Giá trung bình
    AVG(pph.discount_rate) AS avg_discount, -- Mức giảm giá trung bình
    pph.date_key
FROM
    datawarehouse.product_price_history pph
JOIN
    datawarehouse.product_info pi ON pph.id = pi.id
GROUP BY
    pph.id, pi.sku, pi.name, pph.date_key;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS insertBrandPerformance;

DELIMITER $$

CREATE PROCEDURE insertBrandPerformance()
BEGIN
    REPLACE INTO datamart.brand_performance (brand_id, brand_name, total_sales, avg_rating, avg_discount, month_key)
SELECT
    pi.brand_id,
    bi.brand_name,
    SUM(pph.price * (1 - pph.discount_rate / 100)) AS total_sales,
    AVG(pr.rating_average) AS avg_rating,
    AVG(pph.discount_rate) AS avg_discount,
    DATE_FORMAT(pph.date_key, '%Y-%m-01') AS month_key -- Sử dụng ngày đầu tiên của tháng làm `month_key`
--     STR_TO_DATE(pph.date_key, '01/%m/%Y') AS month_key 
FROM
    datawarehouse.product_price_history pph
JOIN
    datawarehouse.product_info pi ON pph.id = pi.id
JOIN
    datawarehouse.brand_info bi ON pi.brand_id = bi.brand_id
LEFT JOIN
    datawarehouse.product_rating pr ON pph.id = pr.id AND pph.date_key = pr.date_key
GROUP BY
    pi.brand_id, bi.brand_name, month_key;
END $$

DELIMITER ;

DROP PROCEDURE insertCategorySaleSummary
DELIMITER $$
CREATE PROCEDURE insertCategorySaleSummary()
BEGIN
    REPLACE INTO datamart.category_sales_summary (category_ids, total_sales, avg_price, date_key)
SELECT
    pi.category_ids AS category_ids, -- Sử dụng đúng tên cột
    SUM(pph.price * (1 - pph.discount_rate / 100)) AS total_sales, -- Tính tổng doanh số sau khi giảm
    AVG(pph.price) AS avg_price, -- Tính giá trung bình
    pph.date_key
FROM
    datawarehouse.product_price_history pph
JOIN
    datawarehouse.product_info pi ON pph.id = pi.id
GROUP BY
    pi.category_ids, pph.date_key;
END $$

DELIMITER ;

DROP PROCEDURE selectCategorySaleSummary

DELIMITER $$

CREATE PROCEDURE selectCategorySaleSummary()
BEGIN
    SELECT
        category_ids, -- Sử dụng đúng tên cột
        total_sales, -- Tính tổng doanh số sau khi giảm
        avg_price, -- Tính giá trung bình
        date_key
    FROM
        datamart.category_sales_summary;
END $$

DELIMITER ;

DROP PROCEDURE selectSalesSummary

DELIMITER $$

CREATE PROCEDURE selectSalesSummary ()
BEGIN
    SELECT 
        date_key, 
        SUM(total_sales) AS total_sales, 
        AVG(avg_price) AS avg_price, 
        AVG(avg_discount) AS avg_discount
    FROM 
        datamart.sales_summary
    GROUP BY 
        date_key
    ORDER BY 
        date_key;
END $$

DELIMITER ;

DROP PROCEDURE selectBrandPerformanceByMonth
DELIMITER $$

CREATE PROCEDURE selectBrandPerformanceByMonth()
BEGIN
    SELECT 
        MONTH(month_key) AS month, -- Lấy tháng từ date
        YEAR(month_key) AS year,   -- Lấy năm từ date
        SUM(total_sales) AS total_sales,
        AVG(avg_rating) AS avg_rating,
        AVG(avg_discount) AS avg_discount
    FROM 
       datamart.brand_performance
    GROUP BY 
        YEAR(month_key), MONTH(month_key)  -- Nhóm theo năm và tháng
    ORDER BY 
        year, month;  -- Sắp xếp theo năm và tháng
END $$

DELIMITER ;
























