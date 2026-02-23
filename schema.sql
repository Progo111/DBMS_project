CREATE DATABASE IF NOT EXISTS pawnshop;

USE pawnshop;

CREATE TABLE
    Appraisals (
        appraisal_id INTEGER NOT NULL,
        appraisal_value INTEGER NULL,
        appraisal_date DATE NULL,
        pledge_id INTEGER NOT NULL,
        appraiser_id INTEGER NOT NULL
    );

ALTER TABLE Appraisals ADD PRIMARY KEY (appraisal_id, pledge_id, appraiser_id);

CREATE TABLE
    Appraisers (
        appraiser_id INTEGER NOT NULL,
        full_name VARCHAR(20) NULL,
        qualification VARCHAR(20) NULL
    );

ALTER TABLE Appraisers ADD PRIMARY KEY (appraiser_id);

CREATE TABLE
    AppraiserSpecialities (
        assigned_date DATE NULL,
        appraiser_id INTEGER NOT NULL,
        specialty_id INTEGER NOT NULL
    );

ALTER TABLE AppraiserSpecialities ADD PRIMARY KEY (specialty_id, appraiser_id);

CREATE TABLE
    Clients (
        client_id INTEGER NOT NULL,
        full_name VARCHAR(20) NULL,
        passport_data VARCHAR(20) NULL,
        phone VARCHAR(20) NULL,
        address VARCHAR(20) NULL,
        birth_date DATE NULL
    );

ALTER TABLE Clients ADD PRIMARY KEY (client_id);

CREATE TABLE
    HomeAppliances (
        item_name VARCHAR(20) NULL,
        brand VARCHAR(20) NULL,
        model VARCHAR(20) NULL,
        serial_number VARCHAR(20) NULL,
        pledge_id INTEGER NOT NULL
    );

ALTER TABLE HomeAppliances ADD PRIMARY KEY (pledge_id);

CREATE TABLE
    Jewelry (
        item_name VARCHAR(20) NULL,
        metal VARCHAR(20) NULL,
        gemstone VARCHAR(20) NULL,
        pledge_id INTEGER NOT NULL
    );

ALTER TABLE Jewelry ADD PRIMARY KEY (pledge_id);

CREATE TABLE
    PaymentMethods (
        payment_method_id INTEGER NOT NULL,
        payment_method_name VARCHAR(20) NULL
    );

ALTER TABLE PaymentMethods ADD PRIMARY KEY (payment_method_id);

CREATE TABLE
    Pledges (
        pledge_id INTEGER NOT NULL,
        pledge_date DATE NULL,
        pledge_amount INTEGER NULL,
        status_id INTEGER NULL,
        storage_item_days INTEGER NULL,
        client_id INTEGER NOT NULL,
        category CHAR(18) NULL
    );

ALTER TABLE Pledges ADD PRIMARY KEY (pledge_id);

CREATE TABLE
    Redemptions (
        redemption_id INTEGER NOT NULL,
        redemption_date DATE NULL,
        redemption_amount INTEGER NULL,
        pledge_id INTEGER NOT NULL,
        payment_method_id INTEGER NULL
    );

ALTER TABLE Redemptions ADD PRIMARY KEY (redemption_id, pledge_id);

CREATE TABLE
    Specialities (
        specialty_id INTEGER NOT NULL,
        specialty_name VARCHAR(20) NULL
    );

ALTER TABLE Specialities ADD PRIMARY KEY (specialty_id);

CREATE TABLE
    Statuses (
        status_id INTEGER NOT NULL,
        status_title VARCHAR(20) NULL
    );

ALTER TABLE Statuses ADD PRIMARY KEY (status_id);

CREATE VIEW
    ClientPledge (
        pledge_date,
        storage_item_days,
        pledge_amount,
        status_title
    ) AS
SELECT
    Pledges.pledge_date,
    Pledges.storage_item_days,
    Pledges.pledge_amount,
    Statuses.status_title
FROM
    Clients,
    Pledges,
    Statuses;

CREATE VIEW
    ClientRedemption (
        full_name,
        phone,
        redemption_date,
        redemption_amount,
        payment_method_name
    ) AS
SELECT
    Clients.full_name,
    Clients.phone,
    Redemptions.redemption_date,
    Redemptions.redemption_amount,
    PaymentMethods.payment_m
FROM
    Redemptions,
    Clients,
    PaymentMethods;

CREATE VIEW
    PledgeApp (
        full_name,
        phone,
        pledge_date,
        pledge_amount,
        appraisal_value,
        full_name,
        qualification
    ) AS
SELECT
    Clients.full_name,
    Clients.phone,
    Pledges.pledge_date,
    Pledges.pledge_amount,
    Appraisals.appraisal_value,
    Appraisers.full_name
FROM
    Appraisals,
    Appraisers,
    Pledges,
    Clients;

ALTER TABLE Appraisals ADD FOREIGN KEY R_7 (pledge_id) REFERENCES Pledges (pledge_id);

ALTER TABLE Appraisals ADD FOREIGN KEY R_9 (appraiser_id) REFERENCES Appraisers (appraiser_id);

ALTER TABLE AppraiserSpecialities ADD FOREIGN KEY R_11 (appraiser_id) REFERENCES Appraisers (appraiser_id);

ALTER TABLE AppraiserSpecialities ADD FOREIGN KEY R_12 (specialty_id) REFERENCES Specialities (specialty_id);

ALTER TABLE HomeAppliances ADD FOREIGN KEY (pledge_id) REFERENCES Pledges (pledge_id) ON DELETE CASCADE;

ALTER TABLE Jewelry ADD FOREIGN KEY (pledge_id) REFERENCES Pledges (pledge_id) ON DELETE CASCADE;

ALTER TABLE Pledges ADD FOREIGN KEY R_4 (status_id) REFERENCES Statuses (status_id);

ALTER TABLE Pledges ADD FOREIGN KEY R_36 (client_id) REFERENCES Clients (client_id);

ALTER TABLE Redemptions ADD FOREIGN KEY R_8 (pledge_id) REFERENCES Pledges (pledge_id);

ALTER TABLE Redemptions ADD FOREIGN KEY R_10 (payment_method_id) REFERENCES PaymentMethods (payment_method_id);