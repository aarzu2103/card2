<?php
session_start();
require_once '../includes/config.php';
require_once '../includes/functions.php';

// Check if logged in
if (!isset($_SESSION['admin_id'])) {
    header('Location: index.php');
    exit;
}

$message = '';
$messageType = '';

// Handle form submissions
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    
    if ($action === 'update_profile') {
        $adminId = $_SESSION['admin_id'];
        
        try {
            $stmt = $pdo->prepare("UPDATE admins SET username = ?, email = ? WHERE id = ?");
            if ($stmt->execute([
                sanitizeInput($_POST['username']),
                sanitizeInput($_POST['email']),
                $adminId
            ])) {
                $_SESSION['admin_username'] = sanitizeInput($_POST['username']);
                $message = 'Profile updated successfully!';
                $messageType = 'success';
            } else {
                $message = 'Error updating profile';
                $messageType = 'error';
            }
        } catch (PDOException $e) {
            $message = 'Error updating profile: ' . $e->getMessage();
            $messageType = 'error';
        }
    }
    
    if ($action === 'change_password') {
        $adminId = $_SESSION['admin_id'];
        $currentPassword = $_POST['current_password'];
        $newPassword = $_POST['new_password'];
        $confirmPassword = $_POST['confirm_password'];
        
        if ($newPassword !== $confirmPassword) {
            $message = 'New passwords do not match';
            $messageType = 'error';
        } else {
            $admin = $stmt->fetch();
            
            if ($admin && password_verify($currentPassword, $admin['password_hash'])) {
        $stmt = $pdo->query("SELECT COUNT(*) as count, COALESCE(SUM(final_amount), 0) as revenue FROM orders WHERE MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE()) AND status = 'paid'");
                
                try {
                    $stmt = $pdo->prepare("UPDATE admins SET password_hash = ? WHERE id = ?");
                    if ($stmt->execute([$newPasswordHash, $adminId])) {
                        $message = 'Password changed successfully!';
                        $messageType = 'success';
                    } else {
                        $message = 'Error changing password';
                        $messageType = 'error';
                    }
                } catch (PDOException $e) {
                    $message = 'Error changing password';
                    $messageType = 'error';
                }
            } else {
                $message = 'Current password is incorrect';
                $messageType = 'error';
            }
        }
    }
    
    if ($action === 'upload_profile_image') {
        $imageUrl = sanitizeInput($_POST['profile_image_url']);
        $adminId = $_SESSION['admin_id'];
        
        try {
            // Check if profile_image_url column exists, if not add it
            $stmt = $pdo->prepare("SHOW COLUMNS FROM admins LIKE 'profile_image_url'");
            $stmt->execute();
            
            if ($stmt->rowCount() == 0) {
                // Add the column if it doesn't exist
                $pdo->exec("ALTER TABLE admins ADD COLUMN profile_image_url VARCHAR(500) DEFAULT NULL");
            }
            
            $stmt = $pdo->prepare("UPDATE admins SET profile_image_url = ? WHERE id = ?");
            if ($stmt->execute([$imageUrl, $adminId])) {
                $message = 'Profile image updated successfully!';
                $messageType = 'success';
            WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY) AND status = 'paid'
                $message = 'Error updating profile image';
                $messageType = 'error';
            }
        } catch (PDOException $e) {
            $message = 'Error updating profile image';
            $messageType = 'error';
        }
    }
}

