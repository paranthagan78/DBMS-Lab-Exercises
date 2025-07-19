SET SERVEROUTPUT ON;
SET ECHO ON;

REM  Check whether the given pizza type is available. If available display its
REM unit price. If not, display "The pizza is not available / Invalid pizza type".

DECLARE
  input_pizza_type VARCHAR2(50) := '&type'; 
  unit_price NUMBER; 

BEGIN
  SELECT unit_price INTO unit_price FROM PIZZA
  WHERE pizza_type=input_pizza_type;

  DBMS_OUTPUT.PUT_LINE('Pizza is avilable and its unit price is '||unit_price);

EXCEPTION 
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Pizza type not available');

END;
/

REM For the given customer name and a range of order date, find whether a
REM customer had placed any order, if so display the number of orders placed
REM by the customer along with the order number(s)

DECLARE
    v_cust_name customer.cust_name%TYPE := '&name';
    v_start_date DATE := TO_DATE('&start_date', 'YYYY-MM-DD'); 
    v_end_date DATE := TO_DATE('&end_date', 'YYYY-MM-DD');
  
    v_order_count NUMBER;
BEGIN
    SELECT COUNT(o.order_no)
    INTO v_order_count
    FROM customer c
    JOIN orders o ON c.cust_id = o.cust_id
    WHERE c.cust_name = v_cust_name
    AND o.order_date BETWEEN v_start_date AND v_end_date;

    IF v_order_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Customer ' || v_cust_name || ' has placed ' || v_order_count || ' order(s) within the specified date range.');

        FOR order_rec IN (SELECT o.order_no
                          FROM customer c
                          JOIN orders o ON c.cust_id = o.cust_id
                          WHERE c.cust_name = v_cust_name
                          AND o.order_date BETWEEN v_start_date AND v_end_date) LOOP
            DBMS_OUTPUT.PUT_LINE('Order Number: ' || order_rec.order_no);
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Customer ' || v_cust_name || ' has not placed any orders within the specified date range.');
    END IF;
END;
/


REM Display the customer name along with the details of pizza type and its
REM quantity ordered for the given order number. Also find the total quantity
REM ordered for the given order number as shown below:
REM SQL> 
REM Enter value for oid: OP100
REM old 11: oid:='&oid';
REM new 11: oid:='OP100';
REM Customer name: Hari
REM Ordered Following Pizza
REM PIZZA TYPE QTY
REM Pan 3
REM Grilled 2
REM Italian 1
REM Spanish 5
REM --------------------
REM Total Qty: 11

DECLARE 
  oid VARCHAR2(10) := '&oid';
  cust_name VARCHAR2(50);
  total_qty NUMBER := 0;

BEGIN 
  SELECT C.cust_name INTO cust_name FROM CUSTOMER C
  JOIN ORDERS O ON O.cust_id=C.cust_id
  WHERE O.order_no= oid;

  DBMS_OUTPUT.PUT_LINE('Customer Name:'||cust_name);


  DBMS_OUTPUT.PUT_LINE('Ordered Following Pizza');
  DBMS_OUTPUT.PUT_LINE('PIZZA TYPE' || ' ' || 'QTY');

  FOR i IN (SELECT P.pizza_type,OL.qty FROM PIZZA P
            JOIN ORDER_LIST OL ON OL.pizza_id=P.pizza_id
            WHERE OL.order_no=oid)

  LOOP
    DBMS_OUTPUT.PUT_LINE(i.pizza_type || '    ' || i.qty);
    total_qty := total_qty + i.qty;
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('--------------------');
  DBMS_OUTPUT.PUT_LINE('Total Qty: ' || total_qty);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Order ID ' || oid || ' not found.');
END;
/


REM Display the total number of orders that contains one pizza type, two pizza
REM type and so on.
REM Number of Orders that contains
REM Only ONE Pizza type 8
REM Two Pizza types 3
REM Three Pizza types 2
REM ALL Pizza types 1


DECLARE
    v_one_type_cnt NUMBER := 0;
    v_two_types_cnt NUMBER := 0;
    v_three_types_cnt NUMBER := 0;
    v_all_types_cnt NUMBER := 0;
    v_all NUMBER := 0;

    CURSOR order_cursor IS
        SELECT order_no, COUNT(DISTINCT pizza_id) AS pizza_types_count
        FROM order_list
        GROUP BY order_no;
    

BEGIN
  SELECT COUNT(DISTINCT pizza_id) INTO v_all FROM pizza ;

    FOR order_rec IN order_cursor LOOP
        CASE order_rec.pizza_types_count
            WHEN 1 THEN
                v_one_type_cnt := v_one_type_cnt + 1;
            WHEN 2 THEN
                v_two_types_cnt := v_two_types_cnt + 1;
            WHEN 3 THEN
                v_three_types_cnt := v_three_types_cnt + 1;
            WHEN v_all THEN
                v_all_types_cnt := v_all_types_cnt + 1;
        END CASE;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Number of Orders that contains');
    DBMS_OUTPUT.PUT_LINE('Only ONE Pizza type ' || v_one_type_cnt);
    DBMS_OUTPUT.PUT_LINE('Two Pizza types ' || v_two_types_cnt);
    DBMS_OUTPUT.PUT_LINE('Three Pizza types ' || v_three_types_cnt);
    DBMS_OUTPUT.PUT_LINE('ALL Pizza types ' || v_all_types_cnt);

END;
/

