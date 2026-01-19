-- ============================================================
-- KS.STUDIO PHOTOGRAPHY MANAGEMENT SYSTEM
-- Combined Database Schema - Full Version
-- ============================================================

-- DROP ALL EXISTING OBJECTS
BEGIN EXECUTE IMMEDIATE 'DROP TABLE payment CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE photo CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE booking CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE outdoor CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE indoor CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE package CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE client CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE photographer CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE photographer_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE client_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE photo_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE package_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE booking_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE payment_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================
-- PHOTOGRAPHER TABLE
-- ============================================================
CREATE TABLE photographer (
    pgid NUMBER(10),
    pgsnr NUMBER(10),
    pgname VARCHAR2(150) NOT NULL,
    pgph VARCHAR2(15),
    pgemail VARCHAR2(255) NOT NULL,
    pgpass VARCHAR2(100) NOT NULL,
    pgrole VARCHAR2(100) DEFAULT 'junior',
    pgstatus VARCHAR2(20) DEFAULT 'active',
    pgcreated DATE DEFAULT SYSDATE,
    CONSTRAINT photographer_pk PRIMARY KEY (pgid),
    CONSTRAINT photographer_email_uk UNIQUE (pgemail),
    CONSTRAINT photographer_mgr_fk FOREIGN KEY (pgsnr) REFERENCES photographer(pgid),
    CONSTRAINT chk_pg_role CHECK (pgrole IN ('senior', 'junior', 'intern')),
    CONSTRAINT chk_pg_status CHECK (pgstatus IN ('active', 'inactive'))
);

CREATE SEQUENCE photographer_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER photographer_bi
BEFORE INSERT ON photographer FOR EACH ROW
BEGIN
    IF :NEW.pgid IS NULL THEN
        SELECT photographer_seq.NEXTVAL INTO :NEW.pgid FROM dual;
    END IF;
END;
/

-- ============================================================
-- CLIENT TABLE
-- ============================================================
CREATE TABLE client (
    clid NUMBER(10),
    clname VARCHAR2(150) NOT NULL,
    clph VARCHAR2(15),
    clemail VARCHAR2(255) NOT NULL,
    clpass VARCHAR2(100) NOT NULL,
    claddress VARCHAR2(255),
    clstatus VARCHAR2(20) DEFAULT 'active',
    clcreated DATE DEFAULT SYSDATE,
    CONSTRAINT client_pk PRIMARY KEY (clid),
    CONSTRAINT client_email_uk UNIQUE (clemail),
    CONSTRAINT chk_cl_status CHECK (clstatus IN ('active', 'inactive'))
);

CREATE SEQUENCE client_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER client_bi
BEFORE INSERT ON client FOR EACH ROW
BEGIN
    IF :NEW.clid IS NULL THEN
        SELECT client_seq.NEXTVAL INTO :NEW.clid FROM dual;
    END IF;
END;
/

-- ============================================================
-- PACKAGE TABLE
-- ============================================================
CREATE TABLE package (
    pkgid NUMBER(10),
    pkgname VARCHAR2(255) NOT NULL,
    pkgprice NUMBER(10,2) CHECK (pkgprice > 0),
    pkgcateg VARCHAR2(100) NOT NULL,
    pkgduration NUMBER(5,2),
    eventtype VARCHAR2(100),
    pkgdesc VARCHAR2(500),
    pkgstatus VARCHAR2(20) DEFAULT 'active',
    createdby NUMBER(10),
    createddate DATE DEFAULT SYSDATE,
    CONSTRAINT package_pk PRIMARY KEY (pkgid),
    CONSTRAINT chk_pkg_categ CHECK (pkgcateg IN ('Indoor', 'Outdoor')),
    CONSTRAINT chk_pkg_event CHECK (eventtype IN ('Wedding', 'Birthday', 'Corporate', 'Portrait', 'Other')),
    CONSTRAINT chk_pkg_status CHECK (pkgstatus IN ('active', 'inactive')),
    CONSTRAINT package_creator_fk FOREIGN KEY (createdby) REFERENCES photographer(pgid)
);

