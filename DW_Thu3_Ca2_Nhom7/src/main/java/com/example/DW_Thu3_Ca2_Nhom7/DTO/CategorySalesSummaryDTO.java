package com.example.DW_Thu3_Ca2_Nhom7.DTO;

import java.util.Date;

public class CategorySalesSummaryDTO {

    private String categoryIds;
    private double totalSales;
    private double avgPrice;
    private Date dateKey;

    // Constructor
    public CategorySalesSummaryDTO(String categoryIds, double totalSales, double avgPrice, Date dateKey) {
        this.categoryIds = categoryIds;
        this.totalSales = totalSales;
        this.avgPrice = avgPrice;
        this.dateKey = dateKey;
    }

    public CategorySalesSummaryDTO() {

    }

    // Getters and Setters
    public String getCategoryIds() {
        return categoryIds;
    }

    public void setCategoryIds(String categoryIds) {
        this.categoryIds = categoryIds;
    }

    public double getTotalSales() {
        return totalSales;
    }

    public void setTotalSales(double totalSales) {
        this.totalSales = totalSales;
    }

    public double getAvgPrice() {
        return avgPrice;
    }

    public void setAvgPrice(double avgPrice) {
        this.avgPrice = avgPrice;
    }

    public Date getDateKey() {
        return dateKey;
    }

    public void setDateKey(Date dateKey) {
        this.dateKey = dateKey;
    }

    // toString method for debugging purposes
    @Override
    public String toString() {
        return "CategorySalesSummaryDTO{" +
                "categoryIds='" + categoryIds + '\'' +
                ", totalSales=" + totalSales +
                ", avgPrice=" + avgPrice +
                ", dateKey=" + dateKey +
                '}';
    }
}