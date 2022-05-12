update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    eindolung_txt = (select
                         case 
                             when eindolung is true 
                             then 'ja'
                             else 'nein'
                         end)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    breitenvariabilitaet_txt = (select 
                                    dispname 
                                from 
                                    afu_gewaesser_oekomorphologie_pub_v1.varbreite varbreite
                                where 
                                    oekomorph.breitenvariabilitaet = varbreite.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    tiefenvariabilitaet_txt = (select 
                                    dispname 
                                from 
                                    afu_gewaesser_oekomorphologie_pub_v1.vartiefe vartiefe
                                where 
                                    oekomorph.tiefenvariabilitaet = vartiefe.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    sohlenverbauung_txt = (select 
                               dispname 
                           from 
                               afu_gewaesser_oekomorphologie_pub_v1.sohlverbau sohlverbau
                           where 
                               oekomorph.sohlenverbauung = sohlverbau.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    sohlmaterial_txt = (select 
                            dispname 
                        from 
                            afu_gewaesser_oekomorphologie_pub_v1.sohlmaterial sohlmaterial
                        where 
                            oekomorph.sohlmaterial = sohlmaterial.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    boeschungsfussverbaulinks_txt = (select 
                                         dispname 
                                     from 
                                         afu_gewaesser_oekomorphologie_pub_v1.boeschverbau boeschverbau
                                     where 
                                         oekomorph.boeschungsfussverbaulinks = boeschverbau.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    boeschungsfussverbaurechts_txt = (select 
                                          dispname 
                                      from 
                                          afu_gewaesser_oekomorphologie_pub_v1.boeschverbau boeschverbau
                                      where 
                                          oekomorph.boeschungsfussverbaurechts = boeschverbau.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    materiallinks_txt = (select 
                             dispname 
                         from 
                             afu_gewaesser_oekomorphologie_pub_v1.boeschmaterial boeschmaterial
                         where 
                             oekomorph.materiallinks = boeschmaterial.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    materialrechts_txt = (select 
                              dispname 
                          from 
                              afu_gewaesser_oekomorphologie_pub_v1.boeschmaterial boeschmaterial
                          where 
                              oekomorph.materialrechts = boeschmaterial.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    uferbeschaffenheitlinks_txt = (select 
                                       dispname 
                                   from 
                                       afu_gewaesser_oekomorphologie_pub_v1.ufer ufer
                                   where 
                                       oekomorph.uferbeschaffenheitlinks = ufer.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    uferbeschaffenheitrechts_txt = (select 
                                        dispname 
                                    from 
                                        afu_gewaesser_oekomorphologie_pub_v1.ufer ufer
                                    where 
                                        oekomorph.uferbeschaffenheitrechts = ufer.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    algenbewuchs_txt = (select 
                            dispname 
                        from 
                            afu_gewaesser_oekomorphologie_pub_v1.bewalgen algen
                        where 
                            oekomorph.algenbewuchs = algen.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    makrophytenbewuchs_txt = (select 
                                  dispname 
                              from 
                                  afu_gewaesser_oekomorphologie_pub_v1.bewmakro makro
                              where 
                                  oekomorph.makrophytenbewuchs = makro.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    totholz_txt = (select 
                       dispname 
                   from 
                       afu_gewaesser_oekomorphologie_pub_v1.totholz totholz
                   where 
                       oekomorph.totholz = totholz.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    ueberhvegetation_txt = (select 
                                dispname 
                            from 
                                afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie_ueberhvegetation ueberhveg
                            where 
                                oekomorph.ueberhvegetation = ueberhveg.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    domkorngroesse_txt = (select 
                              dispname 
                          from 
                              afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie_domkorngroesse domkorngr
                          where 
                              oekomorph.domkorngroesse = domkorngr.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    nutzungumlandlinks_txt = (select 
                                  dispname 
                              from 
                                  afu_gewaesser_oekomorphologie_pub_v1.umfeldtyp umland
                              where 
                                  oekomorph.nutzungumlandlinks = umland.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    nutzungumlandrechts_txt = (select 
                                   dispname 
                               from 
                                   afu_gewaesser_oekomorphologie_pub_v1.umfeldtyp umland
                               where 
                                   oekomorph.nutzungumlandrechts = umland.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    vielenatabstuerze_txt = (select
                             case 
                                 when vielenatabstuerze is true 
                                 then 'ja'
                                 else 'nein'
                             end)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    klasse_txt = (select 
                      dispname 
                  from 
                      afu_gewaesser_oekomorphologie_pub_v1.klasse klasse
                  where 
                      oekomorph.klasse = klasse.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    beurteilungsuferbreitelinks_txt = (select 
                                           dispname 
                                       from 
                                           afu_gewaesser_oekomorphologie_pub_v1.beurteilungsuferbreite beurteilungufer
                                       where 
                                           oekomorph.beurteilungsuferbreitelinks = beurteilungufer.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie oekomorph
set 
    beurteilungsuferbreiterechts_txt = (select 
                                           dispname 
                                       from 
                                           afu_gewaesser_oekomorphologie_pub_v1.beurteilungsuferbreite beurteilungufer
                                       where 
                                           oekomorph.beurteilungsuferbreiterechts = beurteilungufer.ilicode)
;