CREATE SEQUENCE package_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER package_bi
BEFORE INSERT ON package FOR EACH ROW
BEGIN
    IF :NEW.pkgid IS NULL THEN
        SELECT package_seq.NEXTVAL INTO :NEW.pkgid FROM dual;
    END IF;
END;
/

-- ============================================================
-- INDOOR TABLE
-- ============================================================
CREATE TABLE indoor (
    pkgid NUMBER(10),
    numofpax NUMBER(5) DEFAULT 1,
    backgtype VARCHAR2(100) DEFAULT 'White',
    CONSTRAINT indoor_pk PRIMARY KEY (pkgid),
    CONSTRAINT indoor_pkg_fk FOREIGN KEY (pkgid) REFERENCES package(pkgid) ON DELETE CASCADE,
    CONSTRAINT chk_bg_type CHECK (backgtype IN ('White', 'Black', 'Green Screen', 'Custom'))
);

-- ============================================================
-- OUTDOOR TABLE
-- ============================================================
CREATE TABLE outdoor (
    pkgid NUMBER(10),
    distance NUMBER(6,2) DEFAULT 0,
    distancepriceperkm NUMBER(8,2) DEFAULT 0,
    location VARCHAR2(200),
    CONSTRAINT outdoor_pk PRIMARY KEY (pkgid),
    CONSTRAINT outdoor_pkg_fk FOREIGN KEY (pkgid) REFERENCES package(pkgid) ON DELETE CASCADE
);

-- ============================================================
-- PHOTO TABLE (Photo folder links for clients)
-- ============================================================
CREATE TABLE photo (
    folderid NUMBER(10),
    folderlink VARCHAR2(500),
    foldername VARCHAR2(100),
    folderdupload DATE DEFAULT SYSDATE,
    uploadedby NUMBER(10),
    notesforclient VARCHAR2(500),
    CONSTRAINT photo_pk PRIMARY KEY (folderid),
    CONSTRAINT photo_uploader_fk FOREIGN KEY (uploadedby) REFERENCES photographer(pgid)
);

CREATE SEQUENCE photo_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER photo_bi
BEFORE INSERT ON photo FOR EACH ROW
BEGIN
    IF :NEW.folderid IS NULL THEN
        SELECT photo_seq.NEXTVAL INTO :NEW.folderid FROM dual;
    END IF;
END;
/

-- ============================================================
-- BOOKING TABLE
-- ============================================================
CREATE TABLE booking (
    bookingid NUMBER(10),
    clid NUMBER(10) NOT NULL,
    pgid NUMBER(10),
    pkgid NUMBER(10) NOT NULL,
    folderid NUMBER(10),
    bookdate DATE NOT NULL,
    bookstarttime TIMESTAMP,
    bookendtime TIMESTAMP,
    bookpax NUMBER(5) DEFAULT 1 CHECK (bookpax > 0),
    booklocation VARCHAR2(200),
    totalprice NUMBER(10,2),
    bookstatus VARCHAR2(50) DEFAULT 'Pending',
    booknotes VARCHAR2(500),
    bookcreated DATE DEFAULT SYSDATE,
    CONSTRAINT booking_pk PRIMARY KEY (bookingid),
    CONSTRAINT booking_client_fk FOREIGN KEY (clid) REFERENCES client(clid),
    CONSTRAINT booking_photographer_fk FOREIGN KEY (pgid) REFERENCES photographer(pgid),
    CONSTRAINT booking_package_fk FOREIGN KEY (pkgid) REFERENCES package(pkgid),
    CONSTRAINT booking_photo_fk FOREIGN KEY (folderid) REFERENCES photo(folderid),
    CONSTRAINT chk_book_status CHECK (bookstatus IN ('Pending', 'Waiting Approval', 'Confirmed', 'Completed', 'Cancelled'))
);

CREATE SEQUENCE booking_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER booking_bi
BEFORE INSERT ON booking FOR EACH ROW
BEGIN
    IF :NEW.bookingid IS NULL THEN
        SELECT booking_seq.NEXTVAL INTO :NEW.bookingid FROM dual;
    END IF;
END;
/

