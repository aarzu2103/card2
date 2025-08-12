-- Database Backup
-- Generated on: 2025-08-12 07:37:27

-- Table: admin_bypass_tokens
DROP TABLE IF EXISTS `admin_bypass_tokens`;
CREATE TABLE `admin_bypass_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) NOT NULL,
  `token` varchar(64) NOT NULL,
  `expires_at` timestamp NOT NULL,
  `used` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `admin_id` (`admin_id`),
  CONSTRAINT `admin_bypass_tokens_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: admins
DROP TABLE IF EXISTS `admins`;
CREATE TABLE `admins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','manager','editor') DEFAULT 'admin',
  `status` enum('active','inactive') DEFAULT 'active',
  `profile_image_url` varchar(500) DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table: admins
INSERT INTO `admins` VALUES ('1', 'Admin', 'ADMIN@GTAI.IN', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'active', 'https://i.ibb.co/KpnvQbTG/Whats-App-Image-2024-12-02-at-8-48-16-AM.jpg', '2025-08-12 07:19:11', '2025-08-12 07:11:11', '2025-08-12 07:30:21');

-- Table: banners
DROP TABLE IF EXISTS `banners`;
CREATE TABLE `banners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `image_url` varchar(500) NOT NULL,
  `link_url` varchar(500) DEFAULT NULL,
  `position` enum('top','bottom','both') DEFAULT 'both',
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `click_count` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_banners_position_status` (`position`,`status`,`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table: banners
INSERT INTO `banners` VALUES ('1', 'Special Offer Banner', 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=800&h=200', 'https://example.com/offer', 'both', 'active', '1', '0', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `banners` VALUES ('2', 'New Products Banner', 'https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=800&h=200', 'https://example.com/products', 'both', 'active', '2', '0', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `banners` VALUES ('3', 'Contact Us Banner', 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=800&h=200', 'https://example.com/contact', 'both', 'active', '3', '0', '2025-08-12 07:11:11', '2025-08-12 07:11:11');

-- Table: free_website_requests
DROP TABLE IF EXISTS `free_website_requests`;
CREATE TABLE `free_website_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `business_details` text DEFAULT NULL,
  `status` enum('pending','contacted','completed') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table: free_website_requests
INSERT INTO `free_website_requests` VALUES ('1', 'maharaja', '9820323232', 'maharaja@yahoo.com', 'i need this', 'contacted', '2025-08-12 07:13:31', '2025-08-12 07:22:43');

-- Table: gallery
DROP TABLE IF EXISTS `gallery`;
CREATE TABLE `gallery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image_url` varchar(500) NOT NULL,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `alt_text` varchar(200) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `upload_date` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_gallery_status_sort` (`status`,`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table: gallery
INSERT INTO `gallery` VALUES ('1', 'Office Interior', 'Our modern office space', 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=300', 'Modern office interior', 'active', '1', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `gallery` VALUES ('2', 'Team Meeting', 'Our professional team in action', 'https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=300', 'Team meeting', 'active', '2', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `gallery` VALUES ('3', 'Product Display', 'Our premium products showcase', 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=300', 'Product display', 'active', '3', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `gallery` VALUES ('4', 'Workshop', 'Behind the scenes of our production', 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=600', 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=300', 'Production workshop', 'active', '4', '2025-08-12 07:11:11', '2025-08-12 07:11:11');

-- Table: inquiries
DROP TABLE IF EXISTS `inquiries`;
CREATE TABLE `inquiries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(100) NOT NULL,
  `user_phone` varchar(20) DEFAULT NULL,
  `user_email` varchar(100) DEFAULT NULL,
  `products` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`products`)),
  `message` text DEFAULT NULL,
  `status` enum('pending','contacted','completed') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table: inquiries
