DROP DATABASE IF EXISTS tscm;

CREATE DATABASE tscm
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE tscm;

CREATE TABLE vendors 
(
    vendor_id   INT AUTO_INCREMENT PRIMARY KEY,
    vendor_business    VARCHAR(50)   UNIQUE,
    vendor_first_name   VARCHAR(50)     NOT NULL,
    vendor_last_name    VARCHAR(50)     NOT NULL,
    vendor_phone    VARCHAR(50)     NOT NULL    UNIQUE,
    vendor_email    VARCHAR(50)     NOT NULL    UNIQUE,
    certification   VARCHAR(50),
    booth_preference    VARCHAR(50)
)   ENGINE=InnoDB;

CREATE TABLE customers
(
    customer_id     INT AUTO_INCREMENT PRIMARY KEY,
    customer_first_name     VARCHAR(50),
    customer_last_name      VARCHAR(50),
    loyalty_member  BOOLEAN,
    customer_address    VARCHAR(50)     NOT NULL,
    customer_phone      VARCHAR(50)     NOT NULL,
    customer_email      VARCHAR(50)     NOT NULL
)   ENGINE=InnoDB;

CREATE TABLE products 
(
    product_id      INT AUTO_INCREMENT PRIMARY KEY,
    product_name    VARCHAR(50)     NOT NULL,
    product_type    VARCHAR(50)     NOT NULL,
    vendor_id       INT,
    season      ENUM('summer', 'fall', 'winter', 'spring')        NOT NULL,
    FOREIGN KEY (vendor_id)  REFERENCES   vendors(vendor_id)
)   ENGINE=InnoDB;

CREATE TABLE purchase_history
(
    purchase_id     INT AUTO_INCREMENT PRIMARY KEY,
    customer_id     INT,
    vendor_id       INT,
    product_id      INT,
    purchase_date   DATETIME,
    quantity        INT,
    price_per_unit  DECIMAL(8,2),
    total_amount    DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    CHECK (quantity > 0),
    CHECK (price_per_unit > 0.00),
    CHECK (total_amount = quantity * price_per_unit)
)   ENGINE=InnoDB;

CREATE TABLE booths (
    booth_id    INT AUTO_INCREMENT  PRIMARY KEY,
    booth_size      DECIMAL(8,2),
    booth_location      VARCHAR(50),
    booth_description   VARCHAR(50)
)   ENGINE=InnoDB;

CREATE TABLE vendor_booth_assignments (
    assignment_id   INT  AUTO_INCREMENT PRIMARY KEY,
    vendor_id       INT,
    booth_id        INT,
    start_date      DATE,
    end_date        DATE,
    assignment_type     ENUM('permanent', 'seasonal', 'temporary'),
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id),
    FOREIGN KEY (booth_id) REFERENCES booths(booth_id),
    CHECK (start_date <= end_date)
)   ENGINE=InnoDB;

CREATE TABLE schedule (
    schedule_id     INT AUTO_INCREMENT PRIMARY KEY,
    vendor_id       INT,
    booth_id        INT,
    schedule_type   VARCHAR(50),
    schedule_date   DATE    NOT NULL,
    start_time      TIME    NOT NULL,
    end_time        TIME    NOT NULL,
    notes           VARCHAR(200),
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id),
    FOREIGN KEY (booth_id)  REFERENCES booths(booth_id),
    CHECK (start_time < end_time)
)   ENGINE=InnoDB;

CREATE TABLE events (
    event_id    INT  AUTO_INCREMENT  PRIMARY KEY,
    event_name  VARCHAR(50),
    schedule_id     INT,
    FOREIGN KEY (schedule_id) REFERENCES schedule(schedule_id)
)   ENGINE=InnoDB;

CREATE TABLE vendor_payments (
    payment_id   INT   AUTO_INCREMENT PRIMARY KEY,
    vendor_id   INT,
    booth_id    INT,
    booth_fee   DECIMAL(8,2),
    commissions     DECIMAL(8,2),
    penalties   DECIMAL(8,2),
    payment_date     DATE,
    total_payment   DECIMAL(10,2),
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id),
    FOREIGN KEY (booth_id)  REFERENCES booths(booth_id),
    CHECK (booth_fee >= 0),
    CHECK (commissions >= 0),
    CHECK (penalties >= 0)
)   ENGINE=InnoDB;

