-- DROP ROLE is_boden_ddl;

CREATE ROLE is_boden_ddl WITH 
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOLOGIN
	NOREPLICATION
	NOBYPASSRLS
	CONNECTION LIMIT -1;

-- DROP SCHEMA afu_isboden;

CREATE SCHEMA afu_isboden AUTHORIZATION is_boden_ddl;

COMMENT ON SCHEMA afu_isboden IS 'IS-Boden Bodeneinheiten / Kontakt: Abt.Boden Christine Hauert';

-- DROP DOMAIN afu_isboden.d_0_or_neg_1;

CREATE DOMAIN afu_isboden.d_0_or_neg_1 AS integer
	CONSTRAINT d_0_or_neg_1_check CHECK (VALUE = 0 OR VALUE = '-1'::integer);
COMMENT ON TYPE afu_isboden.d_0_or_neg_1 IS 'Zahlenwert 0 oder -1';
-- DROP DOMAIN afu_isboden.d_ge_1_or_le_4_or_null;

CREATE DOMAIN afu_isboden.d_ge_1_or_le_4_or_null AS integer
	CONSTRAINT d_ge_1_or_le_4_or_null CHECK (VALUE > 0 OR VALUE < 5 OR VALUE IS NULL);
COMMENT ON TYPE afu_isboden.d_ge_1_or_le_4_or_null IS 'Zahlenwert 1,2,3,4 or NULL';
-- DROP DOMAIN afu_isboden.d_gt_0_le_100;

CREATE DOMAIN afu_isboden.d_gt_0_le_100 AS integer
	CONSTRAINT d_gt_0_le_100_check CHECK (VALUE > 0 AND VALUE <= 100);
COMMENT ON TYPE afu_isboden.d_gt_0_le_100 IS 'Zahlenwert grösser als 0 und kleiner gleich 100';
-- DROP DOMAIN afu_isboden.d_gt_0_lt_100;

CREATE DOMAIN afu_isboden.d_gt_0_lt_100 AS integer
	CONSTRAINT d_gt_0_lt_100_check CHECK (VALUE > 0 AND VALUE < 100);
COMMENT ON TYPE afu_isboden.d_gt_0_lt_100 IS 'Zahlenwert grösser als 0 und kleiner als 100';
-- DROP DOMAIN afu_isboden.d_gt_2_lt_9;

CREATE DOMAIN afu_isboden.d_gt_2_lt_9 AS smallint
	CONSTRAINT d_gt_2_lt_9_check CHECK (VALUE > 2 AND VALUE < 9);
COMMENT ON TYPE afu_isboden.d_gt_2_lt_9 IS 'Zahlenwert grösser als 2 und kleiner als 9';
-- DROP SEQUENCE afu_isboden.begelfor_t_pk_begelfor_seq;

CREATE SEQUENCE afu_isboden.begelfor_t_pk_begelfor_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 28
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.bodeneinheit_auspraegung_t_pk_bodeneinheit_seq;

CREATE SEQUENCE afu_isboden.bodeneinheit_auspraegung_t_pk_bodeneinheit_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.bodeneinheit_historische_nummer_pk_historische_nummerierung_seq;

CREATE SEQUENCE afu_isboden.bodeneinheit_historische_nummer_pk_historische_nummerierung_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.bodeneinheit_t_pk_ogc_fid_seq;

CREATE SEQUENCE afu_isboden.bodeneinheit_t_pk_ogc_fid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.bodentyp_t_pk_bodentyp_seq;

CREATE SEQUENCE afu_isboden.bodentyp_t_pk_bodentyp_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 27
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.csv_import_t_ogc_fid_seq;

CREATE SEQUENCE afu_isboden.csv_import_t_ogc_fid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.druckmodul_ausschnitte_t_pk_ogc_fid_seq;

CREATE SEQUENCE afu_isboden.druckmodul_ausschnitte_t_pk_ogc_fid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.erosionsgefahr_qgis_server_client_ogc_fid_seq;

CREATE SEQUENCE afu_isboden.erosionsgefahr_qgis_server_client_ogc_fid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.gefuegeform_t_pk_gefuegeform_seq;

CREATE SEQUENCE afu_isboden.gefuegeform_t_pk_gefuegeform_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 16
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.gefueggr_t_pk_gefueggr_seq;

CREATE SEQUENCE afu_isboden.gefueggr_t_pk_gefueggr_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 8
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_ogc_fid_seq;

CREATE SEQUENCE afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_ogc_fid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.humusform_wa_t_pk_humusform_wa_seq;

CREATE SEQUENCE afu_isboden.humusform_wa_t_pk_humusform_wa_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 22
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.kalkgehalt_t_pk_kalkgehalt_seq;

CREATE SEQUENCE afu_isboden.kalkgehalt_t_pk_kalkgehalt_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 7
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.koernkl_t_pk_koernkl_seq;

CREATE SEQUENCE afu_isboden.koernkl_t_pk_koernkl_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 26
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.skelett_t_pk_skelett_seq;

CREATE SEQUENCE afu_isboden.skelett_t_pk_skelett_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.untertyp_t_pk_untertyp_seq;

CREATE SEQUENCE afu_isboden.untertyp_t_pk_untertyp_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 86
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.wasserhhgr_t_pk_wasserhhgr_seq;

CREATE SEQUENCE afu_isboden.wasserhhgr_t_pk_wasserhhgr_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 26
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE afu_isboden.zw_bodeneinheit_untertyp_pk_zw_bodeneinheit_untertyp_seq;

CREATE SEQUENCE afu_isboden.zw_bodeneinheit_untertyp_pk_zw_bodeneinheit_untertyp_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;-- afu_isboden.begelfor_t definition

-- Drop table

-- DROP TABLE afu_isboden.begelfor_t;

CREATE TABLE afu_isboden.begelfor_t ( pk_begelfor serial4 NOT NULL, code varchar(2) NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_begelfor_t PRIMARY KEY (pk_begelfor), CONSTRAINT cons_unique_code_begelfor_t UNIQUE (code));
CREATE INDEX idx_begelfor_t_code ON afu_isboden.begelfor_t USING btree (code) WHERE (archive = 0);
COMMENT ON TABLE afu_isboden.begelfor_t IS 'Geländeform: Gemäss FAL Kap. 8.2, Tabelle 8.2b';

-- Column comments

COMMENT ON COLUMN afu_isboden.begelfor_t.pk_begelfor IS 'Primärschlüssel';
COMMENT ON COLUMN afu_isboden.begelfor_t.code IS 'Die Codes der Geländeform';
COMMENT ON COLUMN afu_isboden.begelfor_t.beschreibung IS 'Beschreibung des Codes';
COMMENT ON COLUMN afu_isboden.begelfor_t.new_date IS 'Datum, wann der Datensatz importiert wurde';
COMMENT ON COLUMN afu_isboden.begelfor_t.archive_date IS 'Datum, wann der Datensatz archiviert wurde';
COMMENT ON COLUMN afu_isboden.begelfor_t.archive IS 'Wenn der Datensatz archviert wurde, ist er > 0.';

-- Constraint comments

COMMENT ON CONSTRAINT cons_pk_begelfor_t ON afu_isboden.begelfor_t IS 'Primärschlüssel';
COMMENT ON CONSTRAINT cons_unique_code_begelfor_t ON afu_isboden.begelfor_t IS 'Jeder Code darf nur einmal vorkommen';


-- afu_isboden.bodeneinheit_lw_qgis_server_client_t definition

-- Drop table

-- DROP TABLE afu_isboden.bodeneinheit_lw_qgis_server_client_t;

CREATE TABLE afu_isboden.bodeneinheit_lw_qgis_server_client_t ( pk_ogc_fid int8 NOT NULL, gemnr int2 NULL, objnr int4 NULL, wasserhhgr varchar(2) NULL, wasserhhgr_beschreibung varchar(255) NULL, wasserhhgr_qgis_txt varchar NULL, bodentyp varchar(2) NULL, bodentyp_beschreibung varchar(255) NULL, gelform varchar(2) NULL, gelform_beschreibung varchar(255) NULL, geologie varchar(30) NULL, untertyp_e text NULL, untertyp_k text NULL, untertyp_i text NULL, untertyp_g text NULL, untertyp_r text NULL, untertyp_p text NULL, untertyp_div text NULL, skelett_ob int4 NULL, skelett_ob_beschreibung varchar(255) NULL, skelett_ub int4 NULL, skelett_ub_beschreibung varchar(255) NULL, koernkl_ob int4 NULL, koernkl_ob_beschreibung varchar(255) NULL, koernkl_ub int4 NULL, koernkl_ub_beschreibung varchar(255) NULL, ton_ob int4 NULL, ton_ub int4 NULL, schluff_ob int4 NULL, schluff_ub int4 NULL, karbgrenze int4 NULL, kalkgeh_ob int4 NULL, kalkgeh_ob_beschreibung varchar(255) NULL, kalkgeh_ub int4 NULL, kalkgeh_ub_beschreibung varchar(255) NULL, ph_ob float8 NULL, ph_ob_qgis_txt text NULL, ph_ub float8 NULL, ph_ub_qgis_txt text NULL, maechtigk_ah int2 NULL, humusgeh_ah float8 NULL, humusgeh_ah_qgis_txt text NULL, humusform_wa varchar(3) NULL, humusform_wa_beschreibung varchar(255) NULL, humusform_wa_qgis_txt text NULL, maechtigk_ahh float8 NULL, gefuegeform_ob varchar(3) NULL, gefuegeform_ob_beschreibung varchar(255) NULL, gefuegeform_t_ob_qgis_int int4 NULL, gefuegeform_ub varchar(3) NULL, gefuegeform_ub_beschreibung varchar(255) NULL, gefueggr_ob int4 NULL, gefueggr_ob_beschreibung varchar(255) NULL, gefueggr_ub int4 NULL, gefueggr_ub_beschreibung varchar(255) NULL, pflngr int4 NULL, pflngr_qgis_int int4 NULL, bodpktzahl int4 NULL, bodpktzahl_qgis_txt text NULL, bemerkungen varchar(300) NULL, los varchar(25) NULL, kartierjahr int2 NULL, kartierer int8 NULL, kartierquartal afu_isboden.d_ge_1_or_le_4_or_null NULL, is_wald bool NULL, bindst_cd float8 NULL, bindst_zn float8 NULL, bindst_cu float8 NULL, bindst_pb float8 NULL, nfkapwe_ob float8 NULL, nfkapwe_ub float8 NULL, nfkapwe float8 NULL, nfkapwe_qgis_txt text NULL, verdempf int2 NULL, drain_wel float8 NULL, wassastoss float8 NULL, is_hauptauspraegung bool NULL, gewichtung_auspraegung afu_isboden.d_gt_0_le_100 NULL, wkb_geometry public.geometry NULL, archive int4 NULL, CONSTRAINT pk_bodeneinheit_lw_qgis_server_client_t PRIMARY KEY (pk_ogc_fid));
CREATE INDEX idx_afu_isboden_bodeneinheit_lw_qgis_server_client_t_wkb_gemetr ON afu_isboden.bodeneinheit_lw_qgis_server_client_t USING gist (wkb_geometry);
COMMENT ON TABLE afu_isboden.bodeneinheit_lw_qgis_server_client_t IS 'Für QGIS-Server-Client Projekt isboden.qgs';


-- afu_isboden.bodeneinheit_onlinedata_t definition

-- Drop table

-- DROP TABLE afu_isboden.bodeneinheit_onlinedata_t;

CREATE TABLE afu_isboden.bodeneinheit_onlinedata_t ( pk_isboden int8 NOT NULL, gemnr int2 NULL, objnr int4 NULL, wasserhhgr varchar(2) NULL, bodentyp varchar(2) NULL, gelform varchar(2) NULL, geologie varchar(30) NULL, ut_e text NULL, ut_k text NULL, ut_i text NULL, ut_g text NULL, ut_r text NULL, ut_p text NULL, ut_div text NULL, skelett_ob int4 NULL, skelett_ub int4 NULL, koernkl_ob int4 NULL, koernkl_ub int4 NULL, ton_ob int4 NULL, ton_ub int4 NULL, schluff_ob int4 NULL, schluff_ub int4 NULL, karbgrenze int4 NULL, kalkgeh_ob int4 NULL, kalkgeh_ub int4 NULL, ph_ob float8 NULL, ph_ub float8 NULL, maecht_ah int2 NULL, humus_ah float8 NULL, hmform_wa varchar(3) NULL, maecht_ahh float8 NULL, gefform_ob varchar(3) NULL, gefform_ub varchar(3) NULL, gefgr_ob int4 NULL, gefgr_ub int4 NULL, pflngr int4 NULL, bodpktzahl int4 NULL, bemerkung varchar(300) NULL, los varchar(25) NULL, kjahr int2 NULL, is_wald bool NULL, bindst_cd float8 NULL, bindst_zn float8 NULL, bindst_cu float8 NULL, bindst_pb float8 NULL, nfkapwe_ob float8 NULL, nfkapwe_ub float8 NULL, nfkapwe float8 NULL, verdempf int2 NULL, is_haupt bool NULL, gewichtung afu_isboden.d_gt_0_le_100 NULL, geom public.geometry NULL, archive int2 DEFAULT 0 NOT NULL, new_date date NULL, archive_date date NULL, CONSTRAINT pk_bodeneinheit_onlinedata_t PRIMARY KEY (pk_isboden));
CREATE INDEX idx_afu_isboden_bodeneinheit_onlinedata_t_bodentyp ON afu_isboden.bodeneinheit_onlinedata_t USING btree (bodentyp);
CREATE INDEX idx_afu_isboden_bodeneinheit_onlinedata_t_geom ON afu_isboden.bodeneinheit_onlinedata_t USING gist (geom);
CREATE INDEX idx_afu_isboden_bodeneinheit_onlinedata_t_wasserhhgr ON afu_isboden.bodeneinheit_onlinedata_t USING btree (wasserhhgr);
COMMENT ON TABLE afu_isboden.bodeneinheit_onlinedata_t IS 'Abgeleitetes Produkt für die Datenabgabe';

-- Column comments

COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.pk_isboden IS 'Primärschlüssel';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.gemnr IS 'Gemeindenummer gemäss BFS';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.objnr IS 'Projektinterne Nummer pro Polygon. Nummern sind innerhalb einer Gemeinde eindeutig.
3-stellig (ab 100): Waldböden - Neukartierung
4-stellig (ab 1000): Landwirtschaftsböden - Neukartierung
4-stellig (ab 5000): Landwirtschaftsböden - aufgearbeitete alte FAL-Kartierungen';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.wasserhhgr IS 'Wasserhaushaltsgruppe: gemäss FAL Kap. 5.3.3

Senkrecht durchwaschene Böden

normal durchlässig
a sehr tiefgründig
b tiefgründig
c mässig tiefgründig
d ziemlich flachgründig
e flachgründig und sehr flachgründig

stauwasserbeeinflusst
f tiefgründig
g mässig tiefgründig
h ziemlich flachgründig
i flachgründig und sehr flachgründig

grund- oder hangwasserbeeinflusst
k tiefgründig
l mässig tiefgründig
m ziemlich flachgründig
n flachgründig und sehr flachgründig


Stauwassergeprägte Böden

selten bis zur Oberfläche porengesättigt
o mässig tiefgründig und tiefgründig
p ziemlich flachgründig und flachgründig

häufig bis zur Oberfläche porengesättigt
q ziemlich flachgründig
r flachgründig und sehr flachgründig


Grund- oder hangwassergeprägte Böden

selten bis zur Oberfläche porengesättigt
s tiefgründig
t mässig tiefgründig
u ziemlich flachgründig und flachgründig

häufig bis zur Oberfläche porengesättigt
v mässig tiefgründig
w ziemlich flachgründig und flachgründig

meist bis zur Oberfläche porengesättigt
x ziemlich flachgründig
y flachgründig und sehr flachgründig

dauernd bis zur Oberfläche porengesättigt
z sehr flachgründig';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.bodentyp IS 'Bodentyp: gemäss FAL Kap. 5.1

Perkolierte (= senkrecht durchwaschene) Böden:
L Silikatgesteinsboden
U Mischgesteinsboden
J Karbonatgesteinsboden
S Humus-Silikatboden
D Humus-Mischgesteinsboden
C Humus-Karbonatgesteinsboden
O Regosol
F Fluvisol
R Rendzina
K Kalkbraunerde
B Braunerde
T Parabraunerde
E Saure Braunerde
P Eisenpodzol
H Humuspodzol
Q Braunpodzol
Z Phäozem
X Auffüllung

Stauwassergeprägte Böden:
Y Braunerde-Pseudogley
I Pseudogley

Grund- oder hangwassergeprägte und periodisch überschwemmte Böden:
V Braunerde-Gley
W Buntgley
G Fahlgley
N Halbmoor
M Moor
A Auenboden';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.gelform IS 'Geländeform: gemäss FAL Kap. 8.2, Tabelle 8.2b

Code - Neigungsart - Neigung in % - typische Landschaftselemente
a eben 0 - 5 Ebene, Plateau

b gleichmässig geneigt 5 - 10 Terrasse, Plateau
c konvex - 10 flache Kuppe
d konkav - 10 flache Mulde
e ungleichmässig 0 - 10 schwach wellig

f gleichmässig geneigt 10 - 15 Flachhang
g konvex - 15 Rücken, Kuppe, Oberhang
h konkav - 15 Mulde, Hangfuss
i ungleichmässig 0 - 15 wellig

*j gleichmässig geneigt 15 - 20 Flachhang
*k gleichmässig geneigt 20 - 25 Flachhang
l konvex - 25 Rücken, Kuppe, Oberhang
m konkav - 25 Mulde, Hangmulde, Hangfuss
n ungleichmässig 0 - 25 stark wellig

o gleichmässig geneigt 25 - 35 Starkhang
p konvex - 35 Oberhang, Kuppe, Rücken, Rippe
q konkav - 35 Hangmulde, enge Mulde, Hangfuss
r ungleichmässig 0 - 35 schwach hügelig

s gleichmässig geneigt 35 - 50 Starkhang
t konvex - 50 Oberhang, Kuppe, Rippe
u konkav - 50 Hangmulde, Hangfuss
v ungleichmässig 0 - 50 hügelig

w gleichmässig geneigt 50 - 75 Steilhang
x ungleichmässig 0 - 75 kupiert

y gleichmässig geneigt >75 extremer Steilhang
z ungleichmässig 0 -> 75 zerklüftet
* Bei der Bodenkarte 1:25000 werden die Klassen j und k zusammengefasst: k = 15 - 25 %';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.geologie IS 'Geologisches Ausgangsmaterial: gemäss FAL Kap. 4.1.4
Code Ausgangsmaterial
TO Torf
TU Tuff
SK Seekreide
SA Sand
LO Löss
HS Hangschutt (Bergsturz)
AL Alluvionen
KO Kolluvionen
HL Hanglehm
SL Seebodenlehm
SC Schotter
MS schottrige Moräne
MO Moräne
MG Grundmoräne
ME Mergel
TN Ton
TS Tonschiefer
SS Sandstein
KG Konglomerat
KS Kalkstein
DO Dolomitgestein
RW Rauhwacke
GR Granit
GN Gneis
SF Schiefer';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.ut_e IS 'Untertyp E: Nennung obligatorisch, maximal 3 Untertypen möglich. Bezeichnung gemäss FAL Kap. 5.2.

Code - Bedeutung

E Säuregrad (pH CaCl2)
E0 alkalisch > 6,7
E1 neutral 6,2 - 6,7
E2 schwach sauer 5,1 - 6,1
E3 sauer 4,3 - 5,0
E4 stark sauer 3,3 - 4,2
E5 sehr stark sauer < 3,3';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.ut_k IS 'Untertyp K: Nennung fakultativ, maximal 3 Untertypen möglich. Bezeichnung gemäss FAL Kap. 5.2.

Code - Bedeutung

K Karbonatgehalt
KE teilweise entkarbonatet
KH karbonathaltig
KR karbonatreich
KF kalkflaumig
KT kalktuffig
KA natriumhaltig';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.ut_i IS 'Untertyp I: Nennung fakultativ, maximal 3 Untertypen möglich. Bezeichnung gemäss FAL Kap. 5.2.

Code - Bedeutung

I Staunässe
I1 schwach pseudogleyig
I2 pseudogleyig
I3 stark pseudogleyig
I4 sehr stark pseudogleyig';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.ut_g IS 'Untertyp G: Nennung fakultativ, maximal 3 Untertypen möglich. Bezeichnung gemäss FAL Kap. 5.2.

Code - Bedeutung

G Fremdnässe wechselnd
G1 grundfeucht
G2 schwach gleyig
G3 gleyig
G4 stark gleyig
G5 sehr stark gleyig
G6 extrem gleyig';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.ut_r IS 'Untertyp R: Nennung fakultativ, maximal 3 Untertypen möglich. Bezeichnung gemäss FAL Kap. 5.2.

Code - Bedeutung

R Fremdnässe dauernd
R1 schwach grundnass
R2 grundnass
R3 stark grundnass
R4 sehr stark grundnass
R5 sumpfig';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.ut_p IS 'Untertyp R: Nennung fakultativ, maximal 3 Untertypen möglich. Bezeichnung gemäss FAL Kap. 5.2.

Code - Bedeutung

P Profilschichtung/ -umlagerung
PE erodiert
PK kolluvial
PM anthropogen
PA alluvial
PU überschüttet
PS auf Seekreide
PP polygenetisch
PL aeolisch
PT auf Torfzwischenschicht(-en)
PD stark durchlässiger Untergrund
PB terrassiert';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.ut_div IS 'Untertyp DIV: Nennung fakultativ, maximal 3 Untertypen möglich. Bezeichnung gemäss FAL Kap. 5.2.

Code - Bedeutung

V Verwitterungsart / extreme Körnung
VL lithosolisch (< 10 cm u.T.)
VF auf Fels (10 - 60 cm u.T.)
VU kluftig
VA karstig
VB blockig
VK psephitisch (extrem kiesig)
VS psammitisch (extrem sandig)
VT pellitisch (extrem feinkörnig)

F Verteilung des Fe - Oxides
FB verbraunt
FP podsolig
FE eisenhüllig
FQ quarzkörnig
FM marmoriert
FK konkretionär
FG graufleckig
FR rubefiziert

Z Gefügezustand
ZS krümelig, bröcklig, (stabil)
ZK klumpig
ZT tonhüllig
ZV vertisolisch
ZL labilaggregiert
ZP pelosolisch

L Lagerungsdichte
L1 locker
L2 verdichtet
L3 kompakt
L4 verhärtet

D Drainage
DD drainiert

M organische Substanz aerob
ML rohhumos
MF modrighumos
MA humusarm
MM mullhumos
MH huminstoffreich

O organische Substanz hydromorph
OM anmorig
OS sapro-organisch
OA antorfig
OF flachtorfig
OT tieftorfig

T Typenausprägung
T1 schwach ausgeprägt
T2 ausgeprägt
T3 degradiert

H Horizontierung
HD diffus
HA abrupt horizontiert
HU unregelmässig horizontiert
HB biologisch durchmischt
HT tiefgepflügt, rigolt';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.skelett_ob IS 'Skelettgehalt Oberboden: Klassen gemäss FAL Kap. 3.6a:
Bezeichnung Fraktion Durchmesser
Feinskelett Feinkies 0,2-2 cm
Grobkies 2-5 cm
Grobskelett kleine Steine 5-10 cm
grosse Steine 10-20 cm
kleine Blöcke 20-50 cm
grosse Blöcke >50 cm

Landwirtschaftsböden (Oberboden) Tab. 3.6b:
Code - Bez.Skelettfraktionierung - Abk. - Vol.%
0 skelettfrei,-arm skf,ska <5
1 schwach skeletthaltig sskh 5-10
2 *kieshaltig kh 10-20
3 steinhaltig sh 10-20
4 *stark kieshaltig stkh 20-30
5 stark steinhaltig stsh 20-30
6 *kiesreich kr 30-50
7 steinreich sr 30-50
8 *Kies >50
9 Geröll, Blöcke >50
* höchstens 1/3 Grobskelett

Waldböden (Oberboden) Tab. 3.6c:
Code - Bez.Skelettfraktionierung - Abk. - Vol.%
0 skelettfrei, skelettarm skf,ska 0-5
1 schwach skeletthaltig sskh 5-10
2 skeletthaltig sh 10-20
4 stark skeletthaltig ssh 20-30
6 skelettreich sr 30-50
8 Kies,Geröll,Geschiebe >50';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.skelett_ub IS 'Skelettgehalt Unterboden: Klassen gemäss FAL Kap. 3.6a:
Bezeichnung Fraktion Durchmesser
Feinskelett Feinkies 0,2-2 cm
Grobkies 2-5 cm
Grobskelett kleine Steine 5-10 cm
grosse Steine 10-20 cm
kleine Blöcke 20-50 cm
grosse Blöcke >50 cm

Landwirtschaftsböden (Oberboden) Tab. 3.6b:
Code - Bez.Skelettfraktionierung - Abk. - Vol.%
0 skelettfrei,-arm skf,ska <5
1 schwach skeletthaltig sskh 5-10
2 *kieshaltig kh 10-20
3 steinhaltig sh 10-20
4 *stark kieshaltig stkh 20-30
5 stark steinhaltig stsh 20-30
6 *kiesreich kr 30-50
7 steinreich sr 30-50
8 *Kies >50
9 Geröll, Blöcke >50
* höchstens 1/3 Grobskelett

