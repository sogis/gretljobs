SELECT
   "FWERT" AS fwert,
   fwert_id::text AS bemerkung
  FROM qrcat."stbl_FWERTE"
    ORDER BY fwert_id ASC;
