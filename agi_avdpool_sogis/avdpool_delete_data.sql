-- Stand Februar 2020: Daten mit archiv = 0 werden gelöscht

delete FROM avdpool.bdbed where archive = 0;
delete FROM avdpool.bdbed_objnam where  archive = 0;
delete FROM avdpool.bdbed_proj where  archive = 0;
delete FROM avdpool.bdbed_symbol where  archive = 0;
delete FROM avdpool.eoline where  archive = 0;
delete FROM avdpool.eopnt where  archive = 0;
delete FROM avdpool.eopoly where  archive = 0;
delete FROM avdpool.flurn where  archive = 0;
delete FROM avdpool.flurn_pos where  archive = 0;
delete FROM avdpool.gebadr where  archive = 0;
delete FROM avdpool.gebein where  archive = 0;
delete FROM avdpool.gebnummer where  archive = 0;
delete FROM avdpool.gelaendename where  archive = 0;
delete FROM avdpool.gemgre where  archive = 0;
delete FROM avdpool.grenzpnt where  archive = 0;
delete FROM avdpool.hfp2 where  archive = 0;
delete FROM avdpool.hfp3 where  archive = 0;
delete FROM avdpool.hgpkt where  archive = 0;
delete FROM avdpool.hohgre where  archive = 0;
delete FROM avdpool.lfp3 where  archive = 0;
delete FROM avdpool.liegen where  archive = 0;
delete FROM avdpool.liegen_pos where  archive = 0;
delete FROM avdpool.ortsnam where  archive = 0;
delete FROM avdpool.ortsnam_pos where  archive = 0;
delete FROM avdpool.planeinteilung where  archive = 0;
delete FROM avdpool.proj_grund where  archive = 0;
delete FROM avdpool.proj_grund_pos where  archive = 0;
delete FROM avdpool.rohrltg where  archive = 0;
delete FROM avdpool.selbstrecht where  archive = 0;
delete FROM avdpool.strnam where  archive = 0;
delete FROM avdpool.strstueck where  archive = 0;
delete FROM avdpool.toleranzstufe where  archive = 0;
