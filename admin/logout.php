<?php
session_start();
require_once '../includes/config.php';
require_once '../includes/functions.php';

// Clear all session data
session_unset();
session_destroy();

// Clear any cookies
if (isset($_COOKIE[session_name()])) {
    setcookie(session_name(), '', time() - 3600, '/');
}

// Clear any remember me cookies if they exist
if (isset($_COOKIE['admin_remember'])) {
    setcookie('admin_remember', '', time() - 3600, '/');
}

// Redirect to login page
header('Location: index.php?logged_out=1');
exit;
?>