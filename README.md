# Custom Governor - Keqing

Dieses Mod fügt **Keqing** und **Ningguang** als zusätzliche Gouverneure für Civilization VI hinzu.

## Basis

Dieses Projekt ist als Erweiterung / Add-on zur bestehenden **Liyue and Inazuma Pack** Mod gedacht:

- https://github.com/dwughjsd/LiyueInazuma_civ6mod
- Steam Workshop: https://steamcommunity.com/sharedfiles/filedetails/?id=2944798624

Die Referenz-Mod nutzt die Mod-GUID:

```text
8772720f-9d8b-4f4f-a46d-87bdfa7b2966
```

Diese ID ist in `custom-gov.modinfo` als Abhängigkeit eingetragen. Dadurch soll Civilization VI dieses Add-on nur zusammen mit der Liyue/Inazuma-Mod aktivieren.

## Aktueller Inhalt

- **Keqing - Yuheng der Sieben Sterne** als Gouverneurin
- **Ningguang - Tianquan der Qixing** als Gouverneurin
- Promotion-Trees mit Grundfähigkeit und mehreren Aufwertungen
- Keqing-Handelsroutenmechanik für Liyue
- Ningguang als Tag-Team-Ergänzung mit zusätzlichem Handelsdruck
- Script-getriebene Promotion-Effekte bei erfolgreichen Handelsrouten
- Platzhalter-Icons und Platzhalter-Porträts aus vorhandenen Civ-VI-Governor-Ressourcen

## Effekte

### Keqing

- **Magnet des Hafens:** Internationale Handelsrouten aus Liyue-Städten haben eine Chance von 35 %, 1 Bevölkerung aus der Zielstadt in die Ursprungsstadt zu ziehen. Zielstädte werden nie unter 1 Bevölkerung reduziert.
- **Jadeklinge der Verwaltung:** Wenn Keqings Handelsrouten-Effekt erfolgreich Bevölkerung abgreift, erhält die Ursprungsstadt +25 Produktion und Liyue erhält +50 Gold.
- **Yuhengs Planung:** Erhöht die Chance von Keqings Handelsrouten-Effekt um +15 Prozentpunkte.
- **Schneller Beschluss:** Wenn Keqings Handelsrouten-Effekt erfolgreich Bevölkerung abgreift, erhält Liyue +30 Wissenschaft und +30 Kultur.
- **Ordnung der Qixing:** Wenn Keqings Handelsrouten-Effekt erfolgreich Bevölkerung abgreift, erhält die Ursprungsstadt +3 Loyalität und die Zielstadt verliert zusätzlich 3 Loyalität.

### Ningguang

- **Vertrag der Qixing:** Reichsweit +4 Gold auf Handelsrouten aus eigenen Städten. Tag-Team: Wenn Keqing eingesetzt ist, erhöht Ningguang die Chance von Keqings Handelsrouten-Effekt um +15 Prozentpunkte. Bei Erfolg verliert die Zielstadt zusätzlich 5 Loyalität.
- **Wirtschaftlicher Druck:** Reichsweit +3 Gold aus Handelsrouten mit fremden Städten. Tag-Team: Wenn Keqings Handelsrouten-Effekt erfolgreich Bevölkerung abgreift, erhält Liyue zusätzlich +75 Gold.
- **Politischer Einfluss:** Reichsweit +2 Einflusspunkte pro Runde auf Stadtstaaten. Tag-Team: Wenn Keqings Handelsrouten-Effekt erfolgreich Bevölkerung abgreift, verliert die Zielstadt zusätzlich 5 Loyalität.
- **Handelsnetzwerk der Qixing:** Reichsweit +2 Große-Händler-Punkte pro Runde.

Die Bevölkerungs- und Tag-Team-Mechanik wird über `Scripts/Keqing_TradePopulation.lua` geladen und reagiert auf `Events.TradeRouteActivityChanged`.

## Bekannte Einschränkungen

- Icons und Porträts sind Platzhalter.
- Civ VI hat für direkte Amenities-/Zufriedenheitsänderungen per Gameplay-Lua keine so saubere Schnittstelle wie für Loyalität. Darum bildet Ningguangs Tag-Team-Effekt die sinkende Zufriedenheit als Loyalitätsdruck ab.
- Ein echter Ingame-Test in Civilization VI ist nötig, um Datenbank-, Script- und UI-Fehler endgültig auszuschließen.

## Installation

1. Installiere und aktiviere die Liyue/Inazuma-Referenzmod.
2. Lade dieses Repository als ZIP herunter oder klone es.
3. Kopiere den Ordner in deinen Civilization-VI-Mods-Ordner.
4. Aktiviere **Custom Governor - Keqing** im Spiel.
5. Starte ein neues Spiel mit Rise and Fall / Gathering Storm.
6. Öffne das Gouverneursmenü und prüfe, ob Keqing und Ningguang ohne `LOC_...`-Fehler erscheinen.
7. Ernenne Keqing und starte eine internationale Handelsroute aus einer Liyue-Stadt.
8. Ernenne zusätzlich Ningguang und prüfe, ob die Chance steigt und die Zielstadt bei Erfolg Loyalität verliert.
9. Prüfe `Lua.log` auf `CustomGov Keqing` und `CustomGov Ningguang` Meldungen.

## Credits

- Basierend auf der Liyue/Inazuma Mod von dwughjsd
- Governor-Design von Parteicoder + Grok
