update 
    arp_waldreservate_pub_v1.waldreservat reservat 
set 
    rechtsstatus_txt = rechtsstatus.dispname 
from 
    arp_waldreservate_pub_v1.rechtsstatus rechtsstatus 
where 
    reservat.rechtsstatus = rechtsstatus.ilicode 
;
update 
    arp_waldreservate_pub_v1.waldreservat reservat 
set 
    mcpfe_code_txt = mcpfe.dispname 
from 
    arp_waldreservate_pub_v1.waldreservat_mcpfe_code mcpfe
where 
    reservat.mcpfe_code  = mcpfe.ilicode 
;