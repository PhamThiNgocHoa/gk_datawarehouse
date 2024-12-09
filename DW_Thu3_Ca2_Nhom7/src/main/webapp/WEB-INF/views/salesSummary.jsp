<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biểu đồ Doanh Số</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

<h2>Biểu đồ Doanh Số và Giá trị</h2>

<!-- Biểu đồ cột -->
<canvas id="salesBarChart" width="800" height="400"></canvas>

<script>
    // Lấy dữ liệu từ server (được truyền từ ModelAndView)
    const salesSummaryData = JSON.parse('${salesSummaryJsons}');  // Chuyển JSON sang đối tượng JavaScript

    // Tạo mảng dữ liệu cho các giá trị cần vẽ
    const dates = salesSummaryData.map(item => {
        // Chuyển đổi timestamp thành đối tượng Date
        const date = new Date(item.dateKey);

        // Lấy các thành phần ngày, tháng, năm
        const day = String(date.getDate()).padStart(2, '0'); // Đảm bảo ngày có 2 chữ số
        const month = String(date.getMonth() + 1).padStart(2, '0'); // Tháng bắt đầu từ 0, cộng thêm 1 để có tháng thực tế
        const year = date.getFullYear();

        // Trả về chuỗi định dạng dd/mm/yyyy
        return `${day}/${month}/${year}`;
    });

    console.log(dates);
    const totalSales = salesSummaryData.map(item => item.totalSales); // Tổng doanh số
    const avgPrice = salesSummaryData.map(item => item.avgPrice); // Giá trung bình
    const avgDiscount = salesSummaryData.map(item => item.avgDiscount); // Giảm giá trung bình

    // Vẽ biểu đồ cột
    const ctx = document.getElementById('salesBarChart').getContext('2d');
    const salesBarChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: dates, // Nhãn trục X (Ngày)
            datasets: [
                {
                    label: 'Tổng Doanh Số',
                    data: totalSales, // Dữ liệu tổng doanh số
                    backgroundColor: 'rgba(75, 192, 192, 0.2)', // Màu nền cho cột
                    borderColor: 'rgba(75, 192, 192, 1)', // Màu viền cột
                    borderWidth: 1
                },
                {
                    label: 'Giá Trung Bình',
                    data: avgPrice, // Dữ liệu giá trung bình
                    backgroundColor: 'rgba(153, 102, 255, 0.2)', // Màu nền cho cột
                    borderColor: 'rgba(153, 102, 255, 1)', // Màu viền cột
                    borderWidth: 1
                },
                {
                    label: 'Giảm Giá Trung Bình',
                    data: avgDiscount, // Dữ liệu giảm giá trung bình
                    backgroundColor: 'rgba(255, 159, 64, 0.2)', // Màu nền cho cột
                    borderColor: 'rgba(255, 159, 64, 1)', // Màu viền cột
                    borderWidth: 1
                }
            ]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'top',
                },
                tooltip: {
                    mode: 'index',
                    intersect: false,
                },
            },
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Ngày'
                    }
                },
                y: {
                    title: {
                        display: true,
                        text: 'Giá trị'
                    }
                }
            }
        }
    });
</script>

</body>
</html>
