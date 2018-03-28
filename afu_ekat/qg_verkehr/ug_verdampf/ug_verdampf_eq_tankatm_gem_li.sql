SELECT k.ogc_fid, k.xkoord, k.ykoord, k.wkb_geometry, k.gem_bfs, 
        CASE
            WHEN k.besch_gesamt > 0::double precision OR k.b15btot > 0 THEN (k.b15btot::double precision + k.besch_gesamt)::numeric * ((0.6666666 * ((( SELECT efak_kalt_tank.efak
               FROM ekat2015.efak_kalt_tank
              WHERE efak_kalt_tank.efak_code = 2 AND efak_kalt_tank.fhz_art = 'LNF'::text))::numeric * k.anz_lnf_li::numeric * 365::numeric) / 1000::numeric)::double precision / (k.besch_gesamt_gem::double precision + k.einw_gem::double precision))::numeric
            ELSE 0::numeric
        END AS emiss_nmvoc
   FROM ( SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
            e.besch_gesamt_gem, h.einw_gem, f.anz_lnf_li, 
                CASE
                    WHEN g.b15btot > 0 THEN g.b15btot
                    ELSE 0
                END AS b15btot, 
                CASE
                    WHEN b.besch_gesamt::double precision > 0::double precision THEN b.besch_gesamt::real
                    ELSE 0::real
                END AS besch_gesamt
           FROM ekat2015.ha_raster_100 a
      LEFT JOIN ( SELECT bz_besch_2_und3_sektor.x, 
                    bz_besch_2_und3_sektor.y, 
                    bz_besch_2_und3_sektor.besch_gesamt
                   FROM ekat2015.bz_besch_2_und3_sektor) b ON a.xkoord = b.x::numeric AND a.ykoord = b.y::numeric
   LEFT JOIN ( SELECT vz15_minus_sammel_ha.x_koord, 
               vz15_minus_sammel_ha.y_koord, vz15_minus_sammel_ha.b15btot
              FROM geostat.vz15_minus_sammel_ha) g ON a.xkoord = g.x_koord::numeric AND a.ykoord = g.y_koord::numeric
   LEFT JOIN ( SELECT sum(a.besch_gesamt) AS besch_gesamt_gem, b.gem_bfs
         FROM ekat2015.bz_besch_2_und3_sektor a
    LEFT JOIN ekat2015.ha_raster_100 b ON a.x::numeric = b.xkoord AND a.y::numeric = b.ykoord
   GROUP BY b.gem_bfs) e ON a.gem_bfs = e.gem_bfs
   LEFT JOIN ( SELECT c.gem_bfs, sum(d.b15btot) AS einw_gem
    FROM ekat2015.ha_raster_100 c, geostat.vz15_minus_sammel_ha d
   WHERE c.xkoord = d.x_koord::numeric AND c.ykoord = d.y_koord::numeric
   GROUP BY c.gem_bfs) h ON a.gem_bfs = h.gem_bfs
   LEFT JOIN ( SELECT gmde.ogc_fid, gmde.gem_bfs, gmde.anz_lnf_li
   FROM ekat2015.gmde
  WHERE gmde.gem_bfs >= 2401 AND gmde.gem_bfs <= 2622) f ON a.gem_bfs = f.gem_bfs
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord) k
  ORDER BY k.xkoord, k.ykoord;
