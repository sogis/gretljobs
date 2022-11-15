--Tabelle zuerst leeren
DELETE FROM ${DB_Schema_StatPopEnt}.hektarraster_statpopent;

INSERT INTO 
  ${DB_Schema_StatPopEnt}.hektarraster_statpopent
     (geometrie,statyear,population_onlypermantresidents,population_total,employees_fulltimeequivalents,employees_total)
     
WITH grid_temp AS (
  --Grid über Kanton generieren
  SELECT 
    (
      ST_SquareGrid(100, geometrie)
    ).* 
  FROM 
    ${DB_Schema_Hoheitsgr}.hoheitsgrenzen_kantonsgrenze kg
), 
--nur Zellen behalten die tatsächlich eine Intersection mit Kanton haben
grid AS (
  SELECT 
    g.geom AS geometrie 
  FROM 
    grid_temp g 
    LEFT JOIN ${DB_Schema_Hoheitsgr}.hoheitsgrenzen_kantonsgrenze kg ON ST_Intersects(g.geom, kg.geometrie) 
  WHERE 
    kg.kantonskuerzel IS NOT NULL
), 
--we do separate steps for each join - seems to run faster than all-in-one step
pperm AS (
  --permanent residents
  SELECT 
    g.geometrie, 
    count(pp.*) AS population_onlypermantresidents --,
  FROM 
    grid g 
    LEFT JOIN ${DB_Schema_StatPopEnt}.statpop pp ON ST_Within(pp.geometrie, g.geometrie) 
    AND pp.populationtype = 1 
  GROUP BY 
    g.geometrie
), 
ptot AS (
  --total population
  SELECT 
    g.geometrie, 
    g.population_onlypermantresidents, 
    count(p.*) AS population_total 
  FROM 
    pperm g 
    LEFT JOIN ${DB_Schema_StatPopEnt}.statpop p ON ST_Within(p.geometrie, g.geometrie) 
  GROUP BY 
    g.geometrie, 
    g.population_onlypermantresidents
), 
empft AS (
  --employees_fulltimeequivalents
  SELECT 
    g.geometrie, 
    g.population_onlypermantresidents, 
    g.population_total, 
    COALESCE(
      SUM(eft.empfte), 
      0
    ) AS employees_fulltimeequivalents 
  FROM 
    ptot g 
    LEFT JOIN ${DB_Schema_StatPopEnt}.statent eft ON ST_Within(eft.geometrie, g.geometrie) 
  GROUP BY 
    g.geometrie, 
    g.population_onlypermantresidents, 
    g.population_total
)
--finally also join employees_total
SELECT 
  g.geometrie AS geometrie,
  ${statyear} AS statyear,
  g.population_onlypermantresidents,
  g.population_total, 
  g.employees_fulltimeequivalents, 
  COALESCE(
    SUM(etot.emptot), 
    0
  ) AS employees_total 
FROM 
  empft g 
  LEFT JOIN ${DB_Schema_StatPopEnt}.statent etot ON ST_Within(etot.geometrie, g.geometrie) 
GROUP BY 
  g.geometrie, 
  g.population_onlypermantresidents, 
  g.population_total, 
  g.employees_fulltimeequivalents
;
