<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Brand Performance</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<canvas id="brandPerformanceChart" width="400" height="200"></canvas>
<script>
    // Lấy dữ liệu JSON từ controller
    const performanceData = JSON.parse('${performanceJson}');

    // Lấy các tháng và năm từ dữ liệu
    const labels = performanceData.map(item => item.month + '/' + item.year);

    // Lấy dữ liệu cho biểu đồ
    const totalSalesData = performanceData.map(item => item.totalSales);
    const avgRatingData = performanceData.map(item => item.avgRating);
    const avgDiscountData = performanceData.map(item => item.avgDiscount);

    // Vẽ biểu đồ cột
    new Chart(document.getElementById('brandPerformanceChart'), {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [
                {
                    label: 'Total Sales',
                    data: totalSalesData,
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                },
                {
                    label: 'Average Rating',
                    data: avgRatingData,
                    backgroundColor: 'rgba(255, 159, 64, 0.2)',
                    borderColor: 'rgba(255, 159, 64, 1)',
                    borderWidth: 1
                },
                {
                    label: 'Average Discount',
                    data: avgDiscountData,
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1
                }
            ]
        },
        options: {
            responsive: true,
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Month'
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Value'
                    }
                }
            }
        }
    });
</script>
</body>
</html>
