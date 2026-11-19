-- ================================================================
-- CONSULTA DE BASES DE DATOS - SEMANA 5
-- GRUPO 14 - UTILIZANDO SUBCONSULTAS PARA RESOLVER REQUERIMIENTOS
-- Esquema: PRY2205_S5
-- ================================================================

-- ================================================================
-- CASO 1: LISTADO DE CLIENTES
-- Trabajadores dependientes, profesion Contador o Vendedor,
-- inscritos despues del promedio redondeado del anio de
-- inscripcion de TODOS los clientes.
-- ================================================================

SELECT
    TO_CHAR(c.numrun, 'FM99G999G999',
            'NLS_NUMERIC_CHARACTERS='',.''')
        || '-' || c.dvrun AS "RUT Cliente",
    INITCAP(TRIM(c.pnombre || ' ' || c.appaterno)) AS "Nombre Cliente",
    UPPER(p.nombre_prof_ofic) AS "Profesión Cliente",
    TO_CHAR(c.fecha_inscripcion, 'DD-MM-YYYY') AS "Fecha de Inscripción",
    c.direccion AS "Dirección Cliente"
FROM cliente c
INNER JOIN profesion_oficio p
    ON p.cod_prof_ofic = c.cod_prof_ofic
WHERE c.cod_tipo_cliente = 10
  AND UPPER(p.nombre_prof_ofic) IN ('CONTADOR', 'VENDEDOR')
  AND EXTRACT(YEAR FROM c.fecha_inscripcion) >
      (
          SELECT ROUND(AVG(EXTRACT(YEAR FROM c2.fecha_inscripcion)))
          FROM cliente c2
      )
ORDER BY c.numrun ASC;


-- ================================================================
-- CASO 2: AUMENTO DE CUPO DE CREDITO
-- Cupo disponible mayor o igual al maximo cupo disponible
-- de tarjetas solicitadas el anio calendario anterior.
-- Crear la tabla y luego consultar el resultado.
-- IMPORTANTE: CREATE TABLE se ejecuta solo si la tabla no existe.
-- Si ya existe por una ejecucion anterior, eliminarla primero
-- con: DROP TABLE CLIENTES_CUPOS_COMPRA;
-- ================================================================

CREATE TABLE CLIENTES_CUPOS_COMPRA AS
SELECT
    TO_CHAR(c.numrun, 'FM99999999') || '-' || UPPER(c.dvrun)
        AS RUT_CLIENTE,
    TRUNC(MONTHS_BETWEEN(SYSDATE, c.fecha_nacimiento) / 12)
        AS EDAD,
    TO_CHAR(t.cupo_disp_compra, 'FM$999G999G999',
            'NLS_NUMERIC_CHARACTERS='',.''')
        AS CUPO_DISPONIBLE_COMPRA,
    UPPER(tc.nombre_tipo_cliente) AS TIPO_CLIENTE
FROM cliente c
INNER JOIN tarjeta_cliente t
    ON t.numrun = c.numrun
INNER JOIN tipo_cliente tc
    ON tc.cod_tipo_cliente = c.cod_tipo_cliente
WHERE t.cupo_disp_compra >=
      (
          SELECT MAX(t2.cupo_disp_compra)
          FROM tarjeta_cliente t2
          WHERE EXTRACT(YEAR FROM t2.fecha_solic_tarjeta) =
                EXTRACT(YEAR FROM SYSDATE) - 1
      );

-- Verificacion del resultado, ordenado por edad ascendente.
SELECT
    RUT_CLIENTE,
    EDAD,
    CUPO_DISPONIBLE_COMPRA,
    TIPO_CLIENTE
FROM CLIENTES_CUPOS_COMPRA
ORDER BY EDAD ASC;