Waldböden (Oberboden) Tab. 3.6c:
Code - Bez.Skelettfraktionierung - Abk. - Vol.%
0 skelettfrei, skelettarm skf,ska 0-5
1 schwach skeletthaltig sskh 5-10
2 skeletthaltig sh 10-20
4 stark skeletthaltig ssh 20-30
6 skelettreich sr 30-50
8 Kies,Geröll,Geschiebe >50';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.koernkl_ob IS ' Feinerdekörnung Oberboden: Klassen gemäss FAL Kap. 3.5 und Tabelle 3.5.b:
Code - Körnungsklasse - Abk. - Gew.% d. mineral. Feinerde (Ton - Schluff)
1 Sand S <5 <15
2 schluffiger Sand uS <5 15-50
3 lehmiger Sand lS 5-10 <50
4 lehmreicher Sand lrS 10-15 <50
5 sandiger Lehm sL 15-20 <50
6 Lehm L 20-30 <50
7 toniger Lehm tL 30-40 <50
8 lehmiger Ton lT 40-50 <50
9 Ton T >50 <50
10 sandiger Schluff sU <10 50-70
11 Schluff U <10 >70
12 lehmiger Schluff lU 10-30 >50
13 toniger Schluff tU 30-50 >50';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.koernkl_ub IS 'Feinerdekörnung Unterboden: Klassen gemäss FAL Kap. 3.5 und Tabelle 3.5.b:
Code - Körnungsklasse - Abk. - Gew.% d. mineral. Feinerde (Ton - Schluff)
1 Sand S <5 <15
2 schluffiger Sand uS <5 15-50
3 lehmiger Sand lS 5-10 <50
4 lehmreicher Sand lrS 10-15 <50
5 sandiger Lehm sL 15-20 <50
6 Lehm L 20-30 <50
7 toniger Lehm tL 30-40 <50
8 lehmiger Ton lT 40-50 <50
9 Ton T >50 <50
10 sandiger Schluff sU <10 50-70
11 Schluff U <10 >70
12 lehmiger Schluff lU 10-30 >50
13 toniger Schluff tU 30-50 >50';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.ton_ob IS 'Tongehalt des Oberbodens in %, Fraktionen gemäss FAL Kap. 3.5.1 (Durchmesser in mm):
Hauptfraktionen
Ton <0.002
Unterfraktionen
Feinton <0.0002
Grobton 0.0002-0.002';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.ton_ub IS 'Tongehalt des Unterbodens in %, Fraktionen gemäss FAL Kap. 3.5.1 (Durchmesser in mm):
Hauptfraktionen
Ton <0.002
Unterfraktionen
Feinton <0.0002
Grobton 0.0002-0.002';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.schluff_ob IS 'Schluffgehalt des Oberbodens in %, Fraktionen gemäss FAL Kap. 3.5.1 (Durchmesser in mm):
Hauptfraktionen
Schluff 0.002-0.05
Unterfraktionen
Feinschluff 0.002-0.02
Grobschluff (Staub) 0.02-0.05';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.schluff_ub IS 'Schluffgehalt des Unterbodens in %, Fraktionen gemäss FAL Kap. 3.5.1 (Durchmesser in mm):
Hauptfraktionen
Schluff 0.002-0.05
Unterfraktionen
Feinschluff 0.002-0.02
Grobschluff (Staub) 0.02-0.05';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.karbgrenze IS 'Karbonatgrenze:
O nicht entkarbonatet, Karbonat bis zur Oberfläche
-1 keine Karbonatgrenze gefunden; Profil bis in die max. erfasste Tiefe entkarbonatet
positive Zahl, z.B. 28 = Karbonatgrenze liegt in der besagten Tiefe, gemessen ab oberem Profilrand, z.B. in 28 cm Tiefe. Dies gilt sowohl im Normalfall (Entkarbonatisierung von oben) wie auch im Spezialfall (karbonathaltige Horizonte über entkarbonatetem Unterboden).';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.kalkgeh_ob IS 'Karbonatgehalt Oberboden: gemäss FAL Kap. 3.7:
Code - Reaktion - Karbonatgehalt
0 keine Reaktion auch kein leises Knistern (Feinerde + Skelett) - kein Karbonat vorhanden
1 Reaktion nur im Skelett - nur Skelett enthält Karbonat
2 nur vereinzelt schwaches Aufbrausen - Spuren von Karbonat vorhanden
3 schwaches Aufbrausen - Karbonatgehalt <2 %
4 mittleres Aufbrausen - Karbonatgehalt 2¿10 %
5 starkes anhaltendes Aufbrausen - Karbonatgehalt >10 %';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.kalkgeh_ub IS 'Karbonatgehalt Unterboden: gemäss FAL Kap. 3.7:
Code - Reaktion - Karbonatgehalt
0 keine Reaktion auch kein leises Knistern (Feinerde + Skelett) - kein Karbonat vorhanden
1 Reaktion nur im Skelett - nur Skelett enthält Karbonat
2 nur vereinzelt schwaches Aufbrausen - Spuren von Karbonat vorhanden
3 schwaches Aufbrausen - Karbonatgehalt <2 %
4 mittleres Aufbrausen - Karbonatgehalt 2¿10 %
5 starkes anhaltendes Aufbrausen - Karbonatgehalt >10 %';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.ph_ob IS 'pH Oberboden, Bestimmung mit Hellige: gemäss FAL Kap. 3.8:
Bez. - pH(H2O) - pH(CaCl2) - ungefähre Basensättigung (%)
stark alkalisch >8,2 >8,2 100
alkalisch 7,7-8,2 7,7-8,2 100
schwach alkalisch 7,3-7,6 6,8-7,6 100
neutral 6,8-7,2 6,2-6,7 >80
schwach sauer 5,9-6,7 5,1-6,1 51-80
sauer 5,3-5,8 4,3-5,0 15-50
stark sauer 3,9-5,2 3,3-4,2 <15
sehr stark sauer <3,9 <3,3';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.ph_ub IS 'pH Unterboden, Bestimmung mit Hellige: gemäss FAL Kap. 3.8:
Bez. - pH(H2O) - pH(CaCl2) - ungefähre Basensättigung (%)
stark alkalisch >8,2 >8,2 100
alkalisch 7,7-8,2 7,7-8,2 100
schwach alkalisch 7,3-7,6 6,8-7,6 100
neutral 6,8-7,2 6,2-6,7 >80
schwach sauer 5,9-6,7 5,1-6,1 51-80
sauer 5,3-5,8 4,3-5,0 15-50
stark sauer 3,9-5,2 3,3-4,2 <15
sehr stark sauer <3,9 <3,3';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.maecht_ah IS 'Mächtigkeit des Ah-Horizontes (in cm)';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.humus_ah IS 'Humusgehalt Ah-Horizont in %: Schätzung des Humusgehaltes (Gehalt an organischer Substanz) gemäss FAL Kap. 3.4:
% org. C* - Gew.% in Feinerde** - Bezeichnung
<1.2 <2 humusarm
1.2-3.0 2-5 schwach humos
3.0-6.0 5-10 humos
6.0-12.0 10-20 humusreich
12.0-18.0 20-30 sehr humusreich
>18,0 >30 organisch
* Gehalt an organisch gebundenem Kohlenstoff
** Gehalt an organischer Substanz in der Feinerde';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.hmform_wa IS 'Humusform, nur bei Waldböden!: gemäss BUWAL Kap. 7.2:
Code - Humusformen
M Mull
Mt Mull, typisch
Mf Mull, moderartig
MHt Feucht-Mull, typisch
MHf Feucht-Mull, moderartig

F Moder
Fm Moder, mullartig
Fa Moder, typisch, feinhumusarm
Fr Moder, typisch, feinhumusreich
Fl Moder, rohhumusartig
FHm Feucht-Moder, mullartig
FHa Feucht-Moder, typisch, feinhumusarm
FHr Feucht-Moder, typisch, feinhumusreich
FHl Feucht-Moder, rohhumusartig

L Rohhumus
La Rohhumus, typisch, feinhumusarm
Lr Rohhumus, typisch, feinhumusreich
LHa Feucht-Rohhumus, typisch, feinhumusarm
Lhr Feucht-Rohhumus, typisch, feinhumusreich

A Anmoor
T Torf';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.maecht_ahh IS 'Mächtigkeit des Ahh-Horizontes (in cm), (1 Stelle nach dem Komma möglich)';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.gefform_ob IS 'Gefügeform Oberboden gemäss FAL Kap. 3.3:
Code - Gefügeformen
Unstrukturierte Gefügeformen (Grundgefüge):
Ek Einzelkorn
Ko Kohärent

Natürliche Gefügeformen:
Kr Krümel
Gr Granulate
Sp Subpolyeder
Po Polyeder
Pr Prismen
Pl Platten

Anthropogen geprägte Gefügeformen:
Br Bröckel
Fr Fragmente
Klr Klumpen rundlich
Krk Klumpen kantig';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.gefform_ub IS 'Gefügeform Unterboden gemäss FAL Kap. 3.3:
Code - Gefügeformen
Unstrukturierte Gefügeformen (Grundgefüge):
Ek Einzelkorn
Ko Kohärent

Natürliche Gefügeformen:
Kr Krümel
Gr Granulate
Sp Subpolyeder
Po Polyeder
Pr Prismen
Pl Platten

Anthropogen geprägte Gefügeformen:
Br Bröckel
Fr Fragmente
Klr Klumpen rundlich
Krk Klumpen kantig';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.gefgr_ob IS 'Gefügegrösse Oberboden : gemäss FAL Kap. 3.3:
Aggregatgrössenklassen - Durchmesser (in mm)
1 <2
2 2-5
3 5-10
4 10-20
5 20-50
6 50-100
7 >100';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.gefgr_ub IS 'Gefügegrösse Unterboden : gemäss FAL Kap. 3.3:
Aggregatgrössenklassen - Durchmesser (in mm)
1 <2
2 2-5
3 5-10
4 10-20
5 20-50
6 50-100
7 >100';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.pflngr IS 'pflanzennutzbare Gründigkeit (in cm)';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.bodpktzahl IS 'Bodenprofilwert (ohne Standortkorrekturen):
für Landwirtschaftsböden gemäss FAL Kap. 11.3;
für Waldböden gemäss BUWAL Kap. 9.6.2
Punkte 0 - 100, höchste Bewertung entspricht 100 Punkten';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.bemerkung IS 'Bemerkung zur Bodeneinheit';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.los IS 'Los der Bodeinheitserfassung';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.kjahr IS 'Das Kartierjahr';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.is_wald IS 'Handelt es sich um eine Waldfläche?';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.bindst_cd IS 'Relative Bindungsstärke für Kupfer (Cu) im Oberboden:
- Herleitung aus den Attributen ph_ob, humus_ah, ton_ob; Berechnungen gemäss DVWK-Modell (Unterlagen AfU, Abt. BS)';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.bindst_zn IS 'Relative Bindungsstärke für Zink (Zn) im Oberboden:
- Herleitung aus den Attributen ph_ob, humus_ah, ton_ob; Berechnungen gemäss DVWK-Modell (Unterlagen AfU, Abt. BS)';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.bindst_cu IS 'Relative Bindungsstärke für Kupfer (Cu) im Oberboden:
- Herleitung aus den Attributen ph_ob, humus_ah, ton_ob; Berechnungen gemäss DVWK-Modell (Unterlagen AfU, Abt. BS)';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.bindst_pb IS 'Relative Bindungsstärke für Blei (Pb) im Oberboden:
- Herleitung aus den Attributen ph_ob, humus_ah, ton_ob; Berechnungen gemäss DVWK-Modell (Unterlagen AfU, Abt. BS)';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.nfkapwe_ob IS 'Nutzbare Feldkapazität des effektiven Wurzelraumes, Oberboden:
- Herleitung aus den Attributen ton_ob, schluff_ob, gefform_ob, gefgr_ob, humus_ah, maecht_ah, skelett_ob;';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.nfkapwe_ub IS 'Nutzbare Feldkapazität des effektiven Wurzelraumes, Unterboden:
- Herleitung aus den Attributen ton_ub, schluff_ub, gefform_ub, gefgr_ub, wasserhhgr, humus_ah;
- Berechnungen gemäss DVGW-Modell und der Dt. Bodenkundl. Kartieranleitung (Unterlagen AfU, Abt. BS)';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.nfkapwe IS 'Nutzbare Feldkapazität des effektiven Wurzelraumes, Ober- und Unterboden: Summe von nfkapwe_ob und nfkapwe_ub';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.verdempf IS 'Verdichtungsempfindlichkeit des Unterbodens
(Herleitung gemäss Entscheidbaum des Kt. BL, angepasst an die Bodeninformationen der Bodenkartierung Solothurn):

1 wenig empfindlicher Boden
2 mässig empfindlicher Boden
3 empfindlicher Boden
4 stark empfindlicher Boden
5 extrem empfindlicher Boden';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.is_haupt IS 'Handelt es sich um eine Haupt- oder Nebenausprägung?';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.gewichtung IS 'Gewichtung der Ausprägung in Prozent. In der Regel 100% bei einer reinen Hauptausprägung. Bei Haupt- und Nebenausprägungen hat die Hauptausprägung jeweils die höchste Gewichtung.';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.geom IS 'Die Geometrie als Simple Feature Polygon';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.archive IS '0: aktiv, 1: archiviert';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN afu_isboden.bodeneinheit_onlinedata_t.archive_date IS 'Datum der Archivierung des Objektes';


-- afu_isboden.bodeneinheit_overlap_t definition

-- Drop table

-- DROP TABLE afu_isboden.bodeneinheit_overlap_t;

CREATE TABLE afu_isboden.bodeneinheit_overlap_t ( pk_ogc_fid int8 NULL, objnr int4 NULL, gemnr int4 NULL, los varchar(25) NULL, wkb_geometry public.geometry NULL, archive int4 NULL);
CREATE INDEX afu_isboden_bodeneinheit_overlap_t_gemnr ON afu_isboden.bodeneinheit_overlap_t USING btree (gemnr);
CREATE INDEX afu_isboden_bodeneinheit_overlap_t_objnr ON afu_isboden.bodeneinheit_overlap_t USING btree (objnr);
CREATE INDEX afu_isboden_bodeneinheit_overlap_t_pk_ogc_fid ON afu_isboden.bodeneinheit_overlap_t USING btree (pk_ogc_fid);
CREATE INDEX afu_isboden_bodeneinheit_overlap_t_ueberlappung ON afu_isboden.bodeneinheit_overlap_t USING gist (wkb_geometry);
COMMENT ON TABLE afu_isboden.bodeneinheit_overlap_t IS 'Materialisation from bodeneinheit_overlap_v';


-- afu_isboden.bodeneinheit_t definition

-- Drop table

-- DROP TABLE afu_isboden.bodeneinheit_t;

CREATE TABLE afu_isboden.bodeneinheit_t ( pk_ogc_fid bigserial NOT NULL, objnr int4 NOT NULL, gemnr int2 NOT NULL, is_wald bool NOT NULL, wkb_geometry public.geometry NULL, kuerzel varchar(5) NULL, los varchar(25) NULL, kartierdate varchar(7) NULL, fk_kartierer int8 NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, label_x float8 NULL, label_y float8 NULL, kartierjahr int2 NULL, kartierquartal afu_isboden.d_ge_1_or_le_4_or_null NULL, vali varchar(25) DEFAULT 'half'::character varying NULL, hali varchar(25) DEFAULT 'center'::character varying NULL, gemnr_aktuell int2 NULL, CONSTRAINT bodeneinheit_t_gemnr_objnr_archive_key UNIQUE (gemnr, objnr, archive), CONSTRAINT check_objnr CHECK ((((objnr)::text ~ '^\d{3}$'::text) OR ((objnr)::text ~ '^\d{4}$'::text))), CONSTRAINT cons_enforce_dims_geometrie CHECK ((st_ndims(wkb_geometry) = 2)), CONSTRAINT cons_enforce_geotype_the_geom CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))), CONSTRAINT cons_enforce_srid_geometrie CHECK ((st_srid(wkb_geometry) = 2056)), CONSTRAINT cons_pk_bodeneinheit_t PRIMARY KEY (pk_ogc_fid));
CREATE INDEX idx_bodeneinheit_t_gemnr ON afu_isboden.bodeneinheit_t USING btree (gemnr) WHERE (archive < 1);
CREATE INDEX idx_bodeneinheit_t_objnr ON afu_isboden.bodeneinheit_t USING btree (objnr) WHERE (archive < 1);
CREATE INDEX idx_bodeneinheit_t_wkb_gemetry ON afu_isboden.bodeneinheit_t USING gist (wkb_geometry) WHERE (archive < 1);
CREATE UNIQUE INDEX unique_gemnr_objnr_imp_and_prod ON afu_isboden.bodeneinheit_t USING btree (gemnr, objnr) WHERE (archive < 1);
COMMENT ON TABLE afu_isboden.bodeneinheit_t IS 'Die Flächen';

-- Column comments

COMMENT ON COLUMN afu_isboden.bodeneinheit_t.pk_ogc_fid IS 'Primärschlüssel';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.objnr IS 'Zahlenwert. 3 stellig = Wald, 4-stellig = Landwirtschaft';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.gemnr IS 'Gemeindenummer BFS (Stand 2005-09-21)';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.is_wald IS 'Handelt es sich um eine Waldfläche?';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.wkb_geometry IS 'Die räumliche Ausprägung der Fläche';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.kuerzel IS 'Das Attribut setzt sich aus wasserhhgr, bodentyp und geologie zusammen (vom Haupttyp?)';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.los IS 'Los';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.kartierdate IS 'Datum wann die Bodeneinheit kartiert wurde';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.fk_kartierer IS 'Fremdschlüssel zum Kartierer';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.new_date IS 'Datum, wann der Datensatz importiert wurde';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.archive_date IS 'Datum, wann der Datensatz archiviert wurde';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.archive IS 'Wenn der Datensatz archviert wurde, ist er > 0.';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.label_x IS 'Vertikale Position des Kuerzels auf der Fläche';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.label_y IS 'Horizontale Position des Kuerzels auf der Fläche';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.kartierjahr IS 'Das Jahr, in welchem kartiert wurde';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.kartierquartal IS 'Das Quartal des Jahres in welchem kartiert wurde';
COMMENT ON COLUMN afu_isboden.bodeneinheit_t.gemnr_aktuell IS 'Aktuelle Gemeindenummer BFS';

-- Constraint comments

COMMENT ON CONSTRAINT check_objnr ON afu_isboden.bodeneinheit_t IS 'Die Objektnummer muss 3- oder 4-stellig sein';

-- Table Triggers

-- DROP FUNCTION afu_isboden.insert_bodeneinheit_trigger_function();

CREATE OR REPLACE FUNCTION afu_isboden.insert_bodeneinheit_trigger_function()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$  
		BEGIN
				INSERT into afu_isboden.bodeneinheit_auspraegung_t
				( 
				fk_bodeneinheit,
				is_hauptauspraegung,
				gewichtung_auspraegung
				)
				VALUES
				(
				NEW.pk_ogc_fid,
				True,
				100
				);
		RETURN NEW;
		END;
		$function$
;

COMMENT ON FUNCTION afu_isboden.insert_bodeneinheit_trigger_function() IS 'Wenn in die Tabelle bodeneinheit_t ein neuer Eintrag gemacht wird, wird eine Verknüpfung (ein Eintrag mit FK) in die Tabelle bodeneinheit_auspraegung_t gemacht.';


CREATE TRIGGER tr_insert_bodeneinheit AFTER
INSERT
    ON
    afu_isboden.bodeneinheit_t FOR EACH ROW EXECUTE FUNCTION afu_isboden.insert_bodeneinheit_trigger_function();
CREATE TRIGGER tr_update_gemnr_objnr_bodeneinheit AFTER
UPDATE
    ON
    afu_isboden.bodeneinheit_t FOR EACH ROW EXECUTE FUNCTION afu_isboden.update_gemnr_objnr_trigger_function();


-- afu_isboden.bodeneinheit_wald_qgis_server_client_t definition

-- Drop table

-- DROP TABLE afu_isboden.bodeneinheit_wald_qgis_server_client_t;

CREATE TABLE afu_isboden.bodeneinheit_wald_qgis_server_client_t ( pk_ogc_fid int8 NOT NULL, gemnr int2 NULL, objnr int4 NULL, wasserhhgr varchar(2) NULL, wasserhhgr_beschreibung varchar(255) NULL, wasserhhgr_qgis_txt varchar NULL, bodentyp varchar(2) NULL, bodentyp_beschreibung varchar(255) NULL, gelform varchar(2) NULL, gelform_beschreibung varchar(255) NULL, geologie varchar(30) NULL, untertyp_e text NULL, untertyp_k text NULL, untertyp_i text NULL, untertyp_g text NULL, untertyp_r text NULL, untertyp_p text NULL, untertyp_div text NULL, skelett_ob int4 NULL, skelett_ob_beschreibung varchar(255) NULL, skelett_ub int4 NULL, skelett_ub_beschreibung varchar(255) NULL, koernkl_ob int4 NULL, koernkl_ob_beschreibung varchar(255) NULL, koernkl_ub int4 NULL, koernkl_ub_beschreibung varchar(255) NULL, ton_ob int4 NULL, ton_ub int4 NULL, schluff_ob int4 NULL, schluff_ub int4 NULL, karbgrenze int4 NULL, kalkgeh_ob int4 NULL, kalkgeh_ob_beschreibung varchar(255) NULL, kalkgeh_ub int4 NULL, kalkgeh_ub_beschreibung varchar(255) NULL, ph_ob float8 NULL, ph_ob_qgis_txt text NULL, ph_ub float8 NULL, ph_ub_qgis_txt text NULL, maechtigk_ah int2 NULL, humusgeh_ah float8 NULL, humusgeh_ah_qgis_txt text NULL, humusform_wa varchar(3) NULL, humusform_wa_beschreibung varchar(255) NULL, humusform_wa_qgis_txt text NULL, maechtigk_ahh float8 NULL, gefuegeform_ob varchar(3) NULL, gefuegeform_ob_beschreibung varchar(255) NULL, gefuegeform_t_ob_qgis_int int4 NULL, gefuegeform_ub varchar(3) NULL, gefuegeform_ub_beschreibung varchar(255) NULL, gefueggr_ob int4 NULL, gefueggr_ob_beschreibung varchar(255) NULL, gefueggr_ub int4 NULL, gefueggr_ub_beschreibung varchar(255) NULL, pflngr int4 NULL, pflngr_qgis_int int4 NULL, bodpktzahl int4 NULL, bodpktzahl_qgis_txt text NULL, bemerkungen varchar(300) NULL, los varchar(25) NULL, kartierjahr int2 NULL, kartierer int8 NULL, kartierquartal afu_isboden.d_ge_1_or_le_4_or_null NULL, is_wald bool NULL, bindst_cd float8 NULL, bindst_zn float8 NULL, bindst_cu float8 NULL, bindst_pb float8 NULL, nfkapwe_ob float8 NULL, nfkapwe_ub float8 NULL, nfkapwe float8 NULL, nfkapwe_qgis_txt text NULL, verdempf int2 NULL, drain_wel float8 NULL, wassastoss float8 NULL, is_hauptauspraegung bool NULL, gewichtung_auspraegung afu_isboden.d_gt_0_le_100 NULL, wkb_geometry public.geometry NULL, archive int4 NULL, CONSTRAINT pk_bodeneinheit_wald_qgis_server_client_t PRIMARY KEY (pk_ogc_fid));
CREATE INDEX idx_bodeneinheit_wald_qgis_server_client_t_wkb_gemetry ON afu_isboden.bodeneinheit_wald_qgis_server_client_t USING gist (wkb_geometry);
COMMENT ON TABLE afu_isboden.bodeneinheit_wald_qgis_server_client_t IS 'Für QGIS-Server-Client Projekt isboden.qgs';


-- afu_isboden.bodentyp_t definition

-- Drop table

-- DROP TABLE afu_isboden.bodentyp_t;

CREATE TABLE afu_isboden.bodentyp_t ( pk_bodentyp serial4 NOT NULL, code varchar(2) NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_bodentyp_t PRIMARY KEY (pk_bodentyp), CONSTRAINT cons_unique_code_bodentyp_t_code UNIQUE (code));
CREATE INDEX idx_bodentyp_t_code ON afu_isboden.bodentyp_t USING btree (code) WHERE (archive = 0);
COMMENT ON TABLE afu_isboden.bodentyp_t IS 'Bodentyp: Gemäss FAL Kap. 5.1';

-- Column comments

COMMENT ON COLUMN afu_isboden.bodentyp_t.pk_bodentyp IS 'Primärschlüssel';
COMMENT ON COLUMN afu_isboden.bodentyp_t.code IS 'Die Codes des Bodentyps';
COMMENT ON COLUMN afu_isboden.bodentyp_t.beschreibung IS 'Beschreibung des Codes';
COMMENT ON COLUMN afu_isboden.bodentyp_t.new_date IS 'Datum, wann der Datensatz importiert wurde';
COMMENT ON COLUMN afu_isboden.bodentyp_t.archive_date IS 'Datum, wann der Datensatz archiviert wurde';
COMMENT ON COLUMN afu_isboden.bodentyp_t.archive IS 'Wenn der Datensatz archviert wurde, ist er > 0.';

-- Constraint comments

COMMENT ON CONSTRAINT cons_pk_bodentyp_t ON afu_isboden.bodentyp_t IS 'Primärschlüssel';
COMMENT ON CONSTRAINT cons_unique_code_bodentyp_t_code ON afu_isboden.bodentyp_t IS 'Jeder Code darf nur einmal vorkommen';


-- afu_isboden.csv_import_t definition

-- Drop table

-- DROP TABLE afu_isboden.csv_import_t;

CREATE TABLE afu_isboden.csv_import_t ( ogc_fid serial4 NOT NULL, gemnr varchar NULL, objnr varchar NULL, wasserhhgr varchar NULL, bodentyp varchar NULL, gelform varchar NULL, geologie varchar NULL, untertyp_e varchar NULL, untertyp_k varchar NULL, untertyp_i varchar NULL, untertyp_g varchar NULL, untertyp_r varchar NULL, untertyp_p varchar NULL, untertyp_div varchar NULL, skelett_ob varchar NULL, skelett_ub varchar NULL, koernkl_ob varchar NULL, koernkl_ub varchar NULL, ton_ob varchar NULL, schluff_ob varchar NULL, ton_ub varchar NULL, schluff_ub varchar NULL, karbgrenze varchar NULL, kalkgeh_ob varchar NULL, kalkgeh_ub varchar NULL, ph_ob varchar NULL, ph_ub varchar NULL, maechtigk_ah varchar NULL, humusgeh_ah varchar NULL, humusform_wa varchar NULL, maechtigk_ahh varchar NULL, gefuegeform_ob varchar NULL, gefueggr_ob varchar NULL, gefuegeform_ub varchar NULL, gefueggr_ub varchar NULL, pflngr varchar NULL, bodpktzahl varchar NULL, bemerkungen varchar NULL, los varchar NULL, kartierjahr varchar NULL, kartierer varchar NULL, kartierquartal varchar NULL, is_wald varchar NULL, is_hauptauspraegung varchar NULL, gewichtung_auspraegung varchar NULL, CONSTRAINT csv_import_t_pkey PRIMARY KEY (ogc_fid));


-- afu_isboden.druckmodul_ausschnitte_t definition

-- Drop table

-- DROP TABLE afu_isboden.druckmodul_ausschnitte_t;

CREATE TABLE afu_isboden.druckmodul_ausschnitte_t ( pk_ogc_fid serial4 NOT NULL, bezeichnung text NOT NULL, x_minimum numeric(10, 3) NOT NULL, y_minimum numeric(10, 3) NOT NULL, x_maximum numeric(10, 3) NOT NULL, y_maximum numeric(10, 3) NOT NULL, CONSTRAINT druckmodul_ausschnitte_t_pkey PRIMARY KEY (pk_ogc_fid));
COMMENT ON TABLE afu_isboden.druckmodul_ausschnitte_t IS 'Enthält von den Benutzern definierte Kartenausschnitte, die zum Druck ausgewählt werden können';

-- Column comments

COMMENT ON COLUMN afu_isboden.druckmodul_ausschnitte_t.pk_ogc_fid IS 'Primärschlüssel';
COMMENT ON COLUMN afu_isboden.druckmodul_ausschnitte_t.bezeichnung IS 'Bezeichnung/Name des Kartenausschnitts';
COMMENT ON COLUMN afu_isboden.druckmodul_ausschnitte_t.x_minimum IS 'Linke Begrenzung des Ausschnitts';
COMMENT ON COLUMN afu_isboden.druckmodul_ausschnitte_t.y_minimum IS 'Untere Begrenzung des Ausschnitts';
COMMENT ON COLUMN afu_isboden.druckmodul_ausschnitte_t.x_maximum IS 'Rechte Begrenzung des Ausschnitts';
COMMENT ON COLUMN afu_isboden.druckmodul_ausschnitte_t.y_maximum IS 'Obere Begrenzung des Ausschnitts';


