package com.example.DW_Thu3_Ca2_Nhom7.Enum;

public enum LocationDataBase {
    EXTRACT_DATA_DB("jdbc:mysql://localhost:3306/extractdata_db"),
    DATAWAREHOUSE_DB("jdbc:mysql://localhost:3306/datawarehoue"),
    MART_DB("jdbc:mysql://localhost:3306/datamart"),
	STAGING_DB("jdbc:mysql://localhost:3306/staging");

    private final String url;

    
    LocationDataBase(String url) {
        this.url = url;
    }

   
    public String getUrl() {
        return url;
    }
}