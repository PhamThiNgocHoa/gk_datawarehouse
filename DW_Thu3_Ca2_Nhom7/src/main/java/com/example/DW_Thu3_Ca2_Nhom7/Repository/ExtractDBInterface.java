package com.example.DW_Thu3_Ca2_Nhom7.Repository;

import org.jdbi.v3.sqlobject.customizer.Bind;
import org.jdbi.v3.sqlobject.statement.SqlCall;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;
import org.springframework.stereotype.Component;

@Component  
public interface ExtractDBInterface {

	@SqlUpdate("LOAD DATA INFILE :fileLocation " +
	           "INTO TABLE control_db.temp_product_daily " +
	           "FIELDS TERMINATED BY ',' " +
	           "OPTIONALLY ENCLOSED BY '\"' " +
	           "LINES TERMINATED BY '\\n' " +
	           "IGNORE 1 ROWS " +
	           "(id, sku, name, url_key, url_path, availability, seller_id, seller_name, brand_id, brand_name, " +
	           "price, original_price, @dummy, @dummy, discount, discount_rate, rating_average, review_count, " +
	           "@dummy, primary_category_path, primary_category_name, thumbnail_url, thumbnail_width, " +
	           "thumbnail_height, productset_id, seller_product_id, seller_product_sku, master_product_sku, " +
	           "@dummy, @dummy, @dummy, order_route, @dummy, @dummy, " +
	           "@dummy, is_authentic, tiki_verified, tiki_hero, origin, freeship_campaign, " +
	           "impression_info, @dummy, @dummy,@dummy, @dummy, @dummy,@dummy, @dummy, @dummy,@dummy,@dummy, @dummy, @dummy,@dummy, @dummy, @dummy,@dummy, @dummy, @dummy,@dummy,@dummy, @dummy, @dummy,@dummy, @dummy, @dummy,@dummy, @dummy, @dummy,@dummy,@dummy, @dummy, @dummy,@dummy, @dummy, @dummy,@dummy, @dummy, @dummy,@dummy,@dummy, @dummy, @dummy,@dummy, @dummy, @dummy,@dummy,@dummy)")
	int loadFileToTable(@Bind("fileLocation") String fileLocation);

	@SqlCall("CALL UpdateDuplicateStatus()")
    void updateStatusForDuplicateIds();
	
	
	@SqlCall("CALL InsertProductDaily()")
    void insertProductDaily();
	



	@SqlUpdate("LOAD DATA INFILE 'E:/Study/HK1_Nam4/DW/Date_Dim/date_dim.csv'\r\n"
	        + "INTO TABLE datawarehouse.date_dim\r\n"
	        + "FIELDS TERMINATED BY ',' \r\n"
	        + "ENCLOSED BY '\"'\r\n"
	        + "LINES TERMINATED BY '\\n'\r\n"
	        + "IGNORE 1 ROWS\r\n"
	        + "(date_id, @raw_date_key, day_of_week, week_of_month, day_name, month_name, `year`, `year_month`, \r\n"
	        + " day_of_year, week_of_year, @dummy, iso_week_year, @raw_previous_sunday, @dummy, @dummy, @raw_next_monday, \r\n"
	        + " quarter_year, iso_week, holiday_type, @raw_is_weekend)\r\n"
	        + "SET date_key = STR_TO_DATE(@raw_date_key, '%m/%d/%Y'),\r\n"
	        + "    previous_sunday = STR_TO_DATE(@raw_previous_sunday, '%m/%d/%Y'),\r\n"
	        + "    next_monday = CASE \r\n"
	        + "        WHEN @raw_next_monday REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$' THEN STR_TO_DATE(@raw_next_monday, '%m/%d/%Y') \r\n"
	        + "        ELSE NULL \r\n"
	        + "    END,\r\n"
	        + "    is_weekend = CASE \r\n"
	        + "        WHEN TRIM(@raw_is_weekend) = 'Weekend' THEN 1 \r\n"
	        + "        WHEN TRIM(@raw_is_weekend) = 'Weekday' THEN 0 \r\n"
	        + "        ELSE NULL \r\n"
	        + "    END;")
	void loadDateDim();


	@SqlCall("CALL insertProductInfo()")
    void insertProductInfo();
	
	
	@SqlCall("CALL insertSellerInfo()")
    void insertSellerInfo();
	
	@SqlCall("CALL insertBrandInfo()")
    void insertBrandInfo();

	@SqlCall("CALL insertProductPriceHistory()")
    void insertProductPriceHistory();
	
	@SqlCall("CALL insertProductRating()")
    void insertProductRating();
}
