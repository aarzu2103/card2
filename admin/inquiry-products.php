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
    
    if ($action === 'add_inquiry_product') {
        $productData = [
            'title' => sanitizeInput($_POST['title']),
            'description' => sanitizeInput($_POST['description']),
            'price' => floatval($_POST['price']),
            'image_url' => sanitizeInput($_POST['image_url']),
            'file_size' => intval($_POST['file_size']),
            'status' => $_POST['status'] ?? 'active',
            'sort_order' => intval($_POST['sort_order'])
        ];
        
        // Validate file size (200KB limit)
        if ($productData['file_size'] > 204800) {
            $message = 'Image file size must be under 200KB';
            $messageType = 'error';
        } else {
            if (addInquiryProduct($productData)) {
                $message = 'Inquiry product added successfully!';
                $messageType = 'success';
            } else {
                $message = 'Error adding inquiry product';
                $messageType = 'error';
            }
        }
    }
    
    if ($action === 'update_inquiry_product') {
        $productId = intval($_POST['product_id']);
        $productData = [
            'title' => sanitizeInput($_POST['title']),
            'description' => sanitizeInput($_POST['description']),
            'price' => floatval($_POST['price']),
            'image_url' => sanitizeInput($_POST['image_url']),
            'file_size' => intval($_POST['file_size']),
            'status' => $_POST['status'] ?? 'active',
            'sort_order' => intval($_POST['sort_order'])
        ];
        
        // Validate file size (200KB limit)
        if ($productData['file_size'] > 204800) {
            $message = 'Image file size must be under 200KB';
            $messageType = 'error';
        } else {
            if (updateInquiryProduct($productId, $productData)) {
                $message = 'Inquiry product updated successfully!';
                $messageType = 'success';
            } else {
                $message = 'Error updating inquiry product';
                $messageType = 'error';
            }
        }
    }
    
    if ($action === 'delete_inquiry_product') {
        $productId = intval($_POST['product_id']);
        
        if (deleteInquiryProduct($productId)) {
            $message = 'Inquiry product deleted successfully!';
            $messageType = 'success';
        } else {
            $message = 'Error deleting inquiry product';
            $messageType = 'error';
        }
    }
}