-- afu_isboden.erosionsgefahr_qgis_server_client_t definition

-- Drop table

-- DROP TABLE afu_isboden.erosionsgefahr_qgis_server_client_t;

CREATE TABLE afu_isboden.erosionsgefahr_qgis_server_client_t ( ogc_fid int4 DEFAULT nextval('afu_isboden.erosionsgefahr_qgis_server_client_ogc_fid_seq'::regclass) NOT NULL, wkb_geometry public.geometry NULL, grid_code int4 NULL, new_date date DEFAULT 'now'::text::date NULL, archive_date date DEFAULT '9999-01-01'::date NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT "$2" CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))), CONSTRAINT cons_enforce_srid_geometrie CHECK ((st_srid(wkb_geometry) = 2056)), CONSTRAINT erosionsgefahr_qgis_server_client_pkey PRIMARY KEY (ogc_fid));
CREATE INDEX erosionsgefahr_qgis_server_client_idx ON afu_isboden.erosionsgefahr_qgis_server_client_t USING gist (wkb_geometry);
COMMENT ON TABLE afu_isboden.erosionsgefahr_qgis_server_client_t IS 'Für QGIS-Server-Client Projekt isboden.qgs';

-- Column comments

COMMENT ON COLUMN afu_isboden.erosionsgefahr_qgis_server_client_t.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN afu_isboden.erosionsgefahr_qgis_server_client_t.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN afu_isboden.erosionsgefahr_qgis_server_client_t.grid_code IS '-9999: nicht untersuchtes Gebiet
1: Risikowahrscheinlichkeit 0%
4: Risikowahrscheinlichkeit >0% - 40%
7: Risikowahrscheinlichkeit >40% - 70%
9: Risikowahrscheinlichkeit >70% - 90%
10: Risikowahrscheinlichkeit >90% - 100%';
COMMENT ON COLUMN afu_isboden.erosionsgefahr_qgis_server_client_t.new_date IS 'Datum des Imports des Objektes';
COMMENT ON COLUMN afu_isboden.erosionsgefahr_qgis_server_client_t.archive_date IS 'Datum der Archivierung des Objektes';
COMMENT ON COLUMN afu_isboden.erosionsgefahr_qgis_server_client_t.archive IS '0: aktiv, 1: archiviert';


-- afu_isboden.gefuegeform_t definition

-- Drop table

-- DROP TABLE afu_isboden.gefuegeform_t;

CREATE TABLE afu_isboden.gefuegeform_t ( pk_gefuegeform serial4 NOT NULL, code varchar(3) NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_gefuegeform_t PRIMARY KEY (pk_gefuegeform), CONSTRAINT cons_unique_code_gefuegeform_t UNIQUE (code));
CREATE INDEX idx_gefuegeform_t_code ON afu_isboden.gefuegeform_t USING btree (code) WHERE (archive = 0);
COMMENT ON TABLE afu_isboden.gefuegeform_t IS 'Gefügeform';

-- Column comments

COMMENT ON COLUMN afu_isboden.gefuegeform_t.pk_gefuegeform IS 'Primärschlüssel';
COMMENT ON COLUMN afu_isboden.gefuegeform_t.code IS 'Der Code zur Gefügeform';
COMMENT ON COLUMN afu_isboden.gefuegeform_t.beschreibung IS 'Beschreibung des Codes';
COMMENT ON COLUMN afu_isboden.gefuegeform_t.new_date IS 'Datum, wann der Datensatz importiert wurde';
COMMENT ON COLUMN afu_isboden.gefuegeform_t.archive_date IS 'Datum, wann der Datensatz archiviert wurde';
COMMENT ON COLUMN afu_isboden.gefuegeform_t.archive IS 'Wenn der Datensatz archviert wurde, ist er > 0.';

-- Constraint comments

COMMENT ON CONSTRAINT cons_pk_gefuegeform_t ON afu_isboden.gefuegeform_t IS 'Primärschlüssel';
COMMENT ON CONSTRAINT cons_unique_code_gefuegeform_t ON afu_isboden.gefuegeform_t IS 'Jeder Code darf nur einmal vorkommen';


-- afu_isboden.gefueggr_t definition

-- Drop table

-- DROP TABLE afu_isboden.gefueggr_t;

CREATE TABLE afu_isboden.gefueggr_t ( pk_gefueggr serial4 NOT NULL, code int4 NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_gefueggr_t PRIMARY KEY (pk_gefueggr), CONSTRAINT cons_unique_code_gefueggr_t UNIQUE (code));
CREATE INDEX idx_gefueggr_t_code ON afu_isboden.gefueggr_t USING btree (code) WHERE (archive = 0);
COMMENT ON TABLE afu_isboden.gefueggr_t IS 'Gefügegrösse';

-- Column comments

COMMENT ON COLUMN afu_isboden.gefueggr_t.pk_gefueggr IS 'Primärschlüssel';
COMMENT ON COLUMN afu_isboden.gefueggr_t.code IS 'Der Code zur Gefügeform';
COMMENT ON COLUMN afu_isboden.gefueggr_t.beschreibung IS 'Beschreibung des Codes';
COMMENT ON COLUMN afu_isboden.gefueggr_t.new_date IS 'Datum, wann der Datensatz importiert wurde';
COMMENT ON COLUMN afu_isboden.gefueggr_t.archive_date IS 'Datum, wann der Datensatz archiviert wurde';
COMMENT ON COLUMN afu_isboden.gefueggr_t.archive IS 'Wenn der Datensatz archviert wurde, ist er > 0.';

-- Constraint comments

COMMENT ON CONSTRAINT cons_pk_gefueggr_t ON afu_isboden.gefueggr_t IS 'Primärschlüssel';
COMMENT ON CONSTRAINT cons_unique_code_gefueggr_t ON afu_isboden.gefueggr_t IS 'Jeder Code darf nur einmal vorkommen';


-- afu_isboden.gemeindeteil_t definition

-- Drop table

-- DROP TABLE afu_isboden.gemeindeteil_t;

CREATE TABLE afu_isboden.gemeindeteil_t ( ogc_fid int4 NOT NULL, gem_bfs_aktuell int4 NULL, gem_bfs int4 NULL, name_aktuell varchar NULL, "name" varchar NULL, gmde_name_aktuell varchar NULL, gmde_name varchar NULL, gmde_nr_aktuell int4 NULL, gmde_nr int4 NULL, bzrk_nr_aktuell int4 NULL, bzrk_nr int4 NULL, eg_nr_aktuell int4 NULL, eg_nr int4 NULL, plz_aktuell int4 NULL, plz int4 NULL, ktn_nr_aktuell int2 NULL, ktn_nr int2 NULL, wkb_geometry_aktuell public.geometry NULL, wkb_geometry public.geometry NULL, CONSTRAINT gemeindeteil_t_pkey PRIMARY KEY (ogc_fid));
CREATE INDEX idx_gemeindeteil_t_gem_bfs ON afu_isboden.gemeindeteil_t USING btree (gem_bfs);
CREATE INDEX idx_gemeindeteil_t_gem_bfs_aktuell ON afu_isboden.gemeindeteil_t USING btree (gem_bfs_aktuell);
CREATE INDEX idx_gemeindeteil_t_name ON afu_isboden.gemeindeteil_t USING btree (name);
CREATE INDEX idx_gemeindeteil_t_name_aktuell ON afu_isboden.gemeindeteil_t USING btree (name_aktuell);
CREATE INDEX idx_gemeindeteil_t_wkb_gemetry ON afu_isboden.gemeindeteil_t USING gist (wkb_geometry);
CREATE INDEX idx_gemeindeteil_t_wkb_geometry_aktuell ON afu_isboden.gemeindeteil_t USING gist (wkb_geometry_aktuell);
COMMENT ON TABLE afu_isboden.gemeindeteil_t IS 'Gemeinden (aktuelle Flächen mit aktueller BFS-Nummer) und Gemeindeteile (Flächen und BFS-Nummern vom 21. September 2005). Diese Tabelle ist die Basis für gemnr und gemnr_aktuell der Tabelle bodeneinheit_t';


-- afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_t definition

-- Drop table

-- DROP TABLE afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_t;

CREATE TABLE afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_t ( ogc_fid int4 DEFAULT nextval('afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_ogc_fid_seq'::regclass) NOT NULL, risk_final int4 NULL, verdempf_t varchar(254) NULL, wkb_geometry public.geometry NULL, CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)), CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 2056)), CONSTRAINT hinweiskarte_bodenverdichtung_qgis_server_client_pkey PRIMARY KEY (ogc_fid));
CREATE INDEX hinweiskarte_bodenverdichtung_qgis_server_c_wkb_g_1425978861276 ON afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_t USING gist (wkb_geometry);
COMMENT ON TABLE afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_t IS 'Für QGIS-Server-Client Projekt isboden.qgs';

-- Column comments

COMMENT ON COLUMN afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_t.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_t.risk_final IS 'Verdichtungsrisikoklassen:
1  geringes Verdichtungsrisiko
2  mittleres Verdichtungsrisiko
3  hohes Verdichtungsrisiko (wechselfeucht)
4  sehr hohes Verdichtungsrisiko
5  nicht befahrbar: Standort zu nass für Befahrung
6  Befahrung nicht empfohlen wegen Topographie (zu steil)
7  seltener Waldstandort: Befahrung nicht angebracht
8  Ruderalflächen / fehlende Angaben';
COMMENT ON COLUMN afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_t.verdempf_t IS 'Verdichtungsrisikoklassen: Beurteilung und Empfehlung
';
COMMENT ON COLUMN afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_t.wkb_geometry IS 'OGC WKB Geometrie';


-- afu_isboden.humusform_wa_t definition

-- Drop table

-- DROP TABLE afu_isboden.humusform_wa_t;

CREATE TABLE afu_isboden.humusform_wa_t ( pk_humusform_wa serial4 NOT NULL, code varchar(3) NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_humusform_wa_t PRIMARY KEY (pk_humusform_wa), CONSTRAINT cons_unique_humusform_wa_t UNIQUE (code));
CREATE INDEX humusform_wa_t_code_idx ON afu_isboden.humusform_wa_t USING btree (code) WHERE (archive = 0);
COMMENT ON TABLE afu_isboden.humusform_wa_t IS 'Humusform, nur bei Waldböden';

-- Column comments

COMMENT ON COLUMN afu_isboden.humusform_wa_t.pk_humusform_wa IS 'Primärschlüssel';
COMMENT ON COLUMN afu_isboden.humusform_wa_t.code IS 'Der Code zur Humusform';
COMMENT ON COLUMN afu_isboden.humusform_wa_t.beschreibung IS 'Beschreibung des Codes';
COMMENT ON COLUMN afu_isboden.humusform_wa_t.new_date IS 'Datum, wann der Datensatz importiert wurde';
COMMENT ON COLUMN afu_isboden.humusform_wa_t.archive_date IS 'Datum, wann der Datensatz archiviert wurde';
COMMENT ON COLUMN afu_isboden.humusform_wa_t.archive IS 'Wenn der Datensatz archviert wurde, ist er > 0.';

-- Constraint comments

COMMENT ON CONSTRAINT cons_pk_humusform_wa_t ON afu_isboden.humusform_wa_t IS 'Primärschlüssel';
COMMENT ON CONSTRAINT cons_unique_humusform_wa_t ON afu_isboden.humusform_wa_t IS 'Jeder Code darf nur einmal vorkommen';


-- afu_isboden.kalkgehalt_t definition

-- Drop table

-- DROP TABLE afu_isboden.kalkgehalt_t;

CREATE TABLE afu_isboden.kalkgehalt_t ( pk_kalkgehalt serial4 NOT NULL, code int4 NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_kalkgehalt_t PRIMARY KEY (pk_kalkgehalt), CONSTRAINT cons_unique_code_kalkgehalt_t UNIQUE (code));
CREATE INDEX idx_kalkgehalt_t_code ON afu_isboden.kalkgehalt_t USING btree (code) WHERE (archive = 0);
COMMENT ON TABLE afu_isboden.kalkgehalt_t IS 'Karbonatgehalt';

-- Column comments

COMMENT ON COLUMN afu_isboden.kalkgehalt_t.pk_kalkgehalt IS 'Primärschlüssel';
COMMENT ON COLUMN afu_isboden.kalkgehalt_t.code IS 'Die Codes zum Karbongehalt';
COMMENT ON COLUMN afu_isboden.kalkgehalt_t.beschreibung IS 'Beschreibung des Codes';
COMMENT ON COLUMN afu_isboden.kalkgehalt_t.new_date IS 'Datum, wann der Datensatz importiert wurde';
COMMENT ON COLUMN afu_isboden.kalkgehalt_t.archive_date IS 'Datum, wann der Datensatz archiviert wurde';
COMMENT ON COLUMN afu_isboden.kalkgehalt_t.archive IS 'Wenn der Datensatz archviert wurde, ist er > 0.';

-- Constraint comments

COMMENT ON CONSTRAINT cons_pk_kalkgehalt_t ON afu_isboden.kalkgehalt_t IS 'Primärschlüssel';
COMMENT ON CONSTRAINT cons_unique_code_kalkgehalt_t ON afu_isboden.kalkgehalt_t IS 'Jeder Code darf nur einmal vorkommen';


-- afu_isboden.kartiererin_v_sc definition

-- Drop table

-- DROP TABLE afu_isboden.kartiererin_v_sc;

CREATE TABLE afu_isboden.kartiererin_v_sc ( pk_kartiererin int4 NOT NULL, "name" varchar(200) NULL, kuerzel varchar(100) NULL, CONSTRAINT kartiererin_v_pk PRIMARY KEY (pk_kartiererin));
COMMENT ON TABLE afu_isboden.kartiererin_v_sc IS 'Ersetzt die View afu_isboden.kartiererin_v';


-- afu_isboden.koernkl_t definition

-- Drop table

-- DROP TABLE afu_isboden.koernkl_t;

CREATE TABLE afu_isboden.koernkl_t ( pk_koernkl serial4 NOT NULL, code int4 NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_koernkl_t PRIMARY KEY (pk_koernkl), CONSTRAINT cons_unique_code_koernkl_t UNIQUE (code));
CREATE INDEX idx_koernkl_t_code ON afu_isboden.koernkl_t USING btree (code) WHERE (archive = 0);
COMMENT ON TABLE afu_isboden.koernkl_t IS 'Feinerdekörnung';

-- Column comments

COMMENT ON COLUMN afu_isboden.koernkl_t.pk_koernkl IS 'Primärschlüssel';
COMMENT ON COLUMN afu_isboden.koernkl_t.code IS 'Die Codes zur Feinerdekörnung';
COMMENT ON COLUMN afu_isboden.koernkl_t.beschreibung IS 'Beschreibung des Codes';
COMMENT ON COLUMN afu_isboden.koernkl_t.new_date IS 'Datum, wann der Datensatz importiert wurde';
COMMENT ON COLUMN afu_isboden.koernkl_t.archive_date IS 'Datum, wann der Datensatz archiviert wurde';
COMMENT ON COLUMN afu_isboden.koernkl_t.archive IS 'Wenn der Datensatz archviert wurde, ist er > 0.';

-- Constraint comments

COMMENT ON CONSTRAINT cons_pk_koernkl_t ON afu_isboden.koernkl_t IS 'Primärschlüssel';
COMMENT ON CONSTRAINT cons_unique_code_koernkl_t ON afu_isboden.koernkl_t IS 'Jeder Code darf nur einmal vorkommen';


-- afu_isboden.skelett_t definition

-- Drop table

-- DROP TABLE afu_isboden.skelett_t;

CREATE TABLE afu_isboden.skelett_t ( pk_skelett serial4 NOT NULL, code int4 NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, is_wald bool NULL, CONSTRAINT cons_pk_skelett_t PRIMARY KEY (pk_skelett));
CREATE INDEX idx_skelett_t_code ON afu_isboden.skelett_t USING btree (code) WHERE (archive = 0);
CREATE UNIQUE INDEX unique_code_is_wald ON afu_isboden.skelett_t USING btree (code, is_wald) WHERE (archive < 1);
COMMENT ON TABLE afu_isboden.skelett_t IS 'Skelettgehalt: Gemäss FAL Kap. 3.6.';

-- Column comments

COMMENT ON COLUMN afu_isboden.skelett_t.pk_skelett IS 'Die Codes vom Skelettgehalt';
COMMENT ON COLUMN afu_isboden.skelett_t.beschreibung IS 'Beschreibung des Codes';
COMMENT ON COLUMN afu_isboden.skelett_t.new_date IS 'Datum, wann der Datensatz importiert wurde';
COMMENT ON COLUMN afu_isboden.skelett_t.archive_date IS 'Datum, wann der Datensatz archiviert wurde';
COMMENT ON COLUMN afu_isboden.skelett_t.archive IS 'Wenn der Datensatz archviert wurde, ist er > 0.';

-- Constraint comments

COMMENT ON CONSTRAINT cons_pk_skelett_t ON afu_isboden.skelett_t IS 'Primärschlüssel';


-- afu_isboden.untertyp_t definition

-- Drop table

-- DROP TABLE afu_isboden.untertyp_t;

CREATE TABLE afu_isboden.untertyp_t ( pk_untertyp serial4 NOT NULL, code varchar(2) NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_untertyp_t PRIMARY KEY (pk_untertyp), CONSTRAINT cons_unique_code_untertyp_t UNIQUE (code));
CREATE INDEX idx_untertyp_t_code ON afu_isboden.untertyp_t USING btree (code) WHERE (archive = 0);
COMMENT ON TABLE afu_isboden.untertyp_t IS 'Untertyp: Gemäss FAL Kap. 5.2.';

-- Column comments

COMMENT ON COLUMN afu_isboden.untertyp_t.pk_untertyp IS 'Primärschlüssel';
COMMENT ON COLUMN afu_isboden.untertyp_t.code IS 'Die Codes der Untertypen';
COMMENT ON COLUMN afu_isboden.untertyp_t.beschreibung IS 'Beschreibung des Codes';
COMMENT ON COLUMN afu_isboden.untertyp_t.new_date IS 'Datum, wann der Datensatz importiert wurde';
COMMENT ON COLUMN afu_isboden.untertyp_t.archive_date IS 'Datum, wann der Datensatz archiviert wurde';
COMMENT ON COLUMN afu_isboden.untertyp_t.archive IS 'Wenn der Datensatz archviert wurde, ist er > 0.';

-- Constraint comments

COMMENT ON CONSTRAINT cons_pk_untertyp_t ON afu_isboden.untertyp_t IS 'Primärschlüssel';
COMMENT ON CONSTRAINT cons_unique_code_untertyp_t ON afu_isboden.untertyp_t IS 'Jeder Code darf nur einmal vorkommen';


-- afu_isboden.wasserhhgr_t definition

-- Drop table

-- DROP TABLE afu_isboden.wasserhhgr_t;

CREATE TABLE afu_isboden.wasserhhgr_t ( pk_wasserhhgr serial4 NOT NULL, code varchar(2) NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_wasserhhgr_t PRIMARY KEY (pk_wasserhhgr), CONSTRAINT cons_unique_wasserhhgr_t_code UNIQUE (code));
CREATE INDEX idx_wasserhhgr_t_code ON afu_isboden.wasserhhgr_t USING btree (code) WHERE (archive = 0);
COMMENT ON TABLE afu_isboden.wasserhhgr_t IS 'Wasserhaushaltsgruppe: Gemäss FAL Kap. 5.3.3';

-- Column comments

COMMENT ON COLUMN afu_isboden.wasserhhgr_t.pk_wasserhhgr IS 'Primärschlüssel';
COMMENT ON COLUMN afu_isboden.wasserhhgr_t.code IS 'Die Codes von wasserhhgr';
COMMENT ON COLUMN afu_isboden.wasserhhgr_t.beschreibung IS 'Beschreibung des Codes';
COMMENT ON COLUMN afu_isboden.wasserhhgr_t.new_date IS 'Datum, wann der Datensatz importiert wurde';
COMMENT ON COLUMN afu_isboden.wasserhhgr_t.archive_date IS 'Datum, wann der Datensatz archiviert wurde';
COMMENT ON COLUMN afu_isboden.wasserhhgr_t.archive IS 'Wenn der Datensatz archviert wurde, ist er > 0.';

-- Constraint comments

COMMENT ON CONSTRAINT cons_pk_wasserhhgr_t ON afu_isboden.wasserhhgr_t IS 'Primärschlüssel';
COMMENT ON CONSTRAINT cons_unique_wasserhhgr_t_code ON afu_isboden.wasserhhgr_t IS 'Jeder Code darf nur einmal vorkommen';


-- afu_isboden.wt_bodart definition

-- Drop table

-- DROP TABLE afu_isboden.wt_bodart;

CREATE TABLE afu_isboden.wt_bodart ( bodart varchar(5) NULL, ton_v float8 NULL, ton_b float8 NULL, schl_v float8 NULL, schl_b float8 NULL);


-- afu_isboden.wt_gefueg definition

-- Drop table

-- DROP TABLE afu_isboden.wt_gefueg;

CREATE TABLE afu_isboden.wt_gefueg ( lagdi varchar(5) NULL, begeffor varchar(5) NULL);


-- afu_isboden.wt_nutzbfk definition

-- Drop table

-- DROP TABLE afu_isboden.wt_nutzbfk;

CREATE TABLE afu_isboden.wt_nutzbfk ( bodart varchar(5) NULL, ld1_2 float8 NULL, ld3 float8 NULL, ld4_5 float8 NULL);


-- afu_isboden.wt_pfnugr definition

-- Drop table

-- DROP TABLE afu_isboden.wt_pfnugr;

CREATE TABLE afu_isboden.wt_pfnugr ( bewashgr varchar(5) NULL, png_w int4 NULL);


-- afu_isboden.wt_tab70_1 definition

-- Drop table

-- DROP TABLE afu_isboden.wt_tab70_1;

CREATE TABLE afu_isboden.wt_tab70_1 ( metall varchar(5) NULL, von float8 NULL, bis float8 NULL, wert1 float8 NULL);


-- afu_isboden.wt_tab70_2 definition

-- Drop table

-- DROP TABLE afu_isboden.wt_tab70_2;

CREATE TABLE afu_isboden.wt_tab70_2 ( metall varchar(5) NULL, grenz_ph float8 NULL, humus float8 NULL, ton float8 NULL);


-- afu_isboden.wt_tab70_3 definition

-- Drop table

-- DROP TABLE afu_isboden.wt_tab70_3;

CREATE TABLE afu_isboden.wt_tab70_3 ( hum_von int4 NULL, hum_bis int4 NULL, bind_st float8 NULL, wert2 float8 NULL);


-- afu_isboden.wt_tab70_4 definition

-- Drop table

-- DROP TABLE afu_isboden.wt_tab70_4;

CREATE TABLE afu_isboden.wt_tab70_4 ( ton_von int4 NULL, ton_bis int4 NULL, bind_st int4 NULL, wert3 float8 NULL);


-- afu_isboden.wt_tab70_4sk definition

-- Drop table

-- DROP TABLE afu_isboden.wt_tab70_4sk;

CREATE TABLE afu_isboden.wt_tab70_4sk ( skelett text NULL, minuswert float8 NULL);


-- afu_isboden.wt_znutzbfk definition

-- Drop table

-- DROP TABLE afu_isboden.wt_znutzbfk;

CREATE TABLE afu_isboden.wt_znutzbfk ( bodart varchar(5) NULL, hugeah_v float8 NULL, hugeah_b float8 NULL, znutzbfk float8 NULL);


-- afu_isboden.bodeneinheit_auspraegung_t definition

-- Drop table

-- DROP TABLE afu_isboden.bodeneinheit_auspraegung_t;

CREATE TABLE afu_isboden.bodeneinheit_auspraegung_t ( pk_bodeneinheit bigserial NOT NULL, fk_bodeneinheit int8 NOT NULL, is_hauptauspraegung bool NOT NULL, gewichtung_auspraegung afu_isboden.d_gt_0_le_100 NOT NULL, fk_wasserhhgr int4 NULL, fk_bodentyp int4 NULL, fk_begelfor int4 NULL, fk_skelett_ob int4 NULL, fk_skelett_ub int4 NULL, fk_koernkl_ob int4 NULL, fk_koernkl_ub int4 NULL, ton_ob int4 NULL, ton_ub int4 NULL, schluff_ob int4 NULL, schluff_ub int4 NULL, karbgrenze int4 NULL, fk_kalkgehalt_ob int4 NULL, fk_kalkgehalt_ub int4 NULL, ph_ob float8 NULL, ph_ub float8 NULL, maechtigk_ah int2 NULL, humusgeh_ah float8 NULL, fk_humusform_wa int4 NULL, fk_gefuegeform_ob int4 NULL, fk_gefuegeform_ub int4 NULL, fk_gefueggr_ob int4 NULL, fk_gefueggr_ub int4 NULL, bemerkungen varchar(300) NULL, bodpktzahl int4 NULL, pflngr int4 NULL, maechtigk_ahh float8 NULL, bindst_cd float8 NULL, bindst_zn float8 NULL, bindst_cu float8 NULL, bindst_pb float8 NULL, nfkapwe_ob float8 NULL, nfkapwe_ub float8 NULL, nfkapwe float8 NULL, verdempf int2 NULL, drain_wel float8 NULL, wassastoss float8 NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, geologie varchar(30) NULL, CONSTRAINT pk_bodeneinheit_auspraegung_t PRIMARY KEY (pk_bodeneinheit), CONSTRAINT cons_fk_begelfor_t FOREIGN KEY (fk_begelfor) REFERENCES afu_isboden.begelfor_t(pk_begelfor), CONSTRAINT cons_fk_bodeneinheit_t FOREIGN KEY (fk_bodeneinheit) REFERENCES afu_isboden.bodeneinheit_t(pk_ogc_fid) ON DELETE CASCADE, CONSTRAINT cons_fk_gefuegeform_t_ob FOREIGN KEY (fk_gefuegeform_ob) REFERENCES afu_isboden.gefuegeform_t(pk_gefuegeform), CONSTRAINT cons_fk_gefuegeform_t_ub FOREIGN KEY (fk_gefuegeform_ub) REFERENCES afu_isboden.gefuegeform_t(pk_gefuegeform), CONSTRAINT cons_fk_gefueggr_t_ob FOREIGN KEY (fk_gefueggr_ob) REFERENCES afu_isboden.gefueggr_t(pk_gefueggr), CONSTRAINT cons_fk_humusform_wa_t FOREIGN KEY (fk_humusform_wa) REFERENCES afu_isboden.humusform_wa_t(pk_humusform_wa), CONSTRAINT cons_fk_kalkgehalt_t_ub FOREIGN KEY (fk_kalkgehalt_ub) REFERENCES afu_isboden.kalkgehalt_t(pk_kalkgehalt), CONSTRAINT cons_fk_koernkl_t_ob FOREIGN KEY (fk_koernkl_ob) REFERENCES afu_isboden.koernkl_t(pk_koernkl), CONSTRAINT cons_fk_koernkl_t_ub FOREIGN KEY (fk_koernkl_ub) REFERENCES afu_isboden.koernkl_t(pk_koernkl), CONSTRAINT cons_fk_skelett_t_ob FOREIGN KEY (fk_skelett_ob) REFERENCES afu_isboden.skelett_t(pk_skelett), CONSTRAINT cons_fk_skelett_t_ub FOREIGN KEY (fk_skelett_ub) REFERENCES afu_isboden.skelett_t(pk_skelett), CONSTRAINT cons_fk_wasserhhgr_t FOREIGN KEY (fk_wasserhhgr) REFERENCES afu_isboden.wasserhhgr_t(pk_wasserhhgr), CONSTRAINT fk_kalkgehalt_t_ob FOREIGN KEY (fk_kalkgehalt_ob) REFERENCES afu_isboden.kalkgehalt_t(pk_kalkgehalt), CONSTRAINT fk_ub_gefueggr FOREIGN KEY (fk_gefueggr_ub) REFERENCES afu_isboden.gefueggr_t(pk_gefueggr));
CREATE INDEX idx_bodeneinheit_auspraegung_t_fk_bodentyp ON afu_isboden.bodeneinheit_auspraegung_t USING btree (fk_bodentyp) WHERE (archive < 1);
CREATE INDEX idx_bodeneinheit_t_fk_wasserhhgr ON afu_isboden.bodeneinheit_auspraegung_t USING btree (fk_wasserhhgr) WHERE (archive < 1);
COMMENT ON TABLE afu_isboden.bodeneinheit_auspraegung_t IS 'Auspraegung Bodeneinheiten';

