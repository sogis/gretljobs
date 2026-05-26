CREATE SCHEMA IF NOT EXISTS mig;

-- -----------------------------------------------------------------------------
-- Mapping-Tabellen anlegen (falls noch nicht vorhanden)
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS mig.map_wasserhaushaltcode (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_bodentypcode (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_gelaendeform (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_gefuegeform (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_gefuegegroesse (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_humusform_wald (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_kalkgehalt (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_koernungsklasse (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_skelettgehalt_landwirtschaft (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_skelettgehalt_wald (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_untertyp_e (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_untertyp_i (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_untertyp_g (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_untertyp_r (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_untertyp_k (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_untertyp_p (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

CREATE TABLE IF NOT EXISTS mig.map_untertyp_diverse (
  src_code text PRIMARY KEY,
  src_beschreibung text,
  tgt_ilicode text NOT NULL,
  tgt_dispname text,
  match_rule text DEFAULT 'manual'
);

DELETE FROM mig.map_wasserhaushaltcode;

INSERT INTO mig.map_wasserhaushaltcode
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('a', 'Senkrecht durchwaschen, normal durchlässig, sehr tiefgründig', 'a', 'a - Senkrecht durchwaschen, normal durchlässig, sehr tiefgründig', 'manual'),
('b', 'Senkrecht durchwaschen, normal durchlässig, tiefgründig', 'b', 'b - Senkrecht durchwaschen, normal durchlässig, tiefgründig', 'manual'),
('c', 'Senkrecht durchwaschen, normal durchlässig, mässig tiefgründig', 'c', 'c - Senkrecht durchwaschen, normal durchlässig, mässig tiefgründig', 'manual'),
('d', 'Senkrecht durchwaschen, normal durchlässig, ziemlich flachgründig', 'd', 'd - Senkrecht durchwaschen, normal durchlässig, ziemlich flachgründig', 'manual'),
('e', 'Senkrecht durchwaschen, normal durchlässig, flachgründig und sehr flachgründig', 'e', 'e - Senkrecht durchwaschen, normal durchlässig, flachgründig und sehr flachgründig', 'manual'),
('f', 'Senkrecht durchwaschen, stauwasserbeeinflusst, tiefgründig', 'f', 'f - Senkrecht durchwaschen, stauwasserbeeinflusst, tiefgründig', 'manual'),
('g', 'Senkrecht durchwaschen, stauwasserbeeinflusst, mässig tiefgründig', 'g', 'g - Senkrecht durchwaschen, stauwasserbeeinflusst, mässig tiefgründig', 'manual'),
('h', 'Senkrecht durchwaschen, stauwasserbeeinflusst, ziemlich flachgründig', 'h', 'h - Senkrecht durchwaschen, stauwasserbeeinflusst, ziemlich flachgründig', 'manual'),
('i', 'Senkrecht durchwaschen, stauwasserbeeinflusst, flachgründig und sehr flachgründig', 'i', 'i - Senkrecht durchwaschen, stauwasserbeeinflusst, flachgründig und sehr flachgründig', 'manual'),
('k', 'Senkrecht durchwaschen, grund- oder hangwasserbeeinflusst, tiefgründig', 'k', 'k - Senkrecht durchwaschen, grund- oder hangwasserbeeinflusst, tiefgründig', 'manual'),
('l', 'Senkrecht durchwaschen, grund- oder hangwasserbeeinflusst, mässig tiefgründig', 'l', 'l - Senkrecht durchwaschen, grund- oder hangwasserbeeinflusst, mässig tiefgründig', 'manual'),
('m', 'Senkrecht durchwaschen, grund- oder hangwasserbeeinflusst, ziemlich flachgründig', 'm', 'm - Senkrecht durchwaschen, grund- oder hangwasserbeeinflusst, ziemlich flachgründig', 'manual'),
('n', 'Senkrecht durchwaschen, grund- oder hangwasserbeeinflusst, flachgründig und sehr flachgründig', 'n', 'n - Senkrecht durchwaschen, grund- oder hangwasserbeeinflusst, flachgründig und sehr flachgründig', 'manual'),
('o', 'Stauwassergeprägt, selten bis zur Oberfläche porengesättigt, mässig tiefgründig und tiefgründig', 'o', 'o - Stauwassergeprägt, selten bis zur Oberfläche porengesättigt, mässig tiefgründig und tiefgründig', 'manual'),
('p', 'Stauwassergeprägt, selten bis zur Oberfläche porengesättigt, ziemlich flachgründig und flachgründig', 'p', 'p - Stauwassergeprägt, selten bis zur Oberfläche porengesättigt, ziemlich flachgründig und flachgründig', 'manual'),
('q', 'Stauwassergeprägt, häufig bis zur Oberfläche porengesättigt, ziemlich flachgründig', 'q', 'q - Stauwassergeprägt, häufig bis zur Oberfläche porengesättigt, ziemlich flachgründig', 'manual'),
('r', 'Stauwassergeprägt, häufig bis zur Oberfläche porengesättigt, flachgründig und sehr flachgründig', 'r', 'r - Stauwassergeprägt, häufig bis zur Oberfläche porengesättigt, flachgründig und sehr flachgründig', 'manual'),
('s', 'Grund- oder hangwassergeprägt, selten bis zur Oberfläche porengesättigt, tiefgründig', 's', 's - Grund- oder hangwassergeprägt, selten bis zur Oberfläche porengesättigt, tiefgründig', 'manual'),
('t', 'Grund- oder hangwassergeprägt, selten bis zur Oberfläche porengesättigt, mässig tiefgründig', 't', 't - Grund- oder hangwassergeprägt, selten bis zur Oberfläche porengesättigt, mässig tiefgründig', 'manual'),
('u', 'Grund- oder hangwassergeprägt, selten bis zur Oberfläche porengesättigt, ziemlich flachgründig und flachgründig', 'u', 'u - Grund- oder hangwassergeprägt, selten bis zur Oberfläche porengesättigt, ziemlich flachgründig und flachgründig', 'manual'),
('v', 'Grund- oder hangwassergeprägt, häufig bis zur Oberfläche porengesättigt, mässig tiefgründig', 'v', 'v - Grund- oder hangwassergeprägt, häufig bis zur Oberfläche porengesättigt, mässig tiefgründig', 'manual'),
('w', 'Grund- oder hangwassergeprägt, häufig bis zur Oberfläche porengesättigt, ziemlich flachgründig und flachgründig', 'w', 'w - Grund- oder hangwassergeprägt, häufig bis zur Oberfläche porengesättigt, ziemlich flachgründig und flachgründig', 'manual'),
('x', 'Grund- oder hangwassergeprägt, meist bis zur Oberfläche porengesättigt, ziemlich flachgründig', 'x', 'x - Grund- oder hangwassergeprägt, meist bis zur Oberfläche porengesättigt, ziemlich flachgründig', 'manual'),
('y', 'Grund- oder hangwassergeprägt, meist bis zur Oberfläche porengesättigt, flachgründig und sehr flachgründig', 'y', 'y - Grund- oder hangwassergeprägt, meist bis zur Oberfläche porengesättigt, flachgründig und sehr flachgründig', 'manual'),
('z', 'Grund- oder hangwassergeprägt, dauernd bis zur Oberfläche', 'z', 'z - Grund- oder hangwassergeprägt, dauernd bis zur Oberfläche porengesättigt, sehr flachgründig', 'manual');

-- ============================================================================
-- Bodentyp
-- ============================================================================

DELETE FROM mig.map_bodentypcode;

INSERT INTO mig.map_bodentypcode
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('A', 'Auenboden', 'A', 'A - Auenboden', 'manual'),
('B', 'Braunerde', 'B', 'B - Braunerde', 'manual'),
('C', 'Humus-Karbonatgesteinsboden', 'C', 'C - Humus-Karbonatgesteinsboden', 'manual'),
('D', 'Humus-Mischgesteinsboden', 'D', 'D - Humus-Mischgesteinsboden', 'manual'),
('E', 'Saure Braunerde', 'E', 'E - Saure Braunerde', 'manual'),
('F', 'Fluvisol', 'F', 'F - Fluvisol', 'manual'),
('G', 'Fahlgley', 'G', 'G - Fahlgley', 'manual'),
('H', 'Humuspodzol', 'H', 'H - Humuspodsol', 'manual'),
('I', 'Pseudogley', 'I', 'I - Pseudogley', 'manual'),
('J', 'Karbonatgesteinsboden', 'J', 'J - Karbonatgesteinsboden', 'manual'),
('K', 'Kalkbraunerde', 'K', 'K - Kalkbraunerde', 'manual'),
('L', 'Silikatgesteinsboden', 'L', 'L - Silikatgesteinsboden', 'manual'),
('M', 'Moor', 'M', 'M - Moor', 'manual'),
('N', 'Halbmoor', 'N', 'N - Halbmoor', 'manual'),
('O', 'Regosol', 'O', 'O - Regosol', 'manual'),
('P', 'Eisenpodzol', 'P', 'P - Eisenpodsol', 'manual'),
('Q', 'Braunpodzol', 'Q', 'Q - Braunpodsol', 'manual'),
('R', 'Rendzina', 'R', 'R - Rendzina', 'manual'),
('S', 'Humus-Silikatboden', 'S', 'S - Humus-Silikatboden', 'manual'),
('T', 'Parabraunerde', 'T', 'T - Parabraunerde', 'manual'),
('U', 'Mischgesteinsboden', 'U', 'U - Mischgesteinsboden', 'manual'),
('V', 'Braunerde-Gley', 'V', 'V - Braunerde-Gley', 'manual'),
('W', 'Buntgley', 'W', 'W - Buntgley', 'manual'),
('X', 'Auffüllung', 'X', 'X - Auffüllung', 'manual'),
('Y', 'Braunerde-Pseudogley', 'Y', 'Y - Braunerde-Pseudogley', 'manual'),
('Z', 'Phäozem', 'Z', 'Z - Phäozem', 'manual');

-- ============================================================================
-- Geländeform
-- ============================================================================

DELETE FROM mig.map_gelaendeform;

INSERT INTO mig.map_gelaendeform
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('a', 'eben 0 - 5 Ebene, Plateau', 'a', 'a eben 0 - 5 Ebene, Plateau', 'manual'),
('b', 'gleichmässig geneigt 5 - 10 Terrasse, Plateau', 'b', 'b gleichmässig geneigt 5 - 10 Terrasse, Plateau', 'manual'),
('c', 'konvex - 10 flache Kuppe', 'c', 'c konvex - 10 flache Kuppe', 'manual'),
('d', 'konkav - 10 flache Mulde', 'd', 'd konkav - 10 flache Mulde', 'manual'),
('e', 'ungleichmässig 0 - 10 schwach wellig', 'e', 'e ungleichmässig 0 - 10 schwach wellig', 'manual'),
('f', 'gleichmässig geneigt 10 - 15 Flachhang', 'f', 'f gleichmässig geneigt 10 - 15 Flachhang', 'manual'),
('g', 'konvex - 15 Rücken, Kuppe, Oberhang', 'g', 'g konvex - 15 Rücken, Kuppe, Oberhang', 'manual'),
('h', 'konkav - 15 Mulde, Hangfuss', 'h', 'h konkav - 15 Mulde, Hangfuss', 'manual'),
('i', 'ungleichmässig 0 - 15 wellig', 'i', 'i ungleichmässig 0 - 15 wellig', 'manual'),
('j', 'gleichmässig geneigt 15 - 20 Flachhang', 'j', 'j gleichmässig geneigt 15 - 20 Flachhang', 'manual'),
('k', 'gleichmässig geneigt 20 - 25 Flachhang', 'k', 'k gleichmässig geneigt 20 - 25 Flachhang', 'manual'),
('l', 'konvex - 25 Rücken, Kuppe, Oberhang', 'l', 'l konvex - 25 Rücken, Kuppe, Oberhang', 'manual'),
('m', 'konkav - 25 Mulde, Hangmulde, Hangfuss', 'm', 'm konkav - 25 Mulde, Hangmulde, Hangfuss', 'manual'),
('n', 'ungleichmässig 0 - 25 stark wellig', 'n', 'n ungleichmässig 0 - 25 stark wellig', 'manual'),
('o', 'gleichmässig geneigt 25 - 35 Starkhang', 'o', 'o gleichmässig geneigt 25 - 35 Starkhang', 'manual'),
('p', 'konvex - 35 Oberhang, Kuppe, Rücken, Rippe', 'p', 'p konvex - 35 Oberhang, Kuppe, Rücken, Rippe', 'manual'),
('q', 'konkav - 35 Hangmulde, enge Mulde, Hangfuss', 'q', 'q konkav - 35 Hangmulde, enge Mulde, Hangfuss', 'manual'),
('r', 'ungleichmässig 0 - 35 schwach hügelig', 'r', 'r ungleichmässig 0 - 35 schwach hügelig', 'manual'),
('s', 'gleichmässig geneigt 35 - 50 Starkhang', 's', 's gleichmässig geneigt 35 - 50 Starkhang', 'manual'),
('t', 'konvex - 50 Oberhang, Kuppe, Rippe', 't', 't konvex - 50 Oberhang, Kuppe, Rippe', 'manual'),
('u', 'konkav - 50 Hangmulde, Hangfuss', 'u', 'u konkav - 50 Hangmulde, Hangfuss', 'manual'),
('v', 'ungleichmässig 0 - 50 hügelig', 'v', 'v ungleichmässig 0 - 50 hügelig', 'manual'),
('w', 'gleichmässig geneigt 50 - 75 Steilhang', 'w', 'w gleichmässig geneigt 50 - 75 Steilhang', 'manual'),
('x', 'ungleichmässig 0 - 75 kupiert', 'x', 'x ungleichmässig 0 - 75 kupiert', 'manual'),
('y', 'gleichmässig geneigt >75 extremer Steilhang', 'y', 'y gleichmässig geneigt >75 extremer Steilhang', 'manual'),
('z', 'ungleichmässig 0 -> 75 zerklüftet', 'z', 'z ungleichmässig 0 -> 75 zerklüftet', 'manual');

-- ============================================================================
-- Gefügeform
-- ============================================================================

DELETE FROM mig.map_gefuegeform;

INSERT INTO mig.map_gefuegeform
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('Ek', 'Einzelkorn', 'Ek', 'Ek - Einzelkorn', 'manual'),
('Ko', 'Kohärent', 'Ko', 'Ko - Kohärent', 'manual'),
('Kr', 'Krümel', 'Kr', 'Kr - Krümel', 'manual'),
('Gr', 'Granulate', 'Gr', 'Gr - Granulate', 'manual'),
('Sp', 'Subpolyeder', 'Sp', 'Sp - Subpolyeder', 'manual'),
('Po', 'Polyeder', 'Po', 'Po - Polyeder', 'manual'),
('Pr', 'Prismen', 'Pr', 'Pr - Prismen', 'manual'),
('Pl', 'Platten', 'Pl', 'Pl - Platten', 'manual'),
('Br', 'Bröckel', 'Br', 'Br - Bröckel', 'manual'),
('Fr', 'Fragmente', 'Fr', 'Fr - Fragmente', 'manual'),
('Klr', 'Klumpen rundlich', 'Klr', 'Klr - Klumpen rundlich', 'manual'),
('Klk', 'Klumpen kantig', 'Klk', 'Klk - Klumpen kantig', 'manual'),
('osm', 'schwamming', 'osm', 'osm - Schwammig', 'manual'),
('obl', 'blättrig', 'obl', 'obl - Blättrig', 'manual'),
('ofi', 'filzig', 'ofi', 'ofi - Filzig', 'manual');

-- ============================================================================
-- Gefügegrösse
-- ============================================================================

DELETE FROM mig.map_gefuegegroesse;

INSERT INTO mig.map_gefuegegroesse
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('1', '<2', 'kleiner_als_2', '1 <2', 'manual'),
('2', '2-5', 'von_2_bis_5', '2 2-5', 'manual'),
('3', '5-10', 'von_5_bis_10', '3 5-10', 'manual'),
('4', '10-20', 'von_10_bis_20', '4 10-20', 'manual'),
('5', '20-50', 'von_20_bis_50', '5 20-50', 'manual'),
('6', '50-100', 'von_50_bis_100', '6 50-100', 'manual'),
('7', '>100', 'groesser_als_100', '7 >100', 'manual');

-- ============================================================================
-- Humusform Wald
-- ============================================================================

DELETE FROM mig.map_humusform_wald;

INSERT INTO mig.map_humusform_wald
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('M', 'Mull', 'M', 'M - Mull', 'manual'),
('Mt', 'Mull, typisch', 'Mt', 'Mt - Mull, typisch', 'manual'),
('Mf', 'Mull, moderartig', 'Mf', 'Mf - Mull, moderartig', 'manual'),
('MHt', 'Feucht-Mull, typisch', 'MHt', 'MHt - Feucht-Mull, typisch', 'manual'),
('MHf', 'Feucht-Mull, moderartig', 'MHf', 'MHf Feucht-Mull, moderartig', 'manual'),
('F', 'Moder', 'F', 'F - Moder', 'manual'),
('Fm', 'Moder, mullartig', 'Fm', 'Fm - Moder, mullartig', 'manual'),
('Fa', 'Moder, typisch, feinhumusarm', 'Fa', 'Fa - Moder, typisch, feinhumusarm', 'manual'),
('Fr', 'Moder, typisch, feinhumusreich', 'Fr', 'Fr - Moder, typisch, feinhumusreich', 'manual'),
('Fl', 'Moder, rohhumusartig', 'Fl', 'Fl - Moder, rohhumusartig', 'manual'),
('FHm', 'Feucht-Moder, mullartig', 'FHm', 'FHm - Feucht-Moder, mullartig', 'manual'),
('FHa', 'Feucht-Moder, typisch, feinhumusarm', 'FHa', 'FHa - Feucht-Moder, typisch, feinhumusarm', 'manual'),
('FHr', 'Feucht-Moder, typisch, feinhumusreich', 'FHr', 'FHr - Feucht-Moder, typisch, feinhumusreich', 'manual'),
('FHl', 'Feucht-Moder, rohhumusartig', 'FHl', 'FHl - Feucht-Moder, rohhumusartig', 'manual'),
('L', 'Rohhumus', 'L', 'L - Rohhumus', 'manual'),
('La', 'Rohhumus, typisch, feinhumusarm', 'La', 'La - Rohhumus, typisch, feinhumusarm', 'manual'),
('Lr', 'Rohhumus, typisch, feinhumusreich', 'Lr', 'Lr - Rohhumus, typisch feinhumusreich', 'manual'),
('LHa', 'Feucht-Rohhumus, typisch, feinhumusarm', 'LHa', 'LHa - Feucht-Rohhumus, typisch, feinhumusarm', 'manual'),
('Lhr', 'Feucht-Rohhumus, typisch, feinhumusreich', 'Lhr', 'Lhr - Feucht-Rohhumus, typisch, feinhumusreich', 'manual'),
('A', 'Anmoor', 'A', 'A - Anmoor', 'manual'),
('T', 'Torf', 'T', 'T - Torf', 'manual');

-- ============================================================================
-- Kalkgehalt
-- ============================================================================

DELETE FROM mig.map_kalkgehalt;

INSERT INTO mig.map_kalkgehalt
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('0', 'kein CaCO3', 'kein_kalk', '0 kein CaCO3', 'manual'),
('1', 'nur  im Skelett CaCO3', 'nur_im_skelett', '1 nur im Skelett CaCO3', 'manual'),
('2', 'CaCO3 +/- vorhanden, gel. Aufbrausen', 'sehr_wenig', '2 CaCO3 +/- vorhanden, gel. Aufbrausen', 'manual'),
('3', 'schwaches Aufbrausen', 'wenig', '3 schwaches Aufbrausen', 'manual'),
('4', 'mittleres Aufbrausen', 'mittel', '4 mittleres Aufbrausen', 'manual'),
('5', 'starkes anhaltendes Aufbrausen', 'viel', '5 starkes anhaltendes Aufbrausen', 'manual');

-- ============================================================================
-- Körnungsklasse
-- Nur die fachlich klaren Werte 1..13.
-- Die alten "Wert aus Datenuebernahme ..."-Codes bewusst NICHT gemappt.
-- ============================================================================

DELETE FROM mig.map_koernungsklasse;

INSERT INTO mig.map_koernungsklasse
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('1', 'Sand', 'sand', '1 Sand S', 'manual'),
('2', 'schluffiger Sand', 'schluffiger_sand', '2 schluffiger Sand uS', 'manual'),
('3', 'lehmiger Sand', 'lehmiger_sand', '3 lehmiger Sand lS', 'manual'),
('4', 'lehmreicher Sand', 'lehmreicher_sand', '4 lehmreicher Sand lrS', 'manual'),
('5', 'sandiger Lehm', 'sandiger_lehm', '5 sandiger Lehm sL', 'manual'),
('6', 'Lehm', 'lehm', '6 Lehm L', 'manual'),
('7', 'toniger Lehm', 'toniger_lehm', '7 toniger Lehm tL', 'manual'),
('8', 'lehmiger Ton', 'lehmiger_ton', '8 lehmiger Ton lT', 'manual'),
('9', 'Ton', 'ton', '9 Ton T', 'manual'),
('10', 'sandiger Schluff', 'sandiger_schluff', '10 sandiger Schluff sU', 'manual'),
('11', 'Schluff', 'schluff', '11 Schluff U', 'manual'),
('12', 'lehmiger Schluff', 'lehmiger_schluff', '12 lehmiger Schluff lU', 'manual'),
('13', 'toniger Schluff', 'toniger_schluff', '13 toniger Schluff tU', 'manual');

-- ============================================================================
-- Skelettgehalt Landwirtschaft
-- Nur die klaren Fachcodes.
-- Die alten Datenübernahme-Codes 20..26 bewusst NICHT gemappt.
-- ============================================================================

DELETE FROM mig.map_skelettgehalt_landwirtschaft;

INSERT INTO mig.map_skelettgehalt_landwirtschaft
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('0', 'skelettfrei,-arm skf,ska <5', 'skelettfrei', '0 skelettfrei,-arm <5', 'manual'),
('1', 'schwach skeletthaltig sskh 5-10', 'schwach_skeletthaltig', '1 schwach skeletthaltig 5-10', 'manual'),
('2', 'kieshaltig kh 10-20', 'kieshaltig', '2 kieshaltig 10-20', 'manual'),
('3', 'steinhaltig sh 10-20', 'steinhaltig', '3 steinhaltig 10-20', 'manual'),
('4', 'stark kieshaltig stkh 20-30', 'stark_kieshaltig', '4 stark kieshaltig 20-30', 'manual'),
('5', 'stark steinhaltig stsh 20-30', 'stark_steinhaltig', '5 stark steinhaltig 20-30', 'manual'),
('6', 'kiesreich kr 30-50', 'kiesreich', '6 kiesreich 30-50', 'manual'),
('7', 'steinreich sr 30-50', 'steinreich', '7 steinreich 30-50', 'manual'),
('8', 'Kies >50', 'kies', '8 Kies >50', 'manual'),
('9', 'Geröll, Blöcke >50', 'geroell', '9 Geröll, Blöcke >50', 'manual');

-- ============================================================================
-- Skelettgehalt Wald
-- ============================================================================

DELETE FROM mig.map_skelettgehalt_wald;

INSERT INTO mig.map_skelettgehalt_wald
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('0', 'skelettfrei, skelettarm skf,ska 0-5', 'skelettfrei', '0 skelettfrei, skelettarm 0-5', 'manual'),
('1', 'schwach skeletthaltig sskh 5-10', 'schwach_skeletthaltig', '1 schwach skeletthaltig 5-10', 'manual'),
('2', 'skeletthaltig sh 10-20', 'skeletthaltig', '2 skeletthaltig 10-20', 'manual'),
('4', 'stark skeletthaltig ssh 20-30', 'stark_skeletthaltig', '4 stark skeletthaltig 20-30', 'manual'),
('6', 'skelettreich sr 30-50', 'skelettreich', '6 skelettreich 30-50', 'manual'),
('8', 'Kies, Geröll, Geschiebe > 50', 'kies', '8 Kies, Geröll, Geschiebe > 50', 'manual');

-- ============================================================================
-- Untertyp E
-- ============================================================================

DELETE FROM mig.map_untertyp_e;

INSERT INTO mig.map_untertyp_e
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('E0', 'alkalisch > 6,7', 'E0', 'E0 - alkalisch > 6,7', 'manual'),
('E1', 'neutral 6,2 - 6,7', 'E1', 'E1 - neutral 6,2 - 6,7', 'manual'),
('E2', 'schwach sauer 5,1 - 6,1', 'E2', 'E2 - schwach sauer 5,1 - 6,1', 'manual'),
('E3', 'sauer 4,3 - 5,0', 'E3', 'E3 - sauer 4,3 - 5,0', 'manual'),
('E4', 'stark sauer 3,3 - 4,2', 'E4', 'E4 - stark sauer 3,3 - 4,2', 'manual'),
('E5', 'sehr stark sauer < 3,3', 'E5', 'E5 - sehr stark sauer < 3,3', 'manual');

-- ============================================================================
-- Untertyp I
-- ============================================================================

DELETE FROM mig.map_untertyp_i;

INSERT INTO mig.map_untertyp_i
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('I1', 'schwach pseudogleyig', 'I1', 'I1 - schwach pseudogleyig', 'manual'),
('I2', 'pseudogleyig', 'I2', 'I2 - pseudogleyig', 'manual'),
('I3', 'stark pseudogleyig', 'I3', 'I3 - stark pseudogleyig', 'manual'),
('I4', 'sehr stark pseudogleyig', 'I4', 'I4 - sehr stark pseudogleyig', 'manual');

-- ============================================================================
-- Untertyp G
-- ============================================================================

DELETE FROM mig.map_untertyp_g;

INSERT INTO mig.map_untertyp_g
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('G1', 'grundfeucht', 'G1', 'G1 - grundfeucht', 'manual'),
('G2', 'schwach gleyig', 'G2', 'G2 - schwach gleyig', 'manual'),
('G3', 'gleyig', 'G3', 'G3 - gleyig', 'manual'),
('G4', 'stark gleyig', 'G4', 'G4 - stark gleyig', 'manual'),
('G5', 'sehr stark gleyig', 'G5', 'G5 - sehr stark gleyig', 'manual'),
('G6', 'extrem gleyig', 'G6', 'G6 - extrrem gleyig', 'manual');

-- ============================================================================
-- Untertyp R
-- ============================================================================

DELETE FROM mig.map_untertyp_r;

INSERT INTO mig.map_untertyp_r
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('R1', 'schwach grundnass', 'R1', 'R1 - schwach grundnass', 'manual'),
('R2', 'grundnass', 'R2', 'R2 - grundnass', 'manual'),
('R3', 'stark grundnass', 'R3', 'R3 - stark grundnass', 'manual'),
('R4', 'sehr stark grundnass', 'R4', 'R4 - sehr stark grundnass', 'manual'),
('R5', 'sumpfig', 'R5', 'R5 - sumpfig', 'manual');

-- ============================================================================
-- Untertyp K
-- ============================================================================

DELETE FROM mig.map_untertyp_k;

INSERT INTO mig.map_untertyp_k
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('KE', 'teilweise entkarbonatet', 'KE', 'KE - teilweise entkarbonatet', 'manual'),
('KH', 'karbonathaltig', 'KH', 'KH - karbonathaltig', 'manual'),
('KR', 'karbonatreich', 'KR', 'KR - karbonatreich', 'manual'),
('KF', 'kalkflaumig', 'KF', 'KF - kalkflaumig', 'manual'),
('KT', 'kalktuffig', 'KT', 'KT - kalktuffig', 'manual'),
('KA', 'natriumhaltig', 'KA', 'KA - natriumhaltig', 'manual');

-- ============================================================================
-- Untertyp P
-- ============================================================================

DELETE FROM mig.map_untertyp_p;

INSERT INTO mig.map_untertyp_p
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('PE', 'erodiert', 'PE', 'PE - erodiert', 'manual'),
('PK', 'kolluvial', 'PK', 'PK - kolluvial', 'manual'),
('PM', 'anthropogen', 'PM', 'PM - anthropogen', 'manual'),
('PA', 'alluvial', 'PA', 'PA - alluvial', 'manual'),
('PU', 'überschüttet', 'PU', 'PU - überschüttet', 'manual'),
('PS', 'auf Seekreide', 'PS', 'PS - auf Seekreide', 'manual'),
('PP', 'polygenetisch', 'PP', 'PP - polygenetisch', 'manual'),
('PL', 'aeolisch', 'PL', 'PL - aeolisch', 'manual'),
('PT', 'auf Torfzwischenschicht(-en)', 'PT', 'PT - auf Torfzwischenschicht(-en)', 'manual'),
('PD', 'stark durchlässiger Untergrund', 'PD', 'PD - stark durchlässiger Untergrund', 'manual'),
('PB', 'terrassiert', 'PB', 'PB - terrassiert', 'manual');

-- ============================================================================
-- Untertyp Diverse
-- OF alt -> OFF neu ist der einzige echte Sonderfall.
-- ============================================================================

DELETE FROM mig.map_untertyp_diverse;

INSERT INTO mig.map_untertyp_diverse
(src_code, src_beschreibung, tgt_ilicode, tgt_dispname, match_rule)
VALUES
('VL', 'lithosolisch (< 10 cm u.T.)', 'VL', 'VL - lithosolisch (< 10 cm u.T.)', 'manual'),
('VF', 'auf Fels (10 - 60 cm u.T.)', 'VF', 'VF - auf Fels (10 - 60 cm u.T.)', 'manual'),
('VU', 'kluftig', 'VU', 'VU - kluftig', 'manual'),
('VA', 'karstig', 'VA', 'VA - karstig', 'manual'),
('VB', 'blockig', 'VB', 'VB - blockig', 'manual'),
('VK', 'psephitisch (extrem kiesig)', 'VK', 'VK - psephitisch (extrem kiesig)', 'manual'),
('VS', 'psammitisch (extrem sandig)', 'VS', 'VS - psammitisch (extrem sandig)', 'manual'),
('VT', 'pelitisch (extrem feinkörnig)', 'VT', 'VT - pelitisch (extrem feinkörnig)', 'manual'),
('FB', 'verbraunt', 'FB', 'FB - verbraunt', 'manual'),
('FP', 'podsolig', 'FP', 'FP - podsolig', 'manual'),
('FE', 'eisenhüllig', 'FE', 'FE - eisenhüllig', 'manual'),
('FQ', 'quarzkörnig', 'FQ', 'FQ - quarzkörnig', 'manual'),
('FM', 'marmoriert', 'FM', 'FM - marmoriert', 'manual'),
('FK', 'konkretionär', 'FK', 'FK - konkretionär', 'manual'),
('FG', 'graufleckig marmoriert', 'FG', 'FG - graufleckig marmoriert', 'manual'),
('FN', 'nassgebleicht', 'FN', 'FN - nassgebleicht', 'manual'),
('FR', 'rubefiziert', 'FR', 'FR - rubefiziert', 'manual'),
('ZS', 'krümelig, bröcklig, (stabil)', 'ZS', 'ZS - krümelig, bröcklig (stabil)', 'manual'),
('ZK', 'klumpig', 'ZK', 'ZK - klumpig', 'manual'),
('ZT', 'tonhüllig', 'ZT', 'ZT - tonhüllig', 'manual'),
('ZV', 'vertisolisch', 'ZV', 'ZV - vertisolisch', 'manual'),
('ZL', 'labil aggregiert', 'ZL', 'ZL - labil aggregiert', 'manual'),
('ZP', 'pelosolisch', 'ZP', 'ZP - pelosolisch', 'manual'),
('L1', 'locker', 'L1', 'L1 - locker', 'manual'),
('L2', 'verdichtet', 'L2', 'L2 - verdichtet', 'manual'),
('L3', 'kompakt', 'L3', 'L3 - kompakt', 'manual'),
('L4', 'verhärtet', 'L4', 'L4 - verhärtet', 'manual'),
('LM', 'mechanische Verdichtung', 'LM', 'LM - mechanisch verdichtet', 'manual'),
('DD', 'drainiert', 'DD', 'DD - drainiert', 'manual'),
('ML', 'rohhumos', 'ML', 'ML - rohhumos', 'manual'),
('MF', 'modrighumos', 'MF', 'MF - modrighumos', 'manual'),
('MA', 'humusarm', 'MA', 'MA - humusarm', 'manual'),
('MM', 'mullhumos', 'MM', 'MM - mullhumos', 'manual'),
('MH', 'huminstoffreich', 'MH', 'MH - huminstoffreich', 'manual'),
('OM', 'anmorig', 'OM', 'OM - anmoorig', 'manual'),
('OS', 'sapro-organisch', 'OS', 'OS - sapro-organisch', 'manual'),
('OA', 'antorfig', 'OA', 'OA - antorfig', 'manual'),
('OF', 'flachtorfig', 'OFF', 'OF - flachtorfig', 'manual'),
('OT', 'tieftorfig', 'OT', 'OT - tieftorfig', 'manual'),
('T1', 'schwach ausgeprägt', 'T1', 'T1 - schwach ausgeprägt', 'manual'),
('T2', 'ausgeprägt', 'T2', 'T2 - ausgeprägt', 'manual'),
('T3', 'degradiert', 'T3', 'T3 - degradiert', 'manual'),
('HD', 'diffus', 'HD', 'HD - diffus', 'manual'),
('HA', 'abrupt horizontiert', 'HA', 'HA - abrupt horizontiert', 'manual'),
('HU', 'unregelmässig horizontiert', 'HU', 'HU - unregelmässig horizontiert', 'manual'),
('HB', 'biologisch durchmischt', 'HB', 'HB - biologisch durchmischt', 'manual'),
('HT', 'tiefgepflügt, rigolt', 'HT', 'HT - tiefgepflügt, rigolt', 'manual');
