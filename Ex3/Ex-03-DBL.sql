SET ECHO ON;

DROP TABLE ORDER_LIST;
DROP TABLE ORDERS;
DROP TABLE PIZZA;
DROP TABLE CUSTOMER;

REM Drop tables
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

REM 1. For each pizza, display the total quantity ordered by the customers.
SELECT P.pizza_id, P.pizza_type, SUM(OL.qty) as total_ordered_quantity FROM PIZZA P
JOIN ORDER_LIST OL ON P.pizza_id = OL.pizza_id GROUP BY P.pizza_id, P.pizza_type;

REM 2. Find the pizza type(s) that is not delivered on the ordered day.
SELECT DISTINCT P.pizza_type FROM PIZZA P
LEFT JOIN ORDER_LIST OL ON P.pizza_id = OL.pizza_id
LEFT JOIN ORDERS O ON OL.order_no = O.order_no
WHERE O.delv_date <> O.order_date OR O.delv_date IS NULL;

REM 3. Display the number of order(s) placed by each customer whether or not he/she placed the order.
SELECT C.cust_id, C.cust_name, COUNT(O.order_no) as total_orders_placed FROM CUSTOMER C
LEFT JOIN ORDERS O ON C.cust_id = O.cust_id GROUP BY C.cust_id, C.cust_name;

REM 4. Find the pairs of pizzas such that the ordered quantity of the first pizza type is more than the second for the order OP100.
SELECT OL1.pizza_id AS first_pizza, OL2.pizza_id AS second_pizza
FROM ORDER_LIST OL1, ORDER_LIST OL2 WHERE OL1.order_no = OL2.order_no
AND OL1.order_no = 'OP100' AND OL1.qty > OL2.qty;

REM 5. Display the details (order number, pizza type, customer name, qty) of the pizza with ordered quantity more than the average 
REM ordered quantity of pizzas.
SELECT O.order_no, P.pizza_type, C.cust_name, OL.qty FROM ORDER_LIST OL
JOIN ORDERS O ON OL.order_no = O.order_no JOIN PIZZA P ON OL.pizza_id = P.pizza_id
JOIN CUSTOMER C ON O.cust_id = C.cust_id WHERE OL.qty > (SELECT AVG(qty) FROM ORDER_LIST);

REM 6. Find the customer(s) who ordered for more than one pizza type in each order.
SELECT C.cust_id, C.cust_name FROM CUSTOMER C WHERE (
  SELECT COUNT(DISTINCT OL.pizza_id) FROM ORDER_LIST OL
  JOIN ORDERS O ON OL.order_no = O.order_no WHERE O.cust_id = C.cust_id
) > 1;

REM 7. Display the details (order number, pizza type, customer name, qty) of the pizza with ordered quantity more than the average 
REM ordered quantity of each pizza type.
SELECT O.order_no, P.pizza_type, C.cust_name, OL.qty FROM ORDER_LIST OL
JOIN ORDERS O ON OL.order_no = O.order_no JOIN PIZZA P ON OL.pizza_id = P.pizza_id
JOIN CUSTOMER C ON O.cust_id = C.cust_id WHERE OL.qty > (SELECT AVG(qty) 
FROM ORDER_LIST WHERE pizza_id = P.pizza_id);

REM 8. Display the details (order number, pizza type, customer name, qty) of the pizza with ordered quantity more than the average 
REM ordered quantity of its pizza type. (Using correlated subquery)
SELECT O.order_no, P.pizza_type, C.cust_name, OL.qty FROM ORDER_LIST OL
JOIN ORDERS O ON OL.order_no = O.order_no JOIN PIZZA P ON OL.pizza_id = P.pizza_id
JOIN CUSTOMER C ON O.cust_id = C.cust_id WHERE OL.qty > (
  SELECT AVG(qty) FROM ORDER_LIST WHERE pizza_id = OL.pizza_id
);

REM 9. Display the customer details who placed all pizza types in a single order.
SELECT C.cust_id, C.cust_name FROM CUSTOMER C WHERE (
  SELECT COUNT(DISTINCT OL.pizza_id) FROM ORDER_LIST OL
  JOIN ORDERS O ON OL.order_no = O.order_no WHERE O.cust_id = C.cust_id) = (SELECT COUNT(DISTINCT pizza_id) FROM PIZZA
);

REM 10. Display the order details that contain the pizza quantity more than the average quantity of any of Pan or Italian pizza type.
SELECT OL.order_no, OL.pizza_id
FROM ORDER_LIST OL
JOIN PIZZA P ON P.pizza_id = OL.pizza_id
WHERE OL.qty > (
SELECT AVG(OL2.qty)
FROM ORDER_LIST OL2
WHERE OL2.pizza_id IN (
(SELECT P1.pizza_id FROM PIZZA P1 WHERE P1.pizza_type = 'pan')
UNION
(SELECT P1.pizza_id FROM PIZZA P1 WHERE P1.pizza_type = 'italian')
)
);

REM 11. Find the order(s) that contain Pan pizza but not the Italian pizza type.
SELECT O.order_no, O.cust_id FROM orders O
JOIN order_list OL ON O.order_no = OL.order_no
MINUS SELECT O.order_no, O.cust_id
FROM orders O
JOIN order_list OL
ON O.order_no = OL.order_no
WHERE OL.pizza_id IN (
SELECT pizza_id FROM pizza 
WHERE pizza_type = 'italian');


REM 12. Display the customer(s) who ordered both Italian and Grilled pizza type.
SELECT DISTINCT O.cust_id, C.cust_name, C.address, C.phone
FROM order_list OL, customer  C
JOIN orders O
ON (O.cust_id = C.cust_id)
WHERE OL.order_no = O.order_no AND OL.pizza_id IN (
SELECT pizza_id 
FROM pizza
WHERE pizza_type = 'italian')
INTERSECT SELECT DISTINCT O.cust_id, C.cust_name, C.address, C.phone
FROM order_list OL, customer  C
JOIN orders O
ON (O.cust_id = C.cust_id)
WHERE OL.order_no = O.order_no AND OL.pizza_id IN (
SELECT pizza_id 
FROM pizza
WHERE pizza_type = 'grilled');
