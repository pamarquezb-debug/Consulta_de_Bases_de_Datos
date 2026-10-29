
SELECT
    p.codproducto AS "ID",

    INITCAP(p.descripcion) AS "Descripción de Producto",

    CASE
        WHEN p.valorcompradolar IS NULL THEN
            'Sin registro'
        ELSE
            TO_CHAR(
                p.valorcompradolar,
                'TM9',
                'NLS_NUMERIC_CHARACTERS='',.'''
            ) || ' USD'
    END AS "Compra en USD",

    CASE
        WHEN p.valorcompradolar IS NULL THEN
            'Sin registro'
        ELSE
            TO_CHAR(
                ROUND(p.valorcompradolar * &TIPOCAMBIO_DOLAR),
                'FM$999G999G990',
                'NLS_NUMERIC_CHARACTERS='',.'''
            ) || ' PESOS'
    END AS "USD convertido",

    NVL(TO_CHAR(p.totalstock), 'Sin datos')
        AS "Stock",

    CASE
        WHEN p.totalstock IS NULL THEN
            'Sin datos'

        WHEN p.totalstock < &UMBRAL_BAJO THEN
            '¡ALERTA stock muy bajo!'

        WHEN p.totalstock BETWEEN &UMBRAL_BAJO
                              AND &UMBRAL_ALTO THEN
            '¡Reabastecer pronto!'

        ELSE
            'OK'
    END AS "Alerta Stock",

    CASE
        WHEN p.totalstock > 80 THEN
            TO_CHAR(
                ROUND(p.vunitario * 0.90),
                'FM$999G999G990',
                'NLS_NUMERIC_CHARACTERS='',.'''
            )
        ELSE
            'N/A'
    END AS "Precio Oferta"

FROM producto p

WHERE LOWER(p.descripcion) LIKE '%zapato%'
  AND LOWER(p.procedencia) = 'i'

ORDER BY p.codproducto DESC;