-- Column comments

COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.pk_bodeneinheit IS 'Primärschlüssel';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.fk_bodeneinheit IS 'Fremdschlüssel zur Fläche bodeneinheit_t';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.is_hauptauspraegung IS 'Handelt es sich um die Hauptsausprägung der Fläche?';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.fk_wasserhhgr IS 'Fremdschlüssel wasserhhgr_t';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.fk_bodentyp IS 'Bodentyp: Gemäss FAL Kap. 5.1';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.fk_begelfor IS 'Fremdschlüssel begelfor_t';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.fk_skelett_ob IS 'Fremdschlüssel von skelett_t';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.fk_skelett_ub IS 'Fremdschlüssel von skelett_lw';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.ton_ob IS 'Tongehalt des Oberbodens in %';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.ton_ub IS 'Tongehalt des Unterbodens';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.schluff_ob IS 'Schluffgehalt des Oberbodens in %';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.schluff_ub IS 'Schlufgehalt des Unterbodens';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.karbgrenze IS 'Karbonatgrenze';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.fk_kalkgehalt_ob IS 'Karbonatgehalt Oberboden: Gemäss FAL Kap. 3.7';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.fk_kalkgehalt_ub IS 'Kabonatgehalt Unterboden: Gemäss FAL Kap. 3.7';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.ph_ob IS 'PH Oberboden';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.humusgeh_ah IS 'Humusgehalt Ah-Horizont';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.fk_humusform_wa IS 'Humusform, nur bei Waldböden';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.fk_gefuegeform_ob IS 'Gefügeform Oberboden gemäss FAL Kap. 3.3';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.fk_gefueggr_ub IS 'Gefügegrösse Unterboden';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.bodpktzahl IS 'Bodenprofilwert';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.pflngr IS 'Pflanzennutzbare Gründigkeit (in cm)';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.bindst_cd IS 'Relative Bindungsstärke für Cadminum';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.bindst_zn IS 'Relative Bindunsstärke für Zink';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.bindst_cu IS 'Relative Bindungsstärke für Kupfer';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.bindst_pb IS 'Relative Bindungsstärke für Blei';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.nfkapwe_ub IS 'Nutbare Feldkapazität des effektiven Wurzelraumes Unterboden';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.nfkapwe IS 'Nutzbare Feldkapazität des effektiven Wurzelraums';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.verdempf IS 'Empfindlichkeit des bodens';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.drain_wel IS 'Drainage Empfehlungskarte';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.new_date IS 'Datum, wann der Datensatz importiert wurde';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.archive_date IS 'Datum, wann der Datensatz archiviert wurde';
COMMENT ON COLUMN afu_isboden.bodeneinheit_auspraegung_t.archive IS 'Wenn der Datensatz archviert wurde, ist er > 0.';

-- Table Triggers

CREATE TRIGGER delete_kuerzel_bodeneinheit_t AFTER
DELETE
    ON
    afu_isboden.bodeneinheit_auspraegung_t FOR EACH ROW EXECUTE FUNCTION afu_isboden.delete_kuerzel_trigger_function();
CREATE TRIGGER insert_kuerzel_bodeneinheit_t BEFORE
INSERT
    ON
    afu_isboden.bodeneinheit_auspraegung_t FOR EACH ROW EXECUTE FUNCTION afu_isboden.insert_kuerzel_trigger_function();
CREATE TRIGGER update_bindst BEFORE
INSERT
    OR
UPDATE
    ON
    afu_isboden.bodeneinheit_auspraegung_t FOR EACH ROW EXECUTE FUNCTION afu_isboden.bindst();
CREATE TRIGGER update_kuerzel_bodeneinheit_t BEFORE
UPDATE
    ON
    afu_isboden.bodeneinheit_auspraegung_t FOR EACH ROW EXECUTE FUNCTION afu_isboden.update_kuerzel_trigger_function();
CREATE TRIGGER update_verdempf BEFORE
INSERT
    OR
UPDATE
    ON
    afu_isboden.bodeneinheit_auspraegung_t FOR EACH ROW EXECUTE FUNCTION afu_isboden.verdempf();
CREATE TRIGGER update_nitrat BEFORE
INSERT
    OR
UPDATE
    ON
    afu_isboden.bodeneinheit_auspraegung_t FOR EACH ROW EXECUTE FUNCTION afu_isboden.nitrat();


-- afu_isboden.bodeneinheit_historische_nummerierung_t definition

-- Drop table

-- DROP TABLE afu_isboden.bodeneinheit_historische_nummerierung_t;

CREATE TABLE afu_isboden.bodeneinheit_historische_nummerierung_t ( pk_historische_nummerierung int8 DEFAULT nextval('afu_isboden.bodeneinheit_historische_nummer_pk_historische_nummerierung_seq'::regclass) NOT NULL, fk_bodeneinheit int8 NOT NULL, objnr int4 NULL, gemnr int2 NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT pk_historische_nummerierung PRIMARY KEY (pk_historische_nummerierung), CONSTRAINT cons_fk_bodeneinheit_t FOREIGN KEY (fk_bodeneinheit) REFERENCES afu_isboden.bodeneinheit_t(pk_ogc_fid) ON DELETE CASCADE);
CREATE INDEX idx_bodeneinheit_historische_nummerierung_t_fk_bodeneinheit ON afu_isboden.bodeneinheit_historische_nummerierung_t USING btree (fk_bodeneinheit) WHERE (archive < 1);
CREATE INDEX idx_bodeneinheit_historische_nummerierung_t_gemnr ON afu_isboden.bodeneinheit_historische_nummerierung_t USING btree (gemnr) WHERE (archive < 1);
CREATE INDEX idx_bodeneinheit_historische_nummerierung_t_objnr ON afu_isboden.bodeneinheit_historische_nummerierung_t USING btree (objnr) WHERE (archive < 1);
COMMENT ON TABLE afu_isboden.bodeneinheit_historische_nummerierung_t IS 'Historische Objnr / Gemnr für die Suche';

-- Column comments

COMMENT ON COLUMN afu_isboden.bodeneinheit_historische_nummerierung_t.pk_historische_nummerierung IS 'Primärschlüssel';
COMMENT ON COLUMN afu_isboden.bodeneinheit_historische_nummerierung_t.fk_bodeneinheit IS 'Fremdschlüssel zur Fläche bodeneinheit_t';
COMMENT ON COLUMN afu_isboden.bodeneinheit_historische_nummerierung_t.objnr IS 'Veraltete objnr oder NULL';
COMMENT ON COLUMN afu_isboden.bodeneinheit_historische_nummerierung_t.gemnr IS 'Veraltete gemnr oder NULL';


-- afu_isboden.zw_bodeneinheit_untertyp definition

-- Drop table

-- DROP TABLE afu_isboden.zw_bodeneinheit_untertyp;

CREATE TABLE afu_isboden.zw_bodeneinheit_untertyp ( pk_zw_bodeneinheit_untertyp bigserial NOT NULL, fk_bodeneinheit int4 NOT NULL, fk_untertyp int4 NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_zw_bodeneinheit_untertyp PRIMARY KEY (pk_zw_bodeneinheit_untertyp), CONSTRAINT fk_bodentyp_auspraegung FOREIGN KEY (fk_bodeneinheit) REFERENCES afu_isboden.bodeneinheit_auspraegung_t(pk_bodeneinheit) ON DELETE CASCADE, CONSTRAINT fk_untertyp FOREIGN KEY (fk_untertyp) REFERENCES afu_isboden.untertyp_t(pk_untertyp));
COMMENT ON TABLE afu_isboden.zw_bodeneinheit_untertyp IS 'Zwischentabelle bodeneinheiten_t untertyp_t';

-- Column comments

COMMENT ON COLUMN afu_isboden.zw_bodeneinheit_untertyp.pk_zw_bodeneinheit_untertyp IS 'Primärschlüssel';
COMMENT ON COLUMN afu_isboden.zw_bodeneinheit_untertyp.fk_bodeneinheit IS 'Fremdschlüssel Bodeneinheiten';
COMMENT ON COLUMN afu_isboden.zw_bodeneinheit_untertyp.fk_untertyp IS 'Fremdschlüssel Untertyp';
COMMENT ON COLUMN afu_isboden.zw_bodeneinheit_untertyp.new_date IS 'Datum, wann der Datensatz importiert wurde';
COMMENT ON COLUMN afu_isboden.zw_bodeneinheit_untertyp.archive_date IS 'Datum, wann der Datensatz archiviert wurde';
COMMENT ON COLUMN afu_isboden.zw_bodeneinheit_untertyp.archive IS 'Wenn der Datensatz archviert wurde, ist er > 0.';


-- afu_isboden.bodeneinheit_hauptauspraegung_simple_v source

CREATE OR REPLACE VIEW afu_isboden.bodeneinheit_hauptauspraegung_simple_v
AS SELECT DISTINCT ON (be.pk_ogc_fid) be.pk_ogc_fid,
    be.kuerzel,
    be.gemnr,
    be.gemnr_aktuell,
    be.objnr,
    wasserhhgr_t.code AS wasserhhgr,
    bodentyp_t.code AS bodentyp,
    begelfor_t.code AS gelform,
    a.geologie,
    untertyp.untertyp,
    skelett_t_ob.code AS skelett_ob,
    skelett_t_ub.code AS skelett_ub,
    koernkl_t_ob.code AS koernkl_ob,
    koernkl_t_ub.code AS koernkl_ub,
    a.ton_ob,
    a.ton_ub,
    a.schluff_ob,
    a.schluff_ub,
    a.karbgrenze,
    kalkgehalt_t_ob.code AS kalkgeh_ob,
    kalkgehalt_t_ub.code AS kalkgeh_ub,
    a.ph_ob,
    a.ph_ub,
    a.maechtigk_ah,
    a.humusgeh_ah,
    humusform_wa_t.code AS humusform_wa,
    a.maechtigk_ahh,
    gefuegeform_t_ob.code AS gefuegeform_ob,
    gefuegeform_t_ub.code AS gefuegeform_ub,
    gefueggr_t_ob.code AS gefueggr_ob,
    gefueggr_t_ub.code AS gefueggr_ub,
    a.pflngr,
    a.bodpktzahl,
    a.bemerkungen,
    be.los,
    be.kartierjahr,
    be.fk_kartierer AS kartierer,
    be.kartierquartal,
    be.is_wald,
    a.bindst_cd,
    a.bindst_zn,
    a.bindst_cu,
    a.bindst_pb,
    a.nfkapwe_ob,
    a.nfkapwe_ub,
    a.nfkapwe,
    a.verdempf,
    a.drain_wel,
    a.wassastoss,
    a.is_hauptauspraegung,
    be.label_x,
    be.label_y,
    be.vali,
    be.hali,
    be.wkb_geometry,
    be.archive
   FROM afu_isboden.bodeneinheit_t be
     LEFT JOIN afu_isboden.bodeneinheit_auspraegung_t a ON a.fk_bodeneinheit = be.pk_ogc_fid
     LEFT JOIN afu_isboden.wasserhhgr_t wasserhhgr_t ON wasserhhgr_t.pk_wasserhhgr = a.fk_wasserhhgr
     LEFT JOIN afu_isboden.bodentyp_t bodentyp_t ON bodentyp_t.pk_bodentyp = a.fk_bodentyp
     LEFT JOIN afu_isboden.begelfor_t begelfor_t ON begelfor_t.pk_begelfor = a.fk_begelfor
     LEFT JOIN afu_isboden.skelett_t skelett_t_ob ON skelett_t_ob.pk_skelett = a.fk_skelett_ob
     LEFT JOIN afu_isboden.skelett_t skelett_t_ub ON skelett_t_ub.pk_skelett = a.fk_skelett_ub
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ob ON koernkl_t_ob.pk_koernkl = a.fk_koernkl_ob
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ub ON koernkl_t_ub.pk_koernkl = a.fk_koernkl_ub
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ob ON kalkgehalt_t_ob.pk_kalkgehalt = a.fk_kalkgehalt_ob
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ub ON kalkgehalt_t_ub.pk_kalkgehalt = a.fk_kalkgehalt_ub
     LEFT JOIN afu_isboden.humusform_wa_t humusform_wa_t ON humusform_wa_t.pk_humusform_wa = a.fk_humusform_wa
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ob ON gefuegeform_t_ob.pk_gefuegeform = a.fk_gefuegeform_ob
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ub ON gefuegeform_t_ub.pk_gefuegeform = a.fk_gefuegeform_ub
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ob ON gefueggr_t_ob.pk_gefueggr = a.fk_gefueggr_ob
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ub ON gefueggr_t_ub.pk_gefueggr = a.fk_gefueggr_ub
     LEFT JOIN ( SELECT zw_bodeneinheit_untertyp_t.fk_bodeneinheit,
            array_agg(untertyp_t.code) AS untertyp,
            array_agg(untertyp_t.beschreibung) AS beschreibung,
            array_agg(untertyp_t.pk_untertyp) AS fk_untertyp
           FROM afu_isboden.zw_bodeneinheit_untertyp zw_bodeneinheit_untertyp_t
             LEFT JOIN afu_isboden.untertyp_t untertyp_t ON untertyp_t.pk_untertyp = zw_bodeneinheit_untertyp_t.fk_untertyp
          GROUP BY zw_bodeneinheit_untertyp_t.fk_bodeneinheit) untertyp ON untertyp.fk_bodeneinheit = a.pk_bodeneinheit
  WHERE a.is_hauptauspraegung
  ORDER BY be.pk_ogc_fid;

COMMENT ON VIEW afu_isboden.bodeneinheit_hauptauspraegung_simple_v IS 'Vereinfachte View für Verifikationen. Wird im Plugin IS-Boden angesprochen (isboden_tools.py)';


-- afu_isboden.bodeneinheit_hauptauspraegung_v source

CREATE OR REPLACE VIEW afu_isboden.bodeneinheit_hauptauspraegung_v
AS SELECT DISTINCT ON (be.pk_ogc_fid) a.pk_bodeneinheit,
    be.pk_ogc_fid,
    be.gemnr,
    be.gemnr_aktuell,
    be.objnr,
    be.is_wald,
    be.label_x,
    be.label_y,
    st_area(be.wkb_geometry) AS area,
    be.kuerzel,
    be.los,
    be.kartierjahr,
    be.fk_kartierer AS kartierer,
    be.kartierquartal,
    a.is_hauptauspraegung,
    a.gewichtung_auspraegung,
    a.geologie,
    untertyp.untertyp,
    untertyp.beschreibung AS untertyp_beschreibung,
    untertyp.fk_untertyp,
    wasserhhgr_t.code AS wasserhhgr,
    wasserhhgr_t.beschreibung AS wasserhhgr_beschreibung,
    wasserhhgr_t.pk_wasserhhgr AS fk_wasserhhgr,
    bodentyp_t.code AS bodentyp,
    bodentyp_t.beschreibung AS bodentyp_beschreibung,
    bodentyp_t.pk_bodentyp AS fk_bodentyp,
    begelfor_t.code AS begelfor,
    begelfor_t.beschreibung AS begelfor_beschreibung,
    begelfor_t.pk_begelfor AS fk_begelfor,
    skelett_t_ob.code AS skelett_ob,
    skelett_t_ob.beschreibung AS skelett_ob_beschreibung,
    skelett_t_ob.pk_skelett AS fk_skelett_ob,
    skelett_t_ub.code AS skelett_ub,
    skelett_t_ub.beschreibung AS skelett_ub_beschreibung,
    skelett_t_ub.pk_skelett AS fk_skelett_ub,
    koernkl_t_ob.code AS koernkl_ob,
    koernkl_t_ob.beschreibung AS koernkl_ob_beschreibung,
    koernkl_t_ob.pk_koernkl AS fk_koernkl_ob,
    koernkl_t_ub.code AS koernkl_ub,
    koernkl_t_ub.beschreibung AS koernkl_ub_beschreibung,
    koernkl_t_ub.pk_koernkl AS fk_koernkl_ub,
    a.ton_ob,
    a.ton_ub,
    a.schluff_ob,
    a.schluff_ub,
    a.karbgrenze,
    kalkgehalt_t_ob.code AS kalkgeh_ob,
    kalkgehalt_t_ob.beschreibung AS kalkgeh_ob_beschreibung,
    kalkgehalt_t_ob.pk_kalkgehalt AS fk_kalkgehalt_ob,
    kalkgehalt_t_ub.code AS kalkgeh_ub,
    kalkgehalt_t_ub.beschreibung AS kalkgeh_ub_beschreibung,
    kalkgehalt_t_ub.pk_kalkgehalt AS fk_kalkgehalt_ub,
    a.ph_ob,
    a.ph_ub,
    a.maechtigk_ah,
    a.humusgeh_ah,
    humusform_wa_t.code AS humusform_wa,
    humusform_wa_t.beschreibung AS humusform_wa_beschreibung,
    humusform_wa_t.pk_humusform_wa AS fk_humusform_wa,
    gefuegeform_t_ob.code AS gefuegeform_ob,
    gefuegeform_t_ob.beschreibung AS gefuegeform_ob_beschreibung,
    gefuegeform_t_ob.pk_gefuegeform AS fk_gefuegeform_ob,
    gefuegeform_t_ub.code AS gefuegeform_ub,
    gefuegeform_t_ub.beschreibung AS gefuegeform_ub_beschreibung,
    gefuegeform_t_ub.pk_gefuegeform AS fk_gefuegeform_ub,
    gefueggr_t_ob.code AS gefueggr_ob,
    gefueggr_t_ob.beschreibung AS gefueggr_ob_beschreibung,
    gefueggr_t_ob.pk_gefueggr AS fk_gefueggr_ob,
    gefueggr_t_ub.code AS gefueggr_ub,
    gefueggr_t_ub.beschreibung AS gefueggr_ub_beschreibung,
    gefueggr_t_ub.pk_gefueggr AS fk_gefueggr_ub,
    a.bemerkungen,
    a.bodpktzahl,
    a.pflngr,
    a.maechtigk_ahh,
    a.bindst_cd,
    a.bindst_zn,
    a.bindst_cu,
    a.bindst_pb,
    a.nfkapwe_ob,
    a.nfkapwe_ub,
    a.nfkapwe,
    a.verdempf,
    a.drain_wel,
    a.wassastoss,
    be.wkb_geometry,
    be.archive
   FROM afu_isboden.bodeneinheit_t be
     LEFT JOIN afu_isboden.bodeneinheit_auspraegung_t a ON a.fk_bodeneinheit = be.pk_ogc_fid
     LEFT JOIN afu_isboden.wasserhhgr_t wasserhhgr_t ON wasserhhgr_t.pk_wasserhhgr = a.fk_wasserhhgr
     LEFT JOIN afu_isboden.bodentyp_t bodentyp_t ON bodentyp_t.pk_bodentyp = a.fk_bodentyp
     LEFT JOIN afu_isboden.begelfor_t begelfor_t ON begelfor_t.pk_begelfor = a.fk_begelfor
     LEFT JOIN afu_isboden.skelett_t skelett_t_ob ON skelett_t_ob.pk_skelett = a.fk_skelett_ob
     LEFT JOIN afu_isboden.skelett_t skelett_t_ub ON skelett_t_ub.pk_skelett = a.fk_skelett_ub
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ob ON koernkl_t_ob.pk_koernkl = a.fk_koernkl_ob
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ub ON koernkl_t_ub.pk_koernkl = a.fk_koernkl_ub
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ob ON kalkgehalt_t_ob.pk_kalkgehalt = a.fk_kalkgehalt_ob
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ub ON kalkgehalt_t_ub.pk_kalkgehalt = a.fk_kalkgehalt_ub
     LEFT JOIN afu_isboden.humusform_wa_t humusform_wa_t ON humusform_wa_t.pk_humusform_wa = a.fk_humusform_wa
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ob ON gefuegeform_t_ob.pk_gefuegeform = a.fk_gefuegeform_ob
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ub ON gefuegeform_t_ub.pk_gefuegeform = a.fk_gefuegeform_ub
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ob ON gefueggr_t_ob.pk_gefueggr = a.fk_gefueggr_ob
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ub ON gefueggr_t_ub.pk_gefueggr = a.fk_gefueggr_ub
     LEFT JOIN ( SELECT zw_bodeneinheit_untertyp_t.fk_bodeneinheit,
            array_agg(untertyp_t.code) AS untertyp,
            array_agg(untertyp_t.beschreibung) AS beschreibung,
            array_agg(untertyp_t.pk_untertyp) AS fk_untertyp
           FROM afu_isboden.zw_bodeneinheit_untertyp zw_bodeneinheit_untertyp_t
             LEFT JOIN afu_isboden.untertyp_t untertyp_t ON untertyp_t.pk_untertyp = zw_bodeneinheit_untertyp_t.fk_untertyp
          GROUP BY zw_bodeneinheit_untertyp_t.fk_bodeneinheit) untertyp ON untertyp.fk_bodeneinheit = a.pk_bodeneinheit
  WHERE a.is_hauptauspraegung
  ORDER BY be.pk_ogc_fid;

COMMENT ON VIEW afu_isboden.bodeneinheit_hauptauspraegung_v IS 'Diese View wird vom IS-Boden Plugin verwendet.';


-- afu_isboden.bodeneinheit_lw_qgis_server_client_v source

