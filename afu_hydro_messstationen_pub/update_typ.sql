UPDATE 
    afu_hydro_messstationen_pub_v1.messstationen
SET 
    typ_txt = (SELECT dispname FROM afu_hydro_messstationen_pub_v1.messstationen_typ WHERE ilicode = typ)