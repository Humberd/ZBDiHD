--zad 1
SELECT
  P.P_NUM || ': ' || P.NAME                     AS Part,
  COUNT(D.ORDER#)                               AS number_Of_Orders,
  TO_CHAR(NVL(AVG(D.NUM_ORDERED * D.QUOTED_PRICE), 0),'L99G999D99MI') AS Sum,
  RANK()
  OVER(ORDER BY ROUND(NVL(AVG(D.NUM_ORDERED * D.QUOTED_PRICE), 0), 2) DESC) as Ranking
FROM PART P
  LEFT JOIN ORDER_DETAILS D ON P.PART# = D.PART#
GROUP BY P.P_NUM, P.NAME

--zad 2