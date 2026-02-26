USE pawnshop;

-- Чтобы seed можно было прогонять много раз:
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE Appraisals;
TRUNCATE TABLE Redemptions;
TRUNCATE TABLE AppraiserSpecialities;
TRUNCATE TABLE HomeAppliances;
TRUNCATE TABLE Jewelry;
TRUNCATE TABLE Pledges;
TRUNCATE TABLE Appraisers;
TRUNCATE TABLE Clients;
TRUNCATE TABLE Statuses;
TRUNCATE TABLE PaymentMethods;
TRUNCATE TABLE Specialities;

SET FOREIGN_KEY_CHECKS = 1;

-- ===== справочники =====
INSERT INTO Statuses (status_id, status_title) VALUES
  (1, 'Active'),
  (2, 'Redeemed'),
  (3, 'Overdue'),
  (4, 'Closed');

INSERT INTO PaymentMethods (payment_method_id, payment_method_name) VALUES
  (1, 'Cash'),
  (2, 'Card'),
  (3, 'Bank transfer');

INSERT INTO Specialities (specialty_id, specialty_name) VALUES
  (1, 'Jewelry'),
  (2, 'Home appliances'),
  (3, 'Antiques');

-- ===== клиенты =====
INSERT INTO Clients (full_name, passport_data, phone, address, birth_date)
VALUES ('Ivan Petrov', '4500 123456', '+7-900-111-11-11', 'Moscow, Tverskaya 1', '1998-04-12');
SET @client1 := LAST_INSERT_ID();

INSERT INTO Clients (full_name, passport_data, phone, address, birth_date)
VALUES ('Anna Smirnova', '4010 987654', '+7-900-222-22-22', 'Saint Petersburg, Nevsky 10', '2001-09-30');
SET @client2 := LAST_INSERT_ID();

INSERT INTO Clients (full_name, passport_data, phone, address, birth_date)
VALUES ('Sergey Ivanov', '4601 555777', '+7-900-333-33-33', 'Kazan, Baumana 5', '1995-01-20');
SET @client3 := LAST_INSERT_ID();

INSERT INTO Clients (full_name, passport_data, phone, address, birth_date)
VALUES ('Maria Volkova', '4702 111222', '+7-900-444-44-44', 'Novosibirsk, Krasny 15', '1999-07-03');
SET @client4 := LAST_INSERT_ID();

-- ===== оценщики =====
INSERT INTO Appraisers (full_name, qualification)
VALUES ('Oleg Kuznetsov', 'Senior appraiser, jewelry & antiques');
SET @appraiser1 := LAST_INSERT_ID();

INSERT INTO Appraisers (full_name, qualification)
VALUES ('Dmitry Sokolov', 'Electronics and home appliances specialist');
SET @appraiser2 := LAST_INSERT_ID();

INSERT INTO Appraisers (full_name, qualification)
VALUES ('Elena Orlova', 'Universal appraiser');
SET @appraiser3 := LAST_INSERT_ID();

-- ===== специализации оценщиков =====
INSERT INTO AppraiserSpecialities (assigned_date, appraiser_id, specialty_id) VALUES
  ('2024-01-10', @appraiser1, 1),
  ('2024-01-10', @appraiser1, 3),
  ('2024-02-01', @appraiser2, 2),
  ('2024-03-15', @appraiser3, 1),
  ('2024-03-15', @appraiser3, 2);

-- ===== залоги + предметы =====
-- 1) Jewelry pledge (Active)
INSERT INTO Pledges (pledge_date, pledge_amount, status_id, storage_item_days, client_id)
VALUES ('2025-10-05', 25000, 1, 30, @client1);
SET @pledge1 := LAST_INSERT_ID();

INSERT INTO Jewelry (pledge_id, item_name, metal, gemstone)
VALUES (@pledge1, 'Ring', 'Gold 585', 'Diamond');

-- 2) Home appliance pledge (Redeemed)
INSERT INTO Pledges (pledge_date, pledge_amount, status_id, storage_item_days, client_id)
VALUES ('2025-09-18', 18000, 2, 21, @client2);
SET @pledge2 := LAST_INSERT_ID();

INSERT INTO HomeAppliances (pledge_id, item_name, brand, model, serial_number)
VALUES (@pledge2, 'Laptop', 'Lenovo', 'ThinkPad T14', 'SN-LNV-001122');

-- 3) Jewelry pledge (Overdue)
INSERT INTO Pledges (pledge_date, pledge_amount, status_id, storage_item_days, client_id)
VALUES ('2025-08-12', 42000, 3, 14, @client3);
SET @pledge3 := LAST_INSERT_ID();

INSERT INTO Jewelry (pledge_id, item_name, metal, gemstone)
VALUES (@pledge3, 'Necklace', 'Silver 925', 'None');

-- 4) Home appliance pledge (Active)
INSERT INTO Pledges (pledge_date, pledge_amount, status_id, storage_item_days, client_id)
VALUES ('2025-10-20', 9000, 1, 10, @client4);
SET @pledge4 := LAST_INSERT_ID();

INSERT INTO HomeAppliances (pledge_id, item_name, brand, model, serial_number)
VALUES (@pledge4, 'Smartphone', 'Samsung', 'Galaxy S21', 'SN-SAM-778899');

-- ===== оценки (Appraisals) =====
-- appraisal_id авто-сгенерится сам
INSERT INTO Appraisals (appraisal_value, appraisal_date, pledge_id, appraiser_id)
VALUES (30000, '2025-10-05', @pledge1, @appraiser1);

INSERT INTO Appraisals (appraisal_value, appraisal_date, pledge_id, appraiser_id)
VALUES (20000, '2025-09-18', @pledge2, @appraiser2);

INSERT INTO Appraisals (appraisal_value, appraisal_date, pledge_id, appraiser_id)
VALUES (45000, '2025-08-12', @pledge3, @appraiser1);

INSERT INTO Appraisals (appraisal_value, appraisal_date, pledge_id, appraiser_id)
VALUES (11000, '2025-10-20', @pledge4, @appraiser3);

-- ===== выкупы (Redemptions) =====
-- redemption_id авто-сгенерится сам
-- Выкуп только по pledge2 (статус Redeemed)
INSERT INTO Redemptions (redemption_date, redemption_amount, pledge_id, payment_method_id)
VALUES ('2025-10-02', 19500, @pledge2, 2);

-- (опционально) можно добавить ещё один выкуп для демонстрации
-- INSERT INTO Redemptions (redemption_date, redemption_amount, pledge_id, payment_method_id)
-- VALUES ('2025-10-25', 9500, @pledge4, 1);