CREATE OR REPLACE VIEW afu_isboden.bodeneinheit_lw_qgis_server_client_v
AS SELECT be.pk_ogc_fid,
    be.gemnr,
    be.objnr,
    wasserhhgr_t.code AS wasserhhgr,
    wasserhhgr_t.beschreibung AS wasserhhgr_beschreibung,
        CASE
            WHEN wasserhhgr_t.code::text = 'a'::text OR wasserhhgr_t.code::text = 'b'::text OR wasserhhgr_t.code::text = 'c'::text OR wasserhhgr_t.code::text = 'd'::text OR wasserhhgr_t.code::text = 'e'::text THEN 'Kein Einfluss von Stau- oder Grundwasser'::text::character varying
            WHEN wasserhhgr_t.code::text = 'f'::text OR wasserhhgr_t.code::text = 'g'::text OR wasserhhgr_t.code::text = 'h'::text OR wasserhhgr_t.code::text = 'i'::text THEN 'Leichter Einfluss von Stauwasser'::text::character varying
            WHEN wasserhhgr_t.code::text = 'k'::text OR wasserhhgr_t.code::text = 'l'::text OR wasserhhgr_t.code::text = 'm'::text OR wasserhhgr_t.code::text = 'n'::text THEN 'Leichter Einfluss von Grund- oder Hangwasser'::text::character varying
            WHEN wasserhhgr_t.code::text = 'o'::text AND a.pflngr >= 70 OR wasserhhgr_t.code::text = 'o'::text AND a.pflngr < 70 OR wasserhhgr_t.code::text = 'p'::text AND a.pflngr >= 30 OR wasserhhgr_t.code::text = 'p'::text AND a.pflngr < 30 OR wasserhhgr_t.code::text = 'q'::text OR wasserhhgr_t.code::text = 'r'::text THEN 'Starker Einfluss von Stauwasser.<br>Falls nicht drainiert, stellenweise dauernd vernässt'::text::character varying
            WHEN wasserhhgr_t.code::text = 's'::text OR wasserhhgr_t.code::text = 't'::text OR wasserhhgr_t.code::text = 'u'::text AND a.pflngr >= 30 OR wasserhhgr_t.code::text = 'u'::text AND a.pflngr < 30 OR wasserhhgr_t.code::text = 'v'::text OR wasserhhgr_t.code::text = 'x'::text OR wasserhhgr_t.code::text = 'y'::text OR wasserhhgr_t.code::text = 'z'::text OR wasserhhgr_t.code::text = 'w'::text AND a.pflngr >= 30 OR wasserhhgr_t.code::text = 'w'::text AND a.pflngr < 30 THEN 'Starker Einfluss von Grund- oder Hangwasser.<br>Falls nicht drainiert, stellenweise dauernd vernässt'::text::character varying
            ELSE NULL::character varying
        END AS wasserhhgr_qgis_txt,
    bodentyp_t.code AS bodentyp,
    bodentyp_t.beschreibung AS bodentyp_beschreibung,
    begelfor_t.code AS gelform,
    begelfor_t.beschreibung AS gelform_beschreibung,
    a.geologie,
    untertyp.untertyp_e,
    untertyp.untertyp_k,
    untertyp.untertyp_i,
    untertyp.untertyp_g,
    untertyp.untertyp_r,
    untertyp.untertyp_p,
    untertyp.untertyp_div,
    skelett_t_ob.code AS skelett_ob,
    skelett_t_ob.beschreibung AS skelett_ob_beschreibung,
    skelett_t_ub.code AS skelett_ub,
    skelett_t_ub.beschreibung AS skelett_ub_beschreibung,
    koernkl_t_ob.code AS koernkl_ob,
    koernkl_t_ob.beschreibung AS koernkl_ob_beschreibung,
    koernkl_t_ub.code AS koernkl_ub,
    koernkl_t_ub.beschreibung AS koernkl_ub_beschreibung,
    a.ton_ob,
    a.ton_ub,
    a.schluff_ob,
    a.schluff_ub,
    a.karbgrenze,
    kalkgehalt_t_ob.code AS kalkgeh_ob,
    kalkgehalt_t_ob.beschreibung AS kalkgeh_ob_beschreibung,
    kalkgehalt_t_ub.code AS kalkgeh_ub,
    kalkgehalt_t_ub.beschreibung AS kalkgeh_ub_beschreibung,
    a.ph_ob,
        CASE
            WHEN a.ph_ob > 0::double precision AND a.ph_ob < 4.3::double precision THEN 'stark sauer:<br>starke Nährstoffauswaschung; Kalkung erforderlich'::text
            WHEN a.ph_ob >= 4.3::double precision AND a.ph_ob < 5.1::double precision THEN 'sauer:<br>Nährstoffauswaschung; Kalkung erforderlich'::text
            WHEN a.ph_ob >= 5.1::double precision AND a.ph_ob < 6.1::double precision THEN 'schwach sauer:<br>optimale Nährstoffverhältnisse; Erhaltungskalkung empfohlen'::text
            WHEN a.ph_ob >= 6.2::double precision AND a.ph_ob < 6.7::double precision THEN 'neutral:<br>optimale Nährstoffverhältnisse; Erhaltungskalkung empfohlen'::text
            WHEN a.ph_ob >= 6.8::double precision THEN 'alkalisch:<br>keine Kalkung'::text
            ELSE NULL::text
        END AS ph_ob_qgis_txt,
    a.ph_ub,
        CASE
            WHEN a.ph_ub > 0::double precision AND a.ph_ub < 3.3::double precision THEN 'sehr stark sauer'::text
            WHEN a.ph_ub >= 3.3::double precision AND a.ph_ub < 4.3::double precision THEN 'stark sauer'::text
            WHEN a.ph_ub >= 4.3::double precision AND a.ph_ub < 5.1::double precision THEN 'sauer'::text
            WHEN a.ph_ub >= 5.1::double precision AND a.ph_ub < 6.2::double precision THEN 'schwach sauer'::text
            WHEN a.ph_ub >= 6.2::double precision AND a.ph_ub < 6.8::double precision THEN 'neutral'::text
            WHEN a.ph_ub >= 6.8::double precision THEN 'alkalisch'::text
            ELSE NULL::text
        END AS ph_ub_qgis_txt,
    a.maechtigk_ah,
    a.humusgeh_ah,
        CASE
            WHEN a.humusgeh_ah > 0::double precision AND a.humusgeh_ah < 2::double precision THEN '< 2.0%: humusarm'::text
            WHEN a.humusgeh_ah >= 2::double precision AND a.humusgeh_ah < 3::double precision THEN '2.0 - 2.9%: schwach humos'::text
            WHEN a.humusgeh_ah >= 3::double precision AND a.humusgeh_ah < 4::double precision THEN '3.0 - 3.9%: mässig humos'::text
            WHEN a.humusgeh_ah >= 4::double precision AND a.humusgeh_ah < 5::double precision THEN '4.0 - 4.9%: mittel humos'::text
            WHEN a.humusgeh_ah >= 5::double precision AND a.humusgeh_ah < 10::double precision THEN '5.0 - 9.9%: humos'::text
            WHEN a.humusgeh_ah >= 10::double precision THEN '>= 10.0%: humusreich bis organisch'::text
            ELSE NULL::text
        END AS humusgeh_ah_qgis_txt,
    humusform_wa_t.code AS humusform_wa,
    humusform_wa_t.beschreibung AS humusform_wa_beschreibung,
        CASE
            WHEN humusform_wa_t.code::text = 'M'::text OR humusform_wa_t.code::text = 'Mt'::text OR humusform_wa_t.code::text = 'Mf'::text THEN 'Mull<br>Hohe biologische Aktivität mit vollständigem Streuabbau nach 1-2 Jahren. Über 8 cm mächtiger, gut strukturierter Oberboden. Günstiger Wasser-, Luft- und Nährstoffhaushalt.'::text
            WHEN humusform_wa_t.code::text = 'Fm'::text OR humusform_wa_t.code::text = 'Fa'::text OR humusform_wa_t.code::text = 'Fr'::text OR humusform_wa_t.code::text = 'Fl'::text THEN 'Moder<br>Wegen Säuregrad reduzierte biologische Aktivität. Verlangsamter, unvollständiger Streuabbau, daher organische Auflage.4-8 cm mächtiger Oberboden. Saure, nährstoffarme Böden in krautarmen Laub- und Nadelwäldern.'::text
            WHEN humusform_wa_t.code::text = 'L'::text OR humusform_wa_t.code::text = 'La'::text OR humusform_wa_t.code::text = 'Lr'::text THEN 'Rohhumus<br>Geringe biologische Aktivität. Gehemmter Streuabbau mit ausgeprägten Auflagehorizonten und geringmächtigem Oberboden. Stark saure, nährstoffarme Böden mit schwer abbaubarer Streu (Nadelwälder)..'::text
            WHEN humusform_wa_t.code::text = 'MHt'::text OR humusform_wa_t.code::text = 'MHf'::text THEN 'Feuchtmull<br>Hohe biologische Aktivität mit vollständigem Streuabbau nach 1-2 Jahren. Über 8 cm mächtiger, gut strukturierter Oberboden. Trotz schwach vernässtem Boden günstiger Wasser-, Luft- und Nährstoffhaushalt.'::text
            WHEN humusform_wa_t.code::text = 'FHm'::text OR humusform_wa_t.code::text = 'FHa'::text OR humusform_wa_t.code::text = 'FHr'::text OR humusform_wa_t.code::text = 'FHl'::text THEN 'Feuchtmoder<br>Wegen Vernässung reduzierte biologische Aktivität. Verlangsamter, unvollständiger Streuabbau, daher organische Auflage.4-8 cm mächtiger Oberboden.Vernässte, z.T. saure, nährstoffarme Bödern.'::text
            WHEN humusform_wa_t.code::text = 'Lha'::text OR humusform_wa_t.code::text = 'LHr'::text THEN 'Feuchtrohhumus<br>Geringe biologische Aktivität. Gehemmter Streuabbau mit ausgeprägten Auflagehorizonten und geringmächtigem Oberboden.Vernässte, stark saure, nährstoffarme Böden mit schwer abbaubarer Streu (Nadelwälder).'::text
            WHEN humusform_wa_t.code::text = 'A'::text THEN 'Anmmor<br>Unvollständiger Streuabbau wegen häufigem Luftmangel. Der dunkle Horizont mit hohem Anteil an organischer Substanz ist strukturarm und schwach sauer bis alkalisch.'::text
            WHEN humusform_wa_t.code::text = 'T'::text THEN 'Torf<br>Anreicherung von kaum zersetzten Pflanzenrückständen, v.a. Torfmoose wegen dauerender Wassersättigung und stark sauren Bedingungen. Faserig, schwammig.'::text
            ELSE NULL::text
        END AS humusform_wa_qgis_txt,
    a.maechtigk_ahh,
    gefuegeform_t_ob.code AS gefuegeform_ob,
    gefuegeform_t_ob.beschreibung AS gefuegeform_ob_beschreibung,
        CASE
            WHEN gefuegeform_t_ob.code::text = 'Kr'::text OR gefuegeform_t_ob.code::text = 'Sp'::text AND gefueggr_t_ob.code::text = '2'::text THEN 1
            WHEN gefuegeform_t_ob.code::text = 'Sp'::text AND (gefueggr_t_ob.code::text = '3'::text OR gefueggr_t_ob.code::text = '4'::text) OR gefuegeform_t_ob.code::text = 'Br'::text AND (gefueggr_t_ob.code::text = '3'::text OR gefueggr_t_ob.code::text = '4'::text) OR gefuegeform_t_ob.code::text = 'Po'::text AND gefueggr_t_ob.code::text = '2'::text THEN 2
            WHEN gefuegeform_t_ob.code::text = 'Po'::text AND (gefueggr_t_ob.code::text = '3'::text OR gefueggr_t_ob.code::text = '4'::text) OR gefuegeform_t_ob.code::text = 'Fr'::text AND (gefueggr_t_ob.code::text = '2'::text OR gefueggr_t_ob.code::text = '3'::text) OR gefuegeform_t_ob.code::text = 'Sp'::text AND gefueggr_t_ob.code::text = '5'::text OR gefuegeform_t_ob.code::text = 'Klr'::text AND (gefueggr_t_ob.code::text = '4'::text OR gefueggr_t_ob.code::text = '3'::text OR gefueggr_t_ob.code::text = '5'::text) OR gefuegeform_t_ob.code::text = 'Br'::text AND (gefueggr_t_ob.code::text = '2'::text OR gefueggr_t_ob.code::text = '5'::text) THEN 3
            WHEN gefuegeform_t_ob.code::text = 'Po'::text AND (gefueggr_t_ob.code::text = '5'::text OR gefueggr_t_ob.code::text = '6'::text) OR gefuegeform_t_ob.code::text = 'Fr'::text AND (gefueggr_t_ob.code::text = '4'::text OR gefueggr_t_ob.code::text = '5'::text) OR gefuegeform_t_ob.code::text = 'Pr'::text AND (gefueggr_t_ob.code::text = '4'::text OR gefueggr_t_ob.code::text = '5'::text OR gefueggr_t_ob.code::text = '6'::text) OR gefuegeform_t_ob.code::text = 'Klr'::text AND (gefueggr_t_ob.code::text = '6'::text OR gefueggr_t_ob.code::text = '7'::text) OR gefuegeform_t_ob.code::text = 'Klk'::text AND (gefueggr_t_ob.code::text = '3'::text OR gefueggr_t_ob.code::text = '4'::text OR gefueggr_t_ob.code::text = '5'::text OR gefueggr_t_ob.code::text = '6'::text) OR gefuegeform_t_ob.code::text = 'Pl'::text AND (gefueggr_t_ob.code::text = '5'::text OR gefueggr_t_ob.code::text = '6'::text) THEN 4
            WHEN gefuegeform_t_ob.code::text = 'Ko'::text OR gefuegeform_t_ob.code::text = 'Ek'::text OR gefuegeform_t_ob.code::text = 'Gr'::text AND gefueggr_t_ob.code::text = '1'::text OR gefuegeform_t_ob.code::text = 'Po'::text AND gefueggr_t_ob.code::text = '7'::text OR gefuegeform_t_ob.code::text = 'Pr'::text AND gefueggr_t_ob.code::text = '7'::text OR gefuegeform_t_ob.code::text = 'Klk'::text AND gefueggr_t_ob.code::text = '7'::text OR gefuegeform_t_ob.code::text = 'Pl'::text AND gefueggr_t_ob.code::text = '7'::text THEN 5
            ELSE NULL::integer
        END AS gefuegeform_t_ob_qgis_int,
    gefuegeform_t_ub.code AS gefuegeform_ub,
    gefuegeform_t_ub.beschreibung AS gefuegeform_ub_beschreibung,
    gefueggr_t_ob.code AS gefueggr_ob,
    gefueggr_t_ob.beschreibung AS gefueggr_ob_beschreibung,
    gefueggr_t_ub.code AS gefueggr_ub,
    gefueggr_t_ub.beschreibung AS gefueggr_ub_beschreibung,
    a.pflngr,
        CASE
            WHEN a.pflngr = 0 OR a.pflngr IS NULL THEN
            CASE
                WHEN a.bodpktzahl > 0 AND a.bodpktzahl <= 49 THEN 1
                WHEN a.bodpktzahl >= 50 AND a.bodpktzahl <= 69 THEN 2
                WHEN a.bodpktzahl >= 70 AND a.bodpktzahl <= 79 THEN 3
                WHEN a.bodpktzahl >= 80 THEN 4
                ELSE NULL::integer
            END
            WHEN a.pflngr > 0 THEN
            CASE
                WHEN a.pflngr > 0 AND a.pflngr <= 29 THEN 1
                WHEN a.pflngr >= 30 AND a.pflngr <= 49 THEN 2
                WHEN a.pflngr >= 50 AND a.pflngr <= 69 THEN 3
                WHEN a.pflngr >= 70 THEN 4
                ELSE NULL::integer
            END
            ELSE NULL::integer
        END AS pflngr_qgis_int,
    a.bodpktzahl,
        CASE
            WHEN a.bodpktzahl >= 90 THEN 'Beste Bodeneigenschaften; Fruchtfolge ohne Einschränkungen'::text
            WHEN a.bodpktzahl >= 80 AND a.bodpktzahl < 90 THEN 'Sehr gute Fruchtfolgeböden; Hackfruchtanbau eingeschränkt'::text
            WHEN a.bodpktzahl >= 70 AND a.bodpktzahl < 80 THEN 'Gute Fruchtfolgeböden für getreidebetonte Fruchtfolge'::text
            WHEN a.bodpktzahl >= 50 AND a.bodpktzahl < 70 THEN 'Gute Futterbauböden; futterbaubetonte Fruchtfolge, Ackerbau stark eingeschränkt'::text
            WHEN a.bodpktzahl >= 35 AND a.bodpktzahl < 50 THEN 'Futterbaulich nutzbare Standorte'::text
            WHEN a.bodpktzahl >= 20 AND a.bodpktzahl < 35 THEN 'Extensive Bewirtschaftung angezeigt'::text
            WHEN a.bodpktzahl > 0 AND a.bodpktzahl < 20 THEN 'Für die landwirtschaftliche Nutzung ungeeignet'::text
            WHEN a.bodpktzahl = 0 THEN 'keine Information'::text
            WHEN a.bodpktzahl IS NULL THEN 'keine Information'::text
            ELSE NULL::text
        END AS bodpktzahl_qgis_txt,
    a.bemerkungen,
    be.los,
    be.kartierjahr,
    be.fk_kartierer AS kartierer,
    be.kartierquartal,
    be.is_wald,
    a.bindst_cd,
    a.bindst_zn,
    a.bindst_cu,
    a.bindst_pb,
    a.nfkapwe_ob,
    a.nfkapwe_ub,
    a.nfkapwe,
        CASE
            WHEN a.nfkapwe < 50::double precision THEN '< 50 mm'::text
            WHEN a.nfkapwe >= 50::double precision AND a.nfkapwe < 100::double precision THEN '50 - 100 mm'::text
            WHEN a.nfkapwe >= 100::double precision AND a.nfkapwe < 150::double precision THEN '100 - 150 mm'::text
            WHEN a.nfkapwe >= 150::double precision AND a.nfkapwe < 200::double precision THEN '150 - 200 mm'::text
            WHEN a.nfkapwe >= 200::double precision AND a.nfkapwe < 250::double precision THEN '200 - 250 mm'::text
            WHEN a.nfkapwe >= 250::double precision THEN '> 250 mm'::text
            ELSE NULL::text
        END AS nfkapwe_qgis_txt,
    a.verdempf,
    a.drain_wel,
    a.wassastoss,
    a.is_hauptauspraegung,
    a.gewichtung_auspraegung,
    be.wkb_geometry,
    be.archive
   FROM afu_isboden.bodeneinheit_t be
     LEFT JOIN afu_isboden.bodeneinheit_auspraegung_t a ON a.fk_bodeneinheit = be.pk_ogc_fid
     LEFT JOIN afu_isboden.wasserhhgr_t wasserhhgr_t ON wasserhhgr_t.pk_wasserhhgr = a.fk_wasserhhgr
     LEFT JOIN afu_isboden.bodentyp_t bodentyp_t ON bodentyp_t.pk_bodentyp = a.fk_bodentyp
     LEFT JOIN afu_isboden.begelfor_t begelfor_t ON begelfor_t.pk_begelfor = a.fk_begelfor
     LEFT JOIN afu_isboden.skelett_t skelett_t_ob ON skelett_t_ob.pk_skelett = a.fk_skelett_ob
     LEFT JOIN afu_isboden.skelett_t skelett_t_ub ON skelett_t_ub.pk_skelett = a.fk_skelett_ub
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ob ON koernkl_t_ob.pk_koernkl = a.fk_koernkl_ob
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ub ON koernkl_t_ub.pk_koernkl = a.fk_koernkl_ub
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ob ON kalkgehalt_t_ob.pk_kalkgehalt = a.fk_kalkgehalt_ob
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ub ON kalkgehalt_t_ub.pk_kalkgehalt = a.fk_kalkgehalt_ub
     LEFT JOIN afu_isboden.humusform_wa_t humusform_wa_t ON humusform_wa_t.pk_humusform_wa = a.fk_humusform_wa
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ob ON gefuegeform_t_ob.pk_gefuegeform = a.fk_gefuegeform_ob
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ub ON gefuegeform_t_ub.pk_gefuegeform = a.fk_gefuegeform_ub
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ob ON gefueggr_t_ob.pk_gefueggr = a.fk_gefueggr_ob
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ub ON gefueggr_t_ub.pk_gefueggr = a.fk_gefueggr_ub
     LEFT JOIN ( SELECT zw_bodeneinheit_untertyp_t.fk_bodeneinheit,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'E'::text) AS filter_array) AS untertyp_e,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'K'::text) AS filter_array) AS untertyp_k,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'I'::text) AS filter_array) AS untertyp_i,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'G'::text) AS filter_array) AS untertyp_g,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'R'::text) AS filter_array) AS untertyp_r,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'P'::text) AS filter_array) AS untertyp_p,
                CASE
                    WHEN regexp_replace(regexp_replace(regexp_replace(regexp_replace(array_agg(untertyp_t.code)::text, '({|})'::text, ''::text, 'g'::text), '(E|K|I|G|R|P).'::text, ''::text, 'g'::text), '( ,|^,)'::text, ''::text, 'g'::text), '( |^,)'::text, ''::text, 'g'::text) = ''::text THEN NULL::text
                    ELSE regexp_replace(regexp_replace(regexp_replace(regexp_replace(array_agg(untertyp_t.code)::text, '(E|K|I|G|R|P).(,|})'::text, ''::text, 'g'::text), '({|})'::text, ''::text, 'g'::text), '( ,|^,)'::text, ''::text, 'g'::text), '( |,$)'::text, ''::text, 'g'::text)
                END AS untertyp_div
           FROM afu_isboden.zw_bodeneinheit_untertyp zw_bodeneinheit_untertyp_t
             LEFT JOIN afu_isboden.untertyp_t untertyp_t ON untertyp_t.pk_untertyp = zw_bodeneinheit_untertyp_t.fk_untertyp
          GROUP BY zw_bodeneinheit_untertyp_t.fk_bodeneinheit) untertyp ON untertyp.fk_bodeneinheit = a.pk_bodeneinheit
  WHERE be.archive = 0 AND be.is_wald = false AND a.is_hauptauspraegung
  ORDER BY be.pk_ogc_fid, a.pk_bodeneinheit, be.gemnr, be.objnr, wasserhhgr_t.code, bodentyp_t.code, begelfor_t.code, a.geologie, untertyp.untertyp_e, untertyp.untertyp_k, untertyp.untertyp_i, untertyp.untertyp_g, untertyp.untertyp_r, untertyp.untertyp_p, untertyp.untertyp_div, skelett_t_ob.code, skelett_t_ub.code, koernkl_t_ob.code, koernkl_t_ub.code, a.ton_ob, a.ton_ub, a.schluff_ob, a.schluff_ub, a.karbgrenze, kalkgehalt_t_ob.code, kalkgehalt_t_ub.code, a.ph_ob, a.ph_ub, a.maechtigk_ah, a.humusgeh_ah, humusform_wa_t.code, a.maechtigk_ahh, gefuegeform_t_ob.code, gefuegeform_t_ub.code, gefueggr_t_ob.code, gefueggr_t_ub.code, a.pflngr, a.bodpktzahl, a.bemerkungen, be.los, be.kartierjahr, be.fk_kartierer, be.kartierquartal, be.is_wald, a.is_hauptauspraegung, be.wkb_geometry, be.archive;

COMMENT ON VIEW afu_isboden.bodeneinheit_lw_qgis_server_client_v IS 'View für QGIS-Server-Client';


-- afu_isboden.bodeneinheit_nebenauspraegung_simple_v source

CREATE OR REPLACE VIEW afu_isboden.bodeneinheit_nebenauspraegung_simple_v
AS SELECT a.pk_bodeneinheit,
    be.pk_ogc_fid,
    be.gemnr,
    be.gemnr_aktuell,
    be.objnr,
    wasserhhgr_t.code AS wasserhhgr,
    bodentyp_t.code AS bodentyp,
    begelfor_t.code AS gelform,
    a.geologie,
    untertyp.untertyp,
    skelett_t_ob.code AS skelett_ob,
    skelett_t_ub.code AS skelett_ub,
    koernkl_t_ob.code AS koernkl_ob,
    koernkl_t_ub.code AS koernkl_ub,
    a.ton_ob,
    a.ton_ub,
    a.schluff_ob,
    a.schluff_ub,
    a.karbgrenze,
    kalkgehalt_t_ob.code AS kalkgeh_ob,
    kalkgehalt_t_ub.code AS kalkgeh_ub,
    a.ph_ob,
    a.ph_ub,
    a.maechtigk_ah,
    a.humusgeh_ah,
    humusform_wa_t.code AS humusform_wa,
    a.maechtigk_ahh,
    gefuegeform_t_ob.code AS gefuegeform_ob,
    gefuegeform_t_ub.code AS gefuegeform_ub,
    gefueggr_t_ob.code AS gefueggr_ob,
    gefueggr_t_ub.code AS gefueggr_ub,
    a.pflngr,
    a.bodpktzahl,
    a.bemerkungen,
    be.los,
    be.kartierjahr,
    be.fk_kartierer AS kartierer,
    be.kartierquartal,
    be.is_wald,
    a.bindst_cd,
    a.bindst_zn,
    a.bindst_cu,
    a.bindst_pb,
    a.nfkapwe_ob,
    a.nfkapwe_ub,
    a.nfkapwe,
    a.verdempf,
    a.drain_wel,
    a.wassastoss,
    a.is_hauptauspraegung,
    be.wkb_geometry,
    be.archive
   FROM afu_isboden.bodeneinheit_t be
     LEFT JOIN afu_isboden.bodeneinheit_auspraegung_t a ON a.fk_bodeneinheit = be.pk_ogc_fid
     LEFT JOIN afu_isboden.wasserhhgr_t wasserhhgr_t ON wasserhhgr_t.pk_wasserhhgr = a.fk_wasserhhgr
     LEFT JOIN afu_isboden.bodentyp_t bodentyp_t ON bodentyp_t.pk_bodentyp = a.fk_bodentyp
     LEFT JOIN afu_isboden.begelfor_t begelfor_t ON begelfor_t.pk_begelfor = a.fk_begelfor
     LEFT JOIN afu_isboden.skelett_t skelett_t_ob ON skelett_t_ob.pk_skelett = a.fk_skelett_ob
     LEFT JOIN afu_isboden.skelett_t skelett_t_ub ON skelett_t_ub.pk_skelett = a.fk_skelett_ub
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ob ON koernkl_t_ob.pk_koernkl = a.fk_koernkl_ob
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ub ON koernkl_t_ub.pk_koernkl = a.fk_koernkl_ub
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ob ON kalkgehalt_t_ob.pk_kalkgehalt = a.fk_kalkgehalt_ob
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ub ON kalkgehalt_t_ub.pk_kalkgehalt = a.fk_kalkgehalt_ub
     LEFT JOIN afu_isboden.humusform_wa_t humusform_wa_t ON humusform_wa_t.pk_humusform_wa = a.fk_humusform_wa
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ob ON gefuegeform_t_ob.pk_gefuegeform = a.fk_gefuegeform_ob
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ub ON gefuegeform_t_ub.pk_gefuegeform = a.fk_gefuegeform_ub
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ob ON gefueggr_t_ob.pk_gefueggr = a.fk_gefueggr_ob
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ub ON gefueggr_t_ub.pk_gefueggr = a.fk_gefueggr_ub
     LEFT JOIN ( SELECT zw_bodeneinheit_untertyp_t.fk_bodeneinheit,
            array_agg(untertyp_t.code) AS untertyp,
            array_agg(untertyp_t.beschreibung) AS beschreibung,
            array_agg(untertyp_t.pk_untertyp) AS fk_untertyp
           FROM afu_isboden.zw_bodeneinheit_untertyp zw_bodeneinheit_untertyp_t
             LEFT JOIN afu_isboden.untertyp_t untertyp_t ON untertyp_t.pk_untertyp = zw_bodeneinheit_untertyp_t.fk_untertyp
          GROUP BY zw_bodeneinheit_untertyp_t.fk_bodeneinheit) untertyp ON untertyp.fk_bodeneinheit = a.pk_bodeneinheit
  WHERE NOT a.is_hauptauspraegung
  ORDER BY be.pk_ogc_fid;

COMMENT ON VIEW afu_isboden.bodeneinheit_nebenauspraegung_simple_v IS 'Vereinfachte View für Verifikationen';


-- afu_isboden.bodeneinheit_nebenauspraegung_v source

