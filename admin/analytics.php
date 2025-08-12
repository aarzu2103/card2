<?php
session_start();
require_once '../includes/config.php';
require_once '../includes/functions.php';

// Check if logged in
if (!isset($_SESSION['admin_id'])) {
    header('Location: index.php');
    exit;
}

// Get analytics data
$analytics = getAnalyticsData();
$revenueChart = getRevenueChart(7); // Last 7 days
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics - Admin</title>
    <link rel="stylesheet" href="../assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <?php include 'includes/header.php'; ?>
    <?php include 'includes/sidebar.php'; ?>
    
    <main class="main-content">
        <div class="page-header">
            <h1><i class="fas fa-chart-bar"></i> Business Analytics</h1>
        </div>
        
        <!-- Analytics Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-calendar-day"></i>
                </div>
                <div class="stat-content">
                    <h3>₹<?php echo number_format($analytics['today']['revenue'] ?? 0); ?></h3>
                    <p>Today's Revenue</p>
                    <span class="stat-change positive">
                        <?php echo $analytics['today']['paid_orders'] ?? 0; ?> paid orders
                    </span>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-calendar-week"></i>
                </div>
                <div class="stat-content">
                    <h3>₹<?php echo number_format($analytics['week']['revenue'] ?? 0); ?></h3>
                    <p>This Week's Revenue</p>
                    <span class="stat-change positive">
                        <?php echo $analytics['week']['paid_orders'] ?? 0; ?> paid orders
                    </span>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-calendar-alt"></i>
                </div>
                <div class="stat-content">
                    <h3>₹<?php echo number_format($analytics['month']['revenue'] ?? 0); ?></h3>
                    <p>This Month's Revenue</p>
                    <span class="stat-change positive">
                        <?php echo $analytics['month']['paid_orders'] ?? 0; ?> paid orders
                    </span>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="stat-content">
                    <h3><?php echo count($analytics['top_products'] ?? []); ?></h3>
                    <p>Top Selling Products</p>
                    <span class="stat-change positive">
                        Active products
                    </span>
                </div>
            </div>
        </div>
        
        <!-- Revenue Chart -->
        <div class="dashboard-card">
            <div class="card-header">
                <h3><i class="fas fa-chart-line"></i> Revenue Trend (Last 30 Days)</h3>
            </div>
            <div class="card-content">
                <canvas id="revenueChart" width="400" height="200"></canvas>
            </div>
        </div>
        
        <!-- Top Products -->
        <div class="dashboard-card">
            <div class="card-header">
                <h3><i class="fas fa-trophy"></i> Top Selling Products</h3>
            </div>
            <div class="card-content">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Units Sold</th>
                                <th>Revenue</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($analytics['top_products'] ?? [] as $product): ?>
                            <tr>
                                <td><?php echo htmlspecialchars($product['title']); ?></td>
                                <td><?php echo $product['total_sold']; ?></td>
                                <td>₹<?php echo number_format($product['total_revenue']); ?></td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <!-- Recent Activity -->
        <div class="dashboard-card">
            <div class="card-header">
                <h3><i class="fas fa-clock"></i> Recent Activity</h3>
            </div>
            <div class="card-content">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Type</th>
                                <th>Details</th>
                                <th>Amount</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($analytics['recent_activity'] ?? [] as $activity): ?>
                            <tr>
                                <td>
                                    <span class="status status-<?php echo $activity['type']; ?>">
                                        <?php echo ucfirst($activity['type']); ?>
                                    </span>
                                </td>
                                <td><?php echo htmlspecialchars($activity['title']); ?></td>
                                <td>
                                    <?php if ($activity['amount'] > 0): ?>
                                        ₹<?php echo number_format($activity['amount']); ?>
                                    <?php else: ?>
                                        -
                                    <?php endif; ?>
                                </td>
                                <td><?php echo date('M j, Y H:i', strtotime($activity['created_at'])); ?></td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
    
    <script>
        // Revenue Chart
        const ctx = document.getElementById('revenueChart').getContext('2d');
        const revenueData = <?php echo json_encode($revenueChart); ?>;
        
        const chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: revenueData.map(item => {
                    const date = new Date(item.date);
                    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
                }),
                datasets: [{
                    label: 'Revenue (₹)',
                    data: revenueData.map(item => item.revenue),
                    borderColor: '#2563eb',
                    backgroundColor: 'rgba(37, 99, 235, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#2563eb',
                    pointBorderColor: '#ffffff',
                    pointBorderWidth: 2,
                    pointRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '₹' + value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>