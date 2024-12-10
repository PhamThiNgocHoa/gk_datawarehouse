<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

<form action="/brandPerformance" method="get">
    <button type="submit">Brand Performance</button>
</form>

<form action="/saleSummary" method="get">
    <button type="submit">Sales Summary</button>
</form>

<!-- Tạo phần tử canvas để vẽ biểu đồ -->
<canvas id="salesChart" width="400" height="200"></canvas>

<script>
    // Lấy dữ liệu từ model (được nhúng như chuỗi JSON)
    var salesSummaryList = JSON.parse('${salesSummaryJson}');
    console.log(salesSummaryList);

    // Chuyển dữ liệu sang định dạng phù hợp với Chart.js
    var labels = salesSummaryList.map(function(item) {
        return item.dateKey; // Đảm bảo trường dateKey đúng với dữ liệu
    });
    var totalSales = salesSummaryList.map(function(item) {
        return item.totalSales; // Đảm bảo trường totalSales đúng với dữ liệu
    });

    // Khởi tạo biểu đồ đường
    var ctx = document.getElementById('salesChart').getContext('2d');
    var salesChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Total Sales',
                data: totalSales,
                fill: false,
                borderColor: 'rgb(75, 192, 192)',
                tension: 0.1
            }]
        },
        options: {
            responsive: true,
            plugins: {
                title: {
                    display: true,
                    text: 'Sales Summary by Date'
                }
            }
        }
    });
</script>
</body>