CREATE TABLE transactions (
    transaction_id  INT AUTO_INCREMENT PRIMARY KEY,
    transaction_type    VARCHAR(50),
    transaction_date    DATE,
    transaction_amount  DECIMAL(10,2),
    customer_id     INT,
    vendor_id       INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
)   ENGINE=InnoDB;

CREATE TABLE csa_subscriptions (
    csa_id  INT AUTO_INCREMENT PRIMARY KEY,
    csa_plan ENUM('weekly', 'monthly', 'produce-only', 'dry-goods-only'),
    csa_inventory   VARCHAR(200)    NOT NULL,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
)   ENGINE=InnoDB;

CREATE TABLE compliance (
    compliance_id   INT AUTO_INCREMENT PRIMARY KEY,
    compliance_type     VARCHAR(50),
    compliance_date     DATE    NOT NULL,
    compliance_renewal      DATE    NOT NULL,
    vendor_id   INT,
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
)   ENGINE=InnoDB;

-- data population
INSERT INTO vendors (vendor_business, vendor_first_name, vendor_last_name, vendor_phone, vendor_email, certification, booth_preference) VALUES
('Sunrise Organic Farm', 'Maria', 'Rodriguez', '(828) 555-0101', 'maria@sunriseorganic.com', 'organic,sustainable', 'North Corner'),
('Blue Ridge Honey Co', 'Robert', 'Johnson', '(828) 555-0102', 'rob@blueridgehoney.com', 'local', 'Near Entrance'),
('Mountain View Bakery', 'Sarah', 'Williams', '(828) 555-0103', 'sarah@mountainviewbakery.com', NULL, 'Food Court'),
('Heritage Tomato Farm', 'David', 'Chen', '(828) 555-0104', 'david@heritagetomatoes.com', 'organic,heirloom', 'Main Row'),
('Artisan Soap Works', 'Jennifer', 'Taylor', '(828) 555-0105', 'jen@artisansoap.com', 'handmade,natural', 'Craft Section'),
('Creek Side Dairy', 'Michael', 'Anderson', '(828) 555-0106', 'mike@creeksidedairy.com', 'grass-fed,local', 'Refrigerated Area'),
('Wildflower Herbs', 'Lisa', 'Martinez', '(828) 555-0107', 'lisa@wildflowerherbs.com', 'organic,medicinal', 'Shade Area'),
('Valley Fresh Produce', 'James', 'Thompson', '(828) 555-0108', 'james@valleyfresh.com', 'sustainable', 'Main Row'),
('Handcrafted Pottery', 'Amanda', 'Wilson', '(828) 555-0109', 'amanda@handcraftedpottery.com', 'handmade', 'Craft Section'),
('Meadow Brook Farm', 'Christopher', 'Davis', '(828) 555-0110', 'chris@meadowbrook.com', 'pasture-raised', 'Near Parking'),
('Mountain Mushrooms', 'Emily', 'Garcia', '(828) 555-0111', 'emily@mountainmushrooms.com', 'organic,wild', 'Shade Area'),
('Fresh Bloom Flowers', 'Daniel', 'Miller', '(828) 555-0112', 'dan@freshbloom.com', 'pesticide-free', 'Entrance Display'),
('Smoky Mountain Jams', 'Rebecca', 'Brown', '(828) 555-0113', 'rebecca@smokymountainjams.com', 'local,small-batch', 'Food Court'),
('Riverside Vegetables', 'Kevin', 'Jones', '(828) 555-0114', 'kevin@riversideveggies.com', 'organic', 'Main Row'),
('Cozy Cabin Candles', 'Michelle', 'Moore', '(828) 555-0115', 'michelle@cozycabin.com', 'soy,handmade', 'Indoor Section');

