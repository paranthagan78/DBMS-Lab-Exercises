SET SERVEROUTPUT ON;
SET ECHO ON;

REM ALTER TABLE ORDERS ADD total_amt NUMBER;

REM  Write a stored procedure to display the total number of pizza's ordered by
REM the given order number. (Use IN, OUT)

CREATE OR REPLACE PROCEDURE GetTotalPizzasOrdered(
    p_order_no IN ORDERS.order_no%TYPE,
    p_total_qty OUT NUMBER
) AS
BEGIN
    SELECT NVL(SUM(ol.qty), 0)
    INTO p_total_qty
    FROM ORDERS o
    JOIN ORDER_LIST ol ON o.order_no = ol.order_no
    WHERE o.order_no = p_order_no;

    IF p_total_qty > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Total number of pizzas ordered for Order ' || p_order_no || ': ' || p_total_qty);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No pizzas ordered for Order ' || p_order_no);
    END IF;
END;
/

DECLARE
    v_total_qty NUMBER;
BEGIN
    GetTotalPizzasOrdered('&orderid', v_total_qty); 
END;
/

REM For the given order number, calculate the Discount as follows:
REM For total amount > 2000 and total amount < 5000: Discount=5%
REM For total amount > 5000 and total amount < 10000: Discount=10%
REM For total amount > 10000: Discount=20%
REM Calculate the total amount (after the discount) and update the same in
REM orders table.

CREATE OR REPLACE PROCEDURE CalculateDiscountAndPrintOrder(
    p_order_no IN ORDERS.order_no%TYPE
) AS
    v_total_amount NUMBER;
    v_discount_rate NUMBER;
    v_final_amount NUMBER;
    v_cust_name customer.cust_name%TYPE;
    v_order_date orders.order_date%TYPE;
    v_phone customer.phone%TYPE;
    v_cust_id customer.cust_id%TYPE;

    CURSOR order_cursor IS
        SELECT o.cust_id, o.order_date, c.cust_name, c.phone, SUM(ol.qty * p.unit_price) AS total_amount
        FROM orders o
        JOIN order_list ol ON o.order_no = ol.order_no
        JOIN pizza p ON ol.pizza_id = p.pizza_id
        JOIN customer c ON o.cust_id = c.cust_id
        WHERE o.order_no = p_order_no
        GROUP BY o.cust_id, o.order_date, c.cust_name, c.phone;

BEGIN
    OPEN order_cursor;

    FETCH order_cursor INTO v_cust_id, v_order_date, v_cust_name, v_phone, v_total_amount;

    IF order_cursor%FOUND THEN
        -- Calculate discount
        IF v_total_amount > 2000 AND v_total_amount < 5000 THEN
            v_discount_rate := 0.05; -- 5%
        ELSIF v_total_amount >= 5000 AND v_total_amount < 10000 THEN
            v_discount_rate := 0.10; -- 10%
        ELSIF v_total_amount >= 10000 THEN
            v_discount_rate := 0.20; -- 20%
        ELSE
            v_discount_rate := 0; -- No discount
        END IF;

        -- Calculate final amount after discount
        v_final_amount := v_total_amount - (v_total_amount * v_discount_rate);

        -- Update the total amount in the ORDERS table
        UPDATE ORDERS
        SET total_amt = v_final_amount
        WHERE order_no = p_order_no;

        -- Print order details
        DBMS_OUTPUT.PUT_LINE('************************************************************');
        DBMS_OUTPUT.PUT_LINE('Order Number: ' || p_order_no || ' Customer Name: ' || v_cust_name);
        DBMS_OUTPUT.PUT_LINE('Order Date: ' || TO_CHAR(v_order_date, 'DD-Mon-YYYY') || ' Phone: ' || v_phone);
        DBMS_OUTPUT.PUT_LINE('************************************************************');

        DBMS_OUTPUT.PUT_LINE('SNo Pizza Type Qty Price Amount');

        FOR order_rec IN (SELECT ROWNUM AS sno, p.pizza_type, ol.qty, p.unit_price, (ol.qty * p.unit_price) AS amount
                          FROM order_list ol
                          JOIN pizza p ON ol.pizza_id = p.pizza_id
                          WHERE ol.order_no = p_order_no) LOOP
            DBMS_OUTPUT.PUT_LINE(order_rec.sno || '. ' || order_rec.pizza_type || ' ' || order_rec.qty || ' ' ||
                                 order_rec.unit_price || ' ' || order_rec.amount);
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Total = ' || v_total_amount);
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Total Amount : Rs.' || v_total_amount);
        DBMS_OUTPUT.PUT_LINE('Discount (' || TO_CHAR(v_discount_rate * 100) || '%) : Rs.' || (v_total_amount * v_discount_rate));
        DBMS_OUTPUT.PUT_LINE('-------------------------- ----');
        DBMS_OUTPUT.PUT_LINE('Amount to be paid : Rs.' || v_final_amount);
        DBMS_OUTPUT.PUT_LINE('-------------------------- ----');
        DBMS_OUTPUT.PUT_LINE('Great Offers! Discount up to 25% on DIWALI Festival Day...');
        DBMS_OUTPUT.PUT_LINE('************************************************************');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No order found for order number ' || p_order_no);
    END IF;

    CLOSE order_cursor;
