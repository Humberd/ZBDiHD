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
SELECT PART#, NAME, CITY,  total_purchase
FROM (
  SELECT
    P.PART#,
    P.NAME,
    C.CITY,
    SUM(D.NUM_ORDERED) as total_purchase,
    RANK()
    OVER (
      PARTITION BY P.PART#
      ORDER BY SUM(D.NUM_ORDERED) DESC
      ) as Rank
  FROM PART P
    JOIN ORDER_DETAILS D ON P.PART# = D.PART#
    JOIN T_ORDERS O ON O.ORDER# = D.ORDER#
    JOIN CUSTOMER C ON C.CUSID = O.CUSID
  GROUP BY GROUPING SETS ((C.CITY, P.PART#, P.NAME)), P.PART#
)
WHERE Rank = 1