INSERT INTO customers (customer_first_name, customer_last_name, loyalty_member, customer_address, customer_phone, customer_email) VALUES
('Emma', 'Thompson', TRUE, '123 Oak Street, Asheville, NC', '(828) 555-1001', 'emma.thompson@email.com'),
('John', 'Davis', TRUE, '456 Maple Ave, Asheville, NC', '(828) 555-1002', 'john.davis@email.com'),
('Sarah', 'Wilson', FALSE, '789 Pine Road, Black Mountain, NC', '(828) 555-1003', 'sarah.wilson@email.com'),
('Michael', 'Brown', TRUE, '321 Cedar Lane, Weaverville, NC', '(828) 555-1004', 'michael.brown@email.com'),
('Lisa', 'Johnson', FALSE, '654 Birch Street, Asheville, NC', '(828) 555-1005', 'lisa.johnson@email.com'),
('David', 'Miller', TRUE, '987 Elm Drive, Hendersonville, NC', '(828) 555-1006', 'david.miller@email.com'),
('Jennifer', 'Garcia', TRUE, '147 Willow Way, Asheville, NC', '(828) 555-1007', 'jennifer.garcia@email.com'),
('Robert', 'Martinez', FALSE, '258 Poplar Street, Woodfin, NC', '(828) 555-1008', 'robert.martinez@email.com'),
('Amanda', 'Anderson', TRUE, '369 Hickory Road, Fletcher, NC', '(828) 555-1009', 'amanda.anderson@email.com'),
('Christopher', 'Taylor', FALSE, '741 Walnut Ave, Asheville, NC', '(828) 555-1010', 'christopher.taylor@email.com');

INSERT INTO products (product_name, product_type, vendor_id, season) VALUES
-- Sunrise Organic Farm (vendor_id = 1)
('Organic Tomatoes', 'Vegetables', 1, 'summer'),
('Organic Lettuce', 'Vegetables', 1, 'spring'),
('Organic Carrots', 'Vegetables', 1, 'fall'),
('Organic Spinach', 'Vegetables', 1, 'winter'),
-- Blue Ridge Honey Co (vendor_id = 2)
('Wildflower Honey', 'Honey', 2, 'summer'),
('Clover Honey', 'Honey', 2, 'spring'),
('Sourwood Honey', 'Honey', 2, 'fall'),
-- Mountain View Bakery (vendor_id = 3)
('Sourdough Bread', 'Baked Goods', 3, 'winter'),
('Blueberry Muffins', 'Baked Goods', 3, 'summer'),
('Apple Pie', 'Baked Goods', 3, 'fall'),
-- Heritage Tomato Farm (vendor_id = 4)
('Cherokee Purple Tomatoes', 'Heirloom Vegetables', 4, 'summer'),
('Brandywine Tomatoes', 'Heirloom Vegetables', 4, 'summer'),
-- Artisan Soap Works (vendor_id = 5)
('Lavender Soap', 'Bath Products', 5, 'spring'),
('Goat Milk Soap', 'Bath Products', 5, 'winter'),
-- Creek Side Dairy (vendor_id = 6)
('Fresh Milk', 'Dairy', 6, 'winter'),
('Aged Cheddar', 'Dairy', 6, 'fall'),
-- Wildflower Herbs (vendor_id = 7)
('Dried Basil', 'Herbs', 7, 'summer'),
('Echinacea Tea', 'Herbs', 7, 'fall'),
-- Valley Fresh Produce (vendor_id = 8)
('Bell Peppers', 'Vegetables', 8, 'summer'),
('Winter Squash', 'Vegetables', 8, 'fall'),
-- Handcrafted Pottery (vendor_id = 9)
('Ceramic Bowls', 'Pottery', 9, 'winter'),
('Garden Planters', 'Pottery', 9, 'spring');