-- ============================================================
-- PAYMENT TABLE
-- ============================================================
CREATE TABLE payment (
    payid NUMBER(10),
    bookingid NUMBER(10) NOT NULL,
    depopref VARCHAR2(100),
    depopdate DATE,
    deporeceipt VARCHAR2(500),
    fullpref VARCHAR2(100),
    fullpdate DATE,
    fullreceipt VARCHAR2(500),
    paidamount NUMBER(10,2) DEFAULT 0 CHECK (paidamount >= 0),
    remamount NUMBER(10,2) DEFAULT 0 CHECK (remamount >= 0),
    receipts VARCHAR2(500),
    paystatus VARCHAR2(20) DEFAULT 'pending',
    paynotes VARCHAR2(500),
    verifiedby NUMBER(10),
    verifieddate DATE,
    CONSTRAINT payment_pk PRIMARY KEY (payid),
    CONSTRAINT payment_booking_fk FOREIGN KEY (bookingid) REFERENCES booking(bookingid),
    CONSTRAINT payment_verifier_fk FOREIGN KEY (verifiedby) REFERENCES photographer(pgid),
    CONSTRAINT chk_pay_status CHECK (paystatus IN ('pending', 'submitted', 'partial', 'verified', 'rejected'))
);

CREATE SEQUENCE payment_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER payment_bi
BEFORE INSERT ON payment FOR EACH ROW
BEGIN
    IF :NEW.payid IS NULL THEN
        SELECT payment_seq.NEXTVAL INTO :NEW.payid FROM dual;
    END IF;
END;
/

-- ============================================================
-- INSERT SAMPLE DATA
-- ============================================================

-- Photographers
INSERT INTO photographer (pgname, pgph, pgemail, pgpass, pgrole, pgstatus)
VALUES ('Admin Senior', '019-1234567', 'senior@ksstudio.com', 'admin123', 'senior', 'active');

INSERT INTO photographer (pgsnr, pgname, pgph, pgemail, pgpass, pgrole, pgstatus)
VALUES (1, 'Ahmad Junior', '019-7654321', 'junior@ksstudio.com', 'junior123', 'junior', 'active');

INSERT INTO photographer (pgsnr, pgname, pgph, pgemail, pgpass, pgrole, pgstatus)
VALUES (1, 'Sarah Intern', '019-5555555', 'intern@ksstudio.com', 'intern123', 'intern', 'active');

-- Clients
INSERT INTO client (clname, clph, clemail, clpass, claddress)
VALUES ('Ali Ahmad', '019-1111111', 'ali@email.com', 'client123', 'Kuala Lumpur');

INSERT INTO client (clname, clph, clemail, clpass, claddress)
VALUES ('Siti Aminah', '019-2222222', 'siti@email.com', 'client123', 'Selangor');

INSERT INTO client (clname, clph, clemail, clpass, claddress)
VALUES ('John Tan', '019-3333333', 'john@email.com', 'client123', 'Penang');

-- Indoor Packages
INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby)
VALUES ('Family Portrait', 150, 'Indoor', 0.5, 'Portrait', 'Perfect for family portraits up to 5 people', 1);
INSERT INTO indoor (pkgid, numofpax, backgtype) VALUES (1, 5, 'White');

INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby)
VALUES ('Corporate Headshot', 200, 'Indoor', 1, 'Corporate', 'Professional headshots for business profiles', 1);
INSERT INTO indoor (pkgid, numofpax, backgtype) VALUES (2, 10, 'White');

INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby)
VALUES ('Birthday Party', 300, 'Indoor', 2, 'Birthday', 'Indoor birthday party photography coverage', 1);
INSERT INTO indoor (pkgid, numofpax, backgtype) VALUES (3, 20, 'Custom');

INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby)
VALUES ('Graduation Portrait', 180, 'Indoor', 1, 'Portrait', 'Graduation photos with cap and gown', 1);
INSERT INTO indoor (pkgid, numofpax, backgtype) VALUES (4, 3, 'Black');

-- Outdoor Packages
INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby)
VALUES ('Wedding Photoshoot', 500, 'Outdoor', 3, 'Wedding', 'Full wedding coverage with professional photographers', 1);
INSERT INTO outdoor (pkgid, distance, distancepriceperkm, location) VALUES (5, 50, 2, 'Kuala Lumpur');

INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby)
VALUES ('Pre-Wedding Shoot', 600, 'Outdoor', 4, 'Wedding', 'Beautiful outdoor pre-wedding session', 1);
INSERT INTO outdoor (pkgid, distance, distancepriceperkm, location) VALUES (6, 30, 2.5, 'Selangor');

INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby)
VALUES ('Event Coverage', 800, 'Outdoor', 5, 'Corporate', 'Complete corporate event photography coverage', 1);
INSERT INTO outdoor (pkgid, distance, distancepriceperkm, location) VALUES (7, 100, 3, 'Nationwide');

-- Sample Bookings
INSERT INTO booking (clid, pgid, pkgid, bookdate, bookstarttime, bookendtime, bookpax, booklocation, totalprice, bookstatus)
VALUES (1, 1, 1, TO_DATE('2026-01-20', 'YYYY-MM-DD'), 
        TO_TIMESTAMP('2026-01-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_TIMESTAMP('2026-01-20 10:30:00', 'YYYY-MM-DD HH24:MI:SS'),
        5, 'KS Studio', 150, 'Confirmed');

INSERT INTO booking (clid, pgid, pkgid, bookdate, bookstarttime, bookendtime, bookpax, booklocation, totalprice, bookstatus)
VALUES (2, 1, 5, TO_DATE('2026-01-25', 'YYYY-MM-DD'), 
        TO_TIMESTAMP('2026-01-25 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_TIMESTAMP('2026-01-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        2, 'Taman Tasik Titiwangsa', 600, 'Waiting Approval');

INSERT INTO booking (clid, pgid, pkgid, bookdate, bookstarttime, bookendtime, bookpax, booklocation, totalprice, bookstatus)
VALUES (3, 2, 2, TO_DATE('2026-01-22', 'YYYY-MM-DD'), 
        TO_TIMESTAMP('2026-01-22 14:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_TIMESTAMP('2026-01-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        10, 'KS Studio', 200, 'Pending');

-- Sample Payments (for testing verification)
INSERT INTO payment (bookingid, depopref, depopdate, paidamount, remamount, receipts, paystatus)
VALUES (1, 'Deposit 30%', SYSDATE-5, 45, 105, 'receipt001.jpg', 'pending');

INSERT INTO payment (bookingid, depopref, depopdate, paidamount, remamount, receipts, paystatus)
VALUES (2, 'Deposit 30%', SYSDATE-2, 180, 420, 'receipt002.jpg', 'pending');

INSERT INTO payment (bookingid, depopref, depopdate, paidamount, remamount, paystatus)
VALUES (3, 'Deposit 30%', SYSDATE-1, 60, 140, 'pending');

-- Sample Photo folder (already uploaded, waiting for payment verification)
INSERT INTO photo (folderlink, foldername, notesforclient, uploadedby)
VALUES ('https://drive.google.com/drive/folders/example123', 'Ali Family Photos Jan 2026', 'Photos available for 30 days. Please download and save.', 1);
UPDATE booking SET folderid = 1 WHERE bookingid = 1;

COMMIT;

-- ============================================================
-- VERIFICATION
-- ============================================================
SELECT 'PHOTOGRAPHERS' AS DATA_TYPE, COUNT(*) AS COUNT FROM photographer
UNION ALL SELECT 'CLIENTS', COUNT(*) FROM client
UNION ALL SELECT 'PACKAGES', COUNT(*) FROM package
UNION ALL SELECT 'BOOKINGS', COUNT(*) FROM booking
UNION ALL SELECT 'PAYMENTS', COUNT(*) FROM payment
UNION ALL SELECT 'PHOTOS', COUNT(*) FROM photo;

-- ============================================================
-- LOGIN CREDENTIALS
-- ============================================================
-- PHOTOGRAPHER PORTAL:
--   senior@ksstudio.com / admin123 (Senior Admin - Full Access)
--   junior@ksstudio.com / junior123 (Junior Staff)
--   intern@ksstudio.com / intern123 (Intern)
--
-- CLIENT PORTAL:
--   ali@email.com / client123
--   siti@email.com / client123
--   john@email.com / client123
-- ============================================================
