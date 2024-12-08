<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> --%>
<%-- <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> --%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Category Sales Summary</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<h2>Category Sales Summary</h2>

<!-- Tạo phần tử canvas để vẽ biểu đồ -->
<canvas id="salesChart" width="400" height="200"></canvas>

<script>
    // Lấy dữ liệu từ model
    var salesSummaryList = ${salesSummaryList}; // Dữ liệu từ controller
    console.log(salesSummaryList);

    // Chuyển dữ liệu sang định dạng phù hợp với Chart.js
    var labels = salesSummaryList.map(function(item) {
        return item.date_key; // Giả sử date_key là trường bạn muốn hiển thị trên trục X
    });
    var totalSales = salesSummaryList.map(function(item) {
        return item.total_sales; // Giả sử total_sales là dữ liệu bạn muốn vẽ trên biểu đồ
    });

    // Khởi tạo biểu đồ đường
    var ctx = document.getElementById('salesChart').getContext('2d');
    var salesChart = new Chart(ctx, {
        type: 'line', // Biểu đồ đường
        data: {
            labels: labels, // Các nhãn trên trục x (date_key)
            datasets: [{
                label: 'Total Sales',
                data: totalSales, // Dữ liệu doanh số
                fill: false,
                borderColor: 'rgb(75, 192, 192)', // Màu đường
                tension: 0.1
            }]
        },
        options: {
            responsive: true,
            plugins: {
                title: {
                    display: true,
                    text: 'Sales Summary by Date'
                },
                tooltip: {
                    callbacks: {
                        label: function(tooltipItem) {
                            return 'Total Sales: ' + tooltipItem.raw;
                        }
                    }
                }
            }
        }
    });
</script>
<div>
    <p>Tổng: ${salesSummaryList}</p>
</div>
</body>