CREATE OR REPLACE VIEW afu_isboden.bodeneinheit_nebenauspraegung_v
AS SELECT a.pk_bodeneinheit,
    be.pk_ogc_fid,
    be.gemnr,
    be.gemnr_aktuell,
    be.objnr,
    be.is_wald,
    be.label_x,
    be.label_y,
    st_area(be.wkb_geometry) AS area,
    be.kuerzel,
    be.los,
    be.kartierjahr,
    be.fk_kartierer AS kartierer,
    be.kartierquartal,
    a.is_hauptauspraegung,
    a.gewichtung_auspraegung,
    a.geologie,
    untertyp.untertyp,
    untertyp.beschreibung AS untertyp_beschreibung,
    untertyp.fk_untertyp,
    wasserhhgr_t.code AS wasserhhgr,
    wasserhhgr_t.beschreibung AS wasserhhgr_beschreibung,
    wasserhhgr_t.pk_wasserhhgr AS fk_wasserhhgr,
    bodentyp_t.code AS bodentyp,
    bodentyp_t.beschreibung AS bodentyp_beschreibung,
    bodentyp_t.pk_bodentyp AS fk_bodentyp,
    begelfor_t.code AS begelfor,
    begelfor_t.beschreibung AS begelfor_beschreibung,
    begelfor_t.pk_begelfor AS fk_begelfor,
    skelett_t_ob.code AS skelett_ob,
    skelett_t_ob.beschreibung AS skelett_ob_beschreibung,
    skelett_t_ob.pk_skelett AS fk_skelett_ob,
    skelett_t_ub.code AS skelett_ub,
    skelett_t_ub.beschreibung AS skelett_ub_beschreibung,
    skelett_t_ub.pk_skelett AS fk_skelett_ub,
    koernkl_t_ob.code AS koernkl_ob,
    koernkl_t_ob.beschreibung AS koernkl_ob_beschreibung,
    koernkl_t_ob.pk_koernkl AS fk_koernkl_ob,
    koernkl_t_ub.code AS koernkl_ub,
    koernkl_t_ub.beschreibung AS koernkl_ub_beschreibung,
    koernkl_t_ub.pk_koernkl AS fk_koernkl_ub,
    a.ton_ob,
    a.ton_ub,
    a.schluff_ob,
    a.schluff_ub,
    a.karbgrenze,
    kalkgehalt_t_ob.code AS kalkgeh_ob,
    kalkgehalt_t_ob.beschreibung AS kalkgeh_ob_beschreibung,
    kalkgehalt_t_ob.pk_kalkgehalt AS fk_kalkgehalt_ob,
    kalkgehalt_t_ub.code AS kalkgeh_ub,
    kalkgehalt_t_ub.beschreibung AS kalkgeh_ub_beschreibung,
    kalkgehalt_t_ub.pk_kalkgehalt AS fk_kalkgehalt_ub,
    a.ph_ob,
    a.ph_ub,
    a.maechtigk_ah,
    a.humusgeh_ah,
    humusform_wa_t.code AS humusform_wa,
    humusform_wa_t.beschreibung AS humusform_wa_beschreibung,
    humusform_wa_t.pk_humusform_wa AS fk_humusform_wa,
    gefuegeform_t_ob.code AS gefuegeform_ob,
    gefuegeform_t_ob.beschreibung AS gefuegeform_ob_beschreibung,
    gefuegeform_t_ob.pk_gefuegeform AS fk_gefuegeform_ob,
    gefuegeform_t_ub.code AS gefuegeform_ub,
    gefuegeform_t_ub.beschreibung AS gefuegeform_ub_beschreibung,
    gefuegeform_t_ub.pk_gefuegeform AS fk_gefuegeform_ub,
    gefueggr_t_ob.code AS gefueggr_ob,
    gefueggr_t_ob.beschreibung AS gefueggr_ob_beschreibung,
    gefueggr_t_ob.pk_gefueggr AS fk_gefueggr_ob,
    gefueggr_t_ub.code AS gefueggr_ub,
    gefueggr_t_ub.beschreibung AS gefueggr_ub_beschreibung,
    gefueggr_t_ub.pk_gefueggr AS fk_gefueggr_ub,
    a.bemerkungen,
    a.bodpktzahl,
    a.pflngr,
    a.maechtigk_ahh,
    a.bindst_cd,
    a.bindst_zn,
    a.bindst_cu,
    a.bindst_pb,
    a.nfkapwe_ob,
    a.nfkapwe_ub,
    a.nfkapwe,
    a.verdempf,
    a.drain_wel,
    a.wassastoss,
    be.wkb_geometry,
    be.archive
   FROM afu_isboden.bodeneinheit_t be
     LEFT JOIN afu_isboden.bodeneinheit_auspraegung_t a ON a.fk_bodeneinheit = be.pk_ogc_fid
     LEFT JOIN afu_isboden.wasserhhgr_t wasserhhgr_t ON wasserhhgr_t.pk_wasserhhgr = a.fk_wasserhhgr
     LEFT JOIN afu_isboden.bodentyp_t bodentyp_t ON bodentyp_t.pk_bodentyp = a.fk_bodentyp
     LEFT JOIN afu_isboden.begelfor_t begelfor_t ON begelfor_t.pk_begelfor = a.fk_begelfor
     LEFT JOIN afu_isboden.skelett_t skelett_t_ob ON skelett_t_ob.pk_skelett = a.fk_skelett_ob
     LEFT JOIN afu_isboden.skelett_t skelett_t_ub ON skelett_t_ub.pk_skelett = a.fk_skelett_ub
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ob ON koernkl_t_ob.pk_koernkl = a.fk_koernkl_ob
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ub ON koernkl_t_ub.pk_koernkl = a.fk_koernkl_ub
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ob ON kalkgehalt_t_ob.pk_kalkgehalt = a.fk_kalkgehalt_ob
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ub ON kalkgehalt_t_ub.pk_kalkgehalt = a.fk_kalkgehalt_ub
     LEFT JOIN afu_isboden.humusform_wa_t humusform_wa_t ON humusform_wa_t.pk_humusform_wa = a.fk_humusform_wa
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ob ON gefuegeform_t_ob.pk_gefuegeform = a.fk_gefuegeform_ob
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ub ON gefuegeform_t_ub.pk_gefuegeform = a.fk_gefuegeform_ub
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ob ON gefueggr_t_ob.pk_gefueggr = a.fk_gefueggr_ob
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ub ON gefueggr_t_ub.pk_gefueggr = a.fk_gefueggr_ub
     LEFT JOIN ( SELECT zw_bodeneinheit_untertyp_t.fk_bodeneinheit,
            array_agg(untertyp_t.code) AS untertyp,
            array_agg(untertyp_t.beschreibung) AS beschreibung,
            array_agg(untertyp_t.pk_untertyp) AS fk_untertyp
           FROM afu_isboden.zw_bodeneinheit_untertyp zw_bodeneinheit_untertyp_t
             LEFT JOIN afu_isboden.untertyp_t untertyp_t ON untertyp_t.pk_untertyp = zw_bodeneinheit_untertyp_t.fk_untertyp
          GROUP BY zw_bodeneinheit_untertyp_t.fk_bodeneinheit) untertyp ON untertyp.fk_bodeneinheit = a.pk_bodeneinheit
  WHERE NOT a.is_hauptauspraegung
  ORDER BY be.pk_ogc_fid;

COMMENT ON VIEW afu_isboden.bodeneinheit_nebenauspraegung_v IS 'Diese View wird vom IS-Boden Plugin verwendet.';


-- afu_isboden.bodeneinheit_onlinedata_v source

CREATE OR REPLACE VIEW afu_isboden.bodeneinheit_onlinedata_v
AS SELECT a.pk_bodeneinheit AS pk_isboden,
    be.gemnr,
    be.objnr,
    wasserhhgr_t.code AS wasserhhgr,
    bodentyp_t.code AS bodentyp,
    begelfor_t.code AS gelform,
    a.geologie,
    untertyp.untertyp_e AS ut_e,
    untertyp.untertyp_k AS ut_k,
    untertyp.untertyp_i AS ut_i,
    untertyp.untertyp_g AS ut_g,
    untertyp.untertyp_r AS ut_r,
    untertyp.untertyp_p AS ut_p,
    untertyp.untertyp_div AS ut_div,
    skelett_t_ob.code AS skelett_ob,
    skelett_t_ub.code AS skelett_ub,
    koernkl_t_ob.code AS koernkl_ob,
    koernkl_t_ub.code AS koernkl_ub,
    a.ton_ob,
    a.ton_ub,
    a.schluff_ob,
    a.schluff_ub,
    a.karbgrenze,
    kalkgehalt_t_ob.code AS kalkgeh_ob,
    kalkgehalt_t_ub.code AS kalkgeh_ub,
    a.ph_ob,
    a.ph_ub,
    a.maechtigk_ah AS maecht_ah,
    a.humusgeh_ah AS humus_ah,
    humusform_wa_t.code AS hmform_wa,
    a.maechtigk_ahh AS maecht_ahh,
    gefuegeform_t_ob.code AS gefform_ob,
    gefuegeform_t_ub.code AS gefform_ub,
    gefueggr_t_ob.code AS gefgr_ob,
    gefueggr_t_ub.code AS gefgr_ub,
    a.pflngr,
    a.bodpktzahl,
    a.bemerkungen AS bemerkung,
    be.los,
    be.kartierjahr AS kjahr,
    be.is_wald,
    a.bindst_cd,
    a.bindst_zn,
    a.bindst_cu,
    a.bindst_pb,
    round(a.nfkapwe_ob::numeric, 2)::double precision AS nfkapwe_ob,
    round(a.nfkapwe_ub::numeric, 2)::double precision AS nfkapwe_ub,
    round(a.nfkapwe::numeric, 2)::double precision AS nfkapwe,
    a.verdempf,
    a.is_hauptauspraegung AS is_haupt,
    a.gewichtung_auspraegung AS gewichtung,
    be.wkb_geometry AS geom,
    be.archive,
    be.new_date,
    be.archive_date
   FROM afu_isboden.bodeneinheit_t be
     LEFT JOIN afu_isboden.bodeneinheit_auspraegung_t a ON a.fk_bodeneinheit = be.pk_ogc_fid
     LEFT JOIN afu_isboden.kartiererin_v kartiererin_v ON kartiererin_v.pk_kartiererin = be.fk_kartierer
     LEFT JOIN afu_isboden.wasserhhgr_t wasserhhgr_t ON wasserhhgr_t.pk_wasserhhgr = a.fk_wasserhhgr
     LEFT JOIN afu_isboden.bodentyp_t bodentyp_t ON bodentyp_t.pk_bodentyp = a.fk_bodentyp
     LEFT JOIN afu_isboden.begelfor_t begelfor_t ON begelfor_t.pk_begelfor = a.fk_begelfor
     LEFT JOIN afu_isboden.skelett_t skelett_t_ob ON skelett_t_ob.pk_skelett = a.fk_skelett_ob
     LEFT JOIN afu_isboden.skelett_t skelett_t_ub ON skelett_t_ub.pk_skelett = a.fk_skelett_ub
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ob ON koernkl_t_ob.pk_koernkl = a.fk_koernkl_ob
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ub ON koernkl_t_ub.pk_koernkl = a.fk_koernkl_ub
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ob ON kalkgehalt_t_ob.pk_kalkgehalt = a.fk_kalkgehalt_ob
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ub ON kalkgehalt_t_ub.pk_kalkgehalt = a.fk_kalkgehalt_ub
     LEFT JOIN afu_isboden.humusform_wa_t humusform_wa_t ON humusform_wa_t.pk_humusform_wa = a.fk_humusform_wa
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ob ON gefuegeform_t_ob.pk_gefuegeform = a.fk_gefuegeform_ob
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ub ON gefuegeform_t_ub.pk_gefuegeform = a.fk_gefuegeform_ub
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ob ON gefueggr_t_ob.pk_gefueggr = a.fk_gefueggr_ob
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ub ON gefueggr_t_ub.pk_gefueggr = a.fk_gefueggr_ub
     LEFT JOIN ( SELECT zw_bodeneinheit_untertyp_t.fk_bodeneinheit,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'E'::text) AS filter_array) AS untertyp_e,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'K'::text) AS filter_array) AS untertyp_k,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'I'::text) AS filter_array) AS untertyp_i,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'G'::text) AS filter_array) AS untertyp_g,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'R'::text) AS filter_array) AS untertyp_r,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'P'::text) AS filter_array) AS untertyp_p,
                CASE
                    WHEN regexp_replace(regexp_replace(regexp_replace(regexp_replace(array_agg(untertyp_t.code)::text, '({|})'::text, ''::text, 'g'::text), '(E|K|I|G|R|P).'::text, ''::text, 'g'::text), '( ,|^,|,)'::text, ''::text, 'g'::text), '( |^,)'::text, ''::text, 'g'::text) = ''::text THEN NULL::text
                    ELSE regexp_replace(regexp_replace(regexp_replace(regexp_replace(array_agg(untertyp_t.code)::text, '(E|K|I|G|R|P).(,|})'::text, ''::text, 'g'::text), '({|})'::text, ''::text, 'g'::text), '( ,|^,)'::text, ''::text, 'g'::text), '( |,$)'::text, ''::text, 'g'::text)
                END AS untertyp_div
           FROM afu_isboden.zw_bodeneinheit_untertyp zw_bodeneinheit_untertyp_t
             LEFT JOIN afu_isboden.untertyp_t untertyp_t ON untertyp_t.pk_untertyp = zw_bodeneinheit_untertyp_t.fk_untertyp
          GROUP BY zw_bodeneinheit_untertyp_t.fk_bodeneinheit) untertyp ON untertyp.fk_bodeneinheit = a.pk_bodeneinheit
  WHERE be.archive >= 0
  ORDER BY be.pk_ogc_fid, a.pk_bodeneinheit, be.gemnr, be.objnr, wasserhhgr_t.code, bodentyp_t.code, begelfor_t.code, a.geologie, untertyp.untertyp_e, untertyp.untertyp_k, untertyp.untertyp_i, untertyp.untertyp_g, untertyp.untertyp_r, untertyp.untertyp_p, untertyp.untertyp_div, skelett_t_ob.code, skelett_t_ub.code, koernkl_t_ob.code, koernkl_t_ub.code, a.ton_ob, a.ton_ub, a.schluff_ob, a.schluff_ub, a.karbgrenze, kalkgehalt_t_ob.code, kalkgehalt_t_ub.code, a.ph_ob, a.ph_ub, a.maechtigk_ah, a.humusgeh_ah, humusform_wa_t.code, a.maechtigk_ahh, gefuegeform_t_ob.code, gefuegeform_t_ub.code, gefueggr_t_ob.code, gefueggr_t_ub.code, a.pflngr, a.bodpktzahl, a.bemerkungen, be.los, be.kartierjahr, be.fk_kartierer, be.kartierquartal, be.is_wald, a.is_hauptauspraegung, be.wkb_geometry, be.archive;


-- afu_isboden.bodeneinheit_plaus_tmp source

CREATE OR REPLACE VIEW afu_isboden.bodeneinheit_plaus_tmp
AS SELECT a.pk_bodeneinheit,
    be.pk_ogc_fid,
    be.gemnr,
    be.objnr,
    wasserhhgr_t.code AS wasserhhgr,
    bodentyp_t.code AS bodentyp,
    begelfor_t.code AS gelform,
    a.geologie,
    untertyp.untertyp_e,
    untertyp.untertyp_k,
    untertyp.untertyp_i,
    untertyp.untertyp_g,
    untertyp.untertyp_r,
    untertyp.untertyp_l,
    untertyp.untertyp_m,
    untertyp.untertyp_o,
    untertyp.untertyp_h,
    skelett_t_ob.code AS skelett_ob,
    skelett_t_ub.code AS skelett_ub,
    koernkl_t_ob.code AS koernkl_ob,
    koernkl_t_ub.code AS koernkl_ub,
    a.ton_ob,
    a.ton_ub,
    a.schluff_ob,
    a.schluff_ub,
    a.karbgrenze,
    kalkgehalt_t_ob.code AS kalkgeh_ob,
    kalkgehalt_t_ub.code AS kalkgeh_ub,
    a.ph_ob,
    a.ph_ub,
    a.maechtigk_ah,
    a.humusgeh_ah,
    humusform_wa_t.code AS humusform_wa,
    a.maechtigk_ahh,
    gefuegeform_t_ob.code AS gefuegeform_ob,
    gefuegeform_t_ub.code AS gefuegeform_ub,
    gefueggr_t_ob.code AS gefueggr_ob,
    gefueggr_t_ub.code AS gefueggr_ub,
    a.pflngr,
    a.bodpktzahl,
    a.bemerkungen,
    be.los,
    be.kartierjahr,
    be.fk_kartierer AS kartierer,
    be.kartierquartal,
    be.is_wald,
    a.bindst_cd,
    a.bindst_zn,
    a.bindst_cu,
    a.bindst_pb,
    a.nfkapwe_ob,
    a.nfkapwe_ub,
    a.nfkapwe,
    a.verdempf,
    a.drain_wel,
    a.wassastoss,
    a.is_hauptauspraegung,
    be.wkb_geometry,
    be.archive
   FROM afu_isboden.bodeneinheit_t be
     LEFT JOIN afu_isboden.bodeneinheit_auspraegung_t a ON a.fk_bodeneinheit = be.pk_ogc_fid
     LEFT JOIN afu_isboden.wasserhhgr_t wasserhhgr_t ON wasserhhgr_t.pk_wasserhhgr = a.fk_wasserhhgr
     LEFT JOIN afu_isboden.bodentyp_t bodentyp_t ON bodentyp_t.pk_bodentyp = a.fk_bodentyp
     LEFT JOIN afu_isboden.begelfor_t begelfor_t ON begelfor_t.pk_begelfor = a.fk_begelfor
     LEFT JOIN afu_isboden.skelett_t skelett_t_ob ON skelett_t_ob.pk_skelett = a.fk_skelett_ob
     LEFT JOIN afu_isboden.skelett_t skelett_t_ub ON skelett_t_ub.pk_skelett = a.fk_skelett_ub
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ob ON koernkl_t_ob.pk_koernkl = a.fk_koernkl_ob
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ub ON koernkl_t_ub.pk_koernkl = a.fk_koernkl_ub
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ob ON kalkgehalt_t_ob.pk_kalkgehalt = a.fk_kalkgehalt_ob
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ub ON kalkgehalt_t_ub.pk_kalkgehalt = a.fk_kalkgehalt_ub
     LEFT JOIN afu_isboden.humusform_wa_t humusform_wa_t ON humusform_wa_t.pk_humusform_wa = a.fk_humusform_wa
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ob ON gefuegeform_t_ob.pk_gefuegeform = a.fk_gefuegeform_ob
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ub ON gefuegeform_t_ub.pk_gefuegeform = a.fk_gefuegeform_ub
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ob ON gefueggr_t_ob.pk_gefueggr = a.fk_gefueggr_ob
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ub ON gefueggr_t_ub.pk_gefueggr = a.fk_gefueggr_ub
     LEFT JOIN ( SELECT zw_bodeneinheit_untertyp_t.fk_bodeneinheit,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'E'::text) AS filter_array) AS untertyp_e,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'K'::text) AS filter_array) AS untertyp_k,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'I'::text) AS filter_array) AS untertyp_i,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'G'::text) AS filter_array) AS untertyp_g,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'R'::text) AS filter_array) AS untertyp_r,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'L'::text) AS filter_array) AS untertyp_l,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'M'::text) AS filter_array) AS untertyp_m,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'O'::text) AS filter_array) AS untertyp_o,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'H'::text) AS filter_array) AS untertyp_h
           FROM afu_isboden.zw_bodeneinheit_untertyp zw_bodeneinheit_untertyp_t
             LEFT JOIN afu_isboden.untertyp_t untertyp_t ON untertyp_t.pk_untertyp = zw_bodeneinheit_untertyp_t.fk_untertyp
          GROUP BY zw_bodeneinheit_untertyp_t.fk_bodeneinheit) untertyp ON untertyp.fk_bodeneinheit = a.pk_bodeneinheit
  WHERE a.archive = 0
  ORDER BY be.pk_ogc_fid, a.pk_bodeneinheit, be.gemnr, be.objnr, wasserhhgr_t.code, bodentyp_t.code, begelfor_t.code, a.geologie, untertyp.untertyp_e, untertyp.untertyp_k, untertyp.untertyp_i, untertyp.untertyp_g, untertyp.untertyp_r, untertyp.untertyp_l, untertyp.untertyp_m, untertyp.untertyp_o, untertyp.untertyp_h, skelett_t_ob.code, skelett_t_ub.code, koernkl_t_ob.code, koernkl_t_ub.code, a.ton_ob, a.ton_ub, a.schluff_ob, a.schluff_ub, a.karbgrenze, kalkgehalt_t_ob.code, kalkgehalt_t_ub.code, a.ph_ob, a.ph_ub, a.maechtigk_ah, a.humusgeh_ah, humusform_wa_t.code, a.maechtigk_ahh, gefuegeform_t_ob.code, gefuegeform_t_ub.code, gefueggr_t_ob.code, gefueggr_t_ub.code, a.pflngr, a.bodpktzahl, a.bemerkungen, be.los, be.kartierjahr, be.fk_kartierer, be.kartierquartal, be.is_wald, a.is_hauptauspraegung, be.wkb_geometry, be.archive;


-- afu_isboden.bodeneinheit_wald_qgis_server_client_v source

