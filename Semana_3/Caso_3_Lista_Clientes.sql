
SELECT
    CASE
        WHEN renta_cli >= 1000000 THEN 'PREMIUM'
        WHEN renta_cli >= 600000 THEN 'ALTA'
        WHEN renta_cli >= 300000 THEN 'MEDIA'
        ELSE 'BAJA'
    END AS "CLASIFICACION_RENTA",

    COUNT(*) AS "CANTIDAD_CLIENTES",

    TO_CHAR(
        ROUND(AVG(renta_cli)),
        'FM$999G999G990',
        'NLS_NUMERIC_CHARACTERS='',.'''
    ) AS "RENTA_PROMEDIO",

    CASE
        WHEN SUM(
            CASE
                WHEN fonofijo_cli IS NOT NULL
                  OR celular_cli IS NOT NULL
                THEN 1
                ELSE 0
            END
        ) = 0
        THEN 'Clientes Sin Teléfono'
        ELSE 'Clientes con Teléfono'
    END AS "ESTADO_TELEFONO"

FROM cliente

GROUP BY
    CASE
        WHEN renta_cli >= 1000000 THEN 'PREMIUM'
        WHEN renta_cli >= 600000 THEN 'ALTA'
        WHEN renta_cli >= 300000 THEN 'MEDIA'
        ELSE 'BAJA'
    END

HAVING AVG(renta_cli) > 200000

ORDER BY "CLASIFICACION_RENTA";
