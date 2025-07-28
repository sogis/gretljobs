COPY(
    SELECT
        thema_sql,
	    information,
	    link,
        ST_AsText(geometrie) AS geometrie
    FROM
        sein.main.sein_sammeltabelle
    )
TO
    ${parquet_path_quoted}
(FORMAT parquet, COMPRESSION uncompressed);