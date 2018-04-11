DROP TABLE order_report PURGE;
DROP TABLE order_details PURGE;
DROP TABLE Inventory PURGE;
DROP TABLE Part PURGE;
DROP TABLE t_Orders PURGE;
DROP TABLE Customer PURGE;
DROP TABLE Rep PURGE;
DROP TABLE Warehouse PURGE;
DROP TABLE Producer PURGE;

CREATE TABLE REP
(
  RepID      CHAR(2) CONSTRAINT REP_RepID_PK PRIMARY KEY,
  Last_Name  CHAR(15),
  First_Name CHAR(15),
  Hire_Date  DATE,
  Street     CHAR(15),
  City       CHAR(15),
  State      CHAR(2),
  Zip        CHAR(5),
  Commission DECIMAL(7, 2),
  Rate       DECIMAL(3, 2),
  CONSTRAINT REP_Commission_CK CHECK (commission >= 0)
);


COMMENT ON TABLE rep IS 'Sales Representative table';
COMMENT ON COLUMN Rep.RepID IS 'Sales representative identifier';
COMMENT ON COLUMN Rep.Last_Name IS 'Last name of the representative';
COMMENT ON COLUMN Rep.First_Name IS 'First name of the representative';
COMMENT ON COLUMN Rep.Hire_Date IS 'Date when the rep started employment';
COMMENT ON COLUMN Rep.Street IS 'Sales representative street address';
COMMENT ON COLUMN Rep.City IS 'Sales representative city';
COMMENT ON COLUMN Rep.State IS 'Sales representative state';
COMMENT ON COLUMN Rep.Zip IS 'Sales representative postal code';
COMMENT ON COLUMN Rep.Commission IS 'Total commission';
COMMENT ON COLUMN Rep.Rate IS 'Commission rate';


CREATE TABLE CUSTOMER
(
  CusID        CHAR(3) CONSTRAINT CUSTOMER_CusID_PK PRIMARY KEY,
  Cus_Name     CHAR(35)                    CONSTRAINT CUSTOMER_CusName_NN NOT NULL,
  Cus_Email    CHAR(25),
  Phone        CHAR(12),
  Street       CHAR(15),
  City         CHAR(15),
  State        CHAR(2) DEFAULT 'PA',
  Zip          CHAR(5),
  Balance      DECIMAL(8, 2)               CONSTRAINT CUSTOMER_Balance_NN NOT NULL,
  Credit_Limit DECIMAL(8, 2) DEFAULT 2500  CONSTRAINT CUSTOMER_CreditLimit_NN NOT NULL,
  RepID        CHAR(2),
  CONSTRAINT CUSTOMER_RepNum_FK FOREIGN KEY (RepID) REFERENCES REP (RepID),
  CONSTRAINT CUSTOMER_balance_CK CHECK (balance >= 0),
  CONSTRAINT CUSTOMER_CreditLimit_CK CHECK (credit_limit >= 0)
);

COMMENT ON TABLE Customer IS 'Table includes basic customer information';
COMMENT ON COLUMN Customer.CusID IS 'Customer identifier';
COMMENT ON COLUMN Customer.Cus_Name IS 'Customer name';
COMMENT ON COLUMN Customer.Cus_Email IS 'Customer email';
COMMENT ON COLUMN Customer.Phone IS 'Customer phone';
COMMENT ON COLUMN Customer.Street IS 'Customer street address';
COMMENT ON COLUMN Customer.City IS 'Customer city';
COMMENT ON COLUMN Customer.State IS 'Customer state';
COMMENT ON COLUMN Customer.Zip IS 'Customer postal code';
COMMENT ON COLUMN Customer.Balance IS 'Customer balance � amount owed';
COMMENT ON COLUMN Customer.Credit_Limit IS 'Customer credit limit';
COMMENT ON COLUMN Customer.RepID IS 'ID of Rep assigned to the customer';