INSERT INTO booths (booth_size, booth_location, booth_description) VALUES
(100.00, 'North Corner A1', 'Premium corner booth with high traffic'),
(80.00, 'Main Row B3', 'Standard booth in main walkway'),
(120.00, 'Food Court C2', 'Large booth in food vendor area'),
(90.00, 'Craft Section D5', 'Medium booth in artisan area'),
(110.00, 'Near Entrance E1', 'High visibility entrance booth'),
(75.00, 'Shade Area F4', 'Covered booth area'),
(95.00, 'Main Row B7', 'Standard main row location'),
(85.00, 'Refrigerated Area G2', 'Booth with electrical hookup'),
(105.00, 'Indoor Section H3', 'Climate controlled indoor space'),
(70.00, 'Near Parking I6', 'Convenient parking access booth');

INSERT INTO vendor_booth_assignments (vendor_id, booth_id, start_date, end_date, assignment_type) VALUES
(1, 1, '2025-04-01', '2025-10-31', 'seasonal'),
(2, 5, '2025-01-01', '2025-12-31', 'permanent'),
(3, 3, '2025-01-01', '2025-12-31', 'permanent'),
(4, 2, '2025-06-01', '2025-09-30', 'seasonal'),
(5, 4, '2025-01-01', '2025-12-31', 'permanent'),
(6, 8, '2025-01-01', '2025-12-31', 'permanent'),
(7, 6, '2025-03-01', '2025-11-30', 'seasonal'),
(8, 7, '2025-04-01', '2025-10-31', 'seasonal'),
(9, 9, '2025-01-01', '2025-12-31', 'permanent'),
(10, 10, '2025-05-01', '2025-08-31', 'temporary');

INSERT INTO schedule (vendor_id, booth_id, schedule_type, schedule_date, start_time, end_time, notes) VALUES
-- Regular market hours
(NULL, NULL, 'MARKET_HOURS', '2025-08-02', '08:00:00', '14:00:00', 'Saturday market'),
(NULL, NULL, 'MARKET_HOURS', '2025-08-06', '08:00:00', '13:00:00', 'Wednesday market'),
-- Vendor booth assignments
(1, 1, 'BOOTH_ASSIGNMENT', '2025-08-02', '08:00:00', '14:00:00', 'Regular Saturday setup'),
(2, 5, 'BOOTH_ASSIGNMENT', '2025-08-02', '07:30:00', '14:00:00', 'Early setup for honey display'),
(3, 3, 'BOOTH_ASSIGNMENT', '2025-08-02', '08:00:00', '14:00:00', 'Fresh baked goods'),
(4, 2, 'BOOTH_ASSIGNMENT', '2025-08-02', '08:00:00', '14:00:00', 'Peak tomato season'),
-- Special events
(3, 3, 'COOKING_DEMO', '2025-08-02', '10:00:00', '11:00:00', 'Bread making demonstration'),
(7, 6, 'EDUCATIONAL_WORKSHOP', '2025-08-02', '11:30:00', '12:30:00', 'Herb growing workshop');

INSERT INTO events (event_name, schedule_id) VALUES
('Bread Making Demo', 7),
('Herb Growing Workshop', 8);

INSERT INTO purchase_history (customer_id, vendor_id, product_id, purchase_date, quantity, price_per_unit, total_amount) VALUES
(1, 1, 1, '2025-07-26 09:30:00', 3, 4.50, 13.50),
(1, 2, 5, '2025-07-26 09:45:00', 1, 12.00, 12.00),
(2, 3, 8, '2025-07-26 10:15:00', 2, 5.00, 10.00),
(3, 1, 2, '2025-07-26 10:30:00', 2, 3.00, 6.00),
(4, 4, 11, '2025-07-26 11:00:00', 5, 6.00, 30.00),
(5, 5, 13, '2025-07-26 11:15:00', 3, 8.00, 24.00),
(6, 6, 15, '2025-07-26 11:30:00', 1, 8.50, 8.50),
(7, 7, 17, '2025-07-26 12:00:00', 2, 4.00, 8.00),
(8, 8, 19, '2025-07-26 12:15:00', 4, 2.50, 10.00),
(9, 9, 21, '2025-07-26 12:30:00', 1, 25.00, 25.00);

