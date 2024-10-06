-- [Problem 5]

-- DROP TABLE commands:
DROP TABLE IF EXISTS ticket_info;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS travelers;
DROP TABLE IF EXISTS purchase;
DROP TABLE IF EXISTS purchasers;
DROP TABLE IF EXISTS customers_phone; 
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS seats;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS aircrafts;

-- CREATE TABLE commands:

CREATE TABLE aircrafts (
    code                     CHAR(3)             NOT NULL,      
    manufacturer             VARCHAR(20)         NOT NULL,
    model                    VARCHAR(20)         NOT NULL,
    PRIMARY KEY (code),
    UNIQUE(manufacturer, model)
);

CREATE TABLE flights (
    flight_number            VARCHAR(20)         NOT NULL, 
    flight_date              DATE                NOT NULL,              
    flight_time              TIME                NOT NULL,
    source                   CHAR(3)             NOT NULL, 
    destination              CHAR(3)             NOT NULL,
    flight_type              VARCHAR(20)         NOT NULL, 
    code                     CHAR(3)             NOT NULL,
    PRIMARY KEY (flight_number, flight_date),
    FOREIGN KEY (code) REFERENCES aircrafts(code)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE seats (
    flight_number            VARCHAR(20)         NOT NULL,
    flight_date              DATE                NOT NULL, 
    seat_number              VARCHAR(3)          NOT NULL, 
    class                    VARCHAR(20)         NOT NULL,
    seat_type                VARCHAR(10)         NOT NULL, 
    flag_exit_row            BOOL                NOT NULL, 
    PRIMARY KEY(flight_number, flight_date, seat_number),
    FOREIGN KEY(flight_number, flight_date) REFERENCES 
        flights(flight_number, flight_date), 
    CHECK (seat_type IN ('Aisle', 'Middle', 'Window'))
);

CREATE TABLE customers (
    customer_id             INT AUTO_INCREMENT   NOT NULL, 
    first_name              VARCHAR(20)          NOT NULL,
    last_name               VARCHAR(20)          NOT NULL, 
    email                   VARCHAR(40)          NOT NULL,
    PRIMARY KEY(customer_id)
);

CREATE TABLE customers_phone (
    customer_id             INT AUTO_INCREMENT   NOT NULL, 
    phone_number            VARCHAR(20)          NOT NULL,
    PRIMARY KEY (customer_id, phone_number), 
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)     
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE purchase (
    purchase_id              INT                 NOT NULL, 
    customer_id              INT AUTO_INCREMENT  NOT NULL, 
    time_stamp               TIMESTAMP           NOT NULL, 
    confirmation_number      CHAR(6)             NOT NULL, 
    PRIMARY KEY (purchase_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE purchasers (
    customer_id              INT AUTO_INCREMENT  NOT NULL, 
    card_number              NUMERIC(16,0), 
    exp_date                 CHAR(5),           
    ver_code                 NUMERIC(3,0),        
    PRIMARY KEY(customer_id),
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE tickets (
    ticket_id                INT                 NOT NULL,
    price                    NUMERIC(10,2)       NOT NULL,
    purchase_id              INT                 NOT NULL, 
    customer_id              INT                 NOT NULL, 
    PRIMARY KEY(ticket_id),
    FOREIGN KEY (purchase_id) REFERENCES purchase(purchase_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE travelers (
    customer_id              INT AUTO_INCREMENT  NOT NULL, 
    passport_number          VARCHAR(20), 
    country_citizenship      VARCHAR(50), 
    contact_name             VARCHAR(50),
    contact_phone_number     VARCHAR(20), 
    freq_flyer_number        CHAR(7), 
    PRIMARY KEY (customer_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
        UNIQUE (passport_number)
);

CREATE TABLE ticket_info (
    ticket_id                INT                 NOT NULL, 
    seat_number              VARCHAR(3)          NOT NULL, 
    flight_number            VARCHAR(20)         NOT NULL, 
    flight_date              DATE                NOT NULL, 
    code                     CHAR(3)             NOT NULL, 
    PRIMARY KEY (ticket_id),  
    FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (flight_number, flight_date)
        REFERENCES flights(ticket_number, flight_date)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (flight_number, flight_date, seat_number)
        REFERENCES seats(flight_number, flight_date, seat_number)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (code) REFERENCES aircrafts(code)
        ON UPDATE CASCADE ON DELETE CASCADE
);