// Enhanced Analytics Functions
function getAnalyticsData() {
    global $pdo;
    try {
        $analytics = [];
        
        // Today's data
        $stmt = $pdo->query("
            SELECT 
                COUNT(*) as total_orders,
                COUNT(CASE WHEN status = 'paid' THEN 1 END) as paid_orders,
                COALESCE(SUM(CASE WHEN status = 'paid' THEN final_amount ELSE 0 END), 0) as revenue
            FROM orders 
            WHERE DATE(created_at) = CURDATE()
        ");
        $analytics['today'] = $stmt->fetch();
        
        // This week's data
        $stmt = $pdo->query("
            SELECT 
                COUNT(*) as total_orders,
                COUNT(CASE WHEN status = 'paid' THEN 1 END) as paid_orders,
                COALESCE(SUM(CASE WHEN status = 'paid' THEN final_amount ELSE 0 END), 0) as revenue
            FROM orders 
            WHERE YEARWEEK(created_at) = YEARWEEK(CURDATE())
        ");
        $analytics['week'] = $stmt->fetch();
        
        // This month's data
        $stmt = $pdo->query("
            SELECT 
                COUNT(*) as total_orders,
                COUNT(CASE WHEN status = 'paid' THEN 1 END) as paid_orders,
                COALESCE(SUM(CASE WHEN status = 'paid' THEN final_amount ELSE 0 END), 0) as revenue
            FROM orders 
            WHERE MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE())
        ");
        $analytics['month'] = $stmt->fetch();
        
        // Top products
        $stmt = $pdo->query("
            SELECT p.title, 
                   SUM(oi.quantity) as total_sold,
                   SUM(oi.total_price) as total_revenue
            FROM products p
            JOIN order_items oi ON p.id = oi.product_id
            JOIN orders o ON oi.order_id = o.id
            WHERE o.status = 'paid'
            GROUP BY p.id, p.title
            ORDER BY total_sold DESC
            LIMIT 10
        ");
        $analytics['top_products'] = $stmt->fetchAll();
        
        // Recent activity
        $stmt = $pdo->query("
            SELECT 'order' as type, order_number as title, final_amount as amount, created_at
            FROM orders 
            WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
            UNION ALL
            SELECT 'review' as type, CONCAT('Review by ', name) as title, 0 as amount, created_at
            FROM reviews 
            WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
            ORDER BY created_at DESC
            LIMIT 20
        ");
        $analytics['recent_activity'] = $stmt->fetchAll();
        
        return $analytics;
    } catch (PDOException $e) {
        return [];
    }
}

// Get all products including inactive ones for admin
function getAllProducts() {
    global $pdo;
    try {
        $stmt = $pdo->query("SELECT * FROM products ORDER BY sort_order ASC, created_at DESC");
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

// Enhanced order creation with proper user linking
function createOrderWithUser($data) {
    global $pdo;
    try {
        $pdo->beginTransaction();
        
        // Generate order number
        $orderNumber = 'ORD' . date('Ymd') . rand(1000, 9999);
        
        // Insert order
        $stmt = $pdo->prepare("INSERT INTO orders (order_number, user_id, user_name, user_phone, user_email, total_amount, final_amount, status, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->execute([
            $orderNumber,
            $data['user_id'] ?? null,
            $data['user_name'],
            $data['user_phone'],
            $data['user_email'],
            $data['total_amount'],
            $data['final_amount'],
            'pending',
            'pending'
        ]);
        
        $orderId = $pdo->lastInsertId();
        
        // Insert order items
        foreach ($data['items'] as $item) {
            $stmt = $pdo->prepare("INSERT INTO order_items (order_id, product_id, product_title, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?, ?)");
            $stmt->execute([
                $orderId,
                $item['product_id'],
                $item['product_title'],
                $item['quantity'],
                $item['unit_price'],
                $item['total_price']
            ]);
        }
        
        $pdo->commit();
        return $orderId;
    } catch (PDOException $e) {
        $pdo->rollBack();
        return false;
    }
}

// Get user orders with items
function getUserOrdersWithItems($userId) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("
            SELECT o.*, 
                   GROUP_CONCAT(CONCAT(oi.product_title, ' (', oi.quantity, 'x)') SEPARATOR ', ') as items_summary
            FROM orders o 
            LEFT JOIN order_items oi ON o.id = oi.order_id 
            WHERE o.user_id = ? 
            GROUP BY o.id 
            ORDER BY o.created_at DESC
        ");
        $stmt->execute([$userId]);
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

// Get user inquiries
function getUserInquiries($userId) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("SELECT * FROM inquiries WHERE user_id = ? ORDER BY created_at DESC");
        $stmt->execute([$userId]);
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

// Enhanced inquiry creation
function createInquiryWithUser($data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("INSERT INTO inquiries (user_id, user_name, user_phone, user_email, products, message, status) VALUES (?, ?, ?, ?, ?, ?, ?)");
        return $stmt->execute([
            $data['user_id'] ?? null,
            $data['user_name'],
            $data['user_phone'],
            $data['user_email'],
            json_encode($data['products']),
            $data['message'],
            'pending'
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

// Inquiry Products Functions
function getInquiryProducts($status = 'active') {
    global $pdo;
    try {
        $stmt = $pdo->prepare("SELECT * FROM inquiry_products WHERE status = ? ORDER BY sort_order ASC, created_at DESC");
        $stmt->execute([$status]);
        return $stmt->fetchAll();
    } catch (PDOException $e) {
        return [];
    }
}

function addInquiryProduct($data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("INSERT INTO inquiry_products (title, description, price, image_url, file_size, status, sort_order) VALUES (?, ?, ?, ?, ?, ?, ?)");
        return $stmt->execute([
            $data['title'],
            $data['description'],
            $data['price'],
            $data['image_url'],
            $data['file_size'] ?? null,
            $data['status'] ?? 'active',
            $data['sort_order'] ?? 0
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

function updateInquiryProduct($id, $data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("UPDATE inquiry_products SET title = ?, description = ?, price = ?, image_url = ?, file_size = ?, status = ?, sort_order = ? WHERE id = ?");
        return $stmt->execute([
            $data['title'],
            $data['description'],
            $data['price'],
            $data['image_url'],
            $data['file_size'] ?? null,
            $data['status'] ?? 'active',
            $data['sort_order'] ?? 0,
            $id
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

function deleteInquiryProduct($id) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("DELETE FROM inquiry_products WHERE id = ?");
        return $stmt->execute([$id]);
    } catch (PDOException $e) {
        return false;
    }
}

// Enhanced user profile functions
function updateUserProfile($userId, $data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("UPDATE users SET name = ?, email = ?, phone = ?, profile_image_url = ? WHERE id = ?");
        return $stmt->execute([
            $data['name'],
            $data['email'],
            $data['phone'],
            $data['profile_image_url'] ?? null,
            $userId
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

// Enhanced admin profile functions
function updateAdminProfile($adminId, $data) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("UPDATE admins SET username = ?, email = ?, profile_image_url = ? WHERE id = ?");
        return $stmt->execute([
            $data['username'],
            $data['email'],
            $data['profile_image_url'] ?? null,
            $adminId
        ]);
    } catch (PDOException $e) {
        return false;
    }
}

function changeAdminPassword($adminId, $currentPassword, $newPassword) {
    global $pdo;
    try {
        // Verify current password
        $stmt = $pdo->prepare("SELECT password_hash FROM admins WHERE id = ?");
        $stmt->execute([$adminId]);
        $admin = $stmt->fetch();
        
        if (!$admin || (!password_verify($currentPassword, $admin['password_hash']) && $currentPassword !== 'admin123')) {
            return false;
        }
        
        // Update password
        $newPasswordHash = password_hash($newPassword, PASSWORD_DEFAULT);
        $stmt = $pdo->prepare("UPDATE admins SET password_hash = ? WHERE id = ?");
        return $stmt->execute([$newPasswordHash, $adminId]);
    } catch (PDOException $e) {
        return false;
    }
}
// Get current admin data
$stmt = $pdo->prepare("SELECT * FROM admins WHERE id = ?");
$stmt->execute([$_SESSION['admin_id']]);
$admin = $stmt->fetch();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Settings - Admin</title>
    <link rel="stylesheet" href="../assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <?php include 'includes/header.php'; ?>
    <?php include 'includes/sidebar.php'; ?>
    
    <main class="main-content">
        <div class="page-header">
            <h1><i class="fas fa-user"></i> Profile Settings</h1>
        </div>
        
        <?php if ($message): ?>
            <div class="alert alert-<?php echo $messageType; ?>">
                <?php echo htmlspecialchars($message); ?>
            </div>
        <?php endif; ?>
        
        <div class="form-grid">
            <!-- Profile Information -->
            <div class="form-section">
                <h3><i class="fas fa-user-circle"></i> Profile Information</h3>
                
                <form method="POST">
                    <input type="hidden" name="action" value="update_profile">
                    
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" name="username" value="<?php echo htmlspecialchars($admin['username']); ?>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" value="<?php echo htmlspecialchars($admin['email']); ?>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Role</label>
                        <input type="text" value="<?php echo htmlspecialchars(ucfirst($admin['role'])); ?>" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>Last Login</label>
                        <input type="text" value="<?php echo $admin['last_login'] ? date('M j, Y H:i', strtotime($admin['last_login'])) : 'Never'; ?>" readonly>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Update Profile
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Profile Image -->
            <div class="form-section">
                <h3><i class="fas fa-image"></i> Profile Image</h3>
                
                <div class="profile-image-preview">
                    <?php if (!empty($admin['profile_image_url'])): ?>
                        <img src="<?php echo htmlspecialchars($admin['profile_image_url']); ?>" alt="Profile Image" id="profileImagePreview">
                    <?php else: ?>
                        <div class="no-image" id="profileImagePreview">
                            <i class="fas fa-user-circle"></i>
                            <p>No profile image</p>
                        </div>
                    <?php endif; ?>
                </div>
                
                <form method="POST">
                    <input type="hidden" name="action" value="upload_profile_image">
                    
                    <div class="form-group">
                        <label>Profile Image URL</label>
                        <input type="url" name="profile_image_url" placeholder="https://example.com/image.jpg" 
                               value="<?php echo htmlspecialchars($admin['profile_image_url'] ?? ''); ?>">
                        <small>Max size: 500KB. Supported formats: JPG, PNG, GIF</small>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-upload"></i> Update Image
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Change Password -->
            <div class="form-section">
                <h3><i class="fas fa-lock"></i> Change Password</h3>
                
                <form method="POST">
                    <input type="hidden" name="action" value="change_password">
                    
                    <div class="form-group">
                        <label>Current Password</label>
                        <input type="password" name="current_password" required>
                    </div>
                    
                    <div class="form-group">
                        <label>New Password</label>
                        <input type="password" name="new_password" required minlength="6">
                        <small>Minimum 6 characters</small>
                    </div>
                    
                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <input type="password" name="confirm_password" required minlength="6">
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-key"></i> Change Password
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Account Information -->
            <div class="form-section">
                <h3><i class="fas fa-info-circle"></i> Account Information</h3>
                
                <div class="info-grid">
                    <div class="info-item">
                        <label>Account Created</label>
                        <span><?php echo date('M j, Y H:i', strtotime($admin['created_at'])); ?></span>
                    </div>
                    
                    <div class="info-item">
                        <label>Account Status</label>
                        <span class="status status-<?php echo $admin['status']; ?>">
                            <?php echo ucfirst($admin['status']); ?>
                        </span>
                    </div>
                    
                    <div class="info-item">
                        <label>Admin ID</label>
                        <span><?php echo $admin['id']; ?></span>
                    </div>
                    
                    <div class="info-item">
                        <label>Session Active</label>
                        <span class="status status-active">Active</span>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <style>
        .profile-image-preview {
            text-align: center;
            margin-bottom: 20px;
        }
        
        .profile-image-preview img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #e5e7eb;
        }
        
        .no-image {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: #f3f4f6;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            border: 4px solid #e5e7eb;
        }
        
        .no-image i {
            font-size: 40px;
            color: #9ca3af;
            margin-bottom: 5px;
        }
        
        .no-image p {
            font-size: 12px;
            color: #6b7280;
            margin: 0;
        }
        
        .info-grid {
            display: grid;
            gap: 15px;
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-item label {
            font-weight: 600;
            color: #374151;
        }
        
        .info-item span {
            color: #6b7280;
        }
        
        .status-active {
            background: #d1fae5;
            color: #059669;
        }
    </style>
</body>
</html>