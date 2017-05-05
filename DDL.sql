--DROP TABLE MaintenancePackage;
--DROP TABLE Vehicle;

create table Customers (
    custID VARCHAR(20) NOT NULL,
    Name VARCHAR(40) NOT NULL,
    firstName VARCHAR(20) NOT NULL,
    lastName VARCHAR(20) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    CONSTRAINT customer_pk PRIMARY KEY (custID)
);

create table Corporations(
    custID VARCHAR(20) NOT NULL,
    CONSTRAINT corporation_pk PRIMARY KEY (custID),
    CONSTRAINT corportaion_fk FOREIGN KEY (custID)
        REFERENCES Customers (custID)
);

create table PrivateIndividuals(
    custID VARCHAR(20) NOT NULL,
    street VARCHAR(40) NOT NULL,
    city VARCHAR(20) NOT NULL,
    state VARCHAR(10) NOT NULL,
    CONSTRAINT privind_pk PRIMARY KEY (custID),
    CONSTRAINT privind_fk FOREIGN KEY (custID)
        REFERENCES Customers (custID)
);

create table Addressess(
    custID VARCHAR(20) NOT NULL,
    type VARCHAR(10) NOT NULL,
    street VARCHAR(40) NOT NULL,
    city VARCHAR(20) NOT NULL,
    state VARCHAR(10) NOT NULL,
    CONSTRAINT address_pk PRIMARY KEY (custID, type, street),
    CONSTRAINT address_fk FOREIGN KEY (custID)
        REFERENCES Customers (custID)
);

create table ExistingCustomers(
    custID VARCHAR(20) NOT NULL,
    regDate DATE NOT NULL,
    CONSTRAINT existing_pk PRIMARY KEY (custID),
    CONSTRAINT existing_fk FOREIGN KEY (custID)
        REFERENCES Customers (custID)
);

create table SteadyCustomers(
    custID VARCHAR(20) NOT NULL,
    loyalty_points INTEGER NOT NULL,
    CONSTRAINT steady_pk PRIMARY KEY (custID),
    CONSTRAINT steady_fk FOREIGN KEY (custID)
        REFERENCES ExistingCustomers (custID)
);

create table PremiereCustomers(
    custID VARCHAR(20) NOT NULL,
    monthly_fee DECIMAL NOT NULL,
    CONSTRAINT premiere_pk PRIMARY KEY (custID),
    CONSTRAINT premiere_fk FOREIGN KEY (custID)
        REFERENCES ExistingCustomers (custID)
);

create table ProspectiveCustomers(
    custID VARCHAR(20) NOT NULL,
    refID VARCHAR(20) NOT NULL,
    status VARCHAR(10) NOT NULL,
    referal_date DATE NOT NULL,
    CONSTRAINT prospective_pk PRIMARY KEY (custID, refID),
    CONSTRAINT prospective_fk_cust FOREIGN KEY (custID)
        REFERENCES Customers (custID),
    CONSTRAINT prospective_fk_ref FOREIGN KEY (refID)
        REFERENCES ExistingCustomers (custID)
);


create table Emails(
    emailID VARCHAR(20) NOT NULL,
    subject VARCHAR(20) not NULL,
    message VARCHAR(50) NOT NULL,
    CONSTRAINT email_pk PRIMARY KEY (emailID)
);

create table EmailSteady(
    emailID VARCHAR(20) NOT NULL,
    custID VARCHAR(20) NOT NULL,
    packageID VARCHAR(20) NOT NULL,
    date_sent DATE NOT NULL,
    CONSTRAINT email_steady_pk PRIMARY KEY (emailID, custID, packageID, date_sent),
    CONSTRAINT email_steady_fk FOREIGN KEY (emailID)
        REFERENCES Emails (emailID),
    CONSTRAINT email_cust_fk FOREIGN KEY (custID)
        REFERENCES SteadyCustomers (custID),
    CONSTRAINT email_pack_id FOREIGN KEY (packageID)
        REFERENCES MaintenancePackage (packageID)
);

create table EmailProspective(
    emailID VARCHAR(20) NOT NULL,
    custID VARCHAR(20) NOT NULL,
    date_sent DATE NOT NULL,
    CONSTRAINT email_pros_pk PRIMARY KEY (emailID, custID, date_sent),
    CONSTRAINT email_pros_fk FOREIGN KEY (emailID)
        REFERENCES Emails (emailID),
    CONSTRAINT email_pros_cust_fk FOREIGN KEY (custID)
        REFERENCES ProspectiveCustomers (custID)
);

CREATE TABLE Vehicle(
    VIN                     varchar(17) NOT NULL,
    make                    varchar(20) NOT NULL,
    model                   varchar(20) NOT NULL,
    vyear                   int NOT NULL,
    currentMileage          int NOT NULL,
    estimatedMilePerYear    int NOT NULL,
    custID                  varchar(20) NOT NULL,
    CONSTRAINT 	vehicle_pk  PRIMARY KEY (VIN).
	CONSTRAINT	vehicle_fk 	FOREIGN KEY(custID) 
		REFERENCES Customers(custID)
);

CREATE TABLE MaintenancePackage(
    packageID 				VARCHAR(20) NOT NULL,
    packageName             varchar(20) NOT NULL,
    packMileage             int NOT NULL,
    VIN                     varchar(17) NOT NULL,
    itemID                  varchar(20) NOT NULL,
    CONSTRAINT  maintenancepackage_pk  PRIMARY KEY (packageID),
    CONSTRAINT maintenancepackage_fk FOREIGN KEY (VIN) REFERENCES Vehicle (VIN),
    CONSTRAINT maintenancepackage_fk FOREIGN KEY (itemID) REFERENCES MaintenanceItem (itemID)
);

CREATE TABLE MaintenanceVisit (
    VIN varchar(17) NOT NULL,
    visitID varchar(20) NOT NULL,
    visitDate date NOT NULL,
    expectedMileage int NOT NULL,
    actualMileage int NOT NULL,
    billedAmount double NOT NULL,
    packageID VARCHAR(20) NOT NULL,
    employeeID varchar(20) NOT NULL,
    CONSTRAINT MaintenanceVisits_pk PRIMARY KEY (visitID)
);

CREATE TABLE MaintenanceItem (
    itemID varchar(20) NOT NULL,
    itemName varchar(30) NOT NULL,
    itemCost double NOT NULL,
    laborHours int NOT NULL,
    itemDesc varchar(50),
    skillName varchar(20) NOT NULL,
    CONSTRAINT MaintenanceItem_pk PRIMARY KEY (itemID)
);

CREATE TABLE VisitItem (
    itemID varchar(20) NOT NULL,
    visitID varchar(20) NOT NULL,
    hours int NOT NULL,
    employeeID varchar(20) NOT NULL,
    CONSTRAINT VisitItem_pk PRIMARY KEY (itemID, visitID),
    CONSTRAINT VisitItem_fk_1 FOREIGN KEY (itemID) REFERENCES MaintenanceItem (itemID),
    CONSTRAINT VisitItem_fk_2 FOREIGN KEY (visitID) REFERENCES MaintenanceVisit (visitID)
);

ALTER TABLE MaintenanceVisit
    ADD CONSTRAINT MaintenanceVisit_fk_1 FOREIGN KEY (VIN) REFERENCES Vehicle (vin);
ALTER TABLE MaintenanceVisit
    ADD CONSTRAINT MaintenanceVisit_fk_2 FOREIGN KEY (packageID) REFERENCES MaintenancePackage (packageID);