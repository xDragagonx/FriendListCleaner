Global("locales", {})
--create tables of each language
locales["eng_eu"]={}
locales["rus"]={}
locales["fr"]={}
locales["ger"]={}
locales["tr"]={}

--Name of dropped Insignia's in compass allod.
locales["eng_eu"][ "itemName" ] = "Packed Hero's Insignia"
locales["fr"][ "itemName" ] = "a ete ressuscite"
locales["rus"][ "itemName" ] = "возрождался"
locales["ger"][ "itemName" ] = "wurde"
locales["tr"][ "itemName" ] = "Paketlenmi? Kahraman?n Muskas?"

--used as test
locales["eng_eu"][ "KOErelic" ] = "Relic of the Kingdom of Elements"
locales["fr"][ "KOErelic" ] = "Relic of Kingdom of Elements"
locales["rus"][ "KOErelic" ] = "Relic of Kingdom of Elements"
locales["ger"][ "KOErelic" ] = "Relic of Kingdom of Elements"
locales["tr"][ "KOErelic" ] = "Relic of the Kingdom of Elements"

locales = locales[common.GetLocalization()] -- trims all other languages except the one that common.getlocal got.