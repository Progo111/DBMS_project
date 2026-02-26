CREATE DATABASE IF NOT EXISTS pawnshop;

USE pawnshop;

CREATE TABLE
    Statuses (
        status_id INT NOT NULL,
        status_title VARCHAR(64) NOT NULL,
        PRIMARY KEY (status_id),
        CONSTRAINT uq_statuses_title UNIQUE (status_title)
    );

CREATE TABLE
    PaymentMethods (
        payment_method_id INT NOT NULL,
        payment_method_name VARCHAR(64) NOT NULL,
        PRIMARY KEY (payment_method_id),
        CONSTRAINT uq_pm__pm_method_name UNIQUE (payment_method_name)
    );

CREATE TABLE
    Specialities (
        specialty_id INT NOT NULL,
        specialty_name VARCHAR(64) NOT NULL,
        PRIMARY KEY (specialty_id),
        CONSTRAINT uq_specialities_name UNIQUE (specialty_name)
    );

CREATE TABLE
    Clients (
        client_id INT NOT NULL AUTO_INCREMENT,
        full_name VARCHAR(256) NOT NULL,
        passport_data VARCHAR(255) NOT NULL,
        phone VARCHAR(20) NOT NULL,
        address TEXT NOT NULL,
        birth_date DATE NOT NULL,
        PRIMARY KEY (client_id),
        CONSTRAINT uq_clients_passport UNIQUE (passport_data)
    );

CREATE TABLE
    Appraisers (
        appraiser_id INT NOT NULL AUTO_INCREMENT,
        full_name VARCHAR(256) NOT NULL,
        qualification VARCHAR(256) NOT NULL,
        PRIMARY KEY (appraiser_id)
    );

CREATE TABLE
    Pledges (
        pledge_id INT NOT NULL AUTO_INCREMENT,
        pledge_date DATE NOT NULL,
        pledge_amount INT NOT NULL,
        status_id INT NOT NULL,
        storage_item_days INT NOT NULL,
        client_id INT NOT NULL,
        category VARCHAR(64) NULL,
        PRIMARY KEY (pledge_id),
        CONSTRAINT fk_pledges_client FOREIGN KEY (client_id) REFERENCES Clients (client_id) ON UPDATE CASCADE ON DELETE RESTRICT,
        CONSTRAINT fk_pledges_status FOREIGN KEY (status_id) REFERENCES Statuses (status_id) ON UPDATE CASCADE ON DELETE RESTRICT
    );

CREATE TABLE
    HomeAppliances (
        pledge_id INT NOT NULL,
        item_name VARCHAR(256) NOT NULL,
        brand VARCHAR(64) NULL,
        model VARCHAR(64) NULL,
        serial_number VARCHAR(20) NULL,
        PRIMARY KEY (pledge_id),
        CONSTRAINT fk_homeappliances_pledge FOREIGN KEY (pledge_id) REFERENCES Pledges (pledge_id) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE
    Jewelry (
        pledge_id INT NOT NULL,
        item_name VARCHAR(256) NOT NULL,
        metal VARCHAR(64) NULL,
        gemstone VARCHAR(64) NULL,
        PRIMARY KEY (pledge_id),
        CONSTRAINT fk_jewelry_pledge FOREIGN KEY (pledge_id) REFERENCES Pledges (pledge_id) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE
    Appraisals (
        appraisal_id INT NOT NULL AUTO_INCREMENT,
        appraisal_value INT NULL,
        appraisal_date DATE NOT NULL,
        pledge_id INT NOT NULL,
        appraiser_id INT NOT NULL,
        PRIMARY KEY (appraisal_id, pledge_id, appraiser_id),
        CONSTRAINT fk_appraisals_pledge FOREIGN KEY (pledge_id) REFERENCES Pledges (pledge_id) ON UPDATE CASCADE ON DELETE RESTRICT,
        CONSTRAINT fk_appraisals_appraiser FOREIGN KEY (appraiser_id) REFERENCES Appraisers (appraiser_id) ON UPDATE CASCADE ON DELETE RESTRICT
    );

CREATE TABLE
    AppraiserSpecialities (
        assigned_date DATE NULL,
        appraiser_id INT NOT NULL,
        specialty_id INT NOT NULL,
        PRIMARY KEY (specialty_id, appraiser_id),
        CONSTRAINT fk_as_appraiser FOREIGN KEY (appraiser_id) REFERENCES Appraisers (appraiser_id) ON UPDATE CASCADE ON DELETE CASCADE,
        CONSTRAINT fk_as_specialty FOREIGN KEY (specialty_id) REFERENCES Specialities (specialty_id) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE
    Redemptions (
        redemption_id INT NOT NULL AUTO_INCREMENT,
        redemption_date DATE NOT NULL,
        redemption_amount INT NOT NULL,
        pledge_id INT NOT NULL,
        payment_method_id INT NOT NULL,
        PRIMARY KEY (redemption_id, pledge_id),
        CONSTRAINT fk_redemptions_pledge FOREIGN KEY (pledge_id) REFERENCES Pledges (pledge_id) ON UPDATE CASCADE ON DELETE CASCADE,
        CONSTRAINT fk_redemptions_payment FOREIGN KEY (payment_method_id) REFERENCES PaymentMethods (payment_method_id) ON UPDATE CASCADE ON DELETE RESTRICT
    );

CREATE VIEW
    ClientPledge AS
SELECT
    p.pledge_date,
    p.storage_item_days,
    p.pledge_amount,
    s.status_title
FROM
    Pledges p
    LEFT JOIN Statuses s ON s.status_id = p.status_id;

CREATE VIEW
    ClientRedemption AS
SELECT
    c.full_name,
    c.phone,
    r.redemption_date,
    r.redemption_amount,
    pm.payment_method_name
FROM
    Redemptions r
    JOIN Pledges p ON p.pledge_id = r.pledge_id
    JOIN Clients c ON c.client_id = p.client_id
    LEFT JOIN PaymentMethods pm ON pm.payment_method_id = r.payment_method_id;

CREATE VIEW
    PledgeApp AS
SELECT
    c.full_name AS client_full_name,
    c.phone AS client_phone,
    p.pledge_date,
    p.pledge_amount,
    a.appraisal_value,
    ap.full_name AS appraiser_full_name,
    ap.qualification
FROM
    Appraisals a
    JOIN Pledges p ON p.pledge_id = a.pledge_id
    JOIN Clients c ON c.client_id = p.client_id
    JOIN Appraisers ap ON ap.appraiser_id = a.appraiser_id;