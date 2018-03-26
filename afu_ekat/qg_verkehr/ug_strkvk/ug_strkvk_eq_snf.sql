SELECT min(k.ogc_fid) AS ogc_fid, min(k.xkoord) AS xkoord, 
    min(k.ykoord) AS ykoord, k.wkb_geometry, min(k.gem_bfs) AS gem_bfs, 
    min(k.vsit::text) AS vsit, sum(k.emiss_co) AS emiss_co, 
    sum(k.emiss_co2) AS emiss_co2, sum(k.emiss_nox) AS emiss_nox, 
    sum(k.emiss_so2) AS emiss_so2, sum(k.emiss_nmvoc) AS emiss_nmvoc, 
    sum(k.emiss_ch4) AS emiss_ch4, sum(k.emiss_nh3) AS emiss_nh3, 
    sum(k.emiss_n2o) AS emiss_n2o, sum(k.emiss_pm10) AS emiss_pm10
   FROM ( SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
            b.vsit, 
                CASE
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 5 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    ELSE 0::numeric::double precision
                END AS emiss_co, 
                CASE
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 25 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    ELSE 0::numeric::double precision
                END AS emiss_co2, 
                CASE
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 2 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    ELSE 0::numeric::double precision
                END AS emiss_nox, 
                CASE
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 1 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    ELSE 0::numeric::double precision
                END AS emiss_so2, 
                CASE
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 22 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    ELSE 0::numeric::double precision
                END AS emiss_nmvoc, 
                CASE
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 6 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    ELSE 0::numeric::double precision
                END AS emiss_ch4, 
                CASE
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 8 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    ELSE 0::numeric::double precision
                END AS emiss_nh3, 
                CASE
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 26 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    ELSE 0::numeric::double precision
                END AS emiss_n2o, 
                CASE
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/30'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/30/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/40'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/40/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/HVS/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/HVS/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Agglo/Sammel/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Agglo/Sammel/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/100'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/100/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/120'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/120/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/AB/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/AB/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Erschliessung/50'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Erschliessung/50/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/HVS-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/HVS-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel/80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel/80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./60'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./60/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./70'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./70/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 0 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 0)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 0)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 0)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 0)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 2 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 2)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 2)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 2)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 2)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 4 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 4)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 4)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 4)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 4)) * b.ant_los4) * 365::double precision / 1000::double precision
                    WHEN b.neigung = 6 AND b.vsit::text = 'Land/Sammel-kurv./80'::text THEN b.dtv_snf::double precision * ((( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/fluessig'::text AND a.neigung = 6)) * b.ant_los1 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/dicht'::text AND a.neigung = 6)) * b.ant_los2 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/gesaettigt'::text AND a.neigung = 6)) * b.ant_los3 + (( SELECT a.efak
                       FROM ekat2015.efak_streckenverkehr a
                      WHERE a.fhz_art = 'SNF'::text AND a.schast = 7 AND a.vk_sit = 'Land/Sammel-kurv./80/stop+go'::text AND a.neigung = 6)) * b.ant_los4) * 365::double precision / 1000::double precision
                    ELSE 0::numeric::double precision
                END AS emiss_pm10
           FROM ekat2015.ha_raster_100 a
      LEFT JOIN ( SELECT intersec_link_ha_raster.ogc_fid, 
                    intersec_link_ha_raster.gid_link, 
                    intersec_link_ha_raster.ogc_fid_ha, 
                    intersec_link_ha_raster.xkoord, 
                    intersec_link_ha_raster.ykoord, 
                    intersec_link_ha_raster.gem_bfs, 
                    intersec_link_ha_raster.laenge, 
                    intersec_link_ha_raster.laenge_neu, 
                    intersec_link_ha_raster.dtv_pw, 
                    intersec_link_ha_raster.dtv_snf, 
                    intersec_link_ha_raster.dtv_li, 
                    intersec_link_ha_raster.dtv_mr, 
                    intersec_link_ha_raster.dtv_rb, 
                    intersec_link_ha_raster.dtv_lb, 
                    intersec_link_ha_raster.ant_los1, 
                    intersec_link_ha_raster.ant_los2, 
                    intersec_link_ha_raster.ant_los3, 
                    intersec_link_ha_raster.ant_los4, 
                    intersec_link_ha_raster.neigung, 
                    intersec_link_ha_raster.vsit, 
                    intersec_link_ha_raster.wkb_geometry, 
                    intersec_link_ha_raster.new_date, 
                    intersec_link_ha_raster.archive_date, 
                    intersec_link_ha_raster.archive
                   FROM ekat2015.intersec_link_ha_raster
                  WHERE intersec_link_ha_raster.archive = 0) b ON a.xkoord = b.xkoord::numeric AND a.ykoord = b.ykoord::numeric
     WHERE a.archive = 0) k
  GROUP BY k.wkb_geometry;
