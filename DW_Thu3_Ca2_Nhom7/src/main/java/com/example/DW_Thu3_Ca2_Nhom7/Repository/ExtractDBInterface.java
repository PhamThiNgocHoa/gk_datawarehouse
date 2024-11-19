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
}
