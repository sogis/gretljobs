GRETL-Job, um die Organisationen im afu_gep-Schema nachzuführen. Es wird ili2pgUpdate verwendet, da Fremdschlüssel auf die Organisationen zeigen und das Dataset nicht "replaced" werden kann.

Man könnte auch alles in einem Job kombinieren. Bis genau klar ist wie der Datenimport/-umbau-Job aussieht (on-demand? Input-Parameter?), lasse ich das in zwei Jobs. So sind es zwei simple Jobs, ohne spezielle Jenkinsfile oder so und der Update-Job wird nur bei Bedarf ausgeführt.