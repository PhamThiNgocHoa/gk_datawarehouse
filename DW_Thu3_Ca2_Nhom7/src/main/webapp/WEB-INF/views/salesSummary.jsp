<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biá»u Äá» Doanh Sá»</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
    
</head>
<body>
<form action="/categorySaleSummary" method="get">
    <button type="submit">Category Sale Summary</button>
</form>

<form action="/brandPerformance" method="get">
    <button type="submit">Brand Performance</button>
</form>


<h2>Biá»u Äá» Doanh Sá» vÃ  GiÃ¡ trá»</h2>

<!-- Biá»u Äá» cá»t -->
<canvas id="salesBarChart" width="800" height="400"></canvas>

<script>
    // Láº¥y dá»¯ liá»u tá»« server (ÄÆ°á»£c truyá»n tá»« ModelAndView)
    const salesSummaryData = JSON.parse('${salesSummaryJsons}');  // Chuyá»n JSON sang Äá»i tÆ°á»£ng JavaScript
	
    console.log(salesSummaryData);
    // Táº¡o máº£ng dá»¯ liá»u cho cÃ¡c giÃ¡ trá» cáº§n váº½
    const dates = salesSummaryData.map(item => {
    const date = new Date(item.dateKey);
    console.log('Raw Date Object:', date);
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();

    return day + '/' + month +'/' + year;
});

console.log(dates);

    const totalSales = salesSummaryData.map(item => item.totalSales); // Tá»ng doanh sá»
    const avgPrice = salesSummaryData.map(item => item.avgPrice); // GiÃ¡ trung bÃ¬nh
    const avgDiscount = salesSummaryData.map(item => item.avgDiscount); // Giáº£m giÃ¡ trung bÃ¬nh

    // Váº½ biá»u Äá» cá»t
    const ctx = document.getElementById('salesBarChart').getContext('2d');
    const salesBarChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: dates, // NhÃ£n trá»¥c X (NgÃ y)
            datasets: [
                {
                    label: 'Tá»ng Doanh Sá»',
                    data: totalSales, // Dá»¯ liá»u tá»ng doanh sá»
                    backgroundColor: 'rgba(75, 192, 192, 0.2)', // MÃ u ná»n cho cá»t
                    borderColor: 'rgba(75, 192, 192, 1)', // MÃ u viá»n cá»t
                    borderWidth: 1
                },
                {
                    label: 'GiÃ¡ Trung BÃ¬nh',
                    data: avgPrice, // Dá»¯ liá»u giÃ¡ trung bÃ¬nh
                    backgroundColor: 'rgba(153, 102, 255, 0.2)', // MÃ u ná»n cho cá»t
                    borderColor: 'rgba(153, 102, 255, 1)', // MÃ u viá»n cá»t
                    borderWidth: 1
                },
                {
                    label: 'Giáº£m GiÃ¡ Trung BÃ¬nh',
                    data: avgDiscount, // Dá»¯ liá»u giáº£m giÃ¡ trung bÃ¬nh
                    backgroundColor: 'rgba(255, 159, 64, 0.2)', // MÃ u ná»n cho cá»t
                    borderColor: 'rgba(255, 159, 64, 1)', // MÃ u viá»n cá»t
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
                        text: 'NgÃ y'
                    }
                },
                y: {
                    title: {
                        display: true,
                        text: 'GiÃ¡ trá»'
                    }
                }
            }
        }
    });
</script>

<style>
body {
    font-family: 'MyCustomFont', sans-serif;
}
</style>
</body>
</html>
