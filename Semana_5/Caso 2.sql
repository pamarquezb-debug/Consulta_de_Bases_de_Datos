
-- ==================================================
-- CASO 2: AUMENTO DE CUPO DE CREDITO
-- ==================================================

-- 1. Crear la tabla CLIENTES_CUPOS_COMPRA
-- Aqui va el CREATE TABLE AS SELECT completo.


CREATE TABLE CLIENTES_CUPOS_COMPRA AS
SELECT
    TO_CHAR(c.numrun, 'FM99G999G999',
        'NLS_NUMERIC_CHARACTERS='',.''')
        || '-' || c.dvrun AS RUT_CLIENTE,
    TRUNC(MONTHS_BETWEEN(SYSDATE, c.fecha_nacimiento) / 12)
        AS EDAD,
    TO_CHAR(t.cupo_disp_compra, 'FM$999G999G999',
        'NLS_NUMERIC_CHARACTERS='',.''')
        AS CUPO_DISPONIBLE,
    tc.nombre_tipo_cliente AS TIPO_CLIENTE
FROM cliente c
INNER JOIN tarjeta_cliente t
    ON c.numrun = t.numrun
INNER JOIN tipo_cliente tc
    ON c.cod_tipo_cliente = tc.cod_tipo_cliente
WHERE t.cupo_disp_compra >=
(
    SELECT MAX(t2.cupo_disp_compra)
    FROM tarjeta_cliente t2
    WHERE EXTRACT(YEAR FROM t2.fecha_solic_tarjeta) =
          EXTRACT(YEAR FROM SYSDATE) - 1
);


-- 2. Consultar los resultados
SELECT
    RUT_CLIENTE,
    EDAD,
    CUPO_DISPONIBLE,
    TIPO_CLIENTE
FROM CLIENTES_CUPOS_COMPRA
ORDER BY EDAD ASC;