SET ECHO ON;

DROP TABLE ORDER_LIST;
DROP TABLE ORDERS;
DROP TABLE PIZZA;
DROP TABLE CUSTOMER;

REM Create CUSTOMER table
CREATE TABLE CUSTOMER (
  cust_id varchar(10),
  cust_name varchar(50),
  address varchar(50),
  phone NUMBER
);

REM Create PIZZA table
CREATE TABLE PIZZA (
  pizza_id varchar(10),
  pizza_type varchar(50),
  unit_price NUMBER
);

REM Create ORDERS table
CREATE TABLE ORDERS (
  order_no varchar(10),
  cust_id varchar(10),
  order_date DATE,
  delv_date DATE
);

REM Create ORDER_LIST table
CREATE TABLE ORDER_LIST (
  order_no varchar(10),
  pizza_id varchar(10),
  qty NUMBER NOT NULL
);

ALTER TABLE CUSTOMER ADD CONSTRAINT customer_id PRIMARY KEY(cust_id);
ALTER TABLE PIZZA ADD CONSTRAINT pi_id PRIMARY KEY(pizza_id);
ALTER TABLE ORDERS ADD CONSTRAINT order_number PRIMARY KEY(order_no);
ALTER TABLE ORDERS ADD CONSTRAINT fk_customer_id FOREIGN KEY(cust_id) REFERENCES CUSTOMER(cust_id);
ALTER TABLE ORDER_LIST ADD CONSTRAINT fk_order FOREIGN KEY(order_no) REFERENCES ORDERS(order_no);
ALTER TABLE ORDER_LIST ADD CONSTRAINT fk_pizza FOREIGN KEY (pizza_id) REFERENCES PIZZA(pizza_id);


REm customer(cust_id, cust_name, address, phone)
REM pizza (pizza_id, pizza_type, unit_price)
REM orders(order_no, cust_id, order_date ,delv_date, total_amt)
REM order_list(order_no, pizza_id, qty)


REM ------------------------------------------------------------------------------------------

REM customer(cust_id, cust_name,address,phone)

insert into customer values('c001','Hari','32 RING ROAD,ALWARPET',9001200031);
insert into customer values('c002','Prasanth','42 bull ROAD,numgambakkam',9444120003);
insert into customer values('c003','Neethu','12a RING ROAD,ALWARPET',9840112003);
insert into customer values('c004','Jim','P.H ROAD,Annanagar',9845712993);
insert into customer values('c005','Sindhu','100 feet ROAD,vadapalani',9840166677);
insert into customer values('c006','Brinda','GST ROAD, TAMBARAM', 9876543210);
insert into customer values('c007','Ramkumar','2nd cross street, Perambur',8566944453);



REM pizza (pizza_id, pizza_type, unit_price)

insert into pizza values('p001','pan',130);
insert into pizza values('p002','grilled',230);
insert into pizza values('p003','italian',200);
insert into pizza values('p004','spanish',260);
insert into pizza values('p005','supremo',250);



REM orders(order_no, cust_id, order_date ,delv_date)

insert into orders values('OP100','c001','28-JUN-2015','28-JUN-2015');
insert into orders values('OP200','c002','28-JUN-2015','29-JUN-2015');

insert into orders values('OP300','c003','29-JUN-2015','29-JUN-2015');
insert into orders values('OP400','c004','29-JUN-2015','29-JUN-2015');
insert into orders values('OP500','c001','29-JUN-2015','30-JUN-2015');
insert into orders values('OP600','c002','29-JUN-2015','29-JUN-2015');

insert into orders values('OP700','c005','30-JUN-2015','30-JUN-2015');
insert into orders values('OP800','c006','30-JUN-2015','30-JUN-2015');


REM order_list(order_no, pizza_id, qty)

insert into order_list values('OP100','p001',3);
insert into order_list values('OP100','p002',2);
insert into order_list values('OP100','p003',2);
insert into order_list values('OP100','p004',5);
insert into order_list values('OP100','p005',4);

insert into order_list values('OP200','p003',2);
insert into order_list values('OP200','p001',6);
insert into order_list values('OP200','p004',8);

insert into order_list values('OP300','p003',3);

insert into order_list values('OP400','p001',3);
insert into order_list values('OP400','p004',1);

insert into order_list values('OP500','p003',6);
insert into order_list values('OP500','p004',5);
insert into order_list values('OP500','p001',null);

insert into order_list values('OP600','p002',3);
insert into order_list values('OP600','p003',2);


REM 1. An user is interested to have list of pizza’s in the range of Rs.200-250.
REM Create a view Pizza_200_250 which keeps the pizza details that has the
REM price in the range of 200 to 250.
DROP VIEW Pizza_200_250;
CREATE VIEW Pizza_200_250 AS SELECT unit_price FROM PIZZA WHERE unit_price BETWEEN 200 AND 250;
SELECT * FROM Pizza_200_250;

REM 2. Pizza company owner is interested to know the number of pizza types
REM ordered in each order. Create a view Pizza_Type_Order that lists the
REM number of pizza types ordered in each order.
DROP VIEW Pizza_Type_Order;
CREATE VIEW Pizza_Type_Order AS SELECT order_no,COUNT(pizza_id) AS types FROM ORDER_LIST Group By order_no ORDER BY order_no;
SELECT * FROM Pizza_Type_Order;

REM 3. To know about the customers of Spanish pizza, create a view
REM Spanish_Customers that list out the customer id, name, order_no of
REM customers who ordered Spanish type.
DROP VIEW Spanish_Customers;
CREATE VIEW Spanish_Customers AS SELECT c.cust_id, c.cust_name, ol.order_no FROM CUSTOMER c JOIN ORDERS o ON c.cust_id = o.cust_id JOIN ORDER_LIST ol ON o.order_no = ol.order_no JOIN PIZZA p ON ol.pizza_id = p.pizza_id WHERE p.pizza_type = 'spanish';
SELECT * FROM Spanish_Customers;

REM 4. Create a sequence named Order_No_Seq which generates the Order
REM number starting from 1001, increment by 1, to a maximum of 9999.
REM Include options of cycle, cache and order. Use this sequence to populate
REM the rows of Order_List table.
DROP SEQUENCE Order_No_Seq;
CREATE SEQUENCE Order_No_Seq INCREMENT BY 1 START WITH 1001 MINVALUE 1001 MAXVALUE 9999 CYCLE CACHE 100 ORDER;


INSERT INTO orders VALUES(CONCAT('OP', TO_CHAR(Order_No_Seq.NEXTVAL)),'c006','30-AUG-2015','30-AUG-2015');
INSERT INTO order_list VALUES(CONCAT('OP', TO_CHAR(Order_No_Seq.CURRVAL)), 'p002', 5);

INSERT INTO orders VALUES(CONCAT('OP', TO_CHAR(Order_No_Seq.NEXTVAL)),'c002','30-SEP-2015','30-SEP-2015');
INSERT INTO order_list VALUES(CONCAT('OP', TO_CHAR(Order_No_Seq.CURRVAL)), 'p001', 3);


SELECT * FROM orders;
SELECT * FROM order_list;

