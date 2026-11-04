
SELECT
    UPPER(nombre_emp || ' ' || appaterno_emp)
        AS "Nombre Empleado",

    TO_CHAR(
        sueldo_emp,
        'FM$999G999G990',
        'NLS_NUMERIC_CHARACTERS='',.'''
    ) AS "Sueldo con Formato",

    CASE
        WHEN sueldo_emp > 2000000 THEN 'ALTO'
        ELSE 'MEDIO'
    END AS "Clasificación Sueldo",

    TRUNC(
        MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12
    ) AS "Años Antigüedad",

    'Corresponde bono ' ||

    CASE
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12)
             BETWEEN 6 AND 10 THEN '5%'
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12)
             BETWEEN 11 AND 20 THEN '10%'
        ELSE '15%'
    END ||

    ': ' ||

    TO_CHAR(
        ROUND(
            sueldo_emp *
            CASE
                WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12)
                     BETWEEN 6 AND 10 THEN 0.05
                WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12)
                     BETWEEN 11 AND 20 THEN 0.10
                ELSE 0.15
            END
        ),
        'FM$999G999G990',
        'NLS_NUMERIC_CHARACTERS='',.'''
    ) AS "BONO"

FROM empleado

WHERE id_categoria_emp = 3

  AND TRUNC(
      MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12
  ) > 5

  AND id_sucursal <> &CODIGO_SUCURSAL

ORDER BY sueldo_emp DESC;
