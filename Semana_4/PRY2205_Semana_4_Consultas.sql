-- ============================================================
-- DUOC UC - Consulta de Bases de Datos - Semana 4
-- Desarrollando JOINS en las tablas
-- Esquema: PRY2205_S4
-- Tres consultas verificadas en Oracle Database Actions
-- ============================================================

-- ============================================================
-- CASO 1: LISTADO DE TRABAJADORES
-- Trabajadores con sueldo base entre $650.000 y $3.000.000.
-- Orden: ciudad descendente y sueldo base ascendente.
-- Resultado verificado: 20 filas.
-- ============================================================
SELECT
    UPPER(t.nombre || ' ' || t.appaterno || ' ' || t.apmaterno)
        AS "Nombre Completo Trabajador",
    TO_CHAR(t.numrut, 'FM99G999G999',
        'NLS_NUMERIC_CHARACTERS='',.''') || '-' || t.dvrut
        AS "RUT Trabajador",
    UPPER(tt.desc_categoria) AS "Tipo Trabajador",
    UPPER(c.nombre_ciudad) AS "Ciudad Trabajador",
    TO_CHAR(t.sueldo_base, 'FML999G999G999',
        'NLS_NUMERIC_CHARACTERS='',.''') AS "Sueldo Base"
FROM trabajador t
INNER JOIN comuna_ciudad c
    ON t.id_ciudad = c.id_ciudad
INNER JOIN tipo_trabajador tt
    ON t.id_categoria_t = tt.id_categoria
WHERE t.sueldo_base BETWEEN 650000 AND 3000000
ORDER BY c.nombre_ciudad DESC, t.sueldo_base ASC;

-- ============================================================
-- CASO 2: LISTADO DE CAJEROS
-- Total de tickets, ventas y comisiones por cajero.
-- Solo trabajadores CAJERO con ventas superiores a $50.000.
-- Orden: total vendido descendente.
-- Resultado verificado: 5 filas.
-- ============================================================
SELECT
    TO_CHAR(t.numrut, 'FM99G999G999',
        'NLS_NUMERIC_CHARACTERS='',.''') || '-' || t.dvrut
        AS "RUT Trabajador",
    INITCAP(t.nombre) || ' ' || INITCAP(t.appaterno)
        AS "Nombre Trabajador",
    COUNT(tc.nro_ticket) AS "Total Tickets",
    TO_CHAR(SUM(tc.monto_ticket), 'FML999G999G999',
        'NLS_NUMERIC_CHARACTERS='',.''') AS "Total Vendido",
    TO_CHAR(SUM(ct.valor_comision), 'FML999G999G999',
        'NLS_NUMERIC_CHARACTERS='',.''') AS "Comision Total",
    UPPER(tt.desc_categoria) AS "Tipo Trabajador",
    UPPER(c.nombre_ciudad) AS "Ciudad Trabajador"
FROM trabajador t
INNER JOIN tipo_trabajador tt
    ON t.id_categoria_t = tt.id_categoria
INNER JOIN comuna_ciudad c
    ON t.id_ciudad = c.id_ciudad
INNER JOIN tickets_concierto tc
    ON t.numrut = tc.numrut_t
INNER JOIN comisiones_ticket ct
    ON tc.nro_ticket = ct.nro_ticket
WHERE UPPER(tt.desc_categoria) = 'CAJERO'
GROUP BY
    t.numrut, t.dvrut, t.nombre, t.appaterno,
    tt.desc_categoria, c.nombre_ciudad
HAVING SUM(tc.monto_ticket) > 50000
ORDER BY SUM(tc.monto_ticket) DESC;

-- ============================================================
-- CASO 3: LISTADO DE BONIFICACIONES
-- Incluye cargas familiares, salud, AFP y estado civil vigente.
-- Bono FONASA: 1% del sueldo base.
-- Bono antiguedad: 10% hasta 10 anos; 15% desde 11 anos.
-- La antiguedad se calcula con SYSDATE; varia con la fecha.
-- Resultado verificado: 23 filas.
-- ============================================================
SELECT
    TO_CHAR(t.numrut, 'FM99G999G999',
        'NLS_NUMERIC_CHARACTERS='',.''') AS "RUT Trabajador",
    INITCAP(t.nombre) || ' ' || INITCAP(t.appaterno)
        AS "Trabajador Nombre",
    EXTRACT(YEAR FROM t.fecing) AS "Año Ingreso",
    TRUNC(MONTHS_BETWEEN(SYSDATE, t.fecing) / 12)
        AS "Años Antiguedad",
    COUNT(af.numrut_carga) AS "Num. Cargas Familiares",
    INITCAP(i.nombre_isapre) AS "Nombre Isapre",
    TO_CHAR(t.sueldo_base, 'FML999G999G999',
        'NLS_NUMERIC_CHARACTERS='',.''') AS "Sueldo Base",
    CASE
        WHEN UPPER(i.nombre_isapre) = 'FONASA'
        THEN TO_CHAR(ROUND(t.sueldo_base * 0.01),
            'FML999G999G999',
            'NLS_NUMERIC_CHARACTERS='',.''')
        ELSE '0'
    END AS "Bono Fonasa",
    TO_CHAR(
        CASE
            WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, t.fecing) / 12) <= 10
            THEN ROUND(t.sueldo_base * 0.10)
            ELSE ROUND(t.sueldo_base * 0.15)
        END,
        'FML999G999G999',
        'NLS_NUMERIC_CHARACTERS='',.''') AS "Bono Antiguedad",
    INITCAP(a.nombre_afp) AS "Nombre AFP",
    UPPER(ec.desc_estcivil) AS "Estado Civil"
FROM trabajador t
INNER JOIN isapre i
    ON t.cod_isapre = i.cod_isapre
INNER JOIN afp a
    ON t.cod_afp = a.cod_afp
INNER JOIN est_civil e
    ON t.numrut = e.numrut_t
INNER JOIN estado_civil ec
    ON e.id_estcivil_est = ec.id_estcivil
LEFT JOIN asignacion_familiar af
    ON t.numrut = af.numrut_t
WHERE e.fecini_estcivil <= SYSDATE
  AND (e.fecter_estcivil IS NULL OR e.fecter_estcivil > SYSDATE)
GROUP BY
    t.numrut, t.nombre, t.appaterno, t.fecing,
    t.sueldo_base, i.nombre_isapre, a.nombre_afp,
    ec.desc_estcivil
ORDER BY t.numrut;
