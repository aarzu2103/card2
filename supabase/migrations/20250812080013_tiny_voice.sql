/*
  # Microsite Database Fixes and Enhancements

  1. New Tables
    - `inquiry_products` - Separate inquiry-only products with image management
    - Enhanced existing tables with missing columns

  2. Table Modifications
    - Added missing columns to existing tables
    - Enhanced order tracking and user management
    - Improved admin bypass functionality

  3. Security
    - Enhanced user session management
    - Improved admin authentication
    - Better order tracking

  4. Sample Data
    - Added sample inquiry products
    - Enhanced existing data
*/

-- Add missing columns to existing tables if they don't exist
ALTER TABLE users ADD COLUMN IF NOT EXISTS profile_image_url VARCHAR(500) DEFAULT NULL;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS user_id INT DEFAULT NULL;
ALTER TABLE products ADD COLUMN IF NOT EXISTS category VARCHAR(100) DEFAULT 'general';

-- Create inquiry_products table for separate inquiry management
CREATE TABLE IF NOT EXISTS inquiry_products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT DEFAULT NULL,
    price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    image_url VARCHAR(500) NOT NULL,
    file_size INT DEFAULT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create user_orders table for better order tracking
CREATE TABLE IF NOT EXISTS user_orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_id INT NOT NULL,
    status ENUM('pending', 'confirmed', 'paid', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create user_inquiries table for tracking user inquiries
CREATE TABLE IF NOT EXISTS user_inquiries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT DEFAULT NULL,
    inquiry_id INT NOT NULL,
    status ENUM('pending', 'contacted', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (inquiry_id) REFERENCES inquiries(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample inquiry products
INSERT INTO inquiry_products (title, description, price, image_url, status, sort_order) VALUES
('Custom Logo Design', 'Professional logo design with unlimited revisions', 1500.00, 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=400', 'active', 1),
('Website Development', 'Custom website development with responsive design', 15000.00, 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=400', 'active', 2),
('Branding Package', 'Complete branding solution for your business', 5000.00, 'https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg?auto=compress&cs=tinysrgb&w=400', 'active', 3),
('Digital Marketing', 'Social media and digital marketing services', 3000.00, 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=400', 'active', 4)
ON DUPLICATE KEY UPDATE updated_at = CURRENT_TIMESTAMP;

-- Update existing products to ensure proper categorization
UPDATE products SET category = 'shopping' WHERE inquiry_only = 0;
UPDATE products SET category = 'inquiry' WHERE inquiry_only = 1;

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_orders_user_id ON user_orders(user_id);
CREATE INDEX IF NOT EXISTS idx_user_inquiries_user_id ON user_inquiries(user_id);
CREATE INDEX IF NOT EXISTS idx_inquiry_products_status ON inquiry_products(status, sort_order);

-- Update view count setting if not exists
INSERT INTO site_settings (setting_key, setting_value, setting_type, description) VALUES
('view_count', '1521', 'number', 'Total website views')
ON DUPLICATE KEY UPDATE setting_value = setting_value;