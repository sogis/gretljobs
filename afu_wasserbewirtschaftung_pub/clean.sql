update afu_wasserbewirtschaftung_pub_v1.wassrbwrtschftung_fassung 
set bemerkung = NULLIF(bemerkung, '');

update afu_wasserbewirtschaftung_pub_v1.wassrbwrtschftung_grundwassereinbau 
set bemerkung = NULLIF(bemerkung, '');

update afu_wasserbewirtschaftung_pub_v1.wassrbwrtschftung_grundwasserwaermepumpen_entnahmeschacht 
set bemerkung = NULLIF(bemerkung, '');

update afu_wasserbewirtschaftung_pub_v1.wassrbwrtschftung_oberflaechenhydrometrie 
set bemerkung = NULLIF(bemerkung, '');

update afu_wasserbewirtschaftung_pub_v1.wassrbwrtschftung_quelle 
set bemerkung = NULLIF(bemerkung, '');

update afu_wasserbewirtschaftung_pub_v1.wassrbwrtschftung_trinkwasserversorgung 
set bemerkung = NULLIF(bemerkung, '');

update afu_wasserbewirtschaftung_pub_v1.wassrbwrtschftung_fassung 
set technische_angabe = NULLIF(technische_angabe, '');

update afu_wasserbewirtschaftung_pub_v1.wassrbwrtschftung_grundwassereinbau 
set technische_angabe = NULLIF(technische_angabe, '');

update afu_wasserbewirtschaftung_pub_v1.wassrbwrtschftung_grundwasserwaermepumpen_entnahmeschacht 
set technische_angabe = NULLIF(technische_angabe, '');

update afu_wasserbewirtschaftung_pub_v1.wassrbwrtschftung_oberflaechenhydrometrie 
set technische_angabe = NULLIF(technische_angabe, '');

update afu_wasserbewirtschaftung_pub_v1.wassrbwrtschftung_quelle 
set technische_angabe = NULLIF(technische_angabe, '');

update afu_wasserbewirtschaftung_pub_v1.wassrbwrtschftung_trinkwasserversorgung 
set technische_angabe = NULLIF(technische_angabe, '');