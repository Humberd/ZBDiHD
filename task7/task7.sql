--zad 1
SELECT
  P.P_NUM || ': ' || P.NAME                                               AS Part,
  COUNT(D.ORDER#)                                                         AS number_Of_Orders,
  TO_CHAR(NVL(AVG(D.NUM_ORDERED * D.QUOTED_PRICE), 0), 'L99G999D99MI')    AS Sum,
  RANK()
  OVER (
    ORDER BY ROUND(NVL(AVG(D.NUM_ORDERED * D.QUOTED_PRICE), 0), 2) DESC ) AS Ranking
FROM PART P
  LEFT JOIN ORDER_DETAILS D ON P.PART# = D.PART#
GROUP BY P.P_NUM, P.NAME;

--zad 2
SELECT *
FROM (SELECT
        P.P_NUM || ': ' || P.NAME                    AS Part,
        COUNT(D.ORDER#)                              AS number_Of_Orders,
        SUM(NVL(D.NUM_ORDERED, 0))                   AS quantity_ordered,
        RANK()
        OVER (
          ORDER BY SUM(NVL(D.NUM_ORDERED, 0)) DESC ) AS Ranking
      FROM PART P
        LEFT JOIN ORDER_DETAILS D ON P.PART# = D.PART#
      GROUP BY P.P_NUM, P.NAME)
WHERE ROWNUM < 4;

--zad 3
SELECT
  C.CITY,
  P.PART#,
  P.NAME,
  SUM(D.NUM_ORDERED)
FROM PART P
  JOIN ORDER_DETAILS D ON P.PART# = D.PART#
  JOIN T_ORDERS O ON O.ORDER# = D.ORDER#
  JOIN CUSTOMER C ON C.CUSID = O.CUSID
GROUP BY GROUPING SETS ((C.CITY, P.PART#, P.NAME), (C.CITY), ());

--zad 4
SELECT
  PART#,
  NAME,
  CITY,
  total_purchase
FROM (
  SELECT
    P.PART#,
    P.NAME,
    C.CITY,
    SUM(D.NUM_ORDERED) AS total_purchase,
    RANK()
    OVER (
      PARTITION BY P.PART#
      ORDER BY SUM(D.NUM_ORDERED) DESC
      )                AS Rank
  FROM PART P
    JOIN ORDER_DETAILS D ON P.PART# = D.PART#
    JOIN T_ORDERS O ON O.ORDER# = D.ORDER#
    JOIN CUSTOMER C ON C.CUSID = O.CUSID
  GROUP BY GROUPING SETS ((C.CITY, P.PART#, P.NAME)), P.PART#
)
WHERE Rank = 1;

--zad 5
SELECT
  c.CUSID,
  c.cus_name,
  nvl(count(DISTINCT O.ORDER#), 0)                                     AS num_order,
  nvl(count(P.PART#), 0)                                               AS ind_pasrts,
  TO_CHAR(nvl(sum(D.QUOTED_PRICE * D.NUM_ORDERED), 0), 'L99G999D99MI') AS total
FROM PART P
  JOIN ORDER_DETAILS D ON P.PART# = D.PART#
  JOIN T_ORDERS O ON O.ORDER# = D.ORDER#
  RIGHT JOIN CUSTOMER C ON C.CUSID = O.CUSID
GROUP BY GROUPING SETS ((c.CUSID, c.cus_name))
ORDER BY total DESC;

--zad 6
SELECT
  CUSID,
  CUS_NAME,
  TO_CHAR(CREDIT_LIMIT, 'L99G999D99MI')     AS CREDIT_LIMIT,
  TO_CHAR(available_credit, 'L99G999D99MI') AS available_credit
FROM (
  SELECT
    CUSID,
    CUS_NAME,
    CREDIT_LIMIT,
    available_credit,
    total_ordered_per_customer,
    RANK()
    OVER (
      ORDER BY total_ordered_per_customer DESC
      ) AS Rank
  FROM (
    SELECT DISTINCT
      C.CUSID,
      C.CUS_NAME,
      C.CREDIT_LIMIT,
      C.CREDIT_LIMIT - C.BALANCE AS available_credit,
      SUM(SUM(D.NUM_ORDERED))
      OVER (
        PARTITION BY C.CUSID
        ORDER BY C.CUSID
        )                        AS total_ordered_per_customer
    FROM CUSTOMER C
      JOIN T_ORDERS ORDER2 ON C.CUSID = ORDER2.CUSID
      JOIN ORDER_DETAILS D ON ORDER2.ORDER# = D.ORDER#
      JOIN PART P ON D.PART# = P.PART#
    GROUP BY GROUPING SETS ((C.CUSID, C.CUS_NAME, C.CREDIT_LIMIT, C.BALANCE, P.PART#))
    ORDER BY total_ordered_per_customer DESC
  )
  ORDER BY RANK ASC, CREDIT_LIMIT DESC
)
WHERE Rank = 1;

--zad 7
SELECT
  name,
  Total,
  Indicator
FROM (
  SELECT
    R.REPID || ': ' || trim(R.LAST_NAME) || ', ' || trim(R.FIRST_NAME) AS name,
    TO_CHAR(SUM(D.NUM_ORDERED * D.QUOTED_PRICE), 'L99G999D99MI')       AS Total,
    'Total Value of Sales'                                             AS Indicator,
    RANK()
    OVER (
      ORDER BY SUM(D.NUM_ORDERED * D.QUOTED_PRICE) DESC
      )                                                                AS Rank
  FROM REP R
    JOIN T_ORDERS ORDER2 ON R.REPID = ORDER2.REPID
    JOIN ORDER_DETAILS D ON ORDER2.ORDER# = D.ORDER#
  GROUP BY R.REPID, R.LAST_NAME, R.FIRST_NAME
)
WHERE Rank = 1
UNION
SELECT
  name,
  Total,
  Indicator
FROM (
  SELECT
    R.REPID || ': ' || trim(R.LAST_NAME) || ', ' || trim(R.FIRST_NAME) AS name,
    to_char(SUM(D.NUM_ORDERED))                                        AS Total,
    'Quantity of items sold'                                           AS Indicator,
    RANK()
    OVER (
      ORDER BY SUM(NUM_ORDERED) DESC
      )                                                                AS Rank
  FROM REP R
    JOIN T_ORDERS ORDER2 ON R.REPID = ORDER2.REPID
    JOIN ORDER_DETAILS D ON ORDER2.ORDER# = D.ORDER#
  GROUP BY R.REPID, R.LAST_NAME, R.FIRST_NAME
)
WHERE Rank = 1
UNION
SELECT
  name,
  Total,
  Indicator
FROM (
  SELECT
    R.REPID || ': ' || trim(R.LAST_NAME) || ', ' || trim(R.FIRST_NAME) AS name,
    TO_CHAR(COUNT(ORDER2.ORDER#))                                      AS Total,
    'Total number of orders'                                           AS Indicator,
    RANK()
    OVER (
      ORDER BY COUNT(ORDER2.ORDER#) DESC
      )                                                                AS Rank
  FROM REP R
    JOIN T_ORDERS ORDER2 ON R.REPID = ORDER2.REPID
  GROUP BY GROUPING SETS ((R.REPID, R.LAST_NAME, R.FIRST_NAME))
)
WHERE Rank = 1;