-- DUOC UC - CONSULTA DE BASES DE DATOS
-- SEMANA 3 - APLICANDO FUNCIONES DE AGRUPACION
-- Esquema: PRY2205_S3
-- Ejecutar cada sentencia por separado cuando se soliciten variables de sustitucion.

-- =============================================================
-- CASO 1: ANALISIS DE PROPIEDADES
-- Variable: VALOR_TOTAL_GASTO_COMUN (ejemplo: 100000)
-- =============================================================
SELECT
    p.id_tipo_propiedad AS "TIPO",
    COUNT(*) AS "TOTAL_PROPIEDADES",
    TO_CHAR(MAX(p.valor_arriendo), 'FM$999G999G990', 'NLS_NUMERIC_CHARACTERS='',.''') AS "MAX_ARRIENDO",
    TO_CHAR(ROUND(AVG(p.valor_arriendo)), 'FM$999G999G990', 'NLS_NUMERIC_CHARACTERS='',.''') AS "PROMEDIO_ARRIENDO",
    TO_CHAR(MIN(p.valor_arriendo), 'FM$999G999G990', 'NLS_NUMERIC_CHARACTERS='',.''') AS "MIN_ARRIENDO",
    CASE
        WHEN MAX(p.valor_arriendo) <= 1000000 THEN 'ESTÁNDAR'
        ELSE 'PREMIUM'
    END AS "CLASIFICACION",
    TO_CHAR(SUM(NVL(p.valor_gasto_comun, 0)), 'FM$999G999G990', 'NLS_NUMERIC_CHARACTERS='',.''') AS "TOTAL_GASTOS_COMUNES"
FROM propiedad p
GROUP BY p.id_tipo_propiedad
HAVING SUM(NVL(p.valor_gasto_comun, 0)) > &VALOR_TOTAL_GASTO_COMUN
ORDER BY SUM(NVL(p.valor_gasto_comun, 0)) DESC;

-- =============================================================
-- CASO 2: ANALISIS DE ANTIGUEDAD DE EMPLEADOS
-- Variable: CODIGO_SUCURSAL (ejemplo: 30)
-- =============================================================
SELECT
    UPPER(nombre_emp || ' ' || appaterno_emp) AS "Nombre Empleado",
    TO_CHAR(sueldo_emp, 'FM$999G999G990', 'NLS_NUMERIC_CHARACTERS='',.''') AS "Sueldo con Formato",
    CASE
        WHEN sueldo_emp > 2000000 THEN 'ALTO'
        ELSE 'MEDIO'
    END AS "Clasificación Sueldo",
    TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) AS "Años Antigüedad",
    'Corresponde bono ' ||
    CASE
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) BETWEEN 6 AND 10 THEN '5%'
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) BETWEEN 11 AND 20 THEN '10%'
        ELSE '15%'
    END || ': ' ||
    TO_CHAR(
        ROUND(sueldo_emp *
            CASE
                WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) BETWEEN 6 AND 10 THEN 0.05
                WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) BETWEEN 11 AND 20 THEN 0.10
                ELSE 0.15
            END
        ),
        'FM$999G999G990',
        'NLS_NUMERIC_CHARACTERS='',.'''
    ) AS "BONO"
FROM empleado
WHERE id_categoria_emp = 3
  AND TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) > 5
  AND id_sucursal <> &CODIGO_SUCURSAL
ORDER BY sueldo_emp DESC;

-- =============================================================
-- CASO 3: LISTA DE CLIENTES
-- =============================================================
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
                WHEN fonofijo_cli IS NOT NULL OR celular_cli IS NOT NULL THEN 1
                ELSE 0
            END
        ) = 0 THEN 'Clientes Sin Teléfono'
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
