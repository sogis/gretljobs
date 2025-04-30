# Doku der Nabodat-Importe als Ausgangssituation für Projekt PFAS

* afu_nabodat_import: xtf -> afu_bodendaten_nabodat_v1
    * Import in Edit-DB mittels XTF ab Modell NABODAT_ErgebnisseBodenbelastung_Punktdaten_V1_1
* afu_bodenprofilstandorte_nabodat_pub: afu_bodendaten_nabodat_v1 -> afu_bodendaten_nabodat_pub
    * Publikation in Modell SO_AFU_Bodenprofilstandorte_Publikation_20210129
* afu_bodendaten_nabodat_abfrage_pub: afu_bodendaten_nabodat_v1 -> afu_bodendaten_nabodat_abfrage_pub_v1
    * Publikation in Modell SO_AFU_Bodenprofilstandorte_Abfrage_Publikation_20240724. Upstream: afu_bodenprofilstandorte_nabodat_pub
* afu_bodendaten_schadstoffuntersuchung_pub: afu_bodendaten_nabodat_v1 -> afu_bodendaten_schadstoffuntersuchung_pub
    * Publikation von Schadstoffuntersuchungen in Modell SO_AFU_Bodendaten_schadstoffuntersuchung_Publikation_20200928 

Fazit: 
* Mit Projekt PFAS neu organisieren in drei Kind Jobs:
    * Nabodat-Import
    * Profil-Pub: Publikation in die beiden Profil-Modelle
    * Schadstoff-Pub: Publikation der Schadstoffe im Boden
    * Die beiden Pub-Jobs haben jeweils eine dependency auf den Import-Job