INSERT INTO vendor_payments (vendor_id, booth_id, booth_fee, commissions, penalties, payment_date, total_payment) VALUES
(1, 1, 150.00, 25.50, 0.00, '2025-07-01', 175.50),
(2, 5, 165.00, 18.00, 0.00, '2025-07-01', 183.00),
(3, 3, 180.00, 15.00, 0.00, '2025-07-01', 195.00),
(4, 2, 135.00, 45.00, 0.00, '2025-07-01', 180.00),
(5, 4, 135.00, 36.00, 0.00, '2025-07-01', 171.00),
(6, 8, 127.50, 12.75, 0.00, '2025-07-01', 140.25),
(7, 6, 112.50, 12.00, 0.00, '2025-07-01', 124.50),
(8, 7, 142.50, 15.00, 0.00, '2025-07-01', 157.50),
(9, 9, 157.50, 37.50, 0.00, '2025-07-01', 195.00),
(10, 10, 105.00, 0.00, 25.00, '2025-07-01', 130.00);

INSERT INTO transactions (transaction_type, transaction_date, transaction_amount, customer_id, vendor_id) VALUES
('product_sale', '2025-07-26', 13.50, 1, 1),
('product_sale', '2025-07-26', 12.00, 1, 2),
('product_sale', '2025-07-26', 10.00, 2, 3),
('product_sale', '2025-07-26', 6.00, 3, 1),
('product_sale', '2025-07-26', 30.00, 4, 4),
('booth_rental', '2025-07-01', 175.50, NULL, 1),
('booth_rental', '2025-07-01', 183.00, NULL, 2),
('booth_rental', '2025-07-01', 195.00, NULL, 3),
('csa_payment', '2025-07-15', 120.00, 1, NULL),
('csa_payment', '2025-07-15', 150.00, 4, NULL);

INSERT INTO csa_subscriptions (csa_plan, csa_inventory, customer_id) VALUES
('weekly', 'tomatoes, lettuce, carrots, honey, bread', 1),
('monthly', 'seasonal vegetables, herbs, dairy products', 4),
('produce-only', 'mixed seasonal vegetables and fruits', 6),
('weekly', 'tomatoes, peppers, herbs, cheese', 7);

INSERT INTO compliance (compliance_type, compliance_date, compliance_renewal, vendor_id) VALUES
('Health Department Permit', '2025-01-15', '2026-01-15', 3),
('Food Handler License', '2025-02-01', '2026-02-01', 3),
('Organic Certification', '2025-01-01', '2026-01-01', 1),
('Organic Certification', '2025-01-01', '2026-01-01', 4),
('Liability Insurance', '2025-01-01', '2026-01-01', 1),
('Liability Insurance', '2025-01-01', '2026-01-01', 2),
('Liability Insurance', '2025-01-01', '2026-01-01', 3),
('Sales Tax Permit', '2025-01-01', '2026-01-01', 5),
('Health Department Permit', '2025-03-01', '2026-03-01', 6),
('Food Handler License', '2025-03-01', '2026-03-01', 6);

CREATE INDEX idx_products_vendor_id ON products(vendor_id);
CREATE INDEX idx_purchase_history_customer_id ON purchase_history(customer_id);
CREATE INDEX idx_purchase_history_vendor_id ON purchase_history(vendor_id);
CREATE INDEX idx_purchase_history_product_id ON purchase_history(product_id);
CREATE INDEX idx_vendor_booth_assignments_vendor_id ON vendor_booth_assignments(vendor_id);
CREATE INDEX idx_vendor_booth_assignments_booth_id ON vendor_booth_assignments(booth_id);

CREATE INDEX idx_purchase_history_date ON purchase_history(purchase_date);
CREATE INDEX idx_schedule_date ON schedule(schedule_date);
CREATE INDEX idx_vendor_payments_date ON vendor_payments(payment_date);

CREATE INDEX idx_customers_email ON customers(customer_email);
CREATE INDEX idx_vendors_email ON vendors(vendor_email);

-- views
-- checks which csa subscriptions are active
CREATE VIEW active_csa_subscriptions AS 
    SELECT c.customer_first_name,
           c.customer_last_name,
           csa.csa_plan,
           csa.csa_inventory 
    FROM customers c 
    JOIN csa_subscriptions csa ON c.customer_id = csa.customer_id;