END;
/

DECLARE
    v_order_no orders.order_no%TYPE := '&orderno'; 
BEGIN
    CalculateDiscountAndPrintOrder(v_order_no);
END;
/


REM Write a stored function to display the customer name who ordered
REM highest among the total number of pizzas for a given pizza type.

CREATE OR REPLACE FUNCTION GetCustomerWithHighestOrder(
    p_pizza_type IN PIZZA.pizza_type%TYPE
) RETURN CUSTOMER.cust_name%TYPE AS
    v_cust_name CUSTOMER.cust_name%TYPE;
BEGIN
    SELECT c.cust_name
    INTO v_cust_name
    FROM customer c
    JOIN orders o ON c.cust_id = o.cust_id
    JOIN order_list ol ON o.order_no = ol.order_no
    JOIN pizza p ON ol.pizza_id = p.pizza_id
    WHERE p.pizza_type = p_pizza_type
    GROUP BY c.cust_name
    ORDER BY SUM(ol.qty) DESC
    FETCH FIRST 1 ROW ONLY;

    RETURN v_cust_name;
END;
/

CREATE OR REPLACE PROCEDURE DisplayCustomerWithHighestOrder(
    p_pizza_type IN PIZZA.pizza_type%TYPE
) AS
    v_cust_name CUSTOMER.cust_name%TYPE;
BEGIN
    v_cust_name := GetCustomerWithHighestOrder(p_pizza_type);

    IF v_cust_name IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Customer who ordered the highest quantity of ' || p_pizza_type || ': ' || v_cust_name);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No orders found for pizza type ' || p_pizza_type);
    END IF;
END;
/

DECLARE
    v_pizza_type PIZZA.pizza_type%TYPE := '&type'; 
BEGIN
    DisplayCustomerWithHighestOrder(v_pizza_type);
END;
/

REM Implement Question (2) using stored function to return the amount to be
REM paid and update the same, for the given order number.

CREATE OR REPLACE FUNCTION CalculateDiscountAndReturnAmount(
    p_order_no IN ORDERS.order_no%TYPE
) RETURN NUMBER AS
    v_total_amount NUMBER;
    v_discount_rate NUMBER;
    v_final_amount NUMBER;
BEGIN
    SELECT total_amt
    INTO v_total_amount
    FROM ORDERS
    WHERE order_no = p_order_no;

    -- Calculate discount
    IF v_total_amount > 2000 AND v_total_amount < 5000 THEN
        v_discount_rate := 0.05; -- 5%
    ELSIF v_total_amount >= 5000 AND v_total_amount < 10000 THEN
        v_discount_rate := 0.10; -- 10%
    ELSIF v_total_amount >= 10000 THEN
        v_discount_rate := 0.20; -- 20%
    ELSE
        v_discount_rate := 0; -- No discount
    END IF;

    -- Calculate final amount after discount
    v_final_amount := v_total_amount - (v_total_amount * v_discount_rate);

    -- Update the total amount in the ORDERS table
    UPDATE ORDERS
    SET total_amt = v_final_amount
    WHERE order_no = p_order_no;

    RETURN v_final_amount;
END;
/

CREATE OR REPLACE PROCEDURE DisplayOrderDetailsAndAmountToBePaid(
    p_order_no IN ORDERS.order_no%TYPE
) AS
    v_final_amount NUMBER;
BEGIN
    v_final_amount := CalculateDiscountAndReturnAmount(p_order_no);

    IF v_final_amount IS NOT NULL THEN
        -- Display order details (you can reuse the display logic from the previous procedure)
        DBMS_OUTPUT.PUT_LINE('Order details can be displayed here if needed.');
        DBMS_OUTPUT.PUT_LINE('Amount to be paid for Order ' || p_order_no || ': Rs.' || v_final_amount);
        DBMS_OUTPUT.PUT_LINE('Order amount has been updated.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No order found for order number ' || p_order_no);
    END IF;
END;
/

DECLARE
    v_order_no ORDERS.order_no%TYPE := '&opid'; -- Replace with the desired order number
BEGIN
    DisplayOrderDetailsAndAmountToBePaid(v_order_no);
END;
/
