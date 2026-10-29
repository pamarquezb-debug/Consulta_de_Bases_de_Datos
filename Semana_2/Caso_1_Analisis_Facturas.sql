
SELECT
    f.numfactura AS "N° Factura",

    TO_CHAR(
        f.fecha,
        'DD "de" FMMonth YYYY',
        'NLS_DATE_LANGUAGE=SPANISH'
    ) AS "Fecha Emisión",

    LPAD(f.rutcliente, 10, '0') AS "RUT Cliente",

    TO_CHAR(f.neto, 'FM$999G999G990',
            'NLS_NUMERIC_CHARACTERS='',.''') AS "Monto Neto",

    TO_CHAR(f.iva, 'FM$999G999G990',
            'NLS_NUMERIC_CHARACTERS='',.''') AS "Monto Iva",

    TO_CHAR(f.total, 'FM$999G999G990',
            'NLS_NUMERIC_CHARACTERS='',.''') AS "Total Factura",

    CASE
        WHEN f.total <= 50000 THEN 'Bajo'
        WHEN f.total <= 100000 THEN 'Medio'
        ELSE 'Alto'
    END AS "Categoría Monto",

    CASE f.codpago
        WHEN 1 THEN 'EFECTIVO'
        WHEN 2 THEN 'TARJETA DEBITO'
        WHEN 3 THEN 'TARJETA CREDITO'
        ELSE 'CHEQUE'
    END AS "Forma de pago"

FROM factura f

WHERE f.fecha >= ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), -12)
  AND f.fecha < TRUNC(SYSDATE, 'YYYY')

ORDER BY f.fecha DESC, f.neto DESC;
