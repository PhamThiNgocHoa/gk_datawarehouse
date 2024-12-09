package com.example.DW_Thu3_Ca2_Nhom7.DTO;

import java.math.BigDecimal;
import java.sql.Date;

public class BrandPerformanceDTO {

    private int month;  // Tháng
    private int year;   // Năm
    private BigDecimal totalSales;  // Tổng doanh thu
    private double avgRating;       // Đánh giá trung bình
    private BigDecimal avgDiscount; // Mức giảm giá trung bình

    // Getters và Setters
    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public BigDecimal getTotalSales() {
        return totalSales;
    }

    public void setTotalSales(BigDecimal totalSales) {
        this.totalSales = totalSales;
    }

    public double getAvgRating() {
        return avgRating;
    }

    public void setAvgRating(double avgRating) {
        this.avgRating = avgRating;
    }

    public BigDecimal getAvgDiscount() {
        return avgDiscount;
    }

    public void setAvgDiscount(BigDecimal avgDiscount) {
        this.avgDiscount = avgDiscount;
    }

    @Override
    public String toString() {
        return "BrandPerformanceDTO{" +
                "month=" + month +
                ", year=" + year +
                ", totalSales=" + totalSales +
                ", avgRating=" + avgRating +
                ", avgDiscount=" + avgDiscount +
                '}';
    }
}
