/*
  # Fix Microsite Database Issues

  1. Table Modifications
    - Add missing columns to existing tables
    - Create inquiry_products table for separate inquiry management
    - Fix user_id column in inquiries table

  2. Enhanced Features
    - Better order tracking
    - User profile management
    - Admin profile image support

  3. Data Integrity
    - Proper foreign key relationships
    - Enhanced indexes for performance
*/

-- Add missing columns to existing tables if they don't exist
ALTER TABLE inquiries ADD COLUMN IF NOT EXISTS user_id INT DEFAULT NULL;
ALTER TABLE inquiries ADD COLUMN IF NOT EXISTS ip_address VARCHAR(45) DEFAULT NULL;

-- Add foreign key for inquiries user_id if not exists
ALTER TABLE inquiries ADD CONSTRAINT fk_inquiries_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;

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

-- Insert sample inquiry products
INSERT INTO inquiry_products (title, description, price, image_url, file_size, status, sort_order) VALUES
('Custom Logo Design', 'Professional logo design with unlimited revisions', 1500.00, 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=400', 150000, 'active', 1),
('Website Development', 'Custom website development with responsive design', 15000.00, 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=400', 180000, 'active', 2),
('Branding Package', 'Complete branding solution for your business', 5000.00, 'https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg?auto=compress&cs=tinysrgb&w=400', 160000, 'active', 3),
('Digital Marketing', 'Social media and digital marketing services', 3000.00, 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=400', 170000, 'active', 4)
ON DUPLICATE KEY UPDATE updated_at = CURRENT_TIMESTAMP;

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_inquiry_products_status ON inquiry_products(status, sort_order);
CREATE INDEX IF NOT EXISTS idx_inquiries_user_id ON inquiries(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);

-- Update existing data to ensure consistency
UPDATE orders SET payment_status = 'pending' WHERE payment_status IS NULL;
UPDATE products SET sort_order = id WHERE sort_order IS NULL OR sort_order = 0;
UPDATE inquiry_products SET sort_order = id WHERE sort_order IS NULL OR sort_order = 0;