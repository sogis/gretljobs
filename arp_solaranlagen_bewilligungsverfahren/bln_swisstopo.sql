CREATE TABLE IF NOT EXISTS bln_swisstopo AS
SELECT 
	ObjNummer AS 'Nummer',
	"Name" AS 'Objektname',
	RefObjBlat AS 'Objektblatt',
	geom
FROM 
	ST_Read('https://data.geo.admin.ch/ch.bafu.bundesinventare-bln/bundesinventare-bln/bundesinventare-bln_2056.shp.zip')
;