CREATE OR REPLACE VIEW afu_isboden.bodeneinheit_wald_qgis_server_client_v
AS SELECT be.pk_ogc_fid,
    be.gemnr,
    be.objnr,
    wasserhhgr_t.code AS wasserhhgr,
    wasserhhgr_t.beschreibung AS wasserhhgr_beschreibung,
        CASE
            WHEN wasserhhgr_t.code::text = 'a'::text OR wasserhhgr_t.code::text = 'b'::text OR wasserhhgr_t.code::text = 'c'::text OR wasserhhgr_t.code::text = 'd'::text OR wasserhhgr_t.code::text = 'e'::text THEN 'Kein Einfluss von Stau- oder Grundwasser'::text::character varying
            WHEN wasserhhgr_t.code::text = 'f'::text OR wasserhhgr_t.code::text = 'g'::text OR wasserhhgr_t.code::text = 'h'::text OR wasserhhgr_t.code::text = 'i'::text THEN 'Leichter Einfluss von Stauwasser'::text::character varying
            WHEN wasserhhgr_t.code::text = 'k'::text OR wasserhhgr_t.code::text = 'l'::text OR wasserhhgr_t.code::text = 'm'::text OR wasserhhgr_t.code::text = 'n'::text THEN 'Leichter Einfluss von Grund- oder Hangwasser'::text::character varying
            WHEN wasserhhgr_t.code::text = 'o'::text AND a.pflngr >= 70 OR wasserhhgr_t.code::text = 'o'::text AND a.pflngr < 70 OR wasserhhgr_t.code::text = 'p'::text AND a.pflngr >= 30 OR wasserhhgr_t.code::text = 'p'::text AND a.pflngr < 30 OR wasserhhgr_t.code::text = 'q'::text OR wasserhhgr_t.code::text = 'r'::text THEN 'Starker Einfluss von Stauwasser.<br>Falls nicht drainiert, stellenweise dauernd vernässt'::text::character varying
            WHEN wasserhhgr_t.code::text = 's'::text OR wasserhhgr_t.code::text = 't'::text OR wasserhhgr_t.code::text = 'u'::text AND a.pflngr >= 30 OR wasserhhgr_t.code::text = 'u'::text AND a.pflngr < 30 OR wasserhhgr_t.code::text = 'v'::text OR wasserhhgr_t.code::text = 'x'::text OR wasserhhgr_t.code::text = 'y'::text OR wasserhhgr_t.code::text = 'z'::text OR wasserhhgr_t.code::text = 'w'::text AND a.pflngr >= 30 OR wasserhhgr_t.code::text = 'w'::text AND a.pflngr < 30 THEN 'Starker Einfluss von Grund- oder Hangwasser.<br>Falls nicht drainiert, stellenweise dauernd vernässt'::text::character varying
            ELSE NULL::character varying
        END AS wasserhhgr_qgis_txt,
    bodentyp_t.code AS bodentyp,
    bodentyp_t.beschreibung AS bodentyp_beschreibung,
    begelfor_t.code AS gelform,
    begelfor_t.beschreibung AS gelform_beschreibung,
    a.geologie,
    untertyp.untertyp_e,
    untertyp.untertyp_k,
    untertyp.untertyp_i,
    untertyp.untertyp_g,
    untertyp.untertyp_r,
    untertyp.untertyp_p,
    untertyp.untertyp_div,
    skelett_t_ob.code AS skelett_ob,
    skelett_t_ob.beschreibung AS skelett_ob_beschreibung,
    skelett_t_ub.code AS skelett_ub,
    skelett_t_ub.beschreibung AS skelett_ub_beschreibung,
    koernkl_t_ob.code AS koernkl_ob,
    koernkl_t_ob.beschreibung AS koernkl_ob_beschreibung,
    koernkl_t_ub.code AS koernkl_ub,
    koernkl_t_ub.beschreibung AS koernkl_ub_beschreibung,
    a.ton_ob,
    a.ton_ub,
    a.schluff_ob,
    a.schluff_ub,
    a.karbgrenze,
    kalkgehalt_t_ob.code AS kalkgeh_ob,
    kalkgehalt_t_ob.beschreibung AS kalkgeh_ob_beschreibung,
    kalkgehalt_t_ub.code AS kalkgeh_ub,
    kalkgehalt_t_ub.beschreibung AS kalkgeh_ub_beschreibung,
    a.ph_ob,
        CASE
            WHEN a.ph_ob > 0::double precision AND a.ph_ob < 3.3::double precision THEN 'sehr stark sauer'::text
            WHEN a.ph_ob >= 3.3::double precision AND a.ph_ob < 4.3::double precision THEN 'stark sauer'::text
            WHEN a.ph_ob >= 4.3::double precision AND a.ph_ob < 5.1::double precision THEN 'sauer'::text
            WHEN a.ph_ob >= 5.1::double precision AND a.ph_ob < 6.2::double precision THEN 'schwach sauer'::text
            WHEN a.ph_ob >= 6.2::double precision AND a.ph_ob < 6.8::double precision THEN 'neutral'::text
            WHEN a.ph_ob >= 6.8::double precision THEN 'alkalisch'::text
            ELSE NULL::text
        END AS ph_ob_qgis_txt,
    a.ph_ub,
        CASE
            WHEN a.ph_ub > 0::double precision AND a.ph_ub < 3.3::double precision THEN 'sehr stark sauer'::text
            WHEN a.ph_ub >= 3.3::double precision AND a.ph_ub < 4.3::double precision THEN 'stark sauer'::text
            WHEN a.ph_ub >= 4.3::double precision AND a.ph_ub < 5.1::double precision THEN 'sauer'::text
            WHEN a.ph_ub >= 5.1::double precision AND a.ph_ub < 6.2::double precision THEN 'schwach sauer'::text
            WHEN a.ph_ub >= 6.2::double precision AND a.ph_ub < 6.8::double precision THEN 'neutral'::text
            WHEN a.ph_ub >= 6.8::double precision THEN 'alkalisch'::text
            ELSE NULL::text
        END AS ph_ub_qgis_txt,
    a.maechtigk_ah,
    a.humusgeh_ah,
        CASE
            WHEN a.humusgeh_ah > 0::double precision AND a.humusgeh_ah < 2::double precision THEN '< 2.0%: humusarm'::text
            WHEN a.humusgeh_ah >= 2::double precision AND a.humusgeh_ah < 5::double precision THEN '2.0 - 4.9%: schwach humos'::text
            WHEN a.humusgeh_ah >= 5::double precision AND a.humusgeh_ah < 10::double precision THEN '5.0 - 9.9%: humos '::text
            WHEN a.humusgeh_ah >= 10::double precision AND a.humusgeh_ah < 20::double precision THEN '10.0 - 19.9%: humusreich'::text
            WHEN a.humusgeh_ah >= 20::double precision AND a.humusgeh_ah < 30::double precision THEN '20.0 - 29.9%: sehr humusreich'::text
            WHEN a.humusgeh_ah >= 30::double precision THEN '>= 30.0%: organisch'::text
            ELSE NULL::text
        END AS humusgeh_ah_qgis_txt,
    humusform_wa_t.code AS humusform_wa,
    humusform_wa_t.beschreibung AS humusform_wa_beschreibung,
        CASE
            WHEN humusform_wa_t.code::text = 'M'::text OR humusform_wa_t.code::text = 'Mt'::text OR humusform_wa_t.code::text = 'Mf'::text THEN 'Mull<br>Hohe biologische Aktivität mit vollständigem Streuabbau nach 1-2 Jahren. Über 8 cm mächtiger, gut strukturierter Oberboden. Günstiger Wasser-, Luft- und Nährstoffhaushalt.'::text
            WHEN humusform_wa_t.code::text = 'Fm'::text OR humusform_wa_t.code::text = 'Fa'::text OR humusform_wa_t.code::text = 'Fr'::text OR humusform_wa_t.code::text = 'Fl'::text THEN 'Moder<br>Wegen Säuregrad reduzierte biologische Aktivität. Verlangsamter, unvollständiger Streuabbau, daher organische Auflage.4-8 cm mächtiger Oberboden. Saure, nährstoffarme Böden in krautarmen Laub- und Nadelwäldern.'::text
            WHEN humusform_wa_t.code::text = 'L'::text OR humusform_wa_t.code::text = 'La'::text OR humusform_wa_t.code::text = 'Lr'::text THEN 'Rohhumus<br>Geringe biologische Aktivität. Gehemmter Streuabbau mit ausgeprägten Auflagehorizonten und geringmächtigem Oberboden. Stark saure, nährstoffarme Böden mit schwer abbaubarer Streu (Nadelwälder)..'::text
            WHEN humusform_wa_t.code::text = 'MHt'::text OR humusform_wa_t.code::text = 'MHf'::text THEN 'Feuchtmull<br>Hohe biologische Aktivität mit vollständigem Streuabbau nach 1-2 Jahren. Über 8 cm mächtiger, gut strukturierter Oberboden. Trotz schwach vernässtem Boden günstiger Wasser-, Luft- und Nährstoffhaushalt.'::text
            WHEN humusform_wa_t.code::text = 'FHm'::text OR humusform_wa_t.code::text = 'FHa'::text OR humusform_wa_t.code::text = 'FHr'::text OR humusform_wa_t.code::text = 'FHl'::text THEN 'Feuchtmoder<br>Wegen Vernässung reduzierte biologische Aktivität. Verlangsamter, unvollständiger Streuabbau, daher organische Auflage.4-8 cm mächtiger Oberboden.Vernässte, z.T. saure, nährstoffarme Bödern.'::text
            WHEN humusform_wa_t.code::text = 'Lha'::text OR humusform_wa_t.code::text = 'LHr'::text THEN 'Feuchtrohhumus<br>Geringe biologische Aktivität. Gehemmter Streuabbau mit ausgeprägten Auflagehorizonten und geringmächtigem Oberboden.Vernässte, stark saure, nährstoffarme Böden mit schwer abbaubarer Streu (Nadelwälder).'::text
            WHEN humusform_wa_t.code::text = 'A'::text THEN 'Anmmor<br>Unvollständiger Streuabbau wegen häufigem Luftmangel. Der dunkle Horizont mit hohem Anteil an organischer Substanz ist strukturarm und schwach sauer bis alkalisch.'::text
            WHEN humusform_wa_t.code::text = 'T'::text THEN 'Torf<br>Anreicherung von kaum zersetzten Pflanzenrückständen, v.a. Torfmoose wegen dauerender Wassersättigung und stark sauren Bedingungen. Faserig, schwammig.'::text
            ELSE NULL::text
        END AS humusform_wa_qgis_txt,
    a.maechtigk_ahh,
    gefuegeform_t_ob.code AS gefuegeform_ob,
    gefuegeform_t_ob.beschreibung AS gefuegeform_ob_beschreibung,
        CASE
            WHEN gefuegeform_t_ob.code::text = 'Kr'::text OR gefuegeform_t_ob.code::text = 'Sp'::text AND gefueggr_t_ob.code::text = '2'::text THEN 1
            WHEN gefuegeform_t_ob.code::text = 'Sp'::text AND (gefueggr_t_ob.code::text = '3'::text OR gefueggr_t_ob.code::text = '4'::text) OR gefuegeform_t_ob.code::text = 'Br'::text AND (gefueggr_t_ob.code::text = '3'::text OR gefueggr_t_ob.code::text = '4'::text) OR gefuegeform_t_ob.code::text = 'Po'::text AND gefueggr_t_ob.code::text = '2'::text THEN 2
            WHEN gefuegeform_t_ob.code::text = 'Po'::text AND (gefueggr_t_ob.code::text = '3'::text OR gefueggr_t_ob.code::text = '4'::text) OR gefuegeform_t_ob.code::text = 'Fr'::text AND (gefueggr_t_ob.code::text = '2'::text OR gefueggr_t_ob.code::text = '3'::text) OR gefuegeform_t_ob.code::text = 'Sp'::text AND gefueggr_t_ob.code::text = '5'::text OR gefuegeform_t_ob.code::text = 'Klr'::text AND (gefueggr_t_ob.code::text = '4'::text OR gefueggr_t_ob.code::text = '3'::text OR gefueggr_t_ob.code::text = '5'::text) OR gefuegeform_t_ob.code::text = 'Br'::text AND (gefueggr_t_ob.code::text = '2'::text OR gefueggr_t_ob.code::text = '5'::text) THEN 3
            WHEN gefuegeform_t_ob.code::text = 'Po'::text AND (gefueggr_t_ob.code::text = '5'::text OR gefueggr_t_ob.code::text = '6'::text) OR gefuegeform_t_ob.code::text = 'Fr'::text AND (gefueggr_t_ob.code::text = '4'::text OR gefueggr_t_ob.code::text = '5'::text) OR gefuegeform_t_ob.code::text = 'Pr'::text AND (gefueggr_t_ob.code::text = '4'::text OR gefueggr_t_ob.code::text = '5'::text OR gefueggr_t_ob.code::text = '6'::text) OR gefuegeform_t_ob.code::text = 'Klr'::text AND (gefueggr_t_ob.code::text = '6'::text OR gefueggr_t_ob.code::text = '7'::text) OR gefuegeform_t_ob.code::text = 'Klk'::text AND (gefueggr_t_ob.code::text = '3'::text OR gefueggr_t_ob.code::text = '4'::text OR gefueggr_t_ob.code::text = '5'::text OR gefueggr_t_ob.code::text = '6'::text) OR gefuegeform_t_ob.code::text = 'Pl'::text AND (gefueggr_t_ob.code::text = '5'::text OR gefueggr_t_ob.code::text = '6'::text) THEN 4
            WHEN gefuegeform_t_ob.code::text = 'Ko'::text OR gefuegeform_t_ob.code::text = 'Ek'::text OR gefuegeform_t_ob.code::text = 'Gr'::text AND gefueggr_t_ob.code::text = '1'::text OR gefuegeform_t_ob.code::text = 'Po'::text AND gefueggr_t_ob.code::text = '7'::text OR gefuegeform_t_ob.code::text = 'Pr'::text AND gefueggr_t_ob.code::text = '7'::text OR gefuegeform_t_ob.code::text = 'Klk'::text AND gefueggr_t_ob.code::text = '7'::text OR gefuegeform_t_ob.code::text = 'Pl'::text AND gefueggr_t_ob.code::text = '7'::text THEN 5
            ELSE NULL::integer
        END AS gefuegeform_t_ob_qgis_int,
    gefuegeform_t_ub.code AS gefuegeform_ub,
    gefuegeform_t_ub.beschreibung AS gefuegeform_ub_beschreibung,
    gefueggr_t_ob.code AS gefueggr_ob,
    gefueggr_t_ob.beschreibung AS gefueggr_ob_beschreibung,
    gefueggr_t_ub.code AS gefueggr_ub,
    gefueggr_t_ub.beschreibung AS gefueggr_ub_beschreibung,
    a.pflngr,
        CASE
            WHEN a.pflngr = 0 THEN
            CASE
                WHEN a.bodpktzahl > 0 AND a.bodpktzahl <= 49 THEN 1
                WHEN a.bodpktzahl >= 50 AND a.bodpktzahl <= 69 THEN 2
                WHEN a.bodpktzahl >= 70 AND a.bodpktzahl <= 79 THEN 3
                WHEN a.bodpktzahl >= 80 THEN 4
                ELSE NULL::integer
            END
            WHEN a.pflngr > 0 THEN
            CASE
                WHEN a.pflngr > 0 AND a.pflngr <= 29 THEN 1
                WHEN a.pflngr >= 30 AND a.pflngr <= 49 THEN 2
                WHEN a.pflngr >= 50 AND a.pflngr <= 69 THEN 3
                WHEN a.pflngr >= 70 THEN 4
                ELSE NULL::integer
            END
            ELSE NULL::integer
        END AS pflngr_qgis_int,
    a.bodpktzahl,
        CASE
            WHEN a.bodpktzahl >= 90 THEN 'Beste Bodeneigenschaften; Fruchtfolge ohne Einschränkungen'::text
            WHEN a.bodpktzahl >= 80 AND a.bodpktzahl < 90 THEN 'Sehr gute Fruchtfolgeböden; Hackfruchtanbau eingeschränkt'::text
            WHEN a.bodpktzahl >= 70 AND a.bodpktzahl < 80 THEN 'Gute Fruchtfolgeböden für getreidebetonte Fruchtfolge'::text
            WHEN a.bodpktzahl >= 50 AND a.bodpktzahl < 70 THEN 'Gute Futterbauböden; futterbaubetonte Fruchtfolge, Ackerbau stark eingeschränkt'::text
            WHEN a.bodpktzahl >= 35 AND a.bodpktzahl < 50 THEN 'Futterbaulich nutzbare Standorte'::text
            WHEN a.bodpktzahl >= 20 AND a.bodpktzahl < 35 THEN 'Extensive Bewirtschaftung angezeigt'::text
            WHEN a.bodpktzahl > 0 AND a.bodpktzahl < 20 THEN 'Für die landwirtschaftliche Nutzung ungeeignet'::text
            WHEN a.bodpktzahl = 0 THEN 'keine Information'::text
            WHEN a.bodpktzahl IS NULL THEN 'keine Information'::text
            ELSE NULL::text
        END AS bodpktzahl_qgis_txt,
    a.bemerkungen,
    be.los,
    be.kartierjahr,
    be.fk_kartierer AS kartierer,
    be.kartierquartal,
    be.is_wald,
    a.bindst_cd,
    a.bindst_zn,
    a.bindst_cu,
    a.bindst_pb,
    a.nfkapwe_ob,
    a.nfkapwe_ub,
    a.nfkapwe,
        CASE
            WHEN a.nfkapwe < 50::double precision THEN '< 50 mm; sehr grosses Trockenstressrisiko'::text
            WHEN a.nfkapwe >= 50::double precision AND a.nfkapwe < 100::double precision THEN '50 - 99 mm; sehr grosses Trockenstressrisiko'::text
            WHEN a.nfkapwe >= 100::double precision AND a.nfkapwe < 150::double precision THEN '100 - 149 mm; grosses Trockenstressrisiko'::text
            WHEN a.nfkapwe >= 150::double precision AND a.nfkapwe < 200::double precision THEN '150 - 199 mm; mässiges Trockenstressrisiko'::text
            WHEN a.nfkapwe >= 200::double precision AND a.nfkapwe < 250::double precision THEN '200 - 249 mm; kleines Trockenstressrisiko'::text
            WHEN a.nfkapwe >= 250::double precision THEN '> 250 mm; kein Trockenstressrisiko'::text
            ELSE NULL::text
        END AS nfkapwe_qgis_txt,
    a.verdempf,
    a.drain_wel,
    a.wassastoss,
    a.is_hauptauspraegung,
    a.gewichtung_auspraegung,
    be.wkb_geometry,
    be.archive
   FROM afu_isboden.bodeneinheit_t be
     LEFT JOIN afu_isboden.bodeneinheit_auspraegung_t a ON a.fk_bodeneinheit = be.pk_ogc_fid
     LEFT JOIN afu_isboden.wasserhhgr_t wasserhhgr_t ON wasserhhgr_t.pk_wasserhhgr = a.fk_wasserhhgr
     LEFT JOIN afu_isboden.bodentyp_t bodentyp_t ON bodentyp_t.pk_bodentyp = a.fk_bodentyp
     LEFT JOIN afu_isboden.begelfor_t begelfor_t ON begelfor_t.pk_begelfor = a.fk_begelfor
     LEFT JOIN afu_isboden.skelett_t skelett_t_ob ON skelett_t_ob.pk_skelett = a.fk_skelett_ob
     LEFT JOIN afu_isboden.skelett_t skelett_t_ub ON skelett_t_ub.pk_skelett = a.fk_skelett_ub
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ob ON koernkl_t_ob.pk_koernkl = a.fk_koernkl_ob
     LEFT JOIN afu_isboden.koernkl_t koernkl_t_ub ON koernkl_t_ub.pk_koernkl = a.fk_koernkl_ub
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ob ON kalkgehalt_t_ob.pk_kalkgehalt = a.fk_kalkgehalt_ob
     LEFT JOIN afu_isboden.kalkgehalt_t kalkgehalt_t_ub ON kalkgehalt_t_ub.pk_kalkgehalt = a.fk_kalkgehalt_ub
     LEFT JOIN afu_isboden.humusform_wa_t humusform_wa_t ON humusform_wa_t.pk_humusform_wa = a.fk_humusform_wa
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ob ON gefuegeform_t_ob.pk_gefuegeform = a.fk_gefuegeform_ob
     LEFT JOIN afu_isboden.gefuegeform_t gefuegeform_t_ub ON gefuegeform_t_ub.pk_gefuegeform = a.fk_gefuegeform_ub
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ob ON gefueggr_t_ob.pk_gefueggr = a.fk_gefueggr_ob
     LEFT JOIN afu_isboden.gefueggr_t gefueggr_t_ub ON gefueggr_t_ub.pk_gefueggr = a.fk_gefueggr_ub
     LEFT JOIN ( SELECT zw_bodeneinheit_untertyp_t.fk_bodeneinheit,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'E'::text) AS filter_array) AS untertyp_e,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'K'::text) AS filter_array) AS untertyp_k,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'I'::text) AS filter_array) AS untertyp_i,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'G'::text) AS filter_array) AS untertyp_g,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'R'::text) AS filter_array) AS untertyp_r,
            ( SELECT afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'P'::text) AS filter_array) AS untertyp_p,
                CASE
                    WHEN regexp_replace(regexp_replace(regexp_replace(regexp_replace(array_agg(untertyp_t.code)::text, '({|})'::text, ''::text, 'g'::text), '(E|K|I|G|R|P).'::text, ''::text, 'g'::text), '( ,|^,)'::text, ''::text, 'g'::text), '( |^,)'::text, ''::text, 'g'::text) = ''::text THEN NULL::text
                    ELSE regexp_replace(regexp_replace(regexp_replace(regexp_replace(array_agg(untertyp_t.code)::text, '(E|K|I|G|R|P).(,|})'::text, ''::text, 'g'::text), '({|})'::text, ''::text, 'g'::text), '( ,|^,)'::text, ''::text, 'g'::text), '( |,$)'::text, ''::text, 'g'::text)
                END AS untertyp_div
           FROM afu_isboden.zw_bodeneinheit_untertyp zw_bodeneinheit_untertyp_t
             LEFT JOIN afu_isboden.untertyp_t untertyp_t ON untertyp_t.pk_untertyp = zw_bodeneinheit_untertyp_t.fk_untertyp
          GROUP BY zw_bodeneinheit_untertyp_t.fk_bodeneinheit) untertyp ON untertyp.fk_bodeneinheit = a.pk_bodeneinheit
  WHERE be.archive = 0 AND be.is_wald AND a.is_hauptauspraegung
  ORDER BY be.pk_ogc_fid, a.pk_bodeneinheit, be.gemnr, be.objnr, wasserhhgr_t.code, bodentyp_t.code, begelfor_t.code, a.geologie, untertyp.untertyp_e, untertyp.untertyp_k, untertyp.untertyp_i, untertyp.untertyp_g, untertyp.untertyp_r, untertyp.untertyp_p, untertyp.untertyp_div, skelett_t_ob.code, skelett_t_ub.code, koernkl_t_ob.code, koernkl_t_ub.code, a.ton_ob, a.ton_ub, a.schluff_ob, a.schluff_ub, a.karbgrenze, kalkgehalt_t_ob.code, kalkgehalt_t_ub.code, a.ph_ob, a.ph_ub, a.maechtigk_ah, a.humusgeh_ah, humusform_wa_t.code, a.maechtigk_ahh, gefuegeform_t_ob.code, gefuegeform_t_ub.code, gefueggr_t_ob.code, gefueggr_t_ub.code, a.pflngr, a.bodpktzahl, a.bemerkungen, be.los, be.kartierjahr, be.fk_kartierer, be.kartierquartal, be.is_wald, a.is_hauptauspraegung, be.wkb_geometry, be.archive;

COMMENT ON VIEW afu_isboden.bodeneinheit_wald_qgis_server_client_v IS 'View für QGIS-Server-Client';


-- afu_isboden.kartiererin_v source

CREATE OR REPLACE VIEW afu_isboden.kartiererin_v
AS SELECT pk_kartiererin,
    name,
    kuerzel
   FROM afu_isboden.kartiererin_v_sc;



-- DROP FUNCTION afu_isboden.bindst();

CREATE OR REPLACE FUNCTION afu_isboden.bindst()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  DECLARE 
     val double precision;
     val_ori double precision;
     ph_ob double precision;
     ton_ob integer;
     skelett_ob integer;
     skelett varchar;
     humusgeh double precision;
     metall varchar;

  BEGIN
     val := 0;
     val_ori := NEW.bindst_cd;
     -- Prüfen ob alle benötigten Felder gefüllt wurden
     IF NEW.fk_bodentyp IS NULL or NEW.ph_ob IS NULL or NEW.humusgeh_ah IS NULL THEN
        --RAISE NOTICE 'Bindst: Es sind nicht alle benötigten Felder gefüllt! %', NEW.pk_bodeneinheit;
     END IF;

     IF NEW.fk_bodentyp IS NOT NULL THEN
     
        ph_ob := NEW.ph_ob;
        humusgeh := NEW.humusgeh_ah;
        ton_ob := NEW.ton_ob;
        IF ton_ob is Null THEN ton_ob := 0; END IF;
        skelett_ob := NEW.fk_skelett_ob;
        IF (skelett_ob > 0 and skelett_ob < 11) THEN 
           skelett := cast((skelett_ob - 1) as varchar); 
        ELSIF skelett_ob = 16 THEN skelett := '4-5';
        ELSIF skelett_ob = 17 THEN skelett := '7-9';
        ELSE  skelett := '0';
        END IF;
        --IF skelett_ob is Null THEN skelett := '0'; END IF;

        -- Berechnung für Cadmium
        metall := 'Cd';
        val := afu_isboden.bindst_berechnen(metall, ph_ob, humusgeh, ton_ob, skelett);
        
--         IF NEW.bindst_cd != val AND NEW.bindst_cd > 0 THEN
--            RAISE NOTICE 'Bindst_cd: Der neu errechnete Wert ist nicht gleich dem bestehenden Wert! %', NEW.pk_bodeneinheit;
--            --RAISE NOTICE 'Ton: %',ton_ob;
--            RAISE NOTICE 'Bindst_cd neu: %', val;
--            RAISE NOTICE 'Bindst_cd: %', NEW.bindst_cd;           
--         END IF;
	NEW.bindst_cd := val;
	
        -- Berechnung für Zink
        metall := 'Zn';
        val := afu_isboden.bindst_berechnen(metall, ph_ob, humusgeh, ton_ob, skelett);
        
--         IF NEW.bindst_zn != val AND NEW.bindst_zn > 0 THEN
--            RAISE NOTICE 'Bindst_zn: Der neu errechnete Wert ist nicht gleich dem bestehenden Wert! %', NEW.pk_bodeneinheit;
--            --RAISE NOTICE 'Ton: %',ton_ob;
--            RAISE NOTICE 'Bindst_zn neu: %', val;
--            RAISE NOTICE 'Bindst_zn: %', NEW.bindst_zn;           
--         END IF;
	NEW.bindst_zn := val;

        -- Berechnung für Kupfer
        metall := 'Cu';
        val := afu_isboden.bindst_berechnen(metall, ph_ob, humusgeh, ton_ob, skelett);
        
--         IF NEW.bindst_cu != val AND NEW.bindst_cu > 0 THEN
--            RAISE NOTICE 'Bindst_cu: Der neu errechnete Wert ist nicht gleich dem bestehenden Wert! %', NEW.pk_bodeneinheit;
--            --RAISE NOTICE 'Ton: %',ton_ob;
--            RAISE NOTICE 'Bindst_cu neu: %', val;
--            RAISE NOTICE 'Bindst_cu: %', NEW.bindst_cu;           
--         END IF;
	NEW.bindst_cu := val;

        -- Berechnung für Blei
        metall := 'Pb';
        val := afu_isboden.bindst_berechnen(metall, ph_ob, humusgeh, ton_ob, skelett);
        
--         IF NEW.bindst_pb != val AND NEW.bindst_pb > 0 THEN
--            RAISE NOTICE 'Bindst_pb: Der neu errechnete Wert ist nicht gleich dem bestehenden Wert! %', NEW.pk_bodeneinheit;
--            --RAISE NOTICE 'Ton: %',ton_ob;
--            RAISE NOTICE 'Bindst_pb neu: %', val;
--            RAISE NOTICE 'Bindst_pb: %', NEW.bindst_pb;           
--         END IF;
	NEW.bindst_pb := val;
                
     END IF;

     RETURN NEW;
END;

$function$
;

COMMENT ON FUNCTION afu_isboden.bindst() IS 'Wenn eine Hauptauspraegung aktualisiert wird, dann sollen die Bindungstärken (Felder bindst_cd, bindst_zn, bindst_cu, bindst_pb) neu berechnet werden. Dafür braucht es die Funktion bindst_berechnen() und die Wertetabellen wt_tab70_1, wt_tab70_2, wt_tab70_3, wt_tab70_4, wt_tab70_4sk. ';

-- DROP FUNCTION afu_isboden.bindst_berechnen(text, float8, float8, int4, varchar);

CREATE OR REPLACE FUNCTION afu_isboden.bindst_berechnen(met text, ph double precision, humusgeh double precision, ton integer, sk character varying)
 RETURNS double precision
 LANGUAGE plpgsql
AS $function$  
DECLARE
   myRecord record;
   val double precision;
   val1 double precision;
   val2 double precision;
   val2humus double precision;
   val2ton double precision;
   val3 double precision;
BEGIN

   --RAISE NOTICE 'METALL: %', met;
   --RAISE NOTICE 'PH: %', ph;
   --RAISE NOTICE 'HUMUSGEH: %', humusgeh;
   --RAISE NOTICE 'TON: %', ton;
   --RAISE NOTICE 'SK: %', sk;
   
   val1 := 0;
   FOR myRecord IN SELECT wert1 FROM afu_isboden.wt_tab70_1 WHERE 
        metall = met AND bis >= ph AND von <= ph LOOP
   END LOOP;
   IF myRecord.wert1 IS NOT NULL THEN val1 := myRecord.wert1; END IF;

   val2humus := 0; val2ton :=0;
   FOR myRecord IN SELECT * FROM afu_isboden.wt_tab70_2 WHERE 
        metall = met LOOP
   END LOOP;
   IF myRecord.grenz_ph < ph THEN 
      val2humus := myRecord.humus; val2ton := myRecord.ton;
      val2 := NULL;
      FOR myRecord IN SELECT * FROM afu_isboden.wt_tab70_3 WHERE 
        hum_von <= humusgeh AND hum_bis >= humusgeh AND bind_st = val2humus LOOP
        IF val2 IS NULL THEN val2 := myRecord.wert2; END IF;
      END LOOP;
      IF val2 IS NULL THEN val2 := 0; END IF;
      val3 := NULL;
      FOR myRecord IN SELECT * FROM afu_isboden.wt_tab70_4 WHERE 
        ton_von <= ton AND ton_bis >= ton AND bind_st = val2ton LOOP
        IF val3 IS NULL THEN val3 := myRecord.wert3; END IF;
      END LOOP;
      IF val3 IS NULL THEN val3 := 0; END IF;
      FOR myRecord IN SELECT * FROM afu_isboden.wt_tab70_4sk WHERE 
        skelett = sk LOOP
      END LOOP;
      IF myRecord.minuswert IS NOT NULL THEN 
         val3 := val3 - myRecord.minuswert;
         IF val3 < 0 THEN val3 := 0; END IF;
      END IF;
      val := val1 + val2 + val3;
   ELSE
      val := val1;
   END IF;

   --RAISE NOTICE 'val1: %', val1;
   --RAISE NOTICE 'val2: %', val2;
   --RAISE NOTICE 'val3: %', val3;
   --RAISE NOTICE 'val: %', val;

   RETURN val;
END;
$function$
;

-- DROP FUNCTION afu_isboden.delete_kuerzel_trigger_function();

CREATE OR REPLACE FUNCTION afu_isboden.delete_kuerzel_trigger_function()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
 BEGIN
		IF NOT OLD.is_hauptauspraegung AND 
		(SELECT COUNT(*) FROM afu_isboden.bodeneinheit_auspraegung_t 
		     WHERE bodeneinheit_auspraegung_t.fk_bodeneinheit = OLD.fk_bodeneinheit) = 1
		     THEN
		    UPDATE afu_isboden.bodeneinheit_t
		    SET kuerzel = trim(both '*' from kuerzel)
		    WHERE pk_ogc_fid = OLD.fk_bodeneinheit;
		END IF;
	        RETURN NEW;
 END;
 $function$
;

COMMENT ON FUNCTION afu_isboden.delete_kuerzel_trigger_function() IS 'Wenn eine Ausprägung gelöscht wird, dann soll das Kuerzel-Feld (wasserhhgr, bodentyp,  aktualisiert werden';

-- DROP FUNCTION afu_isboden.deploy_tables_as_products();

CREATE OR REPLACE FUNCTION afu_isboden.deploy_tables_as_products()
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
  BEGIN	

		--delete content
		EXECUTE 'DELETE FROM afu_isboden.bodeneinheit_lw_qgis_server_client_t';
		EXECUTE 'DELETE FROM afu_isboden.bodeneinheit_wald_qgis_server_client_t';
		EXECUTE 'DELETE FROM afu_isboden.bodeneinheit_onlinedata_t';

		-- refresh content
		EXECUTE 'INSERT INTO afu_isboden.bodeneinheit_lw_qgis_server_client_t SELECT * FROM afu_isboden.bodeneinheit_lw_qgis_server_client_v';
		EXECUTE 'INSERT INTO afu_isboden.bodeneinheit_wald_qgis_server_client_t SELECT * FROM afu_isboden.bodeneinheit_wald_qgis_server_client_v';
		EXECUTE 'INSERT INTO afu_isboden.bodeneinheit_onlinedata_t SELECT * FROM afu_isboden.bodeneinheit_onlinedata_v';


		-- optimize table
		--EXECUTE 'REINDEX TABLE afu_isboden.bodeneinheit_wald_qgis_server_client_t';
		--EXECUTE 'REINDEX TABLE afu_isboden.bodeneinheit_lw_qgis_server_client_t';
		--EXECUTE 'REINDEX TABLE afu_isboden.bodeneinheit_onlinedata_t';
		-- Reindexierung wurde deaktiviert wegen Problemen mit der Berechtigung (owner).
		

  RETURN true;
  END;
$function$
;

COMMENT ON FUNCTION afu_isboden.deploy_tables_as_products() IS 'Derive Products out of the production data modell';

-- DROP FUNCTION afu_isboden.filter_array(_text, text);

