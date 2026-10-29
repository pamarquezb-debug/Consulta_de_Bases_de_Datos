
SELECT
    LPAD(c.rutcliente, 12, '*') AS "RUT",

    INITCAP(c.nombre) AS "Cliente",

    NVL(TO_CHAR(c.telefono), 'Sin teléfono')
        AS "TELÉFONO",

    NVL(TO_CHAR(c.codcomuna), 'Sin comuna')
        AS "COMUNA",

    c.estado AS "ESTADO",

    CASE
        WHEN c.saldo / c.credito < 0.50 THEN
            'Bueno ( ' ||
            TO_CHAR(c.credito - c.saldo,
                'FM$999G999G990',
                'NLS_NUMERIC_CHARACTERS='',.''') || ')'

        WHEN c.saldo / c.credito <= 0.80 THEN
            'Regular ( ' ||
            TO_CHAR(c.saldo,
                'FM$999G999G990',
                'NLS_NUMERIC_CHARACTERS='',.''') || ')'

        ELSE 'Crítico'
    END AS "Estado Crédito",

    NVL(
        SUBSTR(c.mail, INSTR(c.mail, '@') + 1),
        'Correo no registrado'
    ) AS "Dominio Correo"

FROM cliente c

WHERE c.estado = 'A'
  AND c.credito > 0

ORDER BY c.nombre ASC;
