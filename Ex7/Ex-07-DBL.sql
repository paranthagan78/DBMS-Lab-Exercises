SET SERVEROUTPUT ON;
SET ECHO ON;


REM Ensure that the pizza can be delivered on same day or on the next day only
CREATE OR REPLACE TRIGGER CheckDeliveryDate
BEFORE INSERT ON ORDERS
FOR EACH ROW
DECLARE
    v_max_allowed_date DATE;
BEGIN
    -- Calculate the maximum allowed delivery date (today or next day)
    v_max_allowed_date := SYSDATE + 1;

    IF :NEW.delv_date NOT IN (TRUNC(SYSDATE), TRUNC(SYSDATE + 1)) THEN
        -- If the delivery date is not today or tomorrow, raise an exception
        RAISE_APPLICATION_ERROR(-20001, 'Invalid delivery date. Pizza can be delivered on the same day or the next day only.');
    END IF;
END;
/

REM Update the total_amt in ORDERS while entering an order in ORDER_LIST.

CREATE OR REPLACE TRIGGER UpdateTotalAmt
AFTER INSERT ON ORDER_LIST
FOR EACH ROW
DECLARE
    v_total_amt NUMBER;
BEGIN
    -- Calculate the total_amt for the corresponding order
    SELECT SUM(ol.qty * p.unit_price)
    INTO v_total_amt
    FROM ORDER_LIST ol
    JOIN PIZZA p ON ol.pizza_id = p.pizza_id
    WHERE ol.order_no = :NEW.order_no;

    -- Update the total_amt in the ORDERS table
    UPDATE ORDERS
    SET total_amt = v_total_amt
    WHERE order_no = :NEW.order_no;
END;
/

REM To give preference to all customers in delivery of pizzas’, a threshold is
REM set on the number of orders per day per customer. Ensure that a
REM customer can not place more than 5 orders per day.

CREATE OR REPLACE TRIGGER CheckOrderLimit
BEFORE INSERT OR UPDATE ON ORDERS
FOR EACH ROW
DECLARE
    v_order_count NUMBER;
BEGIN
    -- Calculate the number of orders placed by the customer on the given day
    SELECT COUNT(*)
    INTO v_order_count
    FROM ORDERS
    WHERE cust_id = :NEW.cust_id
      AND TRUNC(order_date) = TRUNC(SYSDATE);

    -- Check if the order limit is exceeded
    IF v_order_count >= 5 THEN
        -- Raise an exception if the order limit is exceeded
        RAISE_APPLICATION_ERROR(-20002, 'Customer has reached the maximum limit of 5 orders per day.');
    END IF;
END;
/
