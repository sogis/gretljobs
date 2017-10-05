select distinct on (liegenschaften_projliegenschaft.geometrie)
liegenschaften_projliegenschaft.geometrie, liegenschaften_projgrundstueck.nbident, liegenschaften_projgrundstueck.nummer,
liegenschaften_projgrundstueck.art,liegenschaften_projgrundstueck.art_txt as art_text, liegenschaften_projliegenschaft.flaechenmass, liegenschaften_projgrundstueck.egris_egrid as egrid,
liegenschaften_projgrundstueck.gem_bfs, liegenschaften_projgrundstueckpos.pos, 
       case when liegenschaften_projgrundstueckpos.ori<=300 THEN 90-liegenschaften_projgrundstueckpos.ori/400*360
       else 360-liegenschaften_projgrundstueckpos.ori/400*360+90
       end as orientierung,liegenschaften_projgrundstueckpos.hali, 
liegenschaften_projgrundstueckpos.hali_txt as hali_text, liegenschaften_projgrundstueckpos.vali, liegenschaften_projgrundstueckpos.vali_txt as vali_text,now() as importdatum, 
to_date(liegenschaften_lsnachfuehrung.gueltigereintrag,'YYYYMMDD') as nachfuehrung
from av_avdpool_ng.liegenschaften_projgrundstueck
left join av_avdpool_ng.liegenschaften_projliegenschaft
on liegenschaften_projliegenschaft.projliegenschaft_von=liegenschaften_projgrundstueck.tid
left join av_avdpool_ng.liegenschaften_projgrundstueckpos
on liegenschaften_projgrundstueckpos.projgrundstueckpos_von=liegenschaften_projgrundstueck.tid
left join av_avdpool_ng.liegenschaften_lsnachfuehrung
on liegenschaften_lsnachfuehrung.tid=liegenschaften_projgrundstueck.entstehung
where liegenschaften_projliegenschaft.geometrie is not NULL
UNION
select distinct on (liegenschaften_projselbstrecht.geometrie)
liegenschaften_projselbstrecht.geometrie, liegenschaften_projgrundstueck.nbident, liegenschaften_projgrundstueck.nummer, 
liegenschaften_projgrundstueck.art, liegenschaften_projgrundstueck.art_txt as art_text, liegenschaften_projselbstrecht.flaechenmass, liegenschaften_projgrundstueck.egris_egrid as egrid,
liegenschaften_projgrundstueck.gem_bfs, liegenschaften_projgrundstueckpos.pos,
       case when liegenschaften_projgrundstueckpos.ori<=300 THEN 90-liegenschaften_projgrundstueckpos.ori/400*360
       else 360-liegenschaften_projgrundstueckpos.ori/400*360+90
       end as orientierung, liegenschaften_projgrundstueckpos.hali, 
liegenschaften_projgrundstueckpos.hali_txt as hali_text,liegenschaften_projgrundstueckpos.vali, liegenschaften_projgrundstueckpos.vali_txt as vali_text,now() as importdatum, 
to_date(liegenschaften_lsnachfuehrung.gueltigereintrag,'YYYYMMDD') as nachfuehrung
from av_avdpool_ng.liegenschaften_projgrundstueck
left join av_avdpool_ng.liegenschaften_projgrundstueckpos
on liegenschaften_projgrundstueckpos.projgrundstueckpos_von=liegenschaften_projgrundstueck.tid
right join av_avdpool_ng.liegenschaften_projselbstrecht
on liegenschaften_projselbstrecht.projselbstrecht_von=liegenschaften_projgrundstueck.tid
left join av_avdpool_ng.liegenschaften_lsnachfuehrung
on liegenschaften_lsnachfuehrung.tid=liegenschaften_projgrundstueck.entstehung
where liegenschaften_projselbstrecht.geometrie is not NULL;
