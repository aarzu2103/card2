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
            $profile = getUserProfile($userId);
            echo json_encode(['success' => true, 'data' => $profile]);
            break;
            
        case 'orders':
            $orders = getUserOrdersWithItems($userId);
            echo json_encode(['success' => true, 'data' => $orders]);
            break;
            
        case 'inquiries':
            $inquiries = getUserInquiries($userId);
            echo json_encode(['success' => true, 'data' => $inquiries]);
            break;
            
        default:
            echo json_encode(['error' => 'Invalid type']);
    }
} catch (Exception $e) {
    echo json_encode(['error' => 'Failed to fetch data']);
}
?>