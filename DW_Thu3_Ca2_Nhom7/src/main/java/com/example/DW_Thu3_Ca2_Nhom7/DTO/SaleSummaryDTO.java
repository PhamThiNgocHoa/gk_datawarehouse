package com.example.DW_Thu3_Ca2_Nhom7.DTO;

import java.math.BigDecimal;
import java.sql.Date;

public class SaleSummaryDTO {

    private int id;
    private String sku;
    private String name;
    private BigDecimal totalSales;  // Tổng doanh thu (giá sau khi giảm)
    private BigDecimal avgPrice;    // Giá trung bình
    private BigDecimal avgDiscount; // Mức giảm giá trung bình
    private Date dateKey;           // Ngày ghi nhận doanh số

    // Constructor không tham số
    public SaleSummaryDTO() {
    }

    // Constructor với tất cả các tham số
    public SaleSummaryDTO(int id, String sku, String name, BigDecimal totalSales, BigDecimal avgPrice, BigDecimal avgDiscount, Date dateKey) {
        this.id = id;
        this.sku = sku;
        this.name = name;
        this.totalSales = totalSales;
        this.avgPrice = avgPrice;
        this.avgDiscount = avgDiscount;
        this.dateKey = dateKey;
    }

    // Getters và Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getTotalSales() {
        return totalSales;
    }

    public void setTotalSales(BigDecimal totalSales) {
        this.totalSales = totalSales;
    }

    public BigDecimal getAvgPrice() {
        return avgPrice;
    }

    public void setAvgPrice(BigDecimal avgPrice) {
        this.avgPrice = avgPrice;
    }

    public BigDecimal getAvgDiscount() {
        return avgDiscount;
    }

    public void setAvgDiscount(BigDecimal avgDiscount) {
        this.avgDiscount = avgDiscount;
    }

    public Date getDateKey() {
        return dateKey;
    }

    public void setDateKey(Date dateKey) {
        this.dateKey = dateKey;
    }

    // toString() để dễ dàng kiểm tra
    @Override
    public String toString() {
        return "SaleSummaryDTO{" +
                "id=" + id +
                ", sku='" + sku + '\'' +
                ", name='" + name + '\'' +
                ", totalSales=" + totalSales +
                ", avgPrice=" + avgPrice +
                ", avgDiscount=" + avgDiscount +
                ", dateKey=" + dateKey +
                '}';
    }
}
