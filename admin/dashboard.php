<?php
session_start();
require_once '../includes/config.php';
require_once '../includes/functions.php';

// Check if logged in
if (!isset($_SESSION['admin_id'])) {
    header('Location: index.php');
    exit;
}

// Get dashboard statistics
$stats = getDashboardStats();
$recentOrders = getOrders(5);
$recentReviews = getAllReviews();
$recentReviews = array_slice($recentReviews, 0, 5);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Admin</title>
    <link rel="stylesheet" href="../assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <?php include 'includes/header.php'; ?>
    <?php include 'includes/sidebar.php'; ?>
    
    <main class="main-content">
        <div class="page-header">
            <h1><i class="fas fa-tachometer-alt"></i> Dashboard</h1>
            <p>Welcome back, <?php echo htmlspecialchars($_SESSION['admin_username']); ?>!</p>
        </div>
        
        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon" style="background: #3b82f6;">
                    <i class="fas fa-rupee-sign"></i>
                </div>
                <div class="stat-content">
                    <h3>₹<?php echo number_format($stats['today_revenue'] ?? 0); ?></h3>
                    <p>Today's Revenue</p>
                    <span class="stat-change positive">
                        <i class="fas fa-arrow-up"></i>
                        <?php echo $stats['today_orders'] ?? 0; ?> orders
                    </span>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: #10b981;">
                    <i class="fas fa-calendar-alt"></i>
                </div>
                <div class="stat-content">
                    <h3>₹<?php echo number_format($stats['month_revenue'] ?? 0); ?></h3>
                    <p>This Month</p>
                    <span class="stat-change positive">
                        <i class="fas fa-arrow-up"></i>
                        <?php echo $stats['month_orders'] ?? 0; ?> orders
                    </span>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: #f59e0b;">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <div class="stat-content">
                    <h3><?php echo $stats['pending_orders'] ?? 0; ?></h3>
                    <p>Pending Orders</p>
                    <span class="stat-change">
                        <i class="fas fa-clock"></i>
                        Needs attention
                    </span>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon" style="background: #8b5cf6;">
                    <i class="fas fa-box"></i>
                </div>
                <div class="stat-content">
                    <h3><?php echo $stats['total_products'] ?? 0; ?></h3>
                    <p>Total Products</p>
                    <span class="stat-change positive">
                        <i class="fas fa-check"></i>
                        Active products
                    </span>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="dashboard-card">
            <div class="card-header">
                <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
            </div>
            <div class="card-content">
                <div class="quick-actions">
                    <a href="products.php" class="quick-action">
                        <i class="fas fa-plus"></i>
                        <span>Add Product</span>
                    </a>
                    <a href="orders.php" class="quick-action">
                        <i class="fas fa-shopping-cart"></i>
                        <span>View Orders</span>
                    </a>
                    <a href="reviews.php" class="quick-action">
                        <i class="fas fa-star"></i>
                        <span>Manage Reviews</span>
                    </a>
                    <a href="settings.php" class="quick-action">
                        <i class="fas fa-cog"></i>
                        <span>Settings</span>
                    </a>
                    <a href="backup.php" class="quick-action">
                        <i class="fas fa-download"></i>
                        <span>Backup</span>
                    </a>
                    <a href="../index.php" target="_blank" class="quick-action">
                        <i class="fas fa-external-link-alt"></i>
                        <span>View Website</span>
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Dashboard Grid -->
        <div class="dashboard-grid">
            <!-- Recent Orders -->
            <div class="dashboard-card">
                <div class="card-header">
                    <h3><i class="fas fa-shopping-cart"></i> Recent Orders</h3>
                    <a href="orders.php" class="btn btn-sm btn-primary">View All</a>
                </div>
                <div class="card-content">
                    <?php if (empty($recentOrders)): ?>
                        <p style="text-align: center; color: var(--admin-text-light); padding: 20px;">No orders yet</p>
                    <?php else: ?>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Order #</th>
                                        <th>Customer</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($recentOrders as $order): ?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($order['order_number']); ?></td>
                                        <td><?php echo htmlspecialchars($order['user_name'] ?: 'Guest'); ?></td>
                                        <td>₹<?php echo number_format($order['final_amount']); ?></td>
                                        <td>
                                            <span class="status status-<?php echo $order['status']; ?>">
                                                <?php echo ucfirst($order['status']); ?>
                                            </span>
                                        </td>
                                    </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                    <?php endif; ?>
                </div>
            </div>
            
            <!-- Recent Reviews -->
            <div class="dashboard-card">
                <div class="card-header">
                    <h3><i class="fas fa-star"></i> Recent Reviews</h3>
                    <a href="reviews.php" class="btn btn-sm btn-primary">View All</a>
                </div>
                <div class="card-content">
                    <?php if (empty($recentReviews)): ?>
                        <p style="text-align: center; color: var(--admin-text-light); padding: 20px;">No reviews yet</p>
                    <?php else: ?>
                        <div class="reviews-list">
                            <?php foreach ($recentReviews as $review): ?>
                            <div class="review-item" style="padding: 15px 0; border-bottom: 1px solid var(--admin-border);">
                                <div style="display: flex; justify-content: between; align-items: center; margin-bottom: 8px;">
                                    <strong><?php echo htmlspecialchars($review['name']); ?></strong>
                                    <span class="status status-<?php echo $review['status']; ?>" style="margin-left: auto;">
                                        <?php echo ucfirst($review['status']); ?>
                                    </span>
                                </div>
                                <div style="display: flex; gap: 2px; margin-bottom: 8px;">
                                    <?php for ($i = 1; $i <= 5; $i++): ?>
                                        <i class="fas fa-star" style="color: <?php echo $i <= $review['rating'] ? '#fbbf24' : '#d1d5db'; ?>; font-size: 12px;"></i>
                                    <?php endfor; ?>
                                </div>
                                <p style="font-size: 13px; color: var(--admin-text-light); line-height: 1.4;">
                                    <?php echo htmlspecialchars(substr($review['comment'], 0, 100)); ?>
                                    <?php if (strlen($review['comment']) > 100): ?>...<?php endif; ?>
                                </p>
                            </div>
                            <?php endforeach; ?>
                        </div>
                    <?php endif; ?>
                </div>
            </div>
        </div>
        
        <!-- Notifications -->
        <?php if ($stats['pending_orders'] > 0 || $stats['pending_reviews'] > 0): ?>
        <div class="dashboard-card">
            <div class="card-header">
                <h3><i class="fas fa-bell"></i> Notifications</h3>
            </div>
            <div class="card-content">
                <div class="notifications-list">
                    <?php if ($stats['pending_orders'] > 0): ?>
                    <div class="notification-item" style="padding: 15px; background: #fef3c7; border: 1px solid #fbbf24; border-radius: 8px; margin-bottom: 10px;">
                        <i class="fas fa-shopping-cart" style="color: #d97706;"></i>
                        <span style="color: #92400e; font-weight: 600;">
                            You have <?php echo $stats['pending_orders']; ?> pending order(s) that need attention
                        </span>
                        <a href="orders.php" style="color: #d97706; text-decoration: underline; margin-left: 10px;">View Orders</a>
                    </div>
                    <?php endif; ?>
                    
                    <?php if ($stats['pending_reviews'] > 0): ?>
                    <div class="notification-item" style="padding: 15px; background: #dbeafe; border: 1px solid #3b82f6; border-radius: 8px; margin-bottom: 10px;">
                        <i class="fas fa-star" style="color: #2563eb;"></i>
                        <span style="color: #1e40af; font-weight: 600;">
                            You have <?php echo $stats['pending_reviews']; ?> review(s) waiting for approval
                        </span>
                        <a href="reviews.php" style="color: #2563eb; text-decoration: underline; margin-left: 10px;">Review Now</a>
                    </div>
                    <?php endif; ?>
                </div>
            </div>
        </div>
        <?php endif; ?>
    </main>
    
    <script>
        // Auto-refresh dashboard every 30 seconds
        setInterval(() => {
            // Only refresh if user is still on the page
            if (document.visibilityState === 'visible') {
                location.reload();
            }
        }, 30000);
    </script>
</body>
</html>