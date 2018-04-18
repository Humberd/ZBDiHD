-- Maciej Sawicki GROUPA B
-- Zad. 1B
SELECT
  tr.ID_TYPU,
  tr.OPIS,
  C2.ROK,
  c2.MIESIAC,
  COUNT(R.WARTOSC_REKLAMY) as ilosc_Reklam
FROM TYP_REKLAMY tr
  JOIN REKLAMA R on tr.ID_TYPU = R.ID_TYPU
  JOIN CZAS C2 on R.ID_CZASU = C2.ID_CZASU
GROUP BY tr.ID_TYPU, tr.OPIS, c2.ROK, c2.MIESIAC
ORDER BY tr.OPIS;

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
  NAZWA,
  SUMA,
  Cwiartka,
  ROUND(RATIO_TO_REPORT(SUMA)
        OVER (
          PARTITION BY Cwiartka
          ), 3) * 100 || '%' as Udzial
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
);

-- Zad. 4B
SELECT
  Typ_Reklamy,
  Rok,
  Wartosc,
  Roznica_z_min
FROM (
  SELECT
    tr.ID_TYPU,
    tr.OPIS                                    as Typ_Reklamy,
    NVL(TO_CHAR(c2.ROK), 'Podsumowanie TYPU:') as Rok,
    SUM(R.WARTOSC_REKLAMY)                     as Wartosc,
    SUM(R.WARTOSC_REKLAMY) - MIN(SUM(R.WARTOSC_REKLAMY))
    OVER (
      partition by tr.ID_TYPU
      )                                        as Roznica_z_min
  FROM TYP_REKLAMY tr
    JOIN REKLAMA R on tr.ID_TYPU = R.ID_TYPU
    JOIN CZAS C2 on R.ID_CZASU = C2.ID_CZASU
  GROUP BY GROUPING SETS ((tr.ID_TYPU, tr.OPIS, c2.ROK), (tr.ID_TYPU, tr.OPIS))
  ORDER BY tr.OPIS, SUM(R.WARTOSC_REKLAMY) ASC
);

-- Zad. 5B
SELECT
  K.ID_KONTYNENTU,
  K.NAZWA
FROM PRODUKT p
  JOIN SPRZEDAZ S on p.ID_PRODUKTU = S.ID_PRODUKTU
  JOIN SKLEP S2 on S.ID_SKLEPU = S2.ID_SKLEPU
  JOIN PANSTWO P2 on S2.PANSTWO = P2.ID_PANSTWA
  JOIN KONTYNENT K on P2.KONTYNENT = K.ID_KONTYNENTU
  JOIN TYP_PRODUKTU P3 on p.TYP = P3.ID_TYPU
ORDER BY K.NAZWA