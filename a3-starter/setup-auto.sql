-- clean up old tables;
-- must drop tables with foreign keys first
-- due to referential integrity constraints

DROP TABLE IF EXISTS participated;
DROP TABLE IF EXISTS owns;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS car;
DROP TABLE IF EXISTS accident;

-- Represents a person's information like driver's id, name, and address
-- Requires all non-null values.
CREATE TABLE person (
    driver_id       CHAR(10),
    name            VARCHAR(15)     NOT NULL,
    address         VARCHAR(500)    NOT NULL,
    PRIMARY KEY (driver_id)
);

/*  Represents information of the license, model, and year of the car
    year and model are NULL
*/
CREATE TABLE car (
    license        CHAR(7),
    model          VARCHAR(30)      NULL,
    year           YEAR(4)          NULL,
    PRIMARY KEY (license)
);

-- Represents information of report_number and date/location/summary of accident
-- summary is NULL 
CREATE TABLE accident (
    -- report_number -> auto-incrementing integer column 
    report_number       INT NOT NULL AUTO_INCREMENT,
    date_occurred       TIMESTAMP               NOT NULL,
    location            VARCHAR(500)            NOT NULL,
    summary             VARCHAR(5000)           NULL,
    PRIMARY KEY (report_number)
);

-- Represents information of the person who knows the car 
CREATE TABLE owns (
    driver_id      CHAR(10)     NOT NULL,
    license        CHAR(7)      NOT NULL,
    PRIMARY KEY (driver_id, license),
    FOREIGN KEY (driver_id) REFERENCES person(driver_id)
     ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (license) REFERENCES car(license) 
     ON DELETE CASCADE ON UPDATE CASCADE
);

-- Represents information of the driver id/license/report number/damage amount
-- damage amount is NULL 
CREATE TABLE participated (
    driver_id      CHAR(10)     NOT NULL,
    license        CHAR(7)      NOT NULL,
    report_number  INTEGER      NOT NULL,
    damage_amount  NUMERIC(9, 2)   NULL, 
    PRIMARY KEY (driver_id, license, report_number),
    FOREIGN KEY (driver_id) REFERENCES person(driver_id) ON UPDATE CASCADE,
    FOREIGN KEY (license) REFERENCES car(license) ON UPDATE CASCADE,
    FOREIGN KEY (report_number) 
     REFERENCES accident(report_number) ON UPDATE CASCADE
);




