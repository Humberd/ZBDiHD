-- Maciej Sawicki GROUPA B
-- Zad. 1B

-- Zad. 2B
SELECT
  p.ID_PRODUKTU,
  p.NAZWA,
  NVL(SUM(s.WARTOSC), 0)                                  as Sprzedaz,
  NVL(SUM(R.WARTOSC_REKLAMY), 0)                          as Reklama,
  NVL(SUM(s.WARTOSC), 0) - NVL(SUM(R.WARTOSC_REKLAMY), 0) as Roznica,
  RANK()
  OVER (
    ORDER BY SUM(s.WARTOSC) - SUM(R.WARTOSC_REKLAMY)
    )
FROM PRODUKT p
  LEFT JOIN SPRZEDAZ S on p.ID_PRODUKTU = S.ID_PRODUKTU
  LEFT JOIN REKLAMA R on p.ID_PRODUKTU = R.ID_PRODUKTU
GROUP BY p.ID_PRODUKTU, p.NAZWA;

-- Zad. 3B
SELECT
  ID_PANSTWA,
  NAZWA,
  SUMA,
  Cwiartka,
  ROUND(RATIO_TO_REPORT(SUMA)
        OVER (
          PARTITION BY Cwiartka
          ), 3) * 100
FROM (
  SELECT
    p.ID_PANSTWA,
    p.NAZWA,
    SUM(S2.WARTOSC) as SUMA,
    NTILE(4)
    OVER (
      ORDER BY SUM(S2.WARTOSC) DESC
      )             as Cwiartka
  FROM PANSTWO p
    JOIN SKLEP S on p.ID_PANSTWA = S.PANSTWO
    JOIN SPRZEDAZ S2 on S.ID_SKLEPU = S2.ID_SKLEPU
  GROUP BY p.ID_PANSTWA, p.NAZWA
)