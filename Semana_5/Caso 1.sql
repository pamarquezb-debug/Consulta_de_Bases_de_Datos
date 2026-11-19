
SELECT
    TO_CHAR(c.numrun, 'FM99G999G999', 'NLS_NUMERIC_CHARACTERS='',.''')
        || '-' || c.dvrun AS RUT_CLIENTE,
    TRIM(c.pnombre || ' ' || c.snombre || ' ' ||
         c.appaterno || ' ' || c.apmaterno) AS NOMBRE_CLIENTE,
    UPPER(p.nombre_prof_ofic) AS PROFESION,
    TO_CHAR(c.fecha_inscripcion, 'DD-MM-YYYY') AS FECHA_INSCRIPCION,
    c.direccion AS DIRECCION
FROM cliente c
INNER JOIN profesion_oficio p
    ON c.cod_prof_ofic = p.cod_prof_ofic
WHERE c.cod_tipo_cliente = 10
  AND UPPER(p.nombre_prof_ofic) IN ('CONTADOR', 'VENDEDOR')
  AND EXTRACT(YEAR FROM c.fecha_inscripcion) >
      (
          SELECT ROUND(AVG(EXTRACT(YEAR FROM fecha_inscripcion)))
          FROM cliente
      )
ORDER BY c.numrun ASC;