INSERT INTO `inquiries` VALUES ('1', 'Guest User', '', '', '[{\"id\":5,\"title\":\"Website Development\",\"price\":\"12000.00\",\"image_url\":\"https:\\/\\/images.pexels.com\\/photos\\/3184360\\/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=400\"}]', 'Product Inquiry:\n\nWebsite Development - ₹12000.00\n\nPlease provide more details about these products.', 'pending', '2025-08-12 07:14:16', '2025-08-12 07:14:16');

-- Table: order_items
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_title` varchar(200) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `unit_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: orders
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_number` varchar(50) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `user_phone` varchar(20) DEFAULT NULL,
  `user_email` varchar(100) DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `discount_amount` decimal(10,2) DEFAULT 0.00,
  `final_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('pending','confirmed','paid','shipped','delivered','cancelled') DEFAULT 'pending',
  `payment_status` enum('pending','paid','failed','refunded') DEFAULT 'pending',
  `payment_method` varchar(50) DEFAULT 'upi',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `user_id` (`user_id`),
  KEY `idx_orders_date_status` (`created_at`,`status`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: pdfs
DROP TABLE IF EXISTS `pdfs`;
CREATE TABLE `pdfs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `file_url` varchar(500) NOT NULL,
  `file_size` int(11) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `download_count` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_pdfs_status_sort` (`status`,`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table: pdfs
INSERT INTO `pdfs` VALUES ('1', 'Company Brochure', 'Download our complete company brochure', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', '1024000', 'active', '1', '0', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `pdfs` VALUES ('2', 'Product Catalog', 'Complete catalog of all our products and services', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', '2048000', 'active', '2', '0', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `pdfs` VALUES ('3', 'Price List', 'Current pricing for all products and services', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', '512000', 'active', '3', '0', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `pdfs` VALUES ('4', 'Company Profile', 'Detailed company profile and credentials', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', '1536000', 'active', '4', '0', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `pdfs` VALUES ('5', 'Portfolio', 'Portfolio of our completed projects', 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', '3072000', 'active', '5', '0', '2025-08-12 07:11:11', '2025-08-12 07:11:11');

-- Table: products
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `discount_price` decimal(10,2) DEFAULT NULL,
  `qty_stock` int(11) DEFAULT 0,
  `image_url` varchar(500) NOT NULL,
  `gallery_images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`gallery_images`)),
  `inquiry_only` tinyint(1) DEFAULT 0,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_products_status_sort` (`status`,`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table: products
