/*
  # FINAL & VERIFIED Microsite Database Schema

  Instructions for a successful import:
  1. **CRITICAL FIRST STEP**: Drop all existing tables from your database to ensure a clean install.
  2. In phpMyAdmin, select your database (e.g., u261459251_wap).
  3. Go to the 'SQL' or 'Import' tab and execute this entire script.

  All Fixes Applied:
  - Removed 'CREATE DATABASE' / 'USE' commands for compatibility.
  - Added the missing 'updated_at' column to the 'reviews' table.
  - Added the missing 'updated_at' column to the 'gallery' table.
*/

-- Admins table
CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'manager', 'editor') DEFAULT 'admin',
    status ENUM('active', 'inactive') DEFAULT 'active',
    profile_image_url VARCHAR(500) DEFAULT NULL,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) DEFAULT NULL,
    password_hash VARCHAR(255) NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    email_verified BOOLEAN DEFAULT FALSE,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Products table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT DEFAULT NULL,
    price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    discount_price DECIMAL(10,2) DEFAULT NULL,
    qty_stock INT DEFAULT 0,
    image_url VARCHAR(500) NOT NULL,
    gallery_images JSON DEFAULT NULL,
    inquiry_only BOOLEAN DEFAULT FALSE,
    status ENUM('active', 'inactive') DEFAULT 'active',
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    user_id INT DEFAULT NULL,
    user_name VARCHAR(100) DEFAULT NULL,
    user_phone VARCHAR(20) DEFAULT NULL,
    user_email VARCHAR(100) DEFAULT NULL,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    final_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    status ENUM('pending', 'confirmed', 'paid', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    payment_status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
    payment_method VARCHAR(50) DEFAULT 'upi',
    notes TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Order items table
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    product_title VARCHAR(200) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Reviews table
CREATE TABLE IF NOT EXISTS reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) DEFAULT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    ip_address VARCHAR(45) DEFAULT NULL,
    approved_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Videos table
CREATE TABLE IF NOT EXISTS videos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT DEFAULT NULL,
    youtube_url VARCHAR(500) NOT NULL,
    embed_code VARCHAR(500) DEFAULT NULL,
    thumbnail_url VARCHAR(500) DEFAULT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    sort_order INT DEFAULT 0,
    view_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Banners table
CREATE TABLE IF NOT EXISTS banners (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) DEFAULT NULL,
    image_url VARCHAR(500) NOT NULL,
    link_url VARCHAR(500) DEFAULT NULL,
    position ENUM('top', 'bottom', 'both') DEFAULT 'both',
    status ENUM('active', 'inactive') DEFAULT 'active',
    sort_order INT DEFAULT 0,
    click_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- PDFs table
CREATE TABLE IF NOT EXISTS pdfs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT DEFAULT NULL,
    file_url VARCHAR(500) NOT NULL,
    file_size INT DEFAULT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    sort_order INT DEFAULT 0,
    download_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Site settings table
CREATE TABLE IF NOT EXISTS site_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT DEFAULT NULL,
    setting_type ENUM('text', 'number', 'boolean', 'json') DEFAULT 'text',
    description TEXT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Translations table
