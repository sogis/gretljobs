select distinct on (liegenschaften_liegenschaft.geometrie)
liegenschaften_liegenschaft.geometrie, liegenschaften_grundstueck.nbident, liegenschaften_grundstueck.nummer, liegenschaften_grundstueck.art,
liegenschaften_grundstueck.art_txt as art_text, liegenschaften_liegenschaft.flaechenmass, liegenschaften_grundstueck.egris_egrid as egrid, liegenschaften_grundstueck.gem_bfs, 
liegenschaften_grundstueckpos.pos, 
       case when liegenschaften_grundstueckpos.ori<=300 THEN 90-liegenschaften_grundstueckpos.ori/400*360
       else 360-liegenschaften_grundstueckpos.ori/400*360+90
       end as orientierung, liegenschaften_grundstueckpos.hali, liegenschaften_grundstueckpos.hali_txt as hali_text,
liegenschaften_grundstueckpos.vali, liegenschaften_grundstueckpos.vali_txt as vali_text,now() as importdatum, to_date(liegenschaften_lsnachfuehrung.gueltigereintrag,'YYYYMMDD') as nachfuehrung
from av_avdpool_ng.liegenschaften_grundstueck
left join av_avdpool_ng.liegenschaften_liegenschaft
on liegenschaften_liegenschaft.liegenschaft_von=liegenschaften_grundstueck.tid
left join av_avdpool_ng.liegenschaften_grundstueckpos
on liegenschaften_grundstueckpos.grundstueckpos_von=liegenschaften_grundstueck.tid
left join av_avdpool_ng.liegenschaften_lsnachfuehrung
on liegenschaften_lsnachfuehrung.tid=liegenschaften_grundstueck.entstehung
where liegenschaften_liegenschaft.geometrie is not null
UNION
select distinct on (liegenschaften_selbstrecht.geometrie)
liegenschaften_selbstrecht.geometrie, liegenschaften_grundstueck.nbident, liegenschaften_grundstueck.nummer, liegenschaften_grundstueck.art,
liegenschaften_grundstueck.art_txt as art_text, liegenschaften_selbstrecht.flaechenmass, liegenschaften_grundstueck.egris_egrid as egrid, liegenschaften_grundstueck.gem_bfs, 
liegenschaften_grundstueckpos.pos, 
       case when liegenschaften_grundstueckpos.ori<=300 THEN 90-liegenschaften_grundstueckpos.ori/400*360
       else 360-liegenschaften_grundstueckpos.ori/400*360+90
       end as orientierung,  liegenschaften_grundstueckpos.hali, liegenschaften_grundstueckpos.hali_txt as hali_text,
liegenschaften_grundstueckpos.vali, liegenschaften_grundstueckpos.vali_txt as vali_text,now() as importdatum, to_date(liegenschaften_lsnachfuehrung.gueltigereintrag,'YYYYMMDD') as nachfuehrung
from av_avdpool_ng.liegenschaften_grundstueck
left join av_avdpool_ng.liegenschaften_grundstueckpos
on liegenschaften_grundstueckpos.grundstueckpos_von=liegenschaften_grundstueck.tid
right join av_avdpool_ng.liegenschaften_selbstrecht
on liegenschaften_selbstrecht.selbstrecht_von=liegenschaften_grundstueck.tid
left join av_avdpool_ng.liegenschaften_lsnachfuehrung
on liegenschaften_lsnachfuehrung.tid=liegenschaften_grundstueck.entstehung
where liegenschaften_selbstrecht.geometrie is not null;