// Get all inquiry products
$inquiryProducts = getInquiryProducts('all');
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inquiry Products - Admin</title>
    <link rel="stylesheet" href="../assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <?php include 'includes/header.php'; ?>
    <?php include 'includes/sidebar.php'; ?>
    
    <main class="main-content">
        <div class="page-header">
            <h1><i class="fas fa-question-circle"></i> Inquiry Products Management</h1>
            <button class="btn btn-primary" onclick="showAddProductModal()">
                <i class="fas fa-plus"></i> Add Inquiry Product
            </button>
        </div>
        
        <?php if ($message): ?>
            <div class="alert alert-<?php echo $messageType; ?>">
                <?php echo htmlspecialchars($message); ?>
            </div>
        <?php endif; ?>
        
        <div class="dashboard-card">
            <div class="card-header">
                <h3>Inquiry-Only Products</h3>
                <p>Products that customers can inquire about (no direct purchase)</p>
            </div>
            <div class="card-content">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Image</th>
                                <th>Title</th>
                                <th>Price</th>
                                <th>File Size</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($inquiryProducts as $product): ?>
                            <tr>
                                <td>
                                    <img src="<?php echo htmlspecialchars($product['image_url']); ?>" 
                                         alt="Product" style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px;">
                                </td>
                                <td><?php echo htmlspecialchars($product['title']); ?></td>
                                <td>₹<?php echo number_format($product['price']); ?></td>
                                <td>
                                    <?php 
                                    $sizeKB = $product['file_size'] ? round($product['file_size'] / 1024, 1) : 0;
                                    echo $sizeKB . ' KB';
                                    ?>
                                </td>
                                <td>
                                    <span class="status status-<?php echo $product['status']; ?>">
                                        <?php echo ucfirst($product['status']); ?>
                                    </span>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-primary" onclick="editProduct(<?php echo $product['id']; ?>)">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-danger" onclick="deleteProduct(<?php echo $product['id']; ?>)">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
    
    <!-- Add Product Modal -->
    <div id="addProductModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Add New Inquiry Product</h3>
                <button class="close-modal" onclick="closeModal('addProductModal')">&times;</button>
            </div>
            <form method="POST">
                <input type="hidden" name="action" value="add_inquiry_product">
                
                <div class="form-group">
                    <label>Product Title</label>
                    <input type="text" name="title" required>
                </div>
                
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="3"></textarea>
                </div>
                
                <div class="form-group">
                    <label>Price (₹)</label>
                    <input type="number" name="price" step="0.01" required>
                </div>
                
                <div class="form-group">
                    <label>Image URL</label>
                    <input type="url" name="image_url" required>
                    <small>Supported formats: JPG, PNG, GIF. Max size: 200KB</small>
                </div>
                
                <div class="form-group">
                    <label>File Size (bytes)</label>
                    <input type="number" name="file_size" max="204800" required>
                    <small>Maximum 200KB (204,800 bytes)</small>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Sort Order</label>
                        <input type="number" name="sort_order" value="0">
                    </div>
                    
                    <div class="form-group">
                        <label>Status</label>
                        <select name="status">
                            <option value="active">Active</option>
                            <option value="inactive">Inactive</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Add Product</button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal('addProductModal')">Cancel</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Edit Product Modal -->
    <div id="editProductModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Inquiry Product</h3>
                <button class="close-modal" onclick="closeModal('editProductModal')">&times;</button>
            </div>
            <form method="POST">
                <input type="hidden" name="action" value="update_inquiry_product">
                <input type="hidden" name="product_id" id="editProductId">
                
                <div class="form-group">
                    <label>Product Title</label>
                    <input type="text" name="title" id="editTitle" required>
                </div>
                
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" id="editDescription" rows="3"></textarea>
                </div>
                
                <div class="form-group">
                    <label>Price (₹)</label>
                    <input type="number" name="price" id="editPrice" step="0.01" required>
                </div>
                
                <div class="form-group">
                    <label>Image URL</label>
                    <input type="url" name="image_url" id="editImageUrl" required>
                </div>
                
                <div class="form-group">
                    <label>File Size (bytes)</label>
                    <input type="number" name="file_size" id="editFileSize" max="204800" required>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Sort Order</label>
                        <input type="number" name="sort_order" id="editSortOrder">
                    </div>
                    
                    <div class="form-group">
                        <label>Status</label>
                        <select name="status" id="editStatus">
                            <option value="active">Active</option>
                            <option value="inactive">Inactive</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Update Product</button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal('editProductModal')">Cancel</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function showAddProductModal() {
            document.getElementById('addProductModal').style.display = 'block';
        }
        
        function editProduct(productId) {
            const products = <?php echo json_encode($inquiryProducts); ?>;
            const product = products.find(p => p.id == productId);
            
            if (product) {
                document.getElementById('editProductId').value = product.id;
                document.getElementById('editTitle').value = product.title;
                document.getElementById('editDescription').value = product.description || '';
                document.getElementById('editPrice').value = product.price;
                document.getElementById('editImageUrl').value = product.image_url;
                document.getElementById('editFileSize').value = product.file_size || 0;
                document.getElementById('editSortOrder').value = product.sort_order;
                document.getElementById('editStatus').value = product.status;
                
                document.getElementById('editProductModal').style.display = 'block';
            }
        }
        
        function deleteProduct(productId) {
            if (confirm('Are you sure you want to delete this inquiry product?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.innerHTML = `
                    <input type="hidden" name="action" value="delete_inquiry_product">
                    <input type="hidden" name="product_id" value="${productId}">
                `;
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modals = document.querySelectorAll('.modal');
            modals.forEach(modal => {
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>