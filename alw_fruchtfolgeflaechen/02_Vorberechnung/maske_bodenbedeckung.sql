with humusiert as (

    select 
        st_union(geometrie) as geometrie
    from 
        agi_mopublic_pub.mopublic_bodenbedeckung
    where 
        art_txt IN ('Acker_Wiese', 'Weide', 'Reben', 'Obstkultur', 'uebrige_humusierte')
        and 
        bfs_nr = ${bfsnr}
), 

bestockt as (
    select 
        st_union(st_buffer(geometrie,6)) as geometrie
    from 
        agi_mopublic_pub.mopublic_bodenbedeckung
    where 
        art_txt in ('geschlossener_Wald', 'Parkanlage_bestockt', 'Hecke', 'uebrige_bestockte') 
        and 
        bfs_nr = ${bfsnr}
),

gebaeude as (
    select 
        st_union(st_buffer(geometrie,3)) as geometrie
    from 
        agi_mopublic_pub.mopublic_bodenbedeckung
    where 
        art_txt in ('Gebaeude') 
        and 
        bfs_nr = ${bfsnr}
), 

gewaesser as (
    select 
        st_union(st_buffer(geometrie,6)) as geometrie
    from 
        agi_mopublic_pub.mopublic_bodenbedeckung
    where 
        art_txt in ('fliessendes Gewaesser') 
        and 
        bfs_nr = ${bfsnr}
), 

strassen as (
    select 
        st_union(st_buffer(geometrie,1)) as geometrie
    from 
        agi_mopublic_pub.mopublic_bodenbedeckung
    where 
        art_txt in ('Strasse_Weg','Bahn','Trottoir','Verkehrsinsel','Flugplatz') 
        and 
        bfs_nr = ${bfsnr}
), 

nicht_bestockt as (

    select distinct 
        case 
            when bestockt.geometrie is not null 
            then st_difference(humusiert.geometrie,bestockt.geometrie) 
            else humusiert.geometrie 
            end as geometrie
    from 
        humusiert, 
        bestockt
 ), 
 
 nicht_gebaeude as (

    select distinct 
        case when gebaeude.geometrie is not null 
        then st_difference(nicht_bestockt.geometrie,gebaeude.geometrie) 
        else nicht_bestockt.geometrie 
        end as geometrie
    from 
        nicht_bestockt, 
        gebaeude 
 ), 
 
 nicht_gewaesser as (

    select distinct 
        case 
            when gewaesser.geometrie is not null 
            then st_difference(nicht_gebaeude.geometrie,gewaesser.geometrie) 
            else nicht_gebaeude.geometrie 
            end as geometrie
    from 
        nicht_gebaeude, 
        gewaesser 
  ),  
 
  nicht_strassen as (

    select distinct 
        case 
            when strassen.geometrie is not null
            then st_difference(nicht_gewaesser.geometrie,strassen.geometrie) 
            else nicht_gewaesser.geometrie 
            end as geometrie
    from 
        nicht_gewaesser,
        strassen
 )
 
INSERT INTO alw_fruchtfolgeflaechen.fff_maske_bodenbedeckung (geometrie,bfs_nr,anrechenbar)
    (
     select 
         (st_dump(nicht_strassen.geometrie)).geom as geometrie, 
         ${bfsnr} as bfs_nr, 
         1 as anrechenbar
     from 
         nicht_strassen
    );