CREATE OR REPLACE FUNCTION afu_isboden.filter_array(my_array text[], my_match text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE
	    my_return text;
	    i integer;
	    first_match boolean;

	BEGIN
	   my_return := '';
	   first_match := true; -- for first iteration
	   FOR i IN 1..array_upper(my_array, 1) LOOP
	     IF UPPER(my_array[i]) LIKE UPPER(my_match) || '%' THEN 
	      IF first_match THEN
		my_return = my_array[i];
		first_match = false;
	      ELSE
	        my_return = my_return || ',' || my_array[i];
	      END IF;
	    END IF;
           END LOOP;

           IF my_return = '' THEN
		my_return = NULL;
           END IF;
	Return my_return; 
END;
$function$
;

COMMENT ON FUNCTION afu_isboden.filter_array(_text, text) IS 'Diese Funktion filtert ein array nach Anfangsbuchstaben und gibt nur die Matches als kommaseparierten Text zurück';

-- DROP FUNCTION afu_isboden.generate_gemeindeteil();

CREATE OR REPLACE FUNCTION afu_isboden.generate_gemeindeteil()
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE

BEGIN

    -- empty table
    EXECUTE 'DELETE FROM afu_isboden.gemeindeteil_t';

    -- fill table with old communes
    EXECUTE '
	INSERT INTO afu_isboden.gemeindeteil_t
	SELECT
	geo_past.ogc_fid_past AS ogc_fid,
	geo_recent.gem_bfs,
	gem_bfs_past,
	geo_recent."name",
	geo_past.name_past,
	geo_recent.gmde_name,
	geo_past.gmde_name_past,
	geo_recent.gmde_nr,
	geo_past.gmde_nr_past,
	geo_recent.bzrk_nr,
	geo_past.bzrk_nr_past,
	geo_recent.eg_nr,
	geo_past.eg_nr_past,
	geo_recent.plz,
	geo_past.plz_past,
	geo_recent.ktn_nr,
	geo_past.ktn_nr_past,
	geo_recent.wkb_geometry,
	geo_past.wkb_geometry_past
	FROM
	(
	SELECT DISTINCT ON(gem_bfs) 
	gem_bfs AS gem_bfs_past, 
	ogc_fid AS ogc_fid_past, 
	wkb_geometry AS wkb_geometry_past, 
	gmde_name AS gmde_name_past, 
	name AS name_past, 
	gmde_nr AS gmde_nr_past, 
	bzrk_nr AS bzrk_nr_past, 
	eg_nr AS eg_nr_past, 
	plz AS plz_past, 
	ktn_nr AS ktn_nr_past, 
	new_date AS new_date_past, 
	archive_date AS archive_date_past, 
	archive AS archive_past
	FROM geo_gemeinden 
	WHERE new_date <= ''2005-09-21''::date
	GROUP by gem_bfs, ogc_fid, wkb_geometry, gmde_name, name, gmde_nr, bzrk_nr, eg_nr, plz, 
	ktn_nr, new_date, archive_date, archive
	ORDER by gem_bfs, new_date DESC) geo_past, 
	(SELECT * FROM geo_gemeinden WHERE archive = 0) geo_recent
	WHERE st_dwithin(st_pointonsurface(geo_past.wkb_geometry_past), geo_recent.wkb_geometry, 0::double precision)
	AND geo_past.gem_bfs_past != geo_recent.gem_bfs
	';

	EXECUTE 'INSERT INTO afu_isboden.gemeindeteil_t
	SELECT DISTINCT ON(gem_bfs)
	geo_past.ogc_fid,
	geo_recent.gem_bfs,
	geo_past.gem_bfs AS gem_bfs_past,
	geo_recent."name",
	geo_past."name" AS name_past,
	geo_recent.gmde_name,
	geo_past.gmde_name AS gmde_name_past,
	geo_recent.gmde_nr,
	geo_past.gmde_nr AS gmde_nr_past,
	geo_recent.bzrk_nr,
	geo_past.bzrk_nr AS bzrk_nr_past,
	geo_recent.eg_nr,
	geo_past.eg_nr AS eg_nr_past,
	geo_recent.plz,
	geo_past.plz AS plz_past,
	geo_recent.ktn_nr,
	geo_past.ktn_nr  AS ktn_nr_past,
	geo_recent.wkb_geometry,
	geo_past.wkb_geometry AS wkb_geometry_past
	FROM geo_gemeinden geo_past, geo_gemeinden geo_recent,
	(
	SELECT ogc_fid FROM
	(
	SELECT DISTINCT ON (gem_bfs) ogc_fid FROM geo_gemeinden WHERE new_date <= ''2005-09-21''::date
	GROUP BY gem_bfs, ogc_fid, new_date
	ORDER BY gem_bfs, new_date DESC
	) foo
	EXCEPT
	SELECT ogc_fid FROM afu_isboden.gemeindeteil_t
	) foo
	WHERE geo_past.new_date <= ''2005-09-21''::date
	AND geo_past.ogc_fid != foo.ogc_fid
	AND geo_recent.archive = 0
	AND geo_recent.gem_bfs = geo_past.gem_bfs
	';

	-- SET SRID
	EXECUTE 'UPDATE afu_isboden.gemeindeteil_t SET wkb_geometry = ST_SetSRID(wkb_geometry, 2056)';
	EXECUTE 'UPDATE afu_isboden.gemeindeteil_t SET wkb_geometry_aktuell = ST_SetSRID(wkb_geometry, 2056)';

	-- REINDEX table
	EXECUTE 'REINDEX TABLE afu_isboden.gemeindeteil_t';
 
  
    RETURN TRUE;
END
$function$
;

COMMENT ON FUNCTION afu_isboden.generate_gemeindeteil() IS 'Bei einer Gemeindefusion kann mit dieser Funktion manuell die Tabelle gemeindeteil_t aktualisiert werden.';

-- DROP FUNCTION afu_isboden.get_gemeinde(varchar);

CREATE OR REPLACE FUNCTION afu_isboden.get_gemeinde(character varying)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$DECLARE

thePolygon ALIAS FOR $1;
thePoint GEOMETRY;
gem_bfs_rec RECORD;


BEGIN


  thePoint := ST_PointOnSurface(ST_GeometryFromText(thePolygon));
  FOR gem_bfs_rec in SELECT DISTINCT gem_bfs FROM geo_gemeinden WHERE ST_INTERSECTS(thePOINT, wkb_geometry) AND archive = 0 LOOP

  END LOOP;
  RETURN gem_bfs_rec.gem_bfs;

END;
 
$function$
;

COMMENT ON FUNCTION afu_isboden.get_gemeinde(varchar) IS 'Anhand einer Koordinate wird die GEM_BFS-Nummer zurückgeliefert';

-- DROP FUNCTION afu_isboden.insert_kuerzel_trigger_function();

CREATE OR REPLACE FUNCTION afu_isboden.insert_kuerzel_trigger_function()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$  
	    BEGIN
		IF NOT NEW.is_hauptauspraegung THEN
		    UPDATE afu_isboden.bodeneinheit_t
		    SET kuerzel = trim(both '*' from replace(kuerzel,' ','')) || '*' 
		    WHERE pk_ogc_fid = NEW.fk_bodeneinheit;
		END IF;
	        RETURN NEW;
	    END;
	$function$
;

COMMENT ON FUNCTION afu_isboden.insert_kuerzel_trigger_function() IS 'Wenn eine Ausprägung aktualisiert wird, dann soll das Kuerzel-Feld (wasserhhgr, bodentyp,  aktualisiert werden';

-- DROP FUNCTION afu_isboden.materialize_table_overlapping_bodeneinheiten();

CREATE OR REPLACE FUNCTION afu_isboden.materialize_table_overlapping_bodeneinheiten()
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
	DECLARE

	BEGIN
		EXECUTE 'DELETE FROM afu_isboden.bodeneinheit_overlap_t';

		EXECUTE 'INSERT INTO afu_isboden.bodeneinheit_overlap_t
			SELECT pk_ogc_fid, objnr, gemnr, los, wkb_geometry, archive 
			FROM (
				SELECT DISTINCT ON (a.pk_ogc_fid) 
				a.pk_ogc_fid, 
				a.objnr, 
				a.gemnr, 
				a.los, 
				st_intersection(st_buffer(a.wkb_geometry, 0::double precision), 
				st_buffer(b.wkb_geometry, 0::double precision)) AS wkb_geometry, 
				a.archive
				FROM afu_isboden.bodeneinheit_t a, afu_isboden.bodeneinheit_t b
				WHERE a.pk_ogc_fid <> b.pk_ogc_fid AND a.wkb_geometry && b.wkb_geometry AND st_area(st_intersection(st_buffer(a.wkb_geometry, 0::double precision), st_buffer(b.wkb_geometry, 0::double precision))) > 0::double precision
				ORDER BY a.pk_ogc_fid) AS foo';

		
		EXECUTE 'REINDEX TABLE afu_isboden.bodeneinheit_overlap_t';
	  
	RETURN TRUE;
END;
$function$
;

COMMENT ON FUNCTION afu_isboden.materialize_table_overlapping_bodeneinheiten() IS 'Mit dieser Funktion kann die View afu_isboden.bodeneinheit_overlap_v als Tabelle afu_isboden.bodeneinheit_overlap_t materialisiert werden. Diese weist alle Überlappungen von Flächen auf.';

-- DROP FUNCTION afu_isboden.nitrat();

CREATE OR REPLACE FUNCTION afu_isboden.nitrat()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  DECLARE 
     myRec record;
     myRec2 record;
     nfkwe double precision; val_ori double precision;
     nfkwe_ob double precision; val_ob_ori double precision;
     nfkwe_ub double precision; val_ub_ori double precision;
     schl_ob double precision; schl_ub double precision;
     sk_ob double precision; sk_ub double precision;
     ton_ob integer; ton_ub integer;
     humusgeh double precision;
     wasserhhgr varchar;
     maechtigk_ah integer;
     gef_ob varchar; gef_ub varchar;
     lagdi_ob varchar; lagdi_ub varchar;
     bodart_ob varchar; bodart_ub varchar;
     nutzbfk_ob double precision; nutzbfk_ub double precision;
     znutzbfk_ob double precision; znutzbfk_ub double precision;
     png_wert double precision;
     
  BEGIN
     nfkwe := 0;
     val_ori := NEW.nfkapwe;
     nfkwe_ob := 0;
     val_ob_ori := NEW.nfkapwe_ob;
     nfkwe_ub := 0;
     val_ub_ori := NEW.nfkapwe_ub;
        
     schl_ob := NEW.schluff_ob; schl_ub := NEW.schluff_ub;
     humusgeh := NEW.humusgeh_ah;
     ton_ob := NEW.ton_ob; ton_ub := NEW.ton_ub;
     FOR myRec IN SELECT code FROM afu_isboden.wasserhhgr_t WHERE
        pk_wasserhhgr = NEW.fk_wasserhhgr LOOP
     END LOOP;   
     wasserhhgr := myRec.code;
     maechtigk_ah := NEW.maechtigk_ah;
     
     FOR myRec IN SELECT code FROM afu_isboden.skelett_t WHERE
        pk_skelett = NEW.fk_skelett_ob LOOP
     END LOOP; 
     IF myRec.code = 0 THEN sk_ob := 2; 
     ELSIF myRec.code = 1 THEN sk_ob := 7.5;
     ELSIF myRec.code in (2,3) THEN sk_ob := 15;
     ELSIF myRec.code in (4,5) THEN sk_ob := 25;
     ELSIF myRec.code in (6,7) THEN sk_ob := 40;
     ELSIF myRec.code in (8,9) THEN sk_ob := 55;
     ELSE sk_ob := 0;
     END IF;
     
     FOR myRec IN SELECT code FROM afu_isboden.gefuegeform_t WHERE 
        pk_gefuegeform = NEW.fk_gefuegeform_ob LOOP
     END LOOP;
     FOR myRec2 IN SELECT code FROM afu_isboden.gefueggr_t WHERE 
        pk_gefueggr = NEW.fk_gefueggr_ob LOOP
     END LOOP;
     IF myRec2.code IS NOT NULL THEN
        gef_ob := myRec.code || cast(myRec2.code as varchar);
     ELSE
        gef_ob := myRec.code;
     END IF;

     FOR myRec IN SELECT code FROM afu_isboden.gefuegeform_t WHERE 
        pk_gefuegeform = NEW.fk_gefuegeform_ub LOOP
     END LOOP;
     FOR myRec2 IN SELECT code FROM afu_isboden.gefueggr_t WHERE 
        pk_gefueggr = NEW.fk_gefueggr_ub LOOP
     END LOOP;
     IF myRec.code IS NOT Null THEN
        IF myRec2.code IS NOT Null THEN
           gef_ub := myRec.code || cast(myRec2.code as varchar);
        ELSE
           gef_ub := myRec.code;
        END IF;
     ELSIF gef_ob IS NOT NULL THEN 
        IF gef_ub IS NULL THEN gef_ub := gef_ob; END IF;
     END IF;

     IF maechtigk_ah IS NOT NULL AND wasserhhgr IS NOT NULL THEN

      nfkwe_ob := 0; nfkwe_ub := 0;

      IF gef_ob IS NOT NULL AND ton_ob IS NOT NULL AND schl_ob IS NOT NULL THEN
     
        lagdi_ob := 'x'; 
        FOR myRec IN SELECT lagdi FROM afu_isboden.wt_gefueg WHERE 
           begeffor = lower(gef_ob) LOOP
        END LOOP;
        IF myRec.lagdi IS NOT NULL THEN lagdi_ob := myRec.lagdi; END IF;
        FOR myRec IN SELECT bodart FROM afu_isboden.wt_bodart WHERE 
          ton_v <= ton_ob AND ton_b >= ton_ob AND 
          schl_v <= schl_ob AND schl_b >= schl_ob LOOP
        END LOOP;
        IF myRec.bodart IS NOT NULL THEN bodart_ob := myRec.bodart; END IF;
     
        FOR myRec IN SELECT * FROM afu_isboden.wt_nutzbfk WHERE 
           bodart = bodart_ob LOOP
        END LOOP;
        IF lagdi_ob in ('Ld1','Ld2') THEN nutzbfk_ob := myRec.ld1_2; 
        ELSIF lagdi_ob = 'Ld3' THEN nutzbfk_ob := myRec.ld3;
        ELSIF lagdi_ob in ('Ld4','Ld5') THEN nutzbfk_ob := myRec.ld4_5;
        ELSE nutzbfk_ob := 0;
        END IF;

        IF humusgeh > 0 THEN
           FOR myRec IN SELECT znutzbfk FROM afu_isboden.wt_znutzbfk WHERE 
              bodart = bodart_ob AND hugeah_v <= humusgeh and 
              hugeah_b >= humusgeh LOOP
           END LOOP;
           znutzbfk_ob := myRec.znutzbfk;
        END IF;   

        nfkwe_ob := ((maechtigk_ah * nutzbfk_ob) * ((100 - sk_ob) / 100)) + 
                    ((maechtigk_ah * znutzbfk_ob) * ((100 - sk_ob) / 100));
        
      END IF;

      IF gef_ub IS NOT NULL AND ton_ub IS NOT NULL AND schl_ub IS NOT NULL THEN

        lagdi_ub := 'x';
        FOR myRec IN SELECT lagdi FROM afu_isboden.wt_gefueg WHERE 
           begeffor = lower(gef_ub) LOOP
        END LOOP;
        IF myRec.lagdi IS NOT NULL THEN lagdi_ub := myRec.lagdi; END IF;
        FOR myRec IN SELECT bodart FROM afu_isboden.wt_bodart WHERE 
           ton_v <= ton_ub AND ton_b >= ton_ub AND 
           schl_v <= schl_ub AND schl_b >= schl_ub LOOP
        END LOOP;
        IF myRec.bodart IS NOT NULL THEN bodart_ub := myRec.bodart; END IF;
       
        FOR myRec IN SELECT * FROM afu_isboden.wt_nutzbfk WHERE 
           bodart = bodart_ub LOOP
        END LOOP;
        IF lagdi_ub in ('Ld1','Ld2') THEN nutzbfk_ub := myRec.ld1_2; 
        ELSIF lagdi_ub = 'Ld3' THEN nutzbfk_ub := myRec.ld3;
        ELSIF lagdi_ub in ('Ld4','Ld5') THEN nutzbfk_ub := myRec.ld4_5;
        ELSE nutzbfk_ub := 0;
        END IF;
 
        FOR myRec IN SELECT png_w FROM afu_isboden.wt_pfnugr WHERE 
           bewashgr = wasserhhgr LOOP
        END LOOP;
        png_wert := myRec.png_w;        

        nfkwe_ub := (png_wert - maechtigk_ah) * nutzbfk_ub;
        IF nfkwe_ub < 0 THEN nfkwe_ub := 0; END IF;
        
      END IF;       

     nfkwe := nfkwe_ob + nfkwe_ub;
        
     END IF;
         
--      IF CAST(NEW.nfkapwe AS VARCHAR) != CAST(nfkwe AS VARCHAR) and NEW.nfkapwe != 0 THEN
--            RAISE NOTICE 'NFKWE: Der neu errechnete Wert ist nicht gleich dem bestehenden Wert! %', NEW.pk_bodeneinheit;
--            RAISE NOTICE 'NFKWE: Wert neu: %', nfkwe;
--            RAISE NOTICE 'NFKWE: Wert: %', NEW.nfkapwe;
--      END IF;
     NEW.nfkapwe := nfkwe;
     
--      IF CAST(NEW.nfkapwe_ob AS VARCHAR) != CAST(nfkwe_ob AS VARCHAR) and NEW.nfkapwe_ob != 0 THEN
--            RAISE NOTICE 'NFKWE_OB: Der neu errechnete Wert ist nicht gleich dem bestehenden Wert! %', NEW.pk_bodeneinheit;
--            RAISE NOTICE 'NFKWE_OB: Wert neu: %', nfkwe_ob;
--            RAISE NOTICE 'NFKWE_OB: Wert: %', NEW.nfkapwe_ob;           
--      END IF;
     NEW.nfkapwe_ob := nfkwe_ob;
     
--      IF CAST(NEW.nfkapwe_ub AS VARCHAR) != CAST(nfkwe_ub AS VARCHAR) and NEW.nfkapwe_ub != 0 THEN
--            RAISE NOTICE 'NFKWE_UB: Der neu errechnete Wert ist nicht gleich dem bestehenden Wert! %', NEW.pk_bodeneinheit;
--            RAISE NOTICE 'NFKWE_UB: Wert neu: %', nfkwe_ub;
--            RAISE NOTICE 'NFKWE_UB: Wert: %', NEW.nfkapwe_ub;           
--      END IF;
     NEW.nfkapwe_ub := nfkwe_ub;

     --RAISE NOTICE 'SK_OB: %', sk_ob;
     --RAISE NOTICE 'GEF_OB: %', gef_ob;
     --RAISE NOTICE 'LAGDI_OB: %', lagdi_ob;
     --RAISE NOTICE 'BODART_OB: %', bodart_ob;
     --RAISE NOTICE 'NUTZBFK_OB: %', nutzbfk_ob;
     --RAISE NOTICE 'ZNUTZBFK_OB: %', znutzbfk_ob;
     --RAISE NOTICE 'SCHLUFF_OB: %', schl_ob;
     --RAISE NOTICE 'TON_OB: %', ton_ob;
     --RAISE NOTICE 'HUMUSGEH: %', humusgeh;
     --RAISE NOTICE 'MAECHTIGK_AH: %', maechtigk_ah;
     --RAISE NOTICE 'GEF_UB: %', gef_ub;
     --RAISE NOTICE 'LAGDI_UB: %', lagdi_ub;
     --RAISE NOTICE 'BODART_UB: %', bodart_ub;
     --RAISE NOTICE 'NUTZBFK_UB: %', nutzbfk_ub;
     --RAISE NOTICE 'SCHLUFF_UB: %', schl_ub;
     --RAISE NOTICE 'TON_UB: %', ton_ub;
          
     RETURN NEW;
END;

$function$
;

COMMENT ON FUNCTION afu_isboden.nitrat() IS 'Wenn eine Hauptauspraegung aktualisiert wird, dann sollen die Nitratwerte neu berechnet werden. Dafür braucht es die Wertetabellen wt_gefueg, wt_bodart, wt_nutzbfk, wt_znutzbfk, wt_pfnugr.';

-- DROP FUNCTION afu_isboden.update_gemnr_objnr_trigger_function();

CREATE OR REPLACE FUNCTION afu_isboden.update_gemnr_objnr_trigger_function()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$  
	    BEGIN
		IF (NEW.objnr != OLD.objnr AND NEW.gemnr = OLD.gemnr AND OLD.objnr < 5000) THEN
		    INSERT INTO afu_isboden.bodeneinheit_historische_nummerierung_t
		    (
			    fk_bodeneinheit,
			    objnr,
			    gemnr
		    )
		    VALUES
		    (
			    NEW.pk_ogc_fid,
			    OLD.objnr,
			    NULL
		    );
		END IF;

		IF (NEW.objnr = OLD.objnr AND NEW.gemnr != OLD.gemnr) THEN
		    INSERT INTO afu_isboden.bodeneinheit_historische_nummerierung_t
		    (
			    fk_bodeneinheit,
			    objnr,
			    gemnr
		    )
		    VALUES
		    (
			    NEW.pk_ogc_fid,
			    NULL,
			    OLD.gemnr
		    );
		END IF;

		IF (NEW.objnr != OLD.objnr AND NEW.gemnr != OLD.gemnr) THEN
		    INSERT INTO afu_isboden.bodeneinheit_historische_nummerierung_t
		    (
			    fk_bodeneinheit,
			    objnr,
			    gemnr
		    )
		    VALUES
		    (
			    NEW.pk_ogc_fid,
			    OLD.objnr,
			    OLD.gemnr
		    );
		END IF;
		    
	        RETURN NEW;
	    END;
	$function$
;

COMMENT ON FUNCTION afu_isboden.update_gemnr_objnr_trigger_function() IS 'Falls sich in der Tabelle bodeneinheit_t die objnr oder/und die gemnr ändert, soll die bestehende historisiert werden';

-- DROP FUNCTION afu_isboden.update_kuerzel_trigger_function();

CREATE OR REPLACE FUNCTION afu_isboden.update_kuerzel_trigger_function()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$  
	    BEGIN
		IF NEW.is_hauptauspraegung THEN
		    UPDATE afu_isboden.bodeneinheit_t
		    SET kuerzel = (SELECT kuerzel FROM
		     (SELECT wasserhhgr_t.code || '' || bodentyp_t.code || '' || begelfor_t.code ||
		     (SELECT komplex FROM (SELECT
		     CASE WHEN COUNT(bodeneinheit_auspraegung_t.fk_bodeneinheit) > 1 THEN
			'*'
		     ELSE
			''
		     END AS komplex
		     FROM afu_isboden.bodeneinheit_auspraegung_t 
		     WHERE bodeneinheit_auspraegung_t.fk_bodeneinheit = NEW.fk_bodeneinheit) AS too)
		     AS kuerzel 
		      FROM 
		      afu_isboden.wasserhhgr_t, 
		      afu_isboden.bodentyp_t, 
		      afu_isboden.begelfor_t
                      WHERE wasserhhgr_t.pk_wasserhhgr = NEW.fk_wasserhhgr 
                      AND bodentyp_t.pk_bodentyp = NEW.fk_bodentyp
                      AND  begelfor_t.pk_begelfor = NEW.fk_begelfor) as foo)   
		    WHERE pk_ogc_fid = NEW.fk_bodeneinheit;
		END IF;
	        RETURN NEW;
	    END;
	$function$
;

COMMENT ON FUNCTION afu_isboden.update_kuerzel_trigger_function() IS 'Wenn eine Ausprägung aktualisiert wird, dann soll das Kuerzel-Feld (wasserhhgr, bodentyp,  aktualisiert werden';

-- DROP FUNCTION afu_isboden.verdempf();

CREATE OR REPLACE FUNCTION afu_isboden.verdempf()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  DECLARE 
     val integer;
     val_ori integer;

  BEGIN
     val := 0;
     val_ori := NEW.verdempf;
     -- Prüfen ob alle benötigten Felder gefüllt wurden
     IF NEW.fk_bodentyp IS NULL or NEW.fk_wasserhhgr IS NULL THEN
        --RAISE NOTICE 'Verdempf: Es sind nicht alle benötigten Felder gefüllt! %', NEW.pk_bodeneinheit;
     END IF;
     IF NEW.fk_bodentyp in (24,25) THEN
	NEW.verdempf := 5; val := 5;
     ELSE
      IF New.fk_bodentyp in (9,7,18,8) AND 
          (NEW.fk_skelett_ub in (9,10,23) or NEW.fk_skelett_ub is NULL) THEN
         NEW.verdempf := 1; val := 1;
      END IF;
     END IF;
     IF val = 0 THEN
        IF NEW.fk_wasserhhgr in (1,2,3,4,5) THEN
           IF NEW.fk_skelett_ub in (7,8,22) THEN
              IF NEW.fk_koernkl_ub in (1,3) then
                 NEW.verdempf := 1;
              ELSE
                 IF NEW.fk_koernkl_ub in (10,11) then
                    NEW.verdempf := 3;
                 ELSE
                    IF NEW.fk_bodentyp = 18 THEN
                       NEW.verdempf := 3;
                    ELSE
                       NEW.verdempf := 2;
                    END IF;
                 END IF;
              END IF;   
           ELSE
              IF NEW.fk_koernkl_ub in (10,11) then
                 NEW.verdempf := 3;
              ELSE
                 IF NEW.fk_bodentyp = 18 THEN
                    NEW.verdempf := 3;
                 ELSE
                    NEW.verdempf := 2;
                 END IF;
              END IF;
           END IF;
        ELSE
           IF NEW.fk_wasserhhgr in (6,7,8,9,10,11,12,13) THEN
              IF NEW.fk_koernkl_ub in (10,11) then
                 NEW.verdempf := 4;
              ELSE
                 IF NEW.fk_bodentyp = 18 THEN
                    NEW.verdempf := 4;
                 ELSE
                    NEW.verdempf := 3;
                 END IF;
              END IF;   
           ELSE
              IF NEW.fk_wasserhhgr in (18,19,20) THEN
                 IF NEW.fk_koernkl_ub in (8,9,10,11,13) then
                    NEW.verdempf := 5;
                 ELSE
                    IF NEW.fk_bodentyp = 18 THEN
                       NEW.verdempf := 5;
                    ELSE
                       NEW.verdempf := 4;
                    END IF;
                 END IF;
              ELSE
                 IF NEW.fk_wasserhhgr in (14,15,16,17,21,22,23,24,25) THEN
                    NEW.verdempf := 5;
                 END IF;
              END IF;
           END IF;
        END IF;
     END IF;
--      IF val_ori != NEW.verdempf THEN
--         RAISE NOTICE 'Verdempf: Der neu errechnete Wert ist nicht gleich dem bestehenden Wert! %', NEW.pk_bodeneinheit;
--      END IF;
     RETURN NEW;
  END;

$function$
;

COMMENT ON FUNCTION afu_isboden.verdempf() IS 'Wenn eine Hauptauspraegung aktualisiert wird, dann soll die Verdichtungsempfindlichkeit neu berechnet werden. ';