CREATE TABLE t_ORDERS
(
  Order#     CHAR(5) CONSTRAINT ORDER_Order#_PK PRIMARY KEY,
  Order_Date DATE,
  Ship_Date  DATE,
  Status     CHAR(8) DEFAULT 'Open',
  Pay_Method CHAR(5) DEFAULT 'Card',
  RepID      CHAR(2) CONSTRAINT ORDER_RepID_NN NOT NULL,
  CusID      CHAR(3) CONSTRAINT ORDER_CusID_NN NOT NULL,
  CONSTRAINT ORDER_RepID_FK FOREIGN KEY (RepID) REFERENCES REP (RepID),
  CONSTRAINT ORDER_CusID_FK FOREIGN KEY (CusID) REFERENCES CUSTOMER (CusID)
);

COMMENT ON TABLE t_ORDERS IS 'It has only the ID and date of an order placed by a customer';
COMMENT ON COLUMN t_ORDERS.Order# IS 'Order ID number';
COMMENT ON COLUMN t_ORDERS.Order_Date IS 'Date of the order';
COMMENT ON COLUMN t_ORDERS.Ship_Date IS 'Date of shipping the order';
COMMENT ON COLUMN t_ORDERS.Status IS 'Status of the Order';
COMMENT ON COLUMN t_ORDERS.Pay_Method IS 'Payment method';
COMMENT ON COLUMN t_ORDERS.RepID IS 'ID of REP who processed the order';
COMMENT ON COLUMN t_ORDERS.CusID IS 'ID of customer who placed the order';

CREATE TABLE PRODUCER
(
  P_Num CHAR(4) CONSTRAINT PRODUCER_PNum_PK PRIMARY KEY,
  Name  CHAR(20),
  Phone CHAR(12)
);

COMMENT ON TABLE Producer IS 'Manufacturer of products/parts';
COMMENT ON COLUMN Producer.P_Num IS 'Identifier of manufacturer';
COMMENT ON COLUMN Producer.Name IS 'Name of manufacturer';
COMMENT ON COLUMN Producer.Phone IS 'Manufacturer Phone';

CREATE TABLE PART
(
  Part# CHAR(4) CONSTRAINT PART_Part#_PK PRIMARY KEY,
  Name  CHAR(15),
  Class CHAR(2),
  Price DECIMAL(6, 2),
  P_Num CHAR(4),
  CONSTRAINT Part_PNum_FK FOREIGN KEY (P_Num) REFERENCES PRODUCER (P_Num),
  CONSTRAINT PART_Price_CK CHECK (price > 0)
);

COMMENT ON TABLE Part IS 'Parts in inventory';
COMMENT ON COLUMN Part.Part# IS 'Identifier of part/item/product';
COMMENT ON COLUMN Part.Name IS 'Description of the part';
COMMENT ON COLUMN Part.Class IS 'Class of the part';
COMMENT ON COLUMN Part.Price IS 'Price of the part';
COMMENT ON COLUMN Part.P_Num IS 'ID of manufacturer';