CREATE TABLE IF NOT EXISTS translations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    language_code VARCHAR(5) NOT NULL,
    translation_key VARCHAR(100) NOT NULL,
    translation_value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_translation (language_code, translation_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Gallery table (FIXED)
CREATE TABLE IF NOT EXISTS gallery (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) DEFAULT NULL,
    description TEXT DEFAULT NULL,
    image_url VARCHAR(500) NOT NULL,
    thumbnail_url VARCHAR(500) DEFAULT NULL,
    alt_text VARCHAR(200) DEFAULT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    sort_order INT DEFAULT 0,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Visits table
CREATE TABLE IF NOT EXISTS visits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    page VARCHAR(100) NOT NULL DEFAULT 'home',
    ip_address VARCHAR(45) NOT NULL,
    user_agent TEXT DEFAULT NULL,
    referer VARCHAR(500) DEFAULT NULL,
    visit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Transactions table
CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    transaction_id VARCHAR(100) UNIQUE DEFAULT NULL,
    upi_id VARCHAR(100) DEFAULT NULL,
    amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    status ENUM('pending', 'success', 'failed', 'cancelled') DEFAULT 'pending',
    payment_method VARCHAR(50) DEFAULT 'upi',
    gateway_response JSON DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Inquiries table
CREATE TABLE IF NOT EXISTS inquiries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    user_phone VARCHAR(20) DEFAULT NULL,
    user_email VARCHAR(100) DEFAULT NULL,
    products JSON NOT NULL,
    message TEXT DEFAULT NULL,
    status ENUM('pending', 'contacted', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Free website requests table
CREATE TABLE IF NOT EXISTS free_website_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    mobile VARCHAR(20) NOT NULL,
    email VARCHAR(100) DEFAULT NULL,
    business_details TEXT DEFAULT NULL,
    status ENUM('pending', 'contacted', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Admin bypass tokens table
CREATE TABLE IF NOT EXISTS admin_bypass_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT NOT NULL,
    token VARCHAR(64) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admins(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sample Data Inserts

INSERT INTO admins (username, email, password_hash, role, status) VALUES 
('admin', 'admin@demo.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'active')
ON DUPLICATE KEY UPDATE password_hash = '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi';

INSERT INTO products (title, description, price, discount_price, qty_stock, image_url, inquiry_only, status, sort_order) VALUES
('Premium Business Card', 'High-quality business cards with premium finish and professional design', 500.00, 399.00, 100, 'https://images.pexels.com/photos/6289065/pexels-photo-6289065.jpeg?auto=compress&cs=tinysrgb&w=400', FALSE, 'active', 1),
('Digital Visiting Card', 'Modern digital visiting card solution with QR code and social media integration', 299.00, NULL, 50, 'https://images.pexels.com/photos/6289025/pexels-photo-6289025.jpeg?auto=compress&cs=tinysrgb&w=400', FALSE, 'active', 2),
('Corporate Branding Package', 'Complete corporate branding solution including logo, letterhead, and business cards', 2999.00, 1999.00, 20, 'https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg?auto=compress&cs=tinysrgb&w=400', FALSE, 'active', 3),
('Logo Design Service', 'Professional logo design service with unlimited revisions', 1500.00, NULL, 0, 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=400', TRUE, 'active', 4),
('Website Development', 'Custom website development with responsive design and SEO optimization', 15000.00, 12000.00, 0, 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=400', TRUE, 'active', 5)
ON DUPLICATE KEY UPDATE updated_at = CURRENT_TIMESTAMP;

INSERT INTO reviews (name, email, phone, rating, comment, status, approved_at) VALUES
('Rajesh Kumar', 'rajesh@example.com', '9876543210', 5, 'Excellent service and professional quality work. Highly recommended for business cards!', 'approved', NOW()),
('Priya Singh', 'priya@example.com', '9876543211', 4, 'Great experience with their team. Very responsive and helpful throughout the process.', 'approved', NOW()),
('Amit Patel', 'amit@example.com', '9876543212', 5, 'Outstanding digital visiting card service. Modern design and quick delivery.', 'approved', NOW()),
('Sneha Sharma', 'sneha@example.com', '9876543213', 4, 'Professional branding package exceeded my expectations. Worth every penny!', 'approved', NOW())
ON DUPLICATE KEY UPDATE updated_at = CURRENT_TIMESTAMP;

INSERT INTO videos (title, description, youtube_url, embed_code, status, sort_order) VALUES
('Company Introduction', 'Learn about our company and services', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'https://www.youtube.com/embed/dQw4w9WgXcQ', 'active', 1),
('Product Showcase', 'Showcase of our premium products and services', 'https://www.youtube.com/watch?v=jNQXAC9IVRw', 'https://www.youtube.com/embed/jNQXAC9IVRw', 'active', 2),
('Customer Testimonials', 'What our customers say about our services', 'https://www.youtube.com/watch?v=9bZkp7q19f0', 'https://www.youtube.com/embed/9bZkp7q19f0', 'active', 3)
ON DUPLICATE KEY UPDATE updated_at = CURRENT_TIMESTAMP;

INSERT INTO banners (title, image_url, link_url, position, status, sort_order) VALUES
('Special Offer Banner', 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=800&h=200', 'https://example.com/offer', 'both', 'active', 1),
('New Products Banner', 'https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=800&h=200', 'https://example.com/products', 'both', 'active', 2),
('Contact Us Banner', 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=800&h=200', 'https://example.com/contact', 'both', 'active', 3)
ON DUPLICATE KEY UPDATE updated_at = CURRENT_TIMESTAMP;

INSERT INTO pdfs (title, description, file_url, file_size, status, sort_order) VALUES
('Company Brochure', 'Download our complete company brochure', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1024000, 'active', 1),
('Product Catalog', 'Complete catalog of all our products and services', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 2048000, 'active', 2),
('Price List', 'Current pricing for all products and services', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 512000, 'active', 3),
('Company Profile', 'Detailed company profile and credentials', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 1536000, 'active', 4),
('Portfolio', 'Portfolio of our completed projects', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 3072000, 'active', 5)
ON DUPLICATE KEY UPDATE updated_at = CURRENT_TIMESTAMP;

INSERT INTO gallery (title, description, image_url, thumbnail_url, alt_text, status, sort_order) VALUES
('Office Interior', 'Our modern office space', 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=300', 'Modern office interior', 'active', 1),
('Team Meeting', 'Our professional team in action', 'https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=300', 'Team meeting', 'active', 2),
('Product Display', 'Our premium products showcase', 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=300', 'Product display', 'active', 3),
('Workshop', 'Behind the scenes of our production', 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=300', 'Production workshop', 'active', 4)
ON DUPLICATE KEY UPDATE updated_at = CURRENT_TIMESTAMP;

INSERT INTO site_settings (setting_key, setting_value, setting_type, description) VALUES
('site_title', 'DEMO CARD - Professional Visiting Card', 'text', 'Website title'),
('company_name', 'DEMO CARD', 'text', 'Company name'),
('director_name', 'Vishal Rathod', 'text', 'Director name'),
('director_title', 'FOUNDER', 'text', 'Director title'),
('contact_phone1', '9765834383', 'text', 'Primary phone number'),
('contact_phone2', '9765834383', 'text', 'Secondary phone number'),
('contact_email', 'info@galaxytribes.in', 'text', 'Contact email'),
('contact_address', 'Nashik, Maharashtra, India', 'text', 'Business address'),
('whatsapp_number', '919765834383', 'text', 'WhatsApp number with country code'),
('website_url', 'https://galaxytribes.in', 'text', 'Website URL'),
('upi_id', 'demo@upi', 'text', 'UPI ID for payments'),
('meta_description', 'Professional digital visiting card and business services. Get your custom business card, logo design, and corporate branding solutions.', 'text', 'Meta description for SEO'),
('meta_keywords', 'visiting card, business card, digital card, logo design, branding, corporate identity', 'text', 'Meta keywords for SEO'),
('current_theme', 'blue-dark', 'text', 'Current website theme'),
('discount_text', 'DISCOUNT UPTO 50% Live Use FREE code', 'text', 'Discount popup text'),
('show_discount_popup', '0', 'boolean', 'Show discount popup'),
('show_pwa_prompt', '0', 'boolean', 'Show PWA install prompt'),
('social_facebook', 'https://facebook.com/demo', 'text', 'Facebook page URL'),
('social_youtube', 'https://youtube.com/demo', 'text', 'YouTube channel URL'),
('social_twitter', 'https://twitter.com/demo', 'text', 'Twitter profile URL'),
('social_instagram', 'https://instagram.com/demo', 'text', 'Instagram profile URL'),
('social_linkedin', 'https://linkedin.com/company/demo', 'text', 'LinkedIn page URL'),
('social_pinterest', 'https://pinterest.com/demo', 'text', 'Pinterest profile URL'),
('social_telegram', 'https://t.me/demo', 'text', 'Telegram channel URL'),
('social_zomato', 'https://zomato.com/demo', 'text', 'Zomato restaurant URL')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

INSERT INTO translations (language_code, translation_key, translation_value) VALUES
('en', 'welcome', 'Welcome'), ('en', 'home', 'Home'), ('en', 'about', 'About Us'), ('en', 'products', 'Products'), ('en', 'contact', 'Contact'), ('en', 'gallery', 'Gallery'), ('en', 'videos', 'Videos'), ('en', 'reviews', 'Reviews'), ('en', 'cart', 'Cart'), ('en', 'add_to_cart', 'Add to Cart'), ('en', 'inquiry', 'Inquiry'),
('hi', 'welcome', 'स्वागत'), ('hi', 'home', 'होम'), ('hi', 'about', 'हमारे बारे में'), ('hi', 'products', 'उत्पाद'), ('hi', 'contact', 'संपर्क'), ('hi', 'gallery', 'गैलरी'), ('hi', 'videos', 'वीडियो'), ('hi', 'reviews', 'समीक्षा'), ('hi', 'cart', 'कार्ट'), ('hi', 'add_to_cart', 'कार्ट में जोड़ें'), ('hi', 'inquiry', 'पूछताछ')
ON DUPLICATE KEY UPDATE translation_value = VALUES(translation_value);

INSERT INTO visits (page, ip_address, user_agent) VALUES
('home', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
('home', '192.168.1.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)'),
('home', '10.0.0.1', 'Mozilla/5.0 (Android 10; Mobile; rv:81.0)')
ON DUPLICATE KEY UPDATE visit_date = CURRENT_TIMESTAMP;

-- Creating indexes for better performance
CREATE INDEX IF NOT EXISTS idx_products_status_sort ON products(status, sort_order);
CREATE INDEX IF NOT EXISTS idx_orders_date_status ON orders(created_at, status);
CREATE INDEX IF NOT EXISTS idx_reviews_status_date ON reviews(status, created_at);
CREATE INDEX IF NOT EXISTS idx_banners_position_status ON banners(position, status, sort_order);
CREATE INDEX IF NOT EXISTS idx_videos_status_sort ON videos(status, sort_order);
CREATE INDEX IF NOT EXISTS idx_pdfs_status_sort ON pdfs(status, sort_order);
CREATE INDEX IF NOT EXISTS idx_gallery_status_sort ON gallery(status, sort_order);