-- checks which compliances are expiring and need to be renewed within 60 days
CREATE VIEW upcoming_compliance_renewals AS 
    SELECT vendor_id,
           compliance_type,
           compliance_renewal
    FROM compliance 
    WHERE compliance_renewal BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 60 DAY);

-- procedure that assigns vendor to booth, checks for conflicting assignments, and assigns a booth if there are no conflicts
DELIMITER //

CREATE PROCEDURE AssignVendorToBooth(
    IN p_vendor_id INT,
    IN p_booth_id INT,
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_assignment_type ENUM('permanent', 'seasonal', 'temporary')
)
BEGIN
    DECLARE booth_available BOOLEAN DEFAULT TRUE;
    DECLARE conflict_count INT DEFAULT 0;
    
    SELECT COUNT(*) INTO conflict_count
    FROM vendor_booth_assignments
    WHERE booth_id = p_booth_id
    AND (
        (p_start_date BETWEEN start_date AND end_date) OR
        (p_end_date BETWEEN start_date AND end_date) OR
        (start_date BETWEEN p_start_date AND p_end_date)
    );
    
    IF conflict_count = 0 THEN
        INSERT INTO vendor_booth_assignments (
            vendor_id, booth_id, start_date, end_date, assignment_type
        ) VALUES (
            p_vendor_id, p_booth_id, p_start_date, p_end_date, p_assignment_type
        );
        
        SELECT 'Assignment successful' as result;
    ELSE
        SELECT 'Booth not available for those dates' as result;
    END IF;
END //

DELIMITER ;

-- test and sample queries
-- finds available booths for a given date, shows booths not assigned on 2025-08-15
SELECT b.booth_id, b.booth_location, b.booth_description
FROM booths b
WHERE b.booth_id NOT IN (
    SELECT vba.booth_id 
    FROM vendor_booth_assignments vba
    WHERE '2025-08-15' BETWEEN vba.start_date AND COALESCE(vba.end_date, '2099-12-31')
);

-- calculates total booth rental costs for a season
SELECT v.vendor_first_name, 
       v.vendor_last_name,
       SUM(vp.booth_fee) as total_booth_costs,
       COUNT(vp.payment_id) as number_of_payments
FROM vendors v
JOIN vendor_payments vp ON v.vendor_id = vp.vendor_id
GROUP BY v.vendor_id, v.vendor_business, v.vendor_first_name, v.vendor_last_name
ORDER BY total_booth_costs DESC;

-- displays upcoming events that are scheduled within the next 30 days
SELECT e.event_name,
       s.schedule_date,
       s.start_time,
       s.end_time,
       b.booth_location
FROM events e
JOIN schedule s ON e.schedule_id = s.schedule_id
JOIN booths b ON s.booth_id = b.booth_id
WHERE s.schedule_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
ORDER BY s.schedule_date, s.start_time;

-- shows all vendors with their assigned booths, contact info, and assignment dates
SELECT 
    v.vendor_id,
    v.vendor_business,
    CONCAT(v.vendor_first_name, ' ', v.vendor_last_name) AS vendor_name,
    v.vendor_phone,
    v.vendor_email,
    v.certification,
    v.booth_preference,
    COALESCE(b.booth_id, 'No booth assigned') AS booth_id,
    COALESCE(b.booth_location, 'N/A') AS booth_location,
    COALESCE(b.booth_description, 'N/A') AS booth_description,
    COALESCE(b.booth_size, 0) AS booth_size,
    vba.assignment_type,
    vba.start_date AS assignment_start,
    vba.end_date AS assignment_end,
    CASE 
        WHEN vba.end_date IS NULL OR vba.end_date >= CURDATE() THEN 'Active'
        ELSE 'Expired'
    END AS assignment_status
FROM vendors v
LEFT JOIN vendor_booth_assignments vba ON v.vendor_id = vba.vendor_id
LEFT JOIN booths b ON vba.booth_id = b.booth_id
ORDER BY v.vendor_business, vba.start_date DESC;