CREATE TABLE ORDER_DETAILS
(
  Order#       CHAR(5),
  Part#        CHAR(4),
  Num_Ordered  DECIMAL(3, 0),
  Quoted_Price DECIMAL(6, 2),
  CONSTRAINT ORDERDETAILS_PK PRIMARY KEY (Order#, Part#),
  CONSTRAINT ORDERDETAILS_Order#_FK FOREIGN KEY (Order#) REFERENCES t_ORDERS (Order#),
  CONSTRAINT ORDERDETAILS_Part#_FK FOREIGN KEY (Part#) REFERENCES PART (Part#)
);

COMMENT ON TABLE Order_Details IS 'Details of each order placed by a customer';
COMMENT ON COLUMN Order_Details.Order# IS 'Identifier of the order';
COMMENT ON COLUMN Order_Details.Part# IS 'ID of part on individual order line';
COMMENT ON COLUMN Order_Details.Num_Ordered IS 'Number of part ordered on the line';
COMMENT ON COLUMN Order_Details.Quoted_Price IS 'Quoted price at the time of the order';

CREATE TABLE WAREHOUSE
(
  Warehouse#    CHAR(1),
  Location      VARCHAR2(15),
  Phone         VARCHAR2(12),
  Mngr_Name     VARCHAR2(15),
  Num_Employees DECIMAL(4, 0),
  Area          DECIMAL(7, 1),
  CONSTRAINT Warehouse_PK PRIMARY KEY (warehouse#)
);

COMMENT ON TABLE Warehouse IS 'Warehouse where we keep the inventory of products';
COMMENT ON COLUMN Warehouse.Warehouse# IS 'ID of the warehouse';
COMMENT ON COLUMN Warehouse.Location IS 'Name of city where the warehouse is located';
COMMENT ON COLUMN Warehouse.Phone IS 'Phone number to the warehouse';
COMMENT ON COLUMN Warehouse.Mngr_Name IS 'First and Last name of the manager';
COMMENT ON COLUMN Warehouse.Num_Employees IS 'Number of employees working at the location';
COMMENT ON COLUMN Warehouse.Area IS 'Area (sqr Feet) of the warehouse';

CREATE TABLE INVENTORY
(
  Warehouse#       CHAR(1),
  Part#            CHAR(4),
  On_Hand          DECIMAL(4, 0),
  Min_Quantity     DECIMAL(4, 0),
  Next_Supply_Date DATE,
  CONSTRAINT Inventory_PK PRIMARY KEY (Warehouse#, Part#),
  CONSTRAINT Inventory_min_qty_CK CHECK (Min_Quantity >= 0),
  CONSTRAINT Inventory_On_Hand_CK CHECK (On_Hand >= 0),
  CONSTRAINT Inventory_Warehouse#_FK FOREIGN KEY (Warehouse#) REFERENCES WAREHOUSE (Warehouse#),
  CONSTRAINT Inventory_Part#_FK FOREIGN KEY (Part#) REFERENCES PART (Part#)
);

COMMENT ON TABLE Inventory IS 'Inventory � what we have and where it is';
COMMENT ON COLUMN Inventory.Warehouse# IS 'ID of the Warehouse';
COMMENT ON COLUMN Inventory.Part# IS 'ID of the part in the inventory';
COMMENT ON COLUMN Inventory.On_Hand IS 'Number of copies of the part in the Inventory';
COMMENT ON COLUMN Inventory.Min_Quantity IS 'Minimum quantity before reorder';
COMMENT ON COLUMN Inventory.Next_Supply_Date IS 'Date of Next Reorder';


INSERT INTO REP VALUES
  ('20', 'Kaiser', 'Valerie', TO_DATE('14-OCT-2000', 'DD-MON-YYYY'), '624 Randall', 'Lester', 'PA', '15503', 20542.50,
   0.05);
INSERT INTO REP VALUES
  ('30', 'Hull', 'Richard', TO_DATE('09-JUN-1998', 'DD-MON-YYYY'), '532 Jackson', 'Franklin', 'PA', '15321', 39216.00,
   0.07);
INSERT INTO REP VALUES
  ('40', 'Perez', 'Juan', TO_DATE('22-APR-1992', 'DD-MON-YYYY'), '1626 Taylor', 'Akron', 'PA', '15146', 23487.00, 0.05);


INSERT INTO CUSTOMER VALUES
  ('148', 'Al''s Appliances', 'alsstore@net.com', '412-234-9845', '1828 Raven', 'Carnegie', 'PA', '15236', 6550.00,
          7500.00, '20');
INSERT INTO CUSTOMER VALUES
  ('282', 'Brookings Direct', 'brook@bdirect.com', '412-111-2222', '28 Lakeview', 'Lester', 'PA', '15503', 431.50,
          10000.00, '30');
INSERT INTO CUSTOMER VALUES
  ('356', 'Ferguson''s', 'fergie55@bymail.com', '412-345-9876', '282 Columbia', 'Northfield', 'PA', '15106', 5785.00,
          7500.00, '40');
INSERT INTO CUSTOMER VALUES
  ('408', 'The Everything Shop', 'everything@myshop.com', '412-234-5678', '282 Evergreen', 'Franklin', 'PA', '15321',
          5285.25, 5000.00, '30');
INSERT INTO CUSTOMER VALUES
  ('462', 'Bargains Store', 'john@bargains.com', '412-100-2000', '2837 Greenway', 'Lester', 'PA', '15503', 3412.00,
          10000.00, '40');
INSERT INTO CUSTOMER VALUES
  ('524', 'Kline''s', 'klines@klines.com', '412-123-4567', '372 Oxford', 'Carnegie', 'PA', '15236', 12762.00, 15000.00,
          '20');
INSERT INTO CUSTOMER VALUES
  ('608', 'Johnson''s Department Store', 'chris2@jdstore.com', '412-234-1234', '382 Wildwood', 'Akron', 'PA', '15146',
          2106.00, 10000.00, '40');
INSERT INTO CUSTOMER VALUES
  ('687', 'Lee''s Sport', 'lee@sport.com', '412-222-1145', '3827 Devon', 'Franklin', 'PA', '15321', 2851.00, 5000.00,
          '30');
INSERT INTO CUSTOMER VALUES
  ('725', 'Deerfield''s Four Seasons', 'deerfield@fourseasons.com', '412-333-9898', '3829 Central', 'Akron', 'PA',
          '15146', 248.00, 7500.00, '30');
INSERT INTO CUSTOMER VALUES
  ('842', 'All Season', 'mary@allseasons.com', '412-121-9889', '38 Lakeview', 'Lester', 'PA', '15533', 8221.00, 7500.00,
          '20');


INSERT INTO t_ORDERS VALUES
  ('21608', TO_DATE('12-SEP-2012', 'DD-MON-YYYY'), TO_DATE('12-SEP-2012', 'DD-MON-YYYY'), 'Closed', 'Card', '20',
   '148');
INSERT INTO t_ORDERS VALUES
  ('21610', TO_DATE('12-SEP-2012', 'DD-MON-YYYY'), TO_DATE('13-SEP-2012', 'DD-MON-YYYY'), 'Closed', 'EFT', '40', '356');
INSERT INTO t_ORDERS VALUES
  ('21613', TO_DATE('13-SEP-2012', 'DD-MON-YYYY'), TO_DATE('13-SEP-2012', 'DD-MON-YYYY'), 'Closed', 'Check', '30',
   '408');
INSERT INTO t_ORDERS VALUES
  ('21614', TO_DATE('13-SEP-2012', 'DD-MON-YYYY'), TO_DATE('17-SEP-2012', 'DD-MON-YYYY'), 'Closed', 'Card', '20',
   '282');
INSERT INTO t_ORDERS VALUES
  ('21617', TO_DATE('14-SEP-2012', 'DD-MON-YYYY'), TO_DATE('17-SEP-2012', 'DD-MON-YYYY'), 'Returned', 'Card', '40',
   '608');
INSERT INTO t_ORDERS VALUES
  ('21619', TO_DATE('14-SEP-2012', 'DD-MON-YYYY'), TO_DATE('17-SEP-2012', 'DD-MON-YYYY'), 'Closed', 'Card', '20',
   '148');
INSERT INTO t_ORDERS VALUES ('21623', TO_DATE('14-SEP-2012', 'DD-MON-YYYY'), NULL, 'Open', 'Card', '40', '608');

INSERT INTO PRODUCER VALUES ('S100', 'Work Bench Etc.', '703-234-9845');
INSERT INTO PRODUCER VALUES ('A100', 'Tesko Inc.', '402-234-9845');
INSERT INTO PRODUCER VALUES ('H100', 'Variety Goods', '206-234-9845');


INSERT INTO PART VALUES ('AT94', 'Iron', 'HW', 24.95, 'H100');
INSERT INTO PART VALUES ('BV06', 'Home Gym', 'SG', 794.95, 'S100');
INSERT INTO PART VALUES ('CD52', 'Microwave Oven', 'AP', 165.00, 'A100');
INSERT INTO PART VALUES ('DL71', 'Cordless Drill', 'HW', 129.95, 'H100');
INSERT INTO PART VALUES ('DR93', 'Gas Range', 'AP', 495.00, 'A100');
INSERT INTO PART VALUES ('DW11', 'Washer', 'AP', 399.95, 'A100');
INSERT INTO PART VALUES ('FD21', 'Stand Mixer', 'HW', 159.95, 'H100');
INSERT INTO PART VALUES ('KL62', 'Dryer', 'AP', 349.95, 'A100');
INSERT INTO PART VALUES ('KT03', 'Dishwasher', 'AP', 595.00, 'A100');
INSERT INTO PART VALUES ('KV29', 'Treadmill', 'SG', 1390.00, 'S100');


INSERT INTO ORDER_DETAILS VALUES ('21608', 'AT94', 11, 22.50);
INSERT INTO ORDER_DETAILS VALUES ('21608', 'DL71', 5, 117.00);
INSERT INTO ORDER_DETAILS VALUES ('21608', 'CD52', 5, 148.50);
INSERT INTO ORDER_DETAILS VALUES ('21610', 'DR93', 2, 495.00);
INSERT INTO ORDER_DETAILS VALUES ('21610', 'DW11', 2, 399.95);
INSERT INTO ORDER_DETAILS VALUES ('21613', 'DW11', 4, 375.95);
INSERT INTO ORDER_DETAILS VALUES ('21613', 'KL62', 4, 329.95);
INSERT INTO ORDER_DETAILS VALUES ('21614', 'KT03', 2, 595.00);
INSERT INTO ORDER_DETAILS VALUES ('21617', 'BV06', 2, 794.95);
INSERT INTO ORDER_DETAILS VALUES ('21617', 'CD52', 4, 150.00);
INSERT INTO ORDER_DETAILS VALUES ('21619', 'AT94', 5, 24.95);
INSERT INTO ORDER_DETAILS VALUES ('21619', 'DR93', 1, 495.00);
INSERT INTO ORDER_DETAILS VALUES ('21623', 'KV29', 2, 1290.00);


INSERT INTO warehouse VALUES ('1', 'Tampa', '412-111-2332', 'Joe Martin', 10, 8500);
INSERT INTO warehouse VALUES ('2', 'Oakland', '412-345-6789', 'Mary Smith', 7, 5000);
INSERT INTO warehouse VALUES ('3', 'Akron', '412-456-9876', 'David Lee', 8, 6000);


INSERT INTO inventory VALUES ('1', 'CD52', 162, 60, TO_DATE('12-NOV-2012', 'DD-MON-YYYY'));
INSERT INTO inventory VALUES ('1', 'DR93', 53, 30, TO_DATE('12-NOV-2012', 'DD-MON-YYYY'));
INSERT INTO inventory VALUES ('1', 'KL62', 83, 30, TO_DATE('12-NOV-2012', 'DD-MON-YYYY'));
INSERT INTO inventory VALUES ('1', 'KV29', 11, 5, TO_DATE('12-NOV-2012', 'DD-MON-YYYY'));


INSERT INTO inventory VALUES ('2', 'AT94', 152, 65, TO_DATE('16-NOV-2012', 'DD-MON-YYYY'));
INSERT INTO inventory VALUES ('2', 'BV06', 45, 30, TO_DATE('16-NOV-2012', 'DD-MON-YYYY'));
INSERT INTO inventory VALUES ('2', 'DR93', 28, 20, TO_DATE('16-NOV-2012', 'DD-MON-YYYY'));
INSERT INTO inventory VALUES ('2', 'KT03', 23, 10, TO_DATE('16-NOV-2012', 'DD-MON-YYYY'));


INSERT INTO inventory VALUES ('3', 'AT94', 198, 65, TO_DATE('19-NOV-2012', 'DD-MON-YYYY'));
INSERT INTO inventory VALUES ('3', 'DL71', 321, 75, TO_DATE('19-NOV-2012', 'DD-MON-YYYY'));
INSERT INTO inventory VALUES ('3', 'DW11', 62, 30, TO_DATE('19-NOV-2012', 'DD-MON-YYYY'));
INSERT INTO inventory VALUES ('3', 'FD21', 154, 75, TO_DATE('19-NOV-2012', 'DD-MON-YYYY'));
INSERT INTO inventory VALUES ('3', 'KT03', 18, 10, TO_DATE('19-NOV-2012', 'DD-MON-YYYY'));


COMMIT;