INSERT INTO `products` VALUES ('1', 'Premium Business Card', 'High-quality business cards with premium finish and professional design', '500.00', '399.00', '100', 'https://images.pexels.com/photos/6289065/pexels-photo-6289065.jpeg?auto=compress&cs=tinysrgb&w=400', NULL, '0', 'active', '1', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `products` VALUES ('2', 'Digital Visiting Card', 'Modern digital visiting card solution with QR code and social media integration', '299.00', NULL, '50', 'https://images.pexels.com/photos/6289025/pexels-photo-6289025.jpeg?auto=compress&cs=tinysrgb&w=400', NULL, '0', 'active', '2', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `products` VALUES ('3', 'Corporate Branding Package', 'Complete corporate branding solution including logo, letterhead, and business cards', '2999.00', '1999.00', '20', 'https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg?auto=compress&cs=tinysrgb&w=400', NULL, '0', 'active', '3', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `products` VALUES ('4', 'Logo Design Service', 'Professional logo design service with unlimited revisions', '1500.00', NULL, '0', 'https://images.pexels.com/photos/3184432/pexels-photo-3184432.jpeg?auto=compress&cs=tinysrgb&w=400', NULL, '1', 'active', '4', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `products` VALUES ('5', 'Website Development', 'Custom website development with responsive design and SEO optimization', '15000.00', '12000.00', '0', 'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=400', NULL, '1', 'active', '5', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `products` VALUES ('6', 'NFC Card', 'Tap to share', '199.00', '99.00', '0', 'https://i.ibb.co/2X73Dpp/color-gt-tag-n.jpg', NULL, '0', 'active', '0', '2025-08-12 07:21:43', '2025-08-12 07:21:43');
INSERT INTO `products` VALUES ('7', 'NFC Card', 'Tap to share', '199.00', '99.00', '0', 'https://i.ibb.co/2X73Dpp/color-gt-tag-n.jpg', NULL, '0', 'active', '0', '2025-08-12 07:21:47', '2025-08-12 07:21:47');

-- Table: reviews
DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `rating` int(11) NOT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `comment` text NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `ip_address` varchar(45) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_reviews_status_date` (`status`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table: reviews
INSERT INTO `reviews` VALUES ('1', 'Rajesh Kumar', 'rajesh@example.com', '9876543210', '5', 'Excellent service and professional quality work. Highly recommended for business cards!', 'approved', NULL, '2025-08-12 07:11:11', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `reviews` VALUES ('2', 'Priya Singh', 'priya@example.com', '9876543211', '4', 'Great experience with their team. Very responsive and helpful throughout the process.', 'approved', NULL, '2025-08-12 07:11:11', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `reviews` VALUES ('3', 'Amit Patel', 'amit@example.com', '9876543212', '5', 'Outstanding digital visiting card service. Modern design and quick delivery.', 'approved', NULL, '2025-08-12 07:11:11', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `reviews` VALUES ('4', 'Sneha Sharma', 'sneha@example.com', '9876543213', '4', 'Professional branding package exceeded my expectations. Worth every penny!', 'approved', NULL, '2025-08-12 07:11:11', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `reviews` VALUES ('5', 'rani', 'rani@yahoo.com', '9865326598', '5', 'loved it service', 'approved', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', '2025-08-12 07:19:20', '2025-08-12 07:14:46', '2025-08-12 07:19:20');

-- Table: site_settings
DROP TABLE IF EXISTS `site_settings`;
CREATE TABLE `site_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `setting_type` enum('text','number','boolean','json') DEFAULT 'text',
  `description` text DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table: site_settings
INSERT INTO `site_settings` VALUES ('1', 'site_title', 'GT Digital', 'text', 'Website title', '2025-08-12 07:24:14');
INSERT INTO `site_settings` VALUES ('2', 'company_name', 'GalaxyTribes', 'text', 'Company name', '2025-08-12 07:24:14');
INSERT INTO `site_settings` VALUES ('3', 'director_name', 'GTAI', 'text', 'Director name', '2025-08-12 07:24:14');
INSERT INTO `site_settings` VALUES ('4', 'director_title', 'FOUNDER', 'text', 'Director title', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('5', 'contact_phone1', '9765834383', 'text', 'Primary phone number', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('6', 'contact_phone2', '9765834383', 'text', 'Secondary phone number', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('7', 'contact_email', 'info@galaxytribes.in', 'text', 'Contact email', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('8', 'contact_address', 'Nashik, Maharashtra, India', 'text', 'Business address', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('9', 'whatsapp_number', '919765834383', 'text', 'WhatsApp number with country code', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('10', 'website_url', 'https://galaxytribes.in', 'text', 'Website URL', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('11', 'upi_id', 'vishrajrathod@kotak', 'text', 'UPI ID for payments', '2025-08-12 07:24:14');
INSERT INTO `site_settings` VALUES ('12', 'meta_description', 'Professional digital visiting card and business services. Get your custom business card, logo design, and corporate branding solutions.', 'text', 'Meta description for SEO', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('13', 'meta_keywords', 'visiting card, business card, digital card, logo design, branding, corporate identity', 'text', 'Meta keywords for SEO', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('14', 'current_theme', 'light', 'text', 'Current website theme', '2025-08-12 07:23:03');
INSERT INTO `site_settings` VALUES ('15', 'discount_text', 'DISCOUNT UPTO 50% Live ', 'text', 'Discount popup text', '2025-08-12 07:24:14');
INSERT INTO `site_settings` VALUES ('16', 'show_discount_popup', '1', 'boolean', 'Show discount popup', '2025-08-12 07:24:14');
INSERT INTO `site_settings` VALUES ('17', 'show_pwa_prompt', '0', 'boolean', 'Show PWA install prompt', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('18', 'social_facebook', 'https://facebook.com/demo', 'text', 'Facebook page URL', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('19', 'social_youtube', 'https://youtube.com/demo', 'text', 'YouTube channel URL', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('20', 'social_twitter', 'https://twitter.com/demo', 'text', 'Twitter profile URL', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('21', 'social_instagram', 'https://instagram.com/demo', 'text', 'Instagram profile URL', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('22', 'social_linkedin', 'https://linkedin.com/company/demo', 'text', 'LinkedIn page URL', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('23', 'social_pinterest', 'https://pinterest.com/demo', 'text', 'Pinterest profile URL', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('24', 'social_telegram', 'https://t.me/demo', 'text', 'Telegram channel URL', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('25', 'social_zomato', 'https://zomato.com/demo', 'text', 'Zomato restaurant URL', '2025-08-12 07:11:11');
INSERT INTO `site_settings` VALUES ('26', 'view_count', '15', 'text', NULL, '2025-08-12 07:32:01');

-- Table: transactions
DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `upi_id` varchar(100) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('pending','success','failed','cancelled') DEFAULT 'pending',
  `payment_method` varchar(50) DEFAULT 'upi',
  `gateway_response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`gateway_response`)),
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaction_id` (`transaction_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: translations
DROP TABLE IF EXISTS `translations`;
CREATE TABLE `translations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language_code` varchar(5) NOT NULL,
  `translation_key` varchar(100) NOT NULL,
  `translation_value` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_translation` (`language_code`,`translation_key`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table: translations
INSERT INTO `translations` VALUES ('1', 'en', 'welcome', 'Welcome', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('2', 'en', 'home', 'Home', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('3', 'en', 'about', 'About Us', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('4', 'en', 'products', 'Products', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('5', 'en', 'contact', 'Contact', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('6', 'en', 'gallery', 'Gallery', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('7', 'en', 'videos', 'Videos', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('8', 'en', 'reviews', 'Reviews', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('9', 'en', 'cart', 'Cart', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('10', 'en', 'add_to_cart', 'Add to Cart', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('11', 'en', 'inquiry', 'Inquiry', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('12', 'hi', 'welcome', 'स्वागत', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('13', 'hi', 'home', 'होम', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('14', 'hi', 'about', 'हमारे बारे में', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('15', 'hi', 'products', 'उत्पाद', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('16', 'hi', 'contact', 'संपर्क', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('17', 'hi', 'gallery', 'गैलरी', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('18', 'hi', 'videos', 'वीडियो', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('19', 'hi', 'reviews', 'समीक्षा', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('20', 'hi', 'cart', 'कार्ट', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('21', 'hi', 'add_to_cart', 'कार्ट में जोड़ें', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `translations` VALUES ('22', 'hi', 'inquiry', 'पूछताछ', '2025-08-12 07:11:11', '2025-08-12 07:11:11');

-- Table: users
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `email_verified` tinyint(1) DEFAULT 0,
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table: users
INSERT INTO `users` VALUES ('1', 'vishal', 'vishal', 'vishal@yahoo.com', '9820326565', '$2y$10$nDAphDthk3VvtophxHJRIO.YWqyNNBD3pKqXnW/IIC59GgulvpKB.', 'active', '0', '2025-08-12 07:15:46', '2025-08-12 07:15:39', '2025-08-12 07:15:46');
INSERT INTO `users` VALUES ('2', 'swami', 'swami', 'swami@yahoo.com', '9865989898', '$2y$10$B5MNX7n0p2a2k4C4WFzAJOYf.d.1nfdneUfIzJWbQAbpihsggdvcC', 'active', '0', '2025-08-12 07:16:37', '2025-08-12 07:16:29', '2025-08-12 07:16:37');
INSERT INTO `users` VALUES ('3', 'Ram', 'ram', 'ram@gmail.com', '9820333333', '$2y$10$GUu02WQtrXCiJYPNqagSiuYxGu9/Wkne97Uw6P3t9vJfuqUFsgnN.', 'active', '0', '2025-08-12 07:32:01', '2025-08-12 07:31:51', '2025-08-12 07:32:01');

-- Table: videos
DROP TABLE IF EXISTS `videos`;
CREATE TABLE `videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `youtube_url` varchar(500) NOT NULL,
  `embed_code` varchar(500) DEFAULT NULL,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `view_count` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_videos_status_sort` (`status`,`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table: videos
INSERT INTO `videos` VALUES ('1', 'Company Introduction', 'Learn about our company and services', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'https://www.youtube.com/embed/dQw4w9WgXcQ', NULL, 'active', '1', '0', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `videos` VALUES ('2', 'Product Showcase', 'Showcase of our premium products and services', 'https://www.youtube.com/watch?v=jNQXAC9IVRw', 'https://www.youtube.com/embed/jNQXAC9IVRw', NULL, 'active', '2', '0', '2025-08-12 07:11:11', '2025-08-12 07:11:11');
INSERT INTO `videos` VALUES ('3', 'Customer Testimonials', 'What our customers say about our services', 'https://www.youtube.com/watch?v=9bZkp7q19f0', 'https://www.youtube.com/embed/9bZkp7q19f0', NULL, 'active', '3', '0', '2025-08-12 07:11:11', '2025-08-12 07:11:11');

-- Table: visits
DROP TABLE IF EXISTS `visits`;
CREATE TABLE `visits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page` varchar(100) NOT NULL DEFAULT 'home',
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `referer` varchar(500) DEFAULT NULL,
  `visit_date` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for table: visits
INSERT INTO `visits` VALUES ('1', 'home', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', NULL, '2025-08-12 07:11:11');
INSERT INTO `visits` VALUES ('2', 'home', '192.168.1.1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)', NULL, '2025-08-12 07:11:11');
INSERT INTO `visits` VALUES ('3', 'home', '10.0.0.1', 'Mozilla/5.0 (Android 10; Mobile; rv:81.0)', NULL, '2025-08-12 07:11:11');
INSERT INTO `visits` VALUES ('4', 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '', '2025-08-12 07:12:53');
INSERT INTO `visits` VALUES ('5', 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '', '2025-08-12 07:15:18');
INSERT INTO `visits` VALUES ('6', 'home', '135.148.100.196', '', '', '2025-08-12 07:15:43');
INSERT INTO `visits` VALUES ('7', 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:15:46');
INSERT INTO `visits` VALUES ('8', 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:16:37');
INSERT INTO `visits` VALUES ('9', 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:21:54');
INSERT INTO `visits` VALUES ('10', 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:23:05');
INSERT INTO `visits` VALUES ('11', 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:24:18');
INSERT INTO `visits` VALUES ('12', 'home', '2401:4900:1c9a:d026:3024:4c0:7d17:e807', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:28:47');
INSERT INTO `visits` VALUES ('13', 'home', '2401:4900:1c9a:d026:75fc:c3e2:8935:c958', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36', '', '2025-08-12 07:28:59');
INSERT INTO `visits` VALUES ('14', 'home', '2401:4900:1c9a:d026:75fc:c3e2:8935:c958', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36', '', '2025-08-12 07:29:04');
INSERT INTO `visits` VALUES ('15', 'home', '2401:4900:1c9a:d026:75fc:c3e2:8935:c958', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36', 'https://wap.galaxytribes.in/', '2025-08-12 07:32:01');

