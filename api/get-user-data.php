<?php
session_start();
require_once '../includes/config.php';
require_once '../includes/functions.php';

header('Content-Type: application/json');

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(['error' => 'User not logged in']);
    exit;
}

$userId = $_SESSION['user_id'];
$type = $_GET['type'] ?? 'profile';

try {
    switch ($type) {
        case 'profile':
            $stmt = $pdo->prepare("SELECT id, name, username, email, phone, profile_image_url, last_login, created_at FROM users WHERE id = ?");
            $stmt->execute([$userId]);
            $profile = $stmt->fetch();
            echo json_encode(['success' => true, 'data' => $profile]);
            break;
            
        case 'orders':
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
            $orders = $stmt->fetchAll();
            echo json_encode(['success' => true, 'data' => $orders]);
            break;
            
        case 'inquiries':
            $stmt = $pdo->prepare("SELECT * FROM inquiries WHERE user_id = ? ORDER BY created_at DESC");
            $stmt->execute([$userId]);
            $inquiries = $stmt->fetchAll();
            echo json_encode(['success' => true, 'data' => $inquiries]);
            break;
            
        default:
            echo json_encode(['error' => 'Invalid type']);
    }
} catch (Exception $e) {
    echo json_encode(['error' => 'Failed to fetch data']);
}
?>