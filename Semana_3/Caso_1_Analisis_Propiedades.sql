
SELECT
    p.id_tipo_propiedad AS "TIPO",
    COUNT(*) AS "TOTAL_PROPIEDADES",

    TO_CHAR(
        MAX(p.valor_arriendo),
        'FM$999G999G990',
        'NLS_NUMERIC_CHARACTERS='',.'''
    ) AS "MAX_ARRIENDO",

    TO_CHAR(
        ROUND(AVG(p.valor_arriendo)),
        'FM$999G999G990',
        'NLS_NUMERIC_CHARACTERS='',.'''
    ) AS "PROMEDIO_ARRIENDO",

    TO_CHAR(
        MIN(p.valor_arriendo),
        'FM$999G999G990',
        'NLS_NUMERIC_CHARACTERS='',.'''
    ) AS "MIN_ARRIENDO",

    CASE
        WHEN MAX(p.valor_arriendo) <= 1000000
            THEN 'ESTÁNDAR'
        ELSE 'PREMIUM'
    END AS "CLASIFICACION",

    TO_CHAR(
        SUM(NVL(p.valor_gasto_comun, 0)),
        'FM$999G999G990',
        'NLS_NUMERIC_CHARACTERS='',.'''
    ) AS "TOTAL_GASTOS_COMUNES"

FROM propiedad p

GROUP BY p.id_tipo_propiedad

HAVING SUM(NVL(p.valor_gasto_comun, 0))
       > &VALOR_TOTAL_GASTO_COMUN

ORDER BY SUM(NVL(p.valor_gasto_comun, 0